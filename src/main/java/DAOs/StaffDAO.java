package DAOs;

import DB.DBContext;
import Models.Staff;
import java.sql.*;
import java.time.LocalDate;

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

    public boolean updateStaffProfile(Staff s) {
        String sql = "UPDATE Staff SET Name=?, PhoneNumber=?, Avatar=?, Gender=?,\n" + "                     Address=?, DateOfBirth=?, UpdatedAt=SYSDATETIME()\n" + "    WHERE StaffId=?\n";
        try ( Connection c = db.getConnection();  PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, s.getName());
            p.setString(2, s.getPhoneNumber());
            p.setString(3, s.getAvatar());
            p.setString(4, s.getGender());
            p.setString(5, s.getAddress());
            if (s.getDateOfBirth() == null) {
                p.setNull(6, Types.DATE);
            } else {
                p.setDate(6, Date.valueOf(s.getDateOfBirth()));
            }
            p.setInt(7, s.getStaffId());
            return p.executeUpdate() > 0;
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
        s.setAddress(rs.getString("Address"));                               // NEW
        Date dob = rs.getDate("DateOfBirth");                                // NEW
        s.setDateOfBirth(dob == null ? null : dob.toLocalDate());
        s.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        Timestamp up = rs.getTimestamp("UpdatedAt");
        s.setUpdatedAt(up == null ? null : up.toLocalDateTime());
        s.setDeleted(rs.getBoolean("IsDeleted"));
        return s;
    }
}
