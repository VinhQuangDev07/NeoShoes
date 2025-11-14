package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Models.Customer;
import Utils.Utils;

/**
 * Customer Data Access Object - standardized with DBContext utilities
 *
 * @author NeoShoes
 */
public class CustomerDAO extends DB.DBContext {

    // ==================== BASIC CRUD ====================
    public Customer findById(int id) {
        String sql = "SELECT * FROM Customer WHERE CustomerId=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{id})) {
            if (rs != null && rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            System.err.println("findById: " + e.getMessage());
        }
        return null;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE IsDeleted=0 ORDER BY CreatedAt DESC";
        try ( ResultSet rs = this.execSelectQuery(sql)) {
            while (rs != null && rs.next()) {
                list.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            System.err.println("getAllCustomers: " + e.getMessage());
        }
        return list;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS total FROM Customer WHERE IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql)) {
            if (rs != null && rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("getTotalCustomers: " + e.getMessage());
        }
        return 0;
    }

    public boolean updateBlockStatus(int customerId, boolean isBlock) {
        String sql = "UPDATE Customer SET IsBlock=?, UpdatedAt=GETDATE() WHERE CustomerId=?";
        try {
            int result = this.execQuery(sql, new Object[]{isBlock, customerId});
            return result > 0;
        } catch (SQLException e) {
            System.err.println("updateBlockStatus: " + e.getMessage());
            return false;
        }
    }

    // ==================== FIND & AUTH ====================
    public Customer findByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Email=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs != null && rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            System.err.println("findByEmail: " + e.getMessage());
        }
        return null;
    }

    public Customer login(String email, String password) {
        String sql = "SELECT * FROM Customer WHERE Email=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs == null || !rs.next()) {
                System.err.println("Customer not found: " + email);
                return null;
            }
            if (rs.getBoolean("IsBlock")) {
                System.err.println("Account is blocked: " + email);
                return null;
            }
            String stored = rs.getString("PasswordHash");
            if (!Utils.verifyPassword(password, stored)) {
                System.err.println("Invalid password for: " + email);
                return null;
            }
            return mapCustomer(rs);
        } catch (SQLException e) {
            System.err.println("login: " + e.getMessage());
            return null;
        }
    }

    public boolean updateLastLogin(int customerId) {
        String sql = "UPDATE Customer SET UpdatedAt=GETDATE() WHERE CustomerId=?";
        try {
            int result = this.execQuery(sql, new Object[]{customerId});
            return result > 0;
        } catch (SQLException e) {
            System.err.println("updateLastLogin: " + e.getMessage());
            return false;
        }
    }

    // ==================== CREATE / UPDATE ====================
    public boolean createCustomer(Customer c) {
        String sql = "INSERT INTO Customer (Email, PasswordHash, Name, PhoneNumber, Avatar, Gender, "
                + "CreatedAt, UpdatedAt, IsBlock, IsDeleted) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0, 0)";
        try {
            int result = this.execQuery(sql, new Object[]{
                c.getEmail(), c.getPasswordHash(), c.getName(),
                c.getPhoneNumber(), c.getAvatar(), c.getGender()
            });
            return result > 0;
        } catch (SQLException e) {
            System.err.println("createCustomer: " + e.getMessage());
            return false;
        }
    }

    public boolean updateProfile(int id, String name, String phone, String avatar, String gender) {
        String sql = "UPDATE Customer SET Name=?, PhoneNumber=?, Avatar=?, Gender=?, UpdatedAt=GETDATE() "
                + "WHERE CustomerId=? AND IsDeleted=0";
        try {
            int result = this.execQuery(sql, new Object[]{name, phone, avatar, gender, id});
            return result > 0;
        } catch (SQLException e) {
            System.err.println("updateProfile: " + e.getMessage());
            return false;
        }
    }

    public boolean verifyCurrentPassword(int id, String currentPlain) {
        String sql = "SELECT PasswordHash FROM Customer WHERE CustomerId=? AND IsDeleted=0";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{id})) {
            if (rs.next()) {
                String dbHash = rs.getString("PasswordHash");
                return Utils.verifyPassword(currentPlain, dbHash);
            }
        } catch (SQLException e) {
            System.err.println("verifyCurrentPassword: " + e.getMessage());
        }

        return false;
    }

