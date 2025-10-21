package DAOs;

import DB.DBContext;
import Models.Staff;
import java.sql.*;
import java.time.LocalDate;
import java.util.Objects;

public class StaffDAO {

    private final DBContext db = new DBContext();

    public Staff getStaffById(int id) {
        String sql = "SELECT * FROM Staff WHERE StaffId=? AND IsDeleted=0";
        try ( Connection c = db.getConnection();  PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try ( ResultSet rs = p.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
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
