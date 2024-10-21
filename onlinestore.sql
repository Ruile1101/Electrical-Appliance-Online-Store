CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role ENUM('buyer', 'seller', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buyer (
    buyer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    shipping_address TEXT,
    phone_number VARCHAR(20),
    membership_status ENUM('basic', 'premium') DEFAULT 'basic'
);

CREATE TABLE seller (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(255),
    store_description TEXT,
    store_logo VARCHAR(255),
    store_status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(255),
    category_description TEXT
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    product_name VARCHAR(255),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    buyer_id INT,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE rating (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    buyer_id INT,
    rating_value INT CHECK(rating_value BETWEEN 1 AND 5),
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    product_id INT,
    quantity INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE `order` (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    total_amount DECIMAL(10, 2),
    order_status ENUM('pending', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method ENUM('credit_card', 'cash', 'bank_transfer') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10, 2),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES `order`(order_id)
);

CREATE TABLE voucher (
    voucher_id INT PRIMARY KEY AUTO_INCREMENT,
    voucher_code VARCHAR(50),
    discount_value DECIMAL(5, 2),
    valid_until DATE
);

CREATE TABLE user_voucher (
    user_voucher_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    voucher_id INT,
    claimed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_at TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (voucher_id) REFERENCES voucher(voucher_id)
);

CREATE TABLE shipping_information (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipping_address TEXT,
    shipping_city VARCHAR(255),
    shipping_postcode VARCHAR(10),
    shipping_status ENUM('processing', 'shipped', 'delivered') DEFAULT 'processing',
    FOREIGN KEY (order_id) REFERENCES `order`(order_id)
);

CREATE TABLE refund (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    buyer_id INT,
    product_id INT,
    refund_reason TEXT,
    refund_amount DECIMAL(10, 2),
    refund_status ENUM('requested', 'approved', 'rejected') DEFAULT 'requested',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_date TIMESTAMP,
    admin_id INT,
    refund_method ENUM('bank_transfer', 'tng'),
    refund_approved_date TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

CREATE TABLE refund_request (
    refund_request_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    buyer_id INT,
    refund_reason TEXT,
    refund_status ENUM('pending', 'processed') DEFAULT 'pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_date TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE order_tracking (
    tracking_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    tracking_number VARCHAR(255),
    current_location TEXT,
    estimated_delivery_date DATE,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id)
);

CREATE TABLE chat (
    chat_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    seller_id INT,
    message_content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    notification_type ENUM('order', 'shipping', 'message', 'promotion') NOT NULL,
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE wish_list (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    product_id INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE wallet (
    wallet_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    balance DECIMAL(10, 2),
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE transaction_history (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    wallet_id INT,
    transaction_type ENUM('card', 'tng'),
    amount DECIMAL(10, 2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallet(wallet_id)
);

CREATE TABLE following_shops (
    follow_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    seller_id INT,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id),
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE membership (
    membership_id INT PRIMARY KEY AUTO_INCREMENT,
    buyer_id INT,
    membership_level ENUM('basic', 'premium'),
    expired_date DATE,
    FOREIGN KEY (buyer_id) REFERENCES buyer(buyer_id)
);

CREATE TABLE product_image (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE category_management (
    category_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales_report (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    report_period VARCHAR(255),
    total_sales DECIMAL(10, 2),
    report_generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE product_return (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    order_item_id INT,
    return_reason TEXT,
    return_status ENUM('requested', 'approved', 'denied') DEFAULT 'requested',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_item_id) REFERENCES order_item(order_item_id)
);

CREATE TABLE finance_management (
    finance_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    total_earnings DECIMAL(10, 2),
    payout_status ENUM('pending', 'completed') DEFAULT 'pending',
    payout_date TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE feedback_management (
    feedback_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    response_text TEXT,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE admin_content_management (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    page_name VARCHAR(255),
    content_details TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

CREATE TABLE user_management (
    user_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    user_id INT,
    action TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE order_management (
    order_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    order_id INT,
    action TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (order_id) REFERENCES `order`(order_id)
);

CREATE TABLE voucher_management (
    voucher_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    voucher_id INT,
    action TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (voucher_id) REFERENCES voucher(voucher_id)
);

CREATE TABLE marketing_management (
    marketing_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    promotion_details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

CREATE TABLE return_management (
    return_mgmt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    return_id INT,
    status_update TEXT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (return_id) REFERENCES product_return(return_id)
);

CREATE TABLE report_generation (
    report_gene_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    report_type VARCHAR(255),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);

CREATE TABLE seller_subscription (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    subscription_plan VARCHAR(255),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);

CREATE TABLE customer_engagement (
    engagement_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    messages TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);
	