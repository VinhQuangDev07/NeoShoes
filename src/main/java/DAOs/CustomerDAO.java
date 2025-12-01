/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Customer;
import Utils.Utils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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

}
