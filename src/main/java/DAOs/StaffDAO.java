package DAOs;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import DB.DBContext;
import Models.Staff;

/**
 * Staff Data Access Object
 * @author NeoShoes Team
 */
public class StaffDAO extends DBContext {

    // ============================================
    // BASIC CRUD
    // ============================================
    
    /**
     * Get staff by ID
     */
    public Staff getStaffById(int id) {
        String sql = "SELECT * FROM Staff WHERE StaffId=? AND IsDeleted=0";
        
        try (Connection c = getConnection(); 
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setInt(1, id);
            
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? mapStaff(rs) : null;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting staff by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get all active staff
     */
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff WHERE IsDeleted=0 ORDER BY CreatedAt DESC";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapStaff(rs));
            }
            
            System.out.println("✅ Retrieved " + list.size() + " staff members");
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting all staff: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Search staff by keyword
     */
    public List<Staff> searchStaff(String keyword) {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff " +
                    "WHERE IsDeleted=0 " +
                    "AND (Name LIKE ? OR Email LIKE ? OR PhoneNumber LIKE ?) " +
                    "ORDER BY CreatedAt DESC";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            String pattern = "%" + keyword + "%";
            p.setString(1, pattern);
            p.setString(2, pattern);
            p.setString(3, pattern);
            
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStaff(rs));
                }
            }
            
            System.out.println("✅ Search '" + keyword + "' found " + list.size() + " results");
            
        } catch (SQLException e) {
            System.err.println("❌ Error searching staff: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Filter staff by role
     */
    public List<Staff> getStaffByRole(boolean isAdmin) {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff WHERE IsDeleted=0 AND Role=? ORDER BY CreatedAt DESC";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setBoolean(1, isAdmin);
            
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStaff(rs));
                }
            }
            
            System.out.println("✅ Filter by role '" + (isAdmin ? "Admin" : "Staff") + "' found " + list.size() + " results");
            
        } catch (SQLException e) {
            System.err.println("❌ Error filtering staff by role: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get total staff count
     */
    public int getTotalStaffCount() {
        String sql = "SELECT COUNT(*) FROM Staff WHERE IsDeleted=0";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("✅ Total staff count: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting staff count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ============================================
    // CREATE, UPDATE, DELETE
    // ============================================
    
    /**
     * Create new staff
     */
    public boolean createStaff(Staff staff) {
        String sql = "INSERT INTO Staff (Role, Email, PasswordHash, Name, PhoneNumber, Avatar, Gender, Address, DateOfBirth, CreatedAt, UpdatedAt, IsDeleted) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setBoolean(1, staff.isRole());
            p.setString(2, staff.getEmail());
            p.setString(3, staff.getPasswordHash());
            p.setString(4, staff.getName());
            p.setString(5, staff.getPhoneNumber());
            p.setString(6, staff.getAvatar());
            p.setString(7, staff.getGender());
            p.setString(8, staff.getAddress());
            
            if (staff.getDateOfBirth() != null) {
                p.setDate(9, Date.valueOf(staff.getDateOfBirth()));
            } else {
                p.setNull(9, Types.DATE);
            }
            
            int result = p.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Created staff: " + staff.getEmail());
            }
            
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error creating staff: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update staff information
     */
    public boolean updateStaff(Staff staff) {
        String sql = "UPDATE Staff SET " +
                    "Role=?, Name=?, PhoneNumber=?, Avatar=?, Gender=?, Address=?, DateOfBirth=?, UpdatedAt=GETDATE() " +
                    "WHERE StaffId=? AND IsDeleted=0";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setBoolean(1, staff.isRole());
            p.setString(2, staff.getName());
            p.setString(3, staff.getPhoneNumber());
            p.setString(4, staff.getAvatar());
            p.setString(5, staff.getGender());
            p.setString(6, staff.getAddress());
            
            if (staff.getDateOfBirth() != null) {
                p.setDate(7, Date.valueOf(staff.getDateOfBirth()));
            } else {
                p.setNull(7, Types.DATE);
            }
            
            p.setInt(8, staff.getStaffId());
            
            int result = p.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Updated staff: " + staff.getName());
            }
            
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating staff: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update profile (exclude email, password)
     */
    public boolean updateProfile(int staffId, String phone, String avatarUrl, String gender, String address, LocalDate dob) {
        String sql = "UPDATE Staff SET PhoneNumber=?, Avatar=?, Gender=?, Address=?, DateOfBirth=?, UpdatedAt=GETDATE() " +
                    "WHERE StaffId=? AND IsDeleted=0";
        
        try (Connection c = getConnection(); 
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setString(1, phone);
            p.setString(2, avatarUrl);
            
            if (gender == null) {
                p.setNull(3, Types.NVARCHAR);
            } else {
                p.setString(3, gender);
            }
            
            if (address == null) {
                p.setNull(4, Types.NVARCHAR);
            } else {
                p.setString(4, address);
            }
            
            if (dob == null) {
                p.setNull(5, Types.DATE);
            } else {
                p.setDate(5, Date.valueOf(dob));
            }
            
            p.setInt(6, staffId);
            
            return p.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating profile: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Soft delete staff
     */
    public boolean deleteStaff(int staffId) {
        String sql = "UPDATE Staff SET IsDeleted=1, UpdatedAt=GETDATE() WHERE StaffId=?";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setInt(1, staffId);
            
            int result = p.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Deleted staff ID: " + staffId);
            }
            
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error deleting staff: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // UTILITIES
    // ============================================
    
    /**
     * Check if email exists
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Staff WHERE Email=? AND IsDeleted=0";
        
        try (Connection c = getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setString(1, email);
            
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error checking email exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Change password
     */
    public boolean changePassword(int staffId, String currentPassword, String newPassword) {
        String sqlSelect = "SELECT PasswordHash FROM Staff WHERE StaffId=? AND IsDeleted=0";
        String sqlUpdate = "UPDATE Staff SET PasswordHash=?, UpdatedAt=GETDATE() WHERE StaffId=? AND IsDeleted=0";
        
        try (Connection c = getConnection(); 
             PreparedStatement ps = c.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, staffId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                
                String stored = rs.getString(1);
                
                if (!Objects.equals(stored, currentPassword)) {
                    return false;
                }
                
                try (PreparedStatement up = c.prepareStatement(sqlUpdate)) {
                    up.setString(1, newPassword);
                    up.setInt(2, staffId);
                    return up.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error changing password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // MAPPER
    // ============================================
    
    /**
     * Map ResultSet to Staff object
     */
    private Staff mapStaff(ResultSet rs) throws SQLException {
        Staff s = new Staff();
        s.setStaffId(rs.getInt("StaffId"));
        s.setRole(rs.getBoolean("Role"));
        s.setEmail(rs.getString("Email"));
        s.setPasswordHash(rs.getString("PasswordHash"));
        s.setName(rs.getString("Name"));
        s.setPhoneNumber(rs.getString("PhoneNumber"));
        s.setAvatar(rs.getString("Avatar"));
        s.setGender(rs.getString("Gender"));
        s.setAddress(rs.getString("Address"));
        
        Date dob = rs.getDate("DateOfBirth");
        s.setDateOfBirth(dob == null ? null : dob.toLocalDate());
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        s.setCreatedAt(createdAt.toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        s.setUpdatedAt(updatedAt == null ? null : updatedAt.toLocalDateTime());
        
        s.setDeleted(rs.getBoolean("IsDeleted"));
        
        return s;
    }
}