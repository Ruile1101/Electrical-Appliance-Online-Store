/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package database;
import java.sql.Connection;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author Remus
 */

public class db_connection {
    public static String username = "root";
    public static String password = "";
    public static String url = "jdbc:mysql://localhost:3306/electronic_appliance_online_store";
    public static Connection con = null;

    // Method to get the connection
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, username, password);
            
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(db_connection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }
}



