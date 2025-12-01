package DAOs;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import Models.Voucher;

public class VoucherDAO extends DB.DBContext {

    // Lấy danh sách voucher khả dụng cho customer
    public List<Voucher> getAvailableVouchersForCustomer(int customerId) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT v.*, ISNULL(u.UsageCount, 0) as UsageCount " +
                      "FROM Voucher v " +
                      "LEFT JOIN VoucherUserUsage u ON v.VoucherId = u.VoucherId AND u.CustomerId = ? " +
                      "WHERE v.IsActive = 1 " +
                      "AND v.IsDeleted = 0 " +
                      "AND v.StartDate <= GETDATE() " +
                      "AND v.EndDate >= GETDATE() " +
                      "AND (v.TotalUsageLimit IS NULL OR v.TotalUsageLimit > ( " +
                      "    SELECT COUNT(*) FROM VoucherUserUsage WHERE VoucherId = v.VoucherId " +
                      ")) " +
                      "AND (v.UserUsageLimit IS NULL OR ISNULL(u.UsageCount, 0) < v.UserUsageLimit) " +
                      "ORDER BY v.Value DESC";

        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{customerId});
            while (rs != null && rs.next()) {
                Voucher voucher = mapResultSetToVoucher(rs);
                voucher.setUsageCount(rs.getInt("UsageCount"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // Lấy danh sách voucher đã sử dụng
    public List<Voucher> getUsedVouchersForCustomer(int customerId) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT v.*, u.UsageCount " +
                      "FROM Voucher v " +
                      "INNER JOIN VoucherUserUsage u ON v.VoucherId = u.VoucherId " +
                      "WHERE u.CustomerId = ? " +
                      "AND u.UsageCount > 0 " +
                      "ORDER BY v.EndDate DESC";

        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{customerId});
            while (rs != null && rs.next()) {
                Voucher voucher = mapResultSetToVoucher(rs);
                voucher.setUsageCount(rs.getInt("UsageCount"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // Lấy tất cả voucher của customer (cả available và used)
    public List<Voucher> getAllVouchersForCustomer(int customerId) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT v.*, ISNULL(u.UsageCount, 0) as UsageCount " +
                      "FROM Voucher v " +
                      "LEFT JOIN VoucherUserUsage u ON v.VoucherId = u.VoucherId AND u.CustomerId = ? " +
                      "WHERE v.IsActive = 1 " +
                      "AND v.IsDeleted = 0 " +
                      "AND v.StartDate <= GETDATE() " +
                      "AND v.EndDate >= GETDATE() " +
                      "ORDER BY v.Value DESC";

        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{customerId});
            while (rs != null && rs.next()) {
                Voucher voucher = mapResultSetToVoucher(rs);
                voucher.setUsageCount(rs.getInt("UsageCount"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // Lấy voucher bằng code
    public Voucher getVoucherByCode(String voucherCode, int customerId) {
        String query = "SELECT v.*, ISNULL(u.UsageCount, 0) as UsageCount " +
                      "FROM Voucher v " +
                      "LEFT JOIN VoucherUserUsage u ON v.VoucherId = u.VoucherId AND u.CustomerId = ? " +
                      "WHERE v.VoucherCode = ? " +
                      "AND v.IsActive = 1 " +
                      "AND v.IsDeleted = 0";

        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{customerId, voucherCode});
            if (rs != null && rs.next()) {
                Voucher voucher = mapResultSetToVoucher(rs);
                voucher.setUsageCount(rs.getInt("UsageCount"));
                return voucher;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra voucher có thể sử dụng không
    public boolean isVoucherUsable(int voucherId, int customerId) {
        String query = "SELECT COUNT(*) as Count " +
                      "FROM Voucher v " +
                      "LEFT JOIN VoucherUserUsage u ON v.VoucherId = u.VoucherId AND u.CustomerId = ? " +
                      "WHERE v.VoucherId = ? " +
                      "AND v.IsActive = 1 " +
                      "AND v.IsDeleted = 0 " +
                      "AND v.StartDate <= GETDATE() " +
                      "AND v.EndDate >= GETDATE() " +
                      "AND (v.TotalUsageLimit IS NULL OR v.TotalUsageLimit > ( " +
                      "    SELECT COUNT(*) FROM VoucherUserUsage WHERE VoucherId = v.VoucherId " +
                      ")) " +
                      "AND (v.UserUsageLimit IS NULL OR ISNULL(u.UsageCount, 0) < v.UserUsageLimit)";

        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{customerId, voucherId});
            if (rs != null && rs.next()) {
                return rs.getInt("Count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tăng số lần sử dụng voucher
    public boolean incrementVoucherUsage(int voucherId, int customerId) {
        // Kiểm tra xem đã có record chưa
        String checkQuery = "SELECT COUNT(*) as Count FROM VoucherUserUsage WHERE VoucherId = ? AND CustomerId = ?";
        String insertQuery = "INSERT INTO VoucherUserUsage (VoucherId, CustomerId, UsageCount) VALUES (?, ?, 1)";
        String updateQuery = "UPDATE VoucherUserUsage SET UsageCount = UsageCount + 1 WHERE VoucherId = ? AND CustomerId = ?";
        
        try {
            ResultSet rs = this.execSelectQuery(checkQuery, new Object[]{voucherId, customerId});
            if (rs != null && rs.next()) {
                int count = rs.getInt("Count");
                if (count > 0) {
                    // Update existing record
                    int result = this.execQuery(updateQuery, new Object[]{voucherId, customerId});
                    return result > 0;
                } else {
                    // Insert new record
                    int result = this.execQuery(insertQuery, new Object[]{voucherId, customerId});
                    return result > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy số lần sử dụng voucher của customer
    public int getVoucherUsageCount(int voucherId, int customerId) {
        String query = "SELECT UsageCount FROM VoucherUserUsage WHERE VoucherId = ? AND CustomerId = ?";
        
        try {
            ResultSet rs = this.execSelectQuery(query, new Object[]{voucherId, customerId});
            if (rs != null && rs.next()) {
                return rs.getInt("UsageCount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Voucher mapResultSetToVoucher(ResultSet rs) throws SQLException {
        Voucher voucher = new Voucher();
        voucher.setVoucherId(rs.getInt("VoucherId"));
        voucher.setVoucherCode(rs.getString("VoucherCode"));
        voucher.setType(rs.getString("Type"));
        voucher.setValue(rs.getBigDecimal("Value"));
        
        BigDecimal maxValue = rs.getBigDecimal("MaxValue");
        voucher.setMaxValue(rs.wasNull() ? null : maxValue);
        
        BigDecimal minValue = rs.getBigDecimal("MinValue");
        voucher.setMinValue(rs.wasNull() ? null : minValue);
        
        voucher.setVoucherDescription(rs.getString("VoucherDescription"));
        
        Timestamp startDate = rs.getTimestamp("StartDate");
        if (startDate != null) {
            voucher.setStartDate(startDate.toLocalDateTime());
        }
        
        Timestamp endDate = rs.getTimestamp("EndDate");
        if (endDate != null) {
            voucher.setEndDate(endDate.toLocalDateTime());
        }
        
        int totalUsageLimit = rs.getInt("TotalUsageLimit");
        voucher.setTotalUsageLimit(rs.wasNull() ? null : totalUsageLimit);
        
        int userUsageLimit = rs.getInt("UserUsageLimit");
        voucher.setUserUsageLimit(rs.wasNull() ? null : userUsageLimit);
        
        voucher.setActive(rs.getBoolean("IsActive"));
        
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            voucher.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            voucher.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        voucher.setDeleted(rs.getBoolean("IsDeleted"));
        
        return voucher;
    }

    // ========== THÊM CÁC METHOD SAU VÀO VOUCHERDAO HIỆN TẠI ==========

// ========== GET ALL VOUCHERS (SỬA LẠI) ==========
public List<Voucher> getAllVouchers() throws SQLException {
    List<Voucher> vouchers = new ArrayList<>();
    String query = "SELECT * FROM Voucher WHERE IsDeleted = 0 ORDER BY CreatedAt DESC";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            vouchers.add(mapVoucher(rs));
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in getAllVouchers: " + e.getMessage());
        throw e;
    }
    
    return vouchers;
}

// ========== GET VOUCHER BY ID (SỬA LẠI) ==========
public Voucher getVoucherById(int voucherId) throws SQLException {
    String query = "SELECT * FROM Voucher WHERE VoucherId = ? AND IsDeleted = 0";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setInt(1, voucherId);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapVoucher(rs);
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in getVoucherById: " + e.getMessage());
        throw e;
    }
    
    return null;
}

// ========== GET VOUCHER BY CODE (SỬA LẠI) ==========
public Voucher getVoucherByCode(String code) throws SQLException {
    String query = "SELECT * FROM Voucher WHERE VoucherCode = ? AND IsDeleted = 0";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setString(1, code);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapVoucher(rs);
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in getVoucherByCode: " + e.getMessage());
        throw e;
    }
    
    return null;
}

// ========== ADD VOUCHER (SỬA LẠI - BỎ UsageCount) ==========
public boolean addVoucher(Voucher voucher) throws SQLException {
    String query = "INSERT INTO Voucher (VoucherCode, Type, Value, MaxValue, MinValue, " +
                  "VoucherDescription, StartDate, EndDate, TotalUsageLimit, UserUsageLimit, " +
                  "IsActive, CreatedAt, UpdatedAt, IsDeleted) " +  // ❌ BỎ UsageCount
                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setString(1, voucher.getVoucherCode());
        ps.setString(2, voucher.getType());
        ps.setBigDecimal(3, voucher.getValue());
        ps.setBigDecimal(4, voucher.getMaxValue());
        ps.setBigDecimal(5, voucher.getMinValue());
        ps.setString(6, voucher.getVoucherDescription());
        
        if (voucher.getStartDate() != null) {
            ps.setTimestamp(7, Timestamp.valueOf(voucher.getStartDate()));
        } else {
            ps.setNull(7, Types.TIMESTAMP);
        }
        
        if (voucher.getEndDate() != null) {
            ps.setTimestamp(8, Timestamp.valueOf(voucher.getEndDate()));
        } else {
            ps.setNull(8, Types.TIMESTAMP);
        }
        
        if (voucher.getTotalUsageLimit() != null) {
            ps.setInt(9, voucher.getTotalUsageLimit());
        } else {
            ps.setNull(9, Types.INTEGER);
        }
        
        if (voucher.getUserUsageLimit() != null) {
            ps.setInt(10, voucher.getUserUsageLimit());
        } else {
            ps.setNull(10, Types.INTEGER);
        }
        
        ps.setBoolean(11, voucher.isActive());
        
        int result = ps.executeUpdate();
        System.out.println("✅ Voucher added: " + voucher.getVoucherCode());
        return result > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Error in addVoucher: " + e.getMessage());
        e.printStackTrace();  // In ra stack trace để debug
        throw e;
    }
}

// ========== UPDATE VOUCHER (SỬA LẠI) ==========
public boolean updateVoucher(Voucher voucher) throws SQLException {
    String query = "UPDATE Voucher SET VoucherCode = ?, Type = ?, Value = ?, MaxValue = ?, " +
                  "MinValue = ?, VoucherDescription = ?, StartDate = ?, EndDate = ?, " +
                  "TotalUsageLimit = ?, UserUsageLimit = ?, IsActive = ?, UpdatedAt = GETDATE() " +
                  "WHERE VoucherId = ? AND IsDeleted = 0";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setString(1, voucher.getVoucherCode());
        ps.setString(2, voucher.getType());
        ps.setBigDecimal(3, voucher.getValue());
        ps.setBigDecimal(4, voucher.getMaxValue());
        ps.setBigDecimal(5, voucher.getMinValue());
        ps.setString(6, voucher.getVoucherDescription());
        
        if (voucher.getStartDate() != null) {
            ps.setTimestamp(7, Timestamp.valueOf(voucher.getStartDate()));
        } else {
            ps.setNull(7, Types.TIMESTAMP);
        }
        
        if (voucher.getEndDate() != null) {
            ps.setTimestamp(8, Timestamp.valueOf(voucher.getEndDate()));
        } else {
            ps.setNull(8, Types.TIMESTAMP);
        }
        
        if (voucher.getTotalUsageLimit() != null) {
            ps.setInt(9, voucher.getTotalUsageLimit());
        } else {
            ps.setNull(9, Types.INTEGER);
        }
        
        if (voucher.getUserUsageLimit() != null) {
            ps.setInt(10, voucher.getUserUsageLimit());
        } else {
            ps.setNull(10, Types.INTEGER);
        }
        
        ps.setBoolean(11, voucher.isActive());
        ps.setInt(12, voucher.getVoucherId());
        
        int result = ps.executeUpdate();
        System.out.println("✅ Voucher updated: " + voucher.getVoucherCode());
        return result > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Error in updateVoucher: " + e.getMessage());
        throw e;
    }
}

// DELETE VOUCHER (Admin xóa - soft delete)
public boolean deleteVoucher(int voucherId) throws SQLException {
    String query = "UPDATE Voucher SET IsDeleted = 1, UpdatedAt = GETDATE() WHERE VoucherId = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setInt(1, voucherId);
        
        int result = ps.executeUpdate();
        System.out.println("✅ Voucher deleted: ID " + voucherId);
        return result > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Error in deleteVoucher: " + e.getMessage());
        throw e;
    }
}

// TOGGLE STATUS (Admin bật/tắt)
public boolean toggleVoucherStatus(int voucherId) throws SQLException {
    String query = "UPDATE Voucher SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END, " +
                  "UpdatedAt = GETDATE() WHERE VoucherId = ? AND IsDeleted = 0";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setInt(1, voucherId);
        
        int result = ps.executeUpdate();
        System.out.println("✅ Voucher status toggled: ID " + voucherId);
        return result > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Error in toggleVoucherStatus: " + e.getMessage());
        throw e;
    }
}

// ========== SEARCH VOUCHERS (SỬA LẠI) ==========
public List<Voucher> searchVouchers(String keyword) throws SQLException {
    List<Voucher> vouchers = new ArrayList<>();
    String query = "SELECT * FROM Voucher WHERE IsDeleted = 0 " +
                  "AND (VoucherCode LIKE ? OR VoucherDescription LIKE ?) " +
                  "ORDER BY CreatedAt DESC";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        String searchPattern = "%" + keyword + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in searchVouchers: " + e.getMessage());
        throw e;
    }
    
    return vouchers;
}

// ========== INCREMENT USAGE COUNT (THÊM MỚI) ==========
public boolean incrementUsageCount(int voucherId) throws SQLException {
    String query = "UPDATE Voucher SET UsageCount = UsageCount + 1, UpdatedAt = GETDATE() " +
                  "WHERE VoucherId = ? AND IsDeleted = 0";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setInt(1, voucherId);
        
        int result = ps.executeUpdate();
        return result > 0;
        
    } catch (SQLException e) {
        System.err.println("❌ Error in incrementUsageCount: " + e.getMessage());
        throw e;
    }
}

// ========== GET ACTIVE VOUCHERS (SỬA LẠI) ==========
public List<Voucher> getActiveVouchers() throws SQLException {
    List<Voucher> vouchers = new ArrayList<>();
    String query = "SELECT * FROM Voucher WHERE IsActive = 1 AND IsDeleted = 0 " +
                  "AND StartDate <= GETDATE() AND EndDate >= GETDATE() " +
                  "ORDER BY CreatedAt DESC";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            vouchers.add(mapVoucher(rs));
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in getActiveVouchers: " + e.getMessage());
        throw e;
    }
    
    return vouchers;
}

// ========== MAP RESULTSET TO VOUCHER (SỬA LẠI) ==========
private Voucher mapVoucher(ResultSet rs) throws SQLException {
    Voucher voucher = new Voucher();
    voucher.setVoucherId(rs.getInt("VoucherId"));
    voucher.setVoucherCode(rs.getString("VoucherCode"));
    voucher.setType(rs.getString("Type"));
    voucher.setValue(rs.getBigDecimal("Value"));
    voucher.setMaxValue(rs.getBigDecimal("MaxValue"));
    voucher.setMinValue(rs.getBigDecimal("MinValue"));
    voucher.setVoucherDescription(rs.getString("VoucherDescription"));
    
    Timestamp startTimestamp = rs.getTimestamp("StartDate");
    if (startTimestamp != null) {
        voucher.setStartDate(startTimestamp.toLocalDateTime());
    }
    
    Timestamp endTimestamp = rs.getTimestamp("EndDate");
    if (endTimestamp != null) {
        voucher.setEndDate(endTimestamp.toLocalDateTime());
    }
    
    voucher.setTotalUsageLimit(rs.getInt("TotalUsageLimit"));
    voucher.setUserUsageLimit(rs.getInt("UserUsageLimit"));
    voucher.setActive(rs.getBoolean("IsActive"));
    
    Timestamp createdTimestamp = rs.getTimestamp("CreatedAt");
    if (createdTimestamp != null) {
        voucher.setCreatedAt(createdTimestamp.toLocalDateTime());
    }
    
    Timestamp updatedTimestamp = rs.getTimestamp("UpdatedAt");
    if (updatedTimestamp != null) {
        voucher.setUpdatedAt(updatedTimestamp.toLocalDateTime());
    }
    
    voucher.setDeleted(rs.getBoolean("IsDeleted"));
    
    
    return voucher;
}


  // ========== GET ALL VOUCHERS WITH TOTAL USAGE COUNT ==========
    public List<Voucher> getAllVouchersWithUsageCount() throws SQLException {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT v.*, " +
                      "ISNULL(SUM(vu.UsageCount), 0) AS TotalUsageCount " +
                      "FROM Voucher v " +
                      "LEFT JOIN VoucherUserUsage vu ON v.VoucherId = vu.VoucherId " +
                      "WHERE v.IsDeleted = 0 " +
                      "GROUP BY v.VoucherId, v.VoucherCode, v.Type, v.Value, v.MaxValue, v.MinValue, " +
                      "v.VoucherDescription, v.StartDate, v.EndDate, v.TotalUsageLimit, v.UserUsageLimit, " +
                      "v.IsActive, v.CreatedAt, v.UpdatedAt, v.IsDeleted " +
                      "ORDER BY v.CreatedAt DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Voucher voucher = mapVoucher(rs);
                voucher.setUsageCount(rs.getInt("TotalUsageCount"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllVouchersWithUsageCount: " + e.getMessage());
            throw e;
        }
        
        return vouchers;
    }

    
}