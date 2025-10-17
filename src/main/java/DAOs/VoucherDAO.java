package DAOs;

import Models.Voucher;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
}