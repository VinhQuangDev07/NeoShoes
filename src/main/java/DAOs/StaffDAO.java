package DAOs;

import DB.DBContext;
import Models.Staff;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class StaffDAO {

    private final DBContext db = new DBContext();

    /**
     * Get staff by ID
     * @param id Staff ID
     * @return Staff object or null
     */
    public Staff getStaffById(int id) {
        String sql = "SELECT * FROM Staff WHERE StaffId=? AND IsDeleted=0";
        try (Connection c = db.getConnection(); 
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting staff by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    

    // 1) Update các trường được phép (KHÔNG đổi Name/Email/StaffID)
    public boolean updateProfile(int staffId, String phone, String avatarUrl, String gender, String address, java.time.LocalDate dob) {
        String sql = "UPDATE Staff SET PhoneNumber=?, Avatar=?, Gender=?, Address=?, DateOfBirth=?, UpdatedAt=SYSDATETIME() "
                + "WHERE StaffId=? AND IsDeleted=0";
        try ( Connection c = db.getConnection();  PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, phone);
            p.setString(2, avatarUrl);

// Gender
            if (gender == null) {
                p.setNull(3, Types.NVARCHAR);
            } else {
                p.setString(3, gender);
            }

// Address
            if (address == null) {
                p.setNull(4, Types.NVARCHAR);
            } else {
                p.setString(4, address);
            }

// DOB
            if (dob == null) {
                p.setNull(5, Types.DATE);
            } else {
                p.setDate(5, Date.valueOf(dob));
            }

            p.setInt(6, staffId);
            System.out.printf(
                    "Executing UPDATE for StaffId=%d | phone=%s | avatar=%s | gender=%s | address=%s | dob=%s%n",
                    staffId, phone, avatarUrl, gender, address, String.valueOf(dob)
            );
            return p.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changePassword(int staffId, String currentPassword, String newPassword) {
        String sqlSelect = "SELECT PasswordHash FROM Staff WHERE StaffId=? AND IsDeleted=0";
        String sqlUpdate = "UPDATE Staff SET PasswordHash=?, UpdatedAt=SYSDATETIME() WHERE StaffId=? AND IsDeleted=0";
        try ( Connection c = db.getConnection();  PreparedStatement ps = c.prepareStatement(sqlSelect)) {

            ps.setInt(1, staffId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                String stored = rs.getString(1);

                // ====== CHỌN 1 TRONG 2 NHÁNH SAU ======
                // (A) Nếu bạn đang lưu PLAIN (KHÔNG khuyến nghị – chỉ demo)
                // if (!Objects.equals(stored, currentPassword)) return false;
                // String newStored = newPassword;
                // (B) Nếu bạn lưu dạng HASH (khuyến nghị):
                // -> Dùng đúng HÀM HASH của hệ thống bạn hiện có (ví dụ SQL HASHBYTES/SHA2 trong DB, hoặc hàm Java đã dùng từ trước).
                // Ở đây mình giả sử bạn có dùng cùng cách hash như phía CustomerDAO đang dùng.
                if (!Objects.equals(stored, currentPassword)) {
                    return false;
                }
                String newStored = newPassword;

                try ( PreparedStatement up = c.prepareStatement(sqlUpdate)) {
                    up.setString(1, newStored);
                    up.setInt(2, staffId);
                    return up.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     /**
     * Get all active staff
     * @return List of all staff
     */
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff WHERE IsDeleted=0 ORDER BY CreatedAt DESC";
        
        try (Connection c = db.getConnection();
             PreparedStatement p = c.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            
            while (rs.next()) {
                list.add(map(rs));
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
     * @param keyword Search term (name, email, phone)
     * @return List of matching staff
     */
    public List<Staff> searchStaff(String keyword) {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff " +
                    "WHERE IsDeleted=0 " +
                    "AND (Name LIKE ? OR Email LIKE ? OR PhoneNumber LIKE ?) " +
                    "ORDER BY CreatedAt DESC";
        
        try (Connection c = db.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            String pattern = "%" + keyword + "%";
            p.setString(1, pattern);
            p.setString(2, pattern);
            p.setString(3, pattern);
            
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
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
     * @param isAdmin true for Admin, false for Staff
     * @return List of staff with specified role
     */
    public List<Staff> getStaffByRole(boolean isAdmin) {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff WHERE IsDeleted=0 AND Role=? ORDER BY CreatedAt DESC";
        
        try (Connection c = db.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setBoolean(1, isAdmin);
            
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
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
     * @return Total number of active staff
     */
    public int getTotalStaffCount() {
        String sql = "SELECT COUNT(*) FROM Staff WHERE IsDeleted=0";
        
        try (Connection c = db.getConnection();
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
    
    
     /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists
     */
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Staff WHERE Email=? AND IsDeleted=0";
        
        try (Connection c = db.getConnection();
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
     * Create new staff
     * @param staff Staff object
     * @return true if created successfully
     */
    public boolean createStaff(Staff staff) {
        String sql = "INSERT INTO Staff (Role, Email, PasswordHash, Name, PhoneNumber, Avatar, Gender, Address, DateOfBirth, CreatedAt, UpdatedAt, IsDeleted) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
        
        try (Connection c = db.getConnection();
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
     * @param staff Staff object
     * @return true if updated successfully
     */
    public boolean updateStaff(Staff staff) {
    String sql = "UPDATE Staff SET " +
            "Role=?, Email=?, Name=?, PhoneNumber=?, Avatar=?, Gender=?, Address=?, DateOfBirth=?, UpdatedAt=GETDATE() " +
            "WHERE StaffId=? AND IsDeleted=0";
        
        try (Connection c = db.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            
            p.setBoolean(1, staff.isRole());
            p.setString(2, staff.getEmail());
            p.setString(3, staff.getName());
            p.setString(4, staff.getPhoneNumber());
            p.setString(5, staff.getAvatar());
            p.setString(6, staff.getGender());
            p.setString(7, staff.getAddress());
            
            if (staff.getDateOfBirth() != null) {
                p.setDate(8, Date.valueOf(staff.getDateOfBirth()));
            } else {
                p.setNull(8, Types.DATE);
            }
            
            p.setInt(9, staff.getStaffId());
            
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
     * Soft delete staff
     * @param staffId Staff ID
     * @return true if deleted successfully
     */
    public boolean deleteStaff(int staffId) {
        String sql = "UPDATE Staff SET IsDeleted=1, UpdatedAt=GETDATE() WHERE StaffId=?";
        
        try (Connection c = db.getConnection();
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

    private Staff map(ResultSet rs) throws SQLException {
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
        s.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        Timestamp up = rs.getTimestamp("UpdatedAt");
        s.setUpdatedAt(up == null ? null : up.toLocalDateTime());
        s.setDeleted(rs.getBoolean("IsDeleted"));
        
        return s;
    }
}