//    public boolean changePassword(int id, String currentPlain, String newPlain) {
//        String sqlGet = "SELECT PasswordHash FROM Customer WHERE CustomerId=? AND IsDeleted=0";
//        String sqlUpd = "UPDATE Customer SET PasswordHash=?, UpdatedAt=GETDATE() WHERE CustomerId=?";
//        try ( ResultSet rs = this.execSelectQuery(sqlGet, new Object[]{id})) {
//            if (rs == null || !rs.next()) {
//                return false;
//            }
//            String oldHash = rs.getString("PasswordHash");
//            if (!Utils.verifyPassword(currentPlain, oldHash)) {
//                return false;
//            }
//            int result = this.execQuery(sqlUpd, new Object[]{Utils.hashPassword(newPlain), id});
//            return result > 0;
//        } catch (SQLException e) {
//            System.err.println("changePassword: " + e.getMessage());
//            return false;
//        }
//    }
    
    public boolean changePassword(int id, String newPlain) {
        String sql = "UPDATE Customer SET PasswordHash = ?, UpdatedAt = GETDATE() "
                + "WHERE CustomerId = ? AND IsDeleted = 0";

        String newHash = Utils.hashPassword(newPlain);

        try {
            int rows = execQuery(sql, new Object[]{newHash, id});
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("updatePassword: " + e.getMessage());
            return false;
        }
    }

    // ==================== EMAIL / VERIFY ====================
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) AS count FROM Customer WHERE Email=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs != null && rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.err.println("isEmailExists: " + e.getMessage());
        }
        return false;
    }

    public boolean createVerificationCode(int customerId, String code, LocalDateTime expiry) {
        String sql = "INSERT INTO VerifyCodeCustomer (CustomerId, Code, FailedCount, RequestCount, ExpiredAt, CreatedAt) "
                + "VALUES (?, ?, 0, 1, ?, GETDATE())";
        try {
            int result = this.execQuery(sql, new Object[]{
                customerId, code, Timestamp.valueOf(expiry)
            });
            return result > 0;
        } catch (SQLException e) {
            System.err.println("reateVerificationCode: " + e.getMessage());
            return false;
        }
    }

    public boolean verifyCustomer(String email, String code) {
        try {
            // Step 1: get ID
            ResultSet rsId = this.execSelectQuery("SELECT CustomerId FROM Customer WHERE Email=? AND IsDeleted=0", new Object[]{email});
            if (rsId == null || !rsId.next()) {
                return false;
            }
            int customerId = rsId.getInt("CustomerId");
            rsId.close();

            // Step 2: check code validity
            ResultSet rsCode = this.execSelectQuery(
                    "SELECT COUNT(*) AS cnt FROM VerifyCodeCustomer WHERE CustomerId=? AND Code=? AND ExpiredAt>GETDATE()",
                    new Object[]{customerId, code});
            if (rsCode == null || !rsCode.next() || rsCode.getInt("cnt") == 0) {
                return false;
            }
            rsCode.close();

            // Step 3: update customer
            this.execQuery("UPDATE Customer SET IsVerified=1, UpdatedAt=GETDATE() WHERE CustomerId=?", new Object[]{customerId});

            // Step 4: delete code
            this.execQuery("DELETE FROM VerifyCodeCustomer WHERE CustomerId=? AND Code=?", new Object[]{customerId, code});
            return true;

        } catch (SQLException e) {
            System.err.println("verifyCustomer: " + e.getMessage());
            return false;
        }
    }

    public int getCustomerIdByEmail(String email) {
        String sql = "SELECT CustomerId FROM Customer WHERE Email=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs != null && rs.next()) {
                return rs.getInt("CustomerId");
            }
        } catch (SQLException e) {
            System.err.println("etCustomerIdByEmail: " + e.getMessage());
        }
        return 0;
    }

    public boolean resendVerificationCode(String email) {
        int customerId = getCustomerIdByEmail(email);
        if (customerId == 0) {
            return false;
        }

        try {
            this.execQuery("DELETE FROM VerifyCodeCustomer WHERE CustomerId=?", new Object[]{customerId});
            String code = String.valueOf(100000 + (int) (Math.random() * 900000));
            LocalDateTime expiry = LocalDateTime.now().plusMinutes(10);
            boolean ok = createVerificationCode(customerId, code, expiry);
            if (ok) {
                System.out.println("Resent verification code to: " + email);
                // TODO: gửi email thật bằng EmailService
            }
            return ok;
        } catch (SQLException e) {
            System.err.println("resendVerificationCode: " + e.getMessage());
            return false;
        }
    }

    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Email=? AND IsDeleted=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs != null && rs.next()) {
                return mapCustomer(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ getCustomerByEmail: " + e.getMessage());
        }
        return null;
    }
    // ==================== PASSWORD RESET ====================
