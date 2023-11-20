package jspazuretest;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class DataHandle {
    private Connection conn;
    // Azure SQL connection credentials
    private String server = "sahu0001-sql-server.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "sahu0001";
    private String password = "Jaijagannath2023@";
    // Resulting connection string
    final private String url = String.format(
            "jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            server, database, username, password);

    // Initialize and save the database connection
    private void getDBConnection() throws SQLException {
        if (conn != null) {
            return;
        }
        this.conn = DriverManager.getConnection(url);
    }

    // Return the result of selecting everything from the movie_night table
    public ResultSet getAllCustomer() throws SQLException {
        getDBConnection();
        final String sqlQuery = "SELECT * FROM Customer;";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
        return stmt.executeQuery();
    }
    
    public ResultSet fetchCustomers(int start_range, int end_range) throws SQLException {
        getDBConnection();
        final String sqlQuery = "SELECT * FROM Customer WHERE category BETWEEN '" + start_range + "' and '" + end_range + "'";;
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
        return stmt.executeQuery();
    }
    
    // Inserts a record into the movie_night table with the given attribute values
    public boolean addCustomer(String customer_name, String address, int category) throws SQLException {
        getDBConnection(); // Prepare the database connection
        // Prepare the SQL statement
        final String sqlQuery =
                "INSERT INTO Customer " +
                        "(customer_name, customer_address, category) " +
                        "VALUES " +
                        "(?, ?, ?)";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
        // Replace the '?' in the above statement with the given attribute values
        stmt.setString(1, customer_name);
        stmt.setString(2, address);
        stmt.setInt(3, category);
        // Execute the query, if only one record is updated, then we indicate success by returning true
        return stmt.executeUpdate() == 1;
    }
}
