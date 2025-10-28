/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Models.Customer;
import Utils.Utils;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class CustomerDAO extends DB.DBContext {

    public Customer findById(int id) {
        String sql = "SELECT * FROM dbo.Customer WHERE CustomerId=? AND IsDeleted=0";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setId(rs.getInt("CustomerId"));
                    c.setEmail(rs.getString("Email"));
                    c.setPasswordHash(rs.getString("PasswordHash"));
                    c.setName(rs.getString("Name"));
                    c.setPhoneNumber(rs.getString("PhoneNumber"));
                    c.setAvatar(rs.getString("Avatar"));
                    c.setGender(rs.getString("Gender"));
                    Timestamp cr = rs.getTimestamp("CreatedAt");
                    Timestamp up = rs.getTimestamp("UpdatedAt");
                    c.setCreatedAt(cr == null ? null : cr.toLocalDateTime());
                    c.setUpdatedAt(up == null ? null : up.toLocalDateTime());
                    c.setIsBlock(rs.getBoolean("IsBlock"));
                    c.setIsDeleted(rs.getBoolean("IsDeleted"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all customers (not deleted)
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT * FROM dbo.Customer WHERE isDeleted = 0 ORDER BY createdAt DESC";

        try {
            ResultSet rs = execSelectQuery(query);
            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("CustomerId"));
                c.setEmail(rs.getString("Email"));
                c.setPasswordHash(rs.getString("PasswordHash"));
                c.setName(rs.getString("Name"));
                c.setPhoneNumber(rs.getString("PhoneNumber"));
                c.setAvatar(rs.getString("Avatar"));
                c.setGender(rs.getString("Gender"));
                Timestamp cr = rs.getTimestamp("CreatedAt");
                Timestamp up = rs.getTimestamp("UpdatedAt");
                c.setCreatedAt(cr == null ? null : cr.toLocalDateTime());
                c.setUpdatedAt(up == null ? null : up.toLocalDateTime());
                c.setIsBlock(rs.getBoolean("IsBlock"));
                c.setIsDeleted(rs.getBoolean("IsDeleted"));

                customers.add(c);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    // Get total customer count
    public int getTotalCustomers() {
        String query = "SELECT COUNT(*) as total FROM dbo.Customer WHERE isDeleted = 0";

        try {
            ResultSet rs = execSelectQuery(query);
            if (rs.next()) {
                return rs.getInt("total");
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Block/Unblock customer
    public boolean updateBlockStatus(int customerId, boolean isBlock) {
        String query = "UPDATE dbo.Customer SET isBlock = ?, updatedAt = GETDATE() WHERE CustomerId = ?";

        try {
            int result = execQuery(query, new Object[]{isBlock, customerId});
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Customer findByEmail(String email) {
        String sql = "SELECT * FROM dbo.Customer WHERE Email=? AND IsDeleted=0";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setId(rs.getInt("CustomerId"));
                    c.setEmail(rs.getString("Email"));
                    c.setPasswordHash(rs.getString("PasswordHash"));
                    c.setName(rs.getString("Name"));
                    c.setPhoneNumber(rs.getString("PhoneNumber"));
                    c.setAvatar(rs.getString("Avatar"));
                    c.setGender(rs.getString("Gender"));
                    Timestamp cr = rs.getTimestamp("CreatedAt");
                    Timestamp up = rs.getTimestamp("UpdatedAt");
                    c.setCreatedAt(cr == null ? null : cr.toLocalDateTime());
                    c.setUpdatedAt(up == null ? null : up.toLocalDateTime());
                    c.setIsBlock(rs.getBoolean("IsBlock"));
                    c.setIsDeleted(rs.getBoolean("IsDeleted"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(int id, String name, String phone, String avatar, String gender) {
        String sql = "UPDATE dbo.Customer SET Name=?, PhoneNumber=?, Avatar=?, Gender=?, UpdatedAt=? WHERE CustomerId=? AND IsDeleted=0";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, avatar);
            ps.setString(4, gender);
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changePassword(int id, String currentPlain, String newPlain) {
        String getSql = "SELECT PasswordHash FROM dbo.Customer WHERE CustomerId=? AND IsDeleted=0";
        String updSql = "UPDATE dbo.Customer SET PasswordHash=?, UpdatedAt=? WHERE CustomerId=?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(getSql)) {
            ps.setInt(1, id);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String oldHash = rs.getString(1);
                    if (!Utils.verifyPassword(currentPlain, oldHash)) {
                        return false;
                    }
                } else {
                    return false;
                }
            }
            try ( PreparedStatement up = con.prepareStatement(updSql)) {
                up.setString(1, Utils.hashPassword(newPlain));
                up.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                up.setInt(3, id);
                return up.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if email already exists
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE Email=? AND IsDeleted=0";

        try ( Connection c = getConnection();  PreparedStatement p = c.prepareStatement(sql)) {

            p.setString(1, email);

            try ( ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Create new customer
     */
    public boolean createCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (Email, PasswordHash, Name, PhoneNumber, Avatar, Gender, CreatedAt, UpdatedAt, IsBlock, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0, 0)";

        try ( Connection c = getConnection();  PreparedStatement p = c.prepareStatement(sql)) {

            p.setString(1, customer.getEmail());
            p.setString(2, customer.getPasswordHash());
            p.setString(3, customer.getName());
            p.setString(4, customer.getPhoneNumber());
            p.setString(5, customer.getAvatar());
            p.setString(6, customer.getGender());

            int result = p.executeUpdate();

            if (result > 0) {
                System.out.println("Created customer: " + customer.getEmail());
            }

            return result > 0;

        } catch (SQLException e) {
            System.err.println("Error creating customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create verification code for customer
     */
    public boolean createVerificationCode(int customerId, String code, java.time.LocalDateTime expiry) {
        String sql = "INSERT INTO VerifyCodeCustomer (CustomerId, Code, FailedCount, RequestCount, ExpiredAt, CreatedAt) "
                + "VALUES (?, ?, 0, 1, ?, GETDATE())";

        try ( Connection c = getConnection();  PreparedStatement p = c.prepareStatement(sql)) {

            p.setInt(1, customerId);
            p.setString(2, code);
            p.setTimestamp(3, java.sql.Timestamp.valueOf(expiry));

            int result = p.executeUpdate();

            if (result > 0) {
                System.out.println("Created verification code for customer: " + customerId);
            }

            return result > 0;

        } catch (SQLException e) {
            System.err.println("Error creating verification code: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verify customer email with code
     */
    public boolean verifyCustomer(String email, String code) {
        // 1. Get customer ID by email
        String sqlGetId = "SELECT CustomerId FROM Customer WHERE Email=? AND IsDeleted=0";

        // 2. Check if code is valid and not expired
        String sqlCheckCode = "SELECT COUNT(*) FROM VerifyCodeCustomer "
                + "WHERE CustomerId=? AND Code=? AND ExpiredAt > GETDATE()";

        // 3. Update Customer IsVerified = 1
        String sqlUpdateCustomer = "UPDATE Customer SET IsVerified=1, UpdatedAt=GETDATE() WHERE CustomerId=?";

        // 4. Delete verification code after successful verification
        String sqlDeleteCode = "DELETE FROM VerifyCodeCustomer WHERE CustomerId=? AND Code=?";

        try ( Connection c = getConnection()) {

            int customerId = 0;

            // Step 1: Get customer ID
            try ( PreparedStatement p = c.prepareStatement(sqlGetId)) {
                p.setString(1, email);
                try ( ResultSet rs = p.executeQuery()) {
                    if (rs.next()) {
                        customerId = rs.getInt(1);
                    } else {
                        System.err.println("Customer not found: " + email);
                        return false;
                    }
                }
            }

            // Step 2: Check code
            boolean codeValid = false;
            try ( PreparedStatement p = c.prepareStatement(sqlCheckCode)) {
                p.setInt(1, customerId);
                p.setString(2, code);
                try ( ResultSet rs = p.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        codeValid = true;
                    } else {
                        System.err.println("Invalid or expired verification code");
                        return false;
                    }
                }
            }

            // Step 3: Update Customer IsVerified = 1
            if (codeValid) {
                try ( PreparedStatement p = c.prepareStatement(sqlUpdateCustomer)) {
                    p.setInt(1, customerId);
                    p.executeUpdate();
                    System.out.println("✅ Set IsVerified=1 for customer: " + customerId);
                }

                // Step 4: Delete verification code
                try ( PreparedStatement p = c.prepareStatement(sqlDeleteCode)) {
                    p.setInt(1, customerId);
                    p.setString(2, code);
                    p.executeUpdate();
                    System.out.println("Deleted verification code");
                }

                System.out.println("Successfully verified customer: " + email);
                return true;
            }

            return false;

        } catch (SQLException e) {
            System.err.println("Error verifying customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get customer ID by email
     */
    public int getCustomerIdByEmail(String email) {
        String sql = "SELECT CustomerId FROM Customer WHERE Email=? AND IsDeleted=0";

        try ( Connection c = getConnection();  PreparedStatement p = c.prepareStatement(sql)) {

            p.setString(1, email);

            try ( ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer ID: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Resend verification code
     */
    public boolean resendVerificationCode(String email) {
        // 1. Get customer ID
        int customerId = getCustomerIdByEmail(email);

        if (customerId == 0) {
            System.err.println("Customer not found: " + email);
            return false;
        }

        // 2. Delete old codes
        String sqlDelete = "DELETE FROM VerifyCodeCustomer WHERE CustomerId=?";

        // 3. Create new code
        String code = String.valueOf(100000 + (int) (Math.random() * 900000));
        java.time.LocalDateTime expiry = java.time.LocalDateTime.now().plusMinutes(10);

        try ( Connection c = getConnection()) {

            // Delete old codes
            try ( PreparedStatement p = c.prepareStatement(sqlDelete)) {
                p.setInt(1, customerId);
                p.executeUpdate();
            }

            // Create new code
            boolean created = createVerificationCode(customerId, code, expiry);

            if (created) {
                // Send email with new code
                // TODO: Call EmailService.sendVerificationCode()
                System.out.println("Resent verification code to: " + email);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error resending code: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get customer by email
     */
    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Email=? AND IsDeleted=0";

        try ( Connection c = getConnection();  PreparedStatement p = c.prepareStatement(sql)) {

            p.setString(1, email);

            try ( ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Map ResultSet to Customer object
     */
    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();

        customer.setId(rs.getInt("CustomerId"));
        customer.setEmail(rs.getString("Email"));
        customer.setPasswordHash(rs.getString("PasswordHash"));
        customer.setName(rs.getString("Name"));
        customer.setPhoneNumber(rs.getString("PhoneNumber"));
        customer.setAvatar(rs.getString("Avatar"));
        customer.setGender(rs.getString("Gender"));

        // IsVerified (nếu có cột)
        try {
            customer.setVerified(rs.getBoolean("IsVerified"));
        } catch (SQLException e) {
            // Cột chưa tồn tại, bỏ qua
        }

        // Timestamps
        java.sql.Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            customer.setCreatedAt(createdAt.toLocalDateTime());
        }

        java.sql.Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            customer.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        customer.setIsBlock(rs.getBoolean("IsBlock"));
        customer.setIsDeleted(rs.getBoolean("IsDeleted"));

        return customer;
    }

    /**
     * Login customer with email and password
     */
    public Customer login(String email, String password) {
        String sql = "SELECT * FROM Customer WHERE Email=? AND IsDeleted=0";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Check if account is blocked
                    if (rs.getBoolean("IsBlock")) {
                        System.err.println("Account is blocked: " + email);
                        return null;
                    }
                    
                    // Verify password
                    String storedHash = rs.getString("PasswordHash");
                    if (Utils.verifyPassword(password, storedHash)) {
                        // Map customer data
                        Customer customer = mapCustomer(rs);
                        System.out.println("Login successful: " + email);
                        return customer;
                    } else {
                        System.err.println("Invalid password for: " + email);
                        return null;
                    }
                } else {
                    System.err.println("Customer not found: " + email);
                    return null;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    /**
 * Update last login time
 */
public boolean updateLastLogin(int customerId) {
    String sql = "UPDATE Customer SET UpdatedAt=GETDATE() WHERE CustomerId=?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, customerId);
        int result = ps.executeUpdate();
        
        if (result > 0) {
            System.out.println("✅ Updated last login for customer ID: " + customerId);
            return true;
        }
        
        return false;
        
    } catch (SQLException e) {
        System.err.println("❌ Error updating last login: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    
}
