package DAOs;

import Models.ReturnRequestDetail;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReturnRequestDetailDAO extends DB.DBContext {

    /**
     * Add return request detail
     *
     * @param detail
     * @return
     * @throws java.sql.SQLException
     */
    public int addReturnRequestDetail(ReturnRequestDetail detail) throws SQLException {
        String sql = "INSERT INTO [ReturnRequestDetail] (ReturnRequestId, ProductVariantId, "
                + "Quantity, Amount, Note, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        Object[] params = {
            detail.getReturnRequestId(),
            detail.getProductVariantId(),
            detail.getQuantity(),
            detail.getAmount(),
            detail.getNote()
        };
        return execQueryReturnId(sql, params);
    }

    /**
     * Update return request detail
     *
     * @param detailId
     * @param quantity
     * @param amount
     * @param note
     * @return
     * @throws java.sql.SQLException
     */
    public int updateReturnRequestDetail(int detailId, int quantity,
            BigDecimal amount, String note) throws SQLException {
        String sql = "UPDATE [ReturnRequestDetail] SET Quantity = ?, Amount = ?, "
                + "Note = ?, UpdatedAt = GETDATE() WHERE ReturnRequestDetailId = ?";

        Object[] params = {quantity, amount, note, detailId};
        return execQuery(sql, params);
    }

    /**
     * Get all details by return request ID
     *
     * @param returnRequestId
     * @return
     * @throws java.sql.SQLException
     */
    public List<ReturnRequestDetail> getDetailsByReturnRequestId(int returnRequestId) {
        List<ReturnRequestDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM [ReturnRequestDetail] WHERE ReturnRequestId = ?";
        Object[] params = {returnRequestId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                ReturnRequestDetail detail = new ReturnRequestDetail();
                detail.setReturnRequestDetailId(rs.getInt("ReturnRequestDetailId"));
                detail.setReturnRequestId(rs.getInt("ReturnRequestId"));
                detail.setProductVariantId(rs.getInt("ProductVariantId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setAmount(rs.getBigDecimal("Amount"));
                detail.setNote(rs.getString("Note"));

                Timestamp createTs = rs.getTimestamp("CreatedAt");
                if (createTs != null) {
                    detail.setCreatedAt(createTs.toLocalDateTime());
                }

                Timestamp updateTs = rs.getTimestamp("UpdatedAt");
                if (updateTs != null) {
                    detail.setUpdatedAt(updateTs.toLocalDateTime());
                }

                Timestamp refundTs = rs.getTimestamp("RefundDate");
                if (refundTs != null) {
                    detail.setRefundDate(refundTs.toLocalDateTime());
                }

                list.add(detail);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Delete detail by ID
     *
     * @param detailId
     * @return
     * @throws java.sql.SQLException
     */
    public int deleteDetail(int detailId) throws SQLException {
        String sql = "DELETE FROM [ReturnRequestDetail] WHERE ReturnRequestDetailId = ?";
        Object[] params = {detailId};
        return execQuery(sql, params);
    }

    /**
     * Delete all details by return request ID
     *
     * @param returnRequestId
     * @throws java.sql.SQLException
     */
    public int deleteDetailsByReturnRequestId(int returnRequestId) throws SQLException {
        String sql = "DELETE FROM [ReturnRequestDetail] WHERE ReturnRequestId = ?";
        Object[] params = {returnRequestId};
        return execQuery(sql, params);
    }

    /**
     * Admin marks detail as refunded (updates RefundDate)
     */
    public int updateRefundDate(int returnRequestDetailId) throws SQLException {
        String sql = "UPDATE [ReturnRequestDetail] "
                + "SET RefundDate = GETDATE(), UpdatedAt = GETDATE() "
                + "WHERE ReturnRequestDetailId = ?";
        Object[] params = {returnRequestDetailId};
        return execQuery(sql, params);
    }

    /**
     * Admin marks all details in a request as refunded
     */
    public int updateRefundDateByRequestId(int returnRequestId) {

        try {
            String sql = "UPDATE [ReturnRequestDetail] "
                    + "SET RefundDate = GETDATE(), UpdatedAt = GETDATE() "
                    + "WHERE ReturnRequestId = ?";
            Object[] params = {returnRequestId};
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDetailDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Insert multiple return request details in batch (for transaction support)
     */
    public void insertDetailsBatch(Connection conn, int returnRequestId, List<ReturnRequestDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO [ReturnRequestDetail] (ReturnRequestId, ProductVariantId, "
                + "Quantity, Amount, Note, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            for (ReturnRequestDetail detail : details) {
                ps.setInt(1, returnRequestId);
                ps.setInt(2, detail.getProductVariantId());
                ps.setInt(3, detail.getQuantity());
                ps.setBigDecimal(4, detail.getAmount());
                ps.setString(5, detail.getNote());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}