// Xóa OTP cũ
public void deleteOldVerifyCode(int customerId) {
    String sql = "DELETE FROM VerifyCodeCustomer WHERE CustomerId = ?";
    try {
        this.execQuery(sql, new Object[]{customerId});
    } catch (SQLException e) {
        System.err.println("❌ deleteOldVerifyCode: " + e.getMessage());
        e.printStackTrace();
    }
}

// Lưu OTP mới
public void saveVerifyCode(int customerId, String code, LocalDateTime expiredAt) {
    String sql = "INSERT INTO VerifyCodeCustomer (CustomerId, FailedCount, RequestCount, Code, ExpiredAt, CreatedAt) " +
                 "VALUES (?, 0, 1, ?, ?, GETDATE())";
    try {
        this.execQuery(sql, new Object[]{customerId, code, Timestamp.valueOf(expiredAt)});
    } catch (SQLException e) {
        System.err.println("❌ saveVerifyCode: " + e.getMessage());
        e.printStackTrace();
    }
}

// Verify OTP reset password
public boolean verifyResetOTP(String email, String otp) {
    String sql = "SELECT vc.Code, vc.ExpiredAt, vc.FailedCount " +
                 "FROM VerifyCodeCustomer vc " +
                 "INNER JOIN Customer c ON vc.CustomerId = c.CustomerId " +
                 "WHERE c.Email = ? " +
                 "ORDER BY vc.CreatedAt DESC";
    
    try {
        ResultSet rs = this.execSelectQuery(sql, new Object[]{email});
        
        if (rs != null && rs.next()) {
            String storedOTP = rs.getString("Code");
            Timestamp expiry = rs.getTimestamp("ExpiredAt");
            int failedCount = rs.getInt("FailedCount");
            
            if (failedCount >= 5) {
                return false;
            }
            
            if (storedOTP.equals(otp) && LocalDateTime.now().isBefore(expiry.toLocalDateTime())) {
                return true;
            } else {
                incrementFailedCount(email);
                return false;
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ verifyResetOTP: " + e.getMessage());
        e.printStackTrace();
    }
    return false;
}

// Tăng số lần nhập sai
private void incrementFailedCount(String email) {
    String sql = "UPDATE VerifyCodeCustomer " +
                 "SET FailedCount = FailedCount + 1 " +
                 "WHERE CustomerId = (SELECT CustomerId FROM Customer WHERE Email = ?)";
    try {
        this.execQuery(sql, new Object[]{email});
    } catch (SQLException e) {
        System.err.println("❌ incrementFailedCount: " + e.getMessage());
        e.printStackTrace();
    }
}

// Xóa OTP sau khi dùng xong
public void clearResetOTP(String email) {
    String sql = "DELETE FROM VerifyCodeCustomer " +
                 "WHERE CustomerId = (SELECT CustomerId FROM Customer WHERE Email = ?)";
    try {
        this.execQuery(sql, new Object[]{email});
    } catch (SQLException e) {
        System.err.println("❌ clearResetOTP: " + e.getMessage());
        e.printStackTrace();
    }
}

// Cập nhật password (method này đã có, giữ nguyên)
public boolean updatePassword(String email, String newPassword) {
    String sql = "UPDATE Customer SET PasswordHash = ?, UpdatedAt = GETDATE() WHERE Email = ?";
    try {
        this.execQuery(sql, new Object[]{newPassword, email});
        return true;
    } catch (SQLException e) {
        System.err.println("❌ updatePassword: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
    

    // ==================== MAPPER ====================
    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("CustomerId"));
        c.setEmail(rs.getString("Email"));
        c.setPasswordHash(rs.getString("PasswordHash"));
        c.setName(rs.getString("Name"));
        c.setPhoneNumber(rs.getString("PhoneNumber"));
        c.setAvatar(rs.getString("Avatar"));
        c.setGender(rs.getString("Gender"));
        try {
            c.setVerified(rs.getBoolean("IsVerified"));
        } catch (SQLException ignored) {
        }
        Timestamp cr = rs.getTimestamp("CreatedAt");
        Timestamp up = rs.getTimestamp("UpdatedAt");
        if (cr != null) {
            c.setCreatedAt(cr.toLocalDateTime());
        }
        if (up != null) {
            c.setUpdatedAt(up.toLocalDateTime());
        }
        c.setIsBlock(rs.getBoolean("IsBlock"));
        c.setIsDeleted(rs.getBoolean("IsDeleted"));
        return c;
    }
}
