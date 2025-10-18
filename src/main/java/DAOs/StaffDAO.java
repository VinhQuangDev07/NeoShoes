// StaffDAO.java
package DAOs;

import DB.DBContext;
import Models.Staff;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {
    private final DBContext dbContext;

    public StaffDAO() {
        this.dbContext = new DBContext();
    }

    // Get staff by ID
    public Staff getStaffById(int staffId) {
        String query = "SELECT * FROM Staff WHERE StaffId = ? AND IsDeleted = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get staff by email
    public Staff getStaffByEmail(String email) {
        String query = "SELECT * FROM Staff WHERE Email = ? AND IsDeleted = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update staff profile (without password)
    public boolean updateStaffProfile(Staff staff) {
        String query = "UPDATE Staff SET Name = ?, PhoneNumber = ?, Avatar = ?, Gender = ?, UpdatedAt = ? WHERE StaffId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, staff.getName());
            ps.setString(2, staff.getPhoneNumber());
            ps.setString(3, staff.getAvatar());
            ps.setString(4, staff.getGender());
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, staff.getStaffId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Change password
    public boolean changePassword(int staffId, String newPasswordHash) {
        String query = "UPDATE Staff SET PasswordHash = ?, UpdatedAt = ? WHERE StaffId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, newPasswordHash);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, staffId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all staff (for admin)
    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        String query = "SELECT * FROM Staff WHERE IsDeleted = 0";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // Helper method to map ResultSet to Staff object
    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setStaffId(rs.getInt("StaffId"));
        staff.setRole(rs.getBoolean("Role"));
        staff.setEmail(rs.getString("Email"));
        staff.setPasswordHash(rs.getString("PasswordHash"));
        staff.setName(rs.getString("Name"));
        staff.setPhoneNumber(rs.getString("PhoneNumber"));
        staff.setAvatar(rs.getString("Avatar"));
        staff.setGender(rs.getString("Gender"));
        staff.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            staff.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        staff.setDeleted(rs.getBoolean("IsDeleted"));
        return staff;
    }
}