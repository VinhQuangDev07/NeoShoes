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
import Utils.Utils;

/**
 * Staff Data Access Object
 *
 * @author NeoShoes Team
 */
public class StaffDAO extends DBContext {

   // ============================================
    // BASIC CRUD
    // ============================================
    public Staff getStaffById(int id) {
        String query = "SELECT * FROM Staff WHERE StaffId = ? AND IsDeleted = 0";
        try (ResultSet rs = this.execSelectQuery(query, new Object[]{id})) {
            if (rs != null && rs.next()) return mapStaff(rs);
        } catch (SQLException e) {
            System.err.println("getStaffById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get all active staff
     */
   public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String query = "SELECT * FROM Staff WHERE IsDeleted = 0 ORDER BY CreatedAt DESC";
        try (ResultSet rs = this.execSelectQuery(query)) {
            while (rs != null && rs.next()) list.add(mapStaff(rs));
        } catch (SQLException e) {
            System.err.println("getAllStaff: " + e.getMessage());
        }
        return list;
    }

    /**
     * Search staff by keyword
     */
    public List<Staff> searchStaff(String keyword) {
        List<Staff> list = new ArrayList<>();
        String query = "SELECT * FROM Staff WHERE IsDeleted = 0 " +
                "AND (Name LIKE ? OR Email LIKE ? OR PhoneNumber LIKE ?) " +
                "ORDER BY CreatedAt DESC";
        String pattern = "%" + keyword + "%";
        try (ResultSet rs = this.execSelectQuery(query, new Object[]{pattern, pattern, pattern})) {
            while (rs != null && rs.next()) list.add(mapStaff(rs));
        } catch (SQLException e) {
            System.err.println("searchStaff: " + e.getMessage());
        }
        return list;
    }

    /**
     * Filter staff by role
     */
    public List<Staff> getStaffByRole(boolean isAdmin) {
        List<Staff> list = new ArrayList<>();
        String query = "SELECT * FROM Staff WHERE IsDeleted = 0 AND Role = ? ORDER BY CreatedAt DESC";
        try (ResultSet rs = this.execSelectQuery(query, new Object[]{isAdmin})) {
            while (rs != null && rs.next()) list.add(mapStaff(rs));
        } catch (SQLException e) {
            System.err.println("getStaffByRole: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get total staff count
     */
    public int getTotalStaffCount() {
        String query = "SELECT COUNT(*) AS Count FROM Staff WHERE IsDeleted = 0";
        try (ResultSet rs = this.execSelectQuery(query)) {
            if (rs != null && rs.next()) return rs.getInt("Count");
        } catch (SQLException e) {
            System.err.println("getTotalStaffCount: " + e.getMessage());
        }
        return 0;
    }

    // ============================================
    // CREATE, UPDATE, DELETE
    // ============================================
    /**
     * Create new staff
     */
     public boolean createStaff(Staff s) {
        String query = "INSERT INTO Staff (Role, Email, PasswordHash, Name, PhoneNumber, Avatar, Gender, " +
                "Address, DateOfBirth, CreatedAt, UpdatedAt, IsDeleted) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
        try {
            int result = this.execQuery(query, new Object[]{
                    s.isRole(), s.getEmail(), s.getPasswordHash(), s.getName(),
                    s.getPhoneNumber(), s.getAvatar(), s.getGender(), s.getAddress(),
                    s.getDateOfBirth() != null ? Date.valueOf(s.getDateOfBirth()) : null
            });
            return result > 0;
        } catch (SQLException e) {
            System.err.println("createStaff: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update staff information
     */
    public boolean updateStaff(Staff s) {
        String query = "UPDATE Staff SET Role=?, Email=?, Name=?, PhoneNumber=?, Avatar=?, Gender=?, " +
                "Address=?, DateOfBirth=?, UpdatedAt=GETDATE() WHERE StaffId=? AND IsDeleted=0";
        try {
            int result = this.execQuery(query, new Object[]{
                    s.isRole(), s.getEmail(), s.getName(), s.getPhoneNumber(), s.getAvatar(),
                    s.getGender(), s.getAddress(),
                    s.getDateOfBirth() != null ? Date.valueOf(s.getDateOfBirth()) : null,
                    s.getStaffId()
            });
            return result > 0;
        } catch (SQLException e) {
            System.err.println("updateStaff: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update profile (exclude email, password)
     */
    public boolean updateProfile(int staffId, String phone, String avatar, String gender, String address, LocalDate dob) {
        String query = "UPDATE Staff SET PhoneNumber=?, Avatar=?, Gender=?, Address=?, DateOfBirth=?, " +
                "UpdatedAt=GETDATE() WHERE StaffId=? AND IsDeleted=0";
        try {
            int result = this.execQuery(query, new Object[]{
                    phone, avatar, gender, address,
                    dob != null ? Date.valueOf(dob) : null, staffId
            });
            return result > 0;
        } catch (SQLException e) {
            System.err.println("updateProfile: " + e.getMessage());
            return false;
        }
    }

    /**
     * Soft delete staff
     */
    public boolean deleteStaff(int staffId) {
        String query = "UPDATE Staff SET IsDeleted = 1, UpdatedAt = GETDATE() WHERE StaffId = ?";
        try {
            int result = this.execQuery(query, new Object[]{staffId});
            return result > 0;
        } catch (SQLException e) {
            System.err.println("deleteStaff: " + e.getMessage());
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
        String query = "SELECT COUNT(*) AS Count FROM Staff WHERE Email=? AND IsDeleted=0";
        try (ResultSet rs = this.execSelectQuery(query, new Object[]{email})) {
            if (rs != null && rs.next()) return rs.getInt("Count") > 0;
        } catch (SQLException e) {
            System.err.println("isEmailExists: " + e.getMessage());
        }
        return false;
    }

    /**
     * Change password
     */
    public boolean changePassword(int staffId, String current, String newPwd) {
        String sqlGet = "SELECT PasswordHash FROM Staff WHERE StaffId=? AND IsDeleted=0";
        String sqlUpd = "UPDATE Staff SET PasswordHash=?, UpdatedAt=GETDATE() WHERE StaffId=? AND IsDeleted=0";
        try (ResultSet rs = this.execSelectQuery(sqlGet, new Object[]{staffId})) {
            if (rs == null || !rs.next()) return false;
            String stored = rs.getString("PasswordHash");
            String newHash = Utils.hashPassword(newPwd);
            if (!Utils.verifyPassword(current, stored)) return false;
            int result = this.execQuery(sqlUpd, new Object[]{newHash, staffId});
            return result > 0;
        } catch (SQLException e) {
            System.err.println("changePassword: " + e.getMessage());
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
        s.setDateOfBirth(dob != null ? dob.toLocalDate() : null);
        Timestamp created = rs.getTimestamp("CreatedAt");
        if (created != null) s.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("UpdatedAt");
        if (updated != null) s.setUpdatedAt(updated.toLocalDateTime());
        s.setDeleted(rs.getBoolean("IsDeleted"));
        return s;
    }

   // ============================================
    // AUTHENTICATION
    // ============================================
    public Staff login(String email, String password) {
        String query = "SELECT * FROM Staff WHERE Email=? AND IsDeleted=0";
        try (ResultSet rs = this.execSelectQuery(query, new Object[]{email})) {
            if (rs == null || !rs.next()) return null;
            String hash = rs.getString("PasswordHash");
            if (!Utils.verifyPassword(password, hash)) return null;
            return mapStaff(rs);
        } catch (SQLException e) {
            System.err.println("login: " + e.getMessage());
            return null;
        }
    }
}
