package DAOs;

import Models.ReturnRequest;
import Models.ReturnRequestDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReturnRequestDAO extends DB.DBContext {

    /**
     * Get return request by ID
     */
    public ReturnRequest getReturnRequestById(int returnRequestId) {
        String sql = "SELECT [ReturnRequestId], [OrderId], [CustomerId], [ReturnStatus], "
                + "[RequestDate], [DecideDate], [Reason], [BankAccountInfo], [Note] "
                + "FROM [ReturnRequest] WHERE [ReturnRequestId] = ?";
        Object[] params = {returnRequestId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                ReturnRequest rr = new ReturnRequest();
                rr.setReturnRequestId(rs.getInt("ReturnRequestId"));
                rr.setOrderId(rs.getInt("OrderId"));
                rr.setCustomerId(rs.getInt("CustomerId"));
                rr.setReturnStatus(rs.getString("ReturnStatus"));
                Timestamp requestTs = rs.getTimestamp("RequestDate");
                if (requestTs != null) {
                    rr.setRequestDate(requestTs.toLocalDateTime());
                }
                Timestamp decideTs = rs.getTimestamp("DecideDate");
                if (decideTs != null) {
                    rr.setDecideDate(decideTs.toLocalDateTime());
                }
                rr.setReason(rs.getString("Reason"));
                rr.setBankAccountInfo(rs.getString("BankAccountInfo"));
                rr.setNote(rs.getString("Note"));
                return rr;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<ReturnRequest> getAllReturnRequests() {
        List<ReturnRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ReturnRequest";

        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                ReturnRequest rr = new ReturnRequest();
                rr.setReturnRequestId(rs.getInt("ReturnRequestId"));
                rr.setOrderId(rs.getInt("OrderId"));
                rr.setCustomerId(rs.getInt("CustomerId"));
                rr.setReturnStatus(rs.getString("ReturnStatus"));

                Timestamp requestTs = rs.getTimestamp("RequestDate");
                if (requestTs != null) {
                    rr.setRequestDate(requestTs.toLocalDateTime());
                }

                Timestamp decideTs = rs.getTimestamp("DecideDate");
                if (decideTs != null) {
                    rr.setDecideDate(decideTs.toLocalDateTime());
                }

                rr.setReason(rs.getString("Reason"));
                rr.setBankAccountInfo(rs.getString("BankAccountInfo"));
                rr.setNote(rs.getString("Note"));
                list.add(rr);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Check if return request exists for an order
     */
    public boolean existsByOrderId(int orderId) throws SQLException {
        String sql = "SELECT COUNT(*) as cnt FROM [ReturnRequest] WHERE [OrderId] = ?";
        Object[] params = {orderId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        }
        return false;
    }

    /**
     * Create new return request
     */
    public int createReturnRequest(ReturnRequest request) throws SQLException {
        String sql = "INSERT INTO [ReturnRequest] (OrderId, CustomerId, ReturnStatus, "
                + "RequestDate, Reason, BankAccountInfo, Note) "
                + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";
        Object[] params = {
            request.getOrderId(),
            request.getCustomerId(),
            request.getReturnStatus(),
            request.getReason(),
            request.getBankAccountInfo(),
            request.getNote()
        };
        return execQueryReturnId(sql, params);
    }

    /**
     * Update return request status (for admin)
     */
    public int updateReturnRequestStatus(int returnRequestId, String newStatus) throws SQLException {
        String sql = "UPDATE [ReturnRequest] SET ReturnStatus = ?, DecideDate = GETDATE() "
                + "WHERE ReturnRequestId = ?";
        Object[] params = {newStatus, returnRequestId};
        return execQuery(sql, params);
    }

    /**
     * Delete return request (only if status is PENDING)
     */
    public int deleteReturnRequest(int returnRequestId, int customerId) {
        try {
            String sql = "DELETE FROM [ReturnRequest] "
                    + "WHERE ReturnRequestId = ? AND CustomerId = ?";
            Object[] params = {returnRequestId, customerId};
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public Integer getRequestIdByOrderId(int orderId) throws SQLException {
        String sql = "SELECT ReturnRequestId FROM ReturnRequest WHERE OrderId = ?";
        Object[] params = {orderId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("ReturnRequestId");
            }
        }
        return null;
    }

    /**
     * Admin update return request status and decide date
     */
    public int updateReturnRequestStatusByAdmin(int returnRequestId, String newStatus) {
        try {
            String sql = "UPDATE [ReturnRequest] "
                    + "SET ReturnStatus = ?, DecideDate = GETDATE() "
                    + "WHERE ReturnRequestId = ?";
            Object[] params = {newStatus, returnRequestId};
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * * Update return request (only if status is PENDING)
     */
    public int updateReturnRequest(int returnRequestId, int customerId, String reason, String bankAccountInfo, String note) throws SQLException {
        String sql = "UPDATE [ReturnRequest] SET Reason = ?, BankAccountInfo = ?, Note = ? " + "WHERE ReturnRequestId = ? AND CustomerId = ? AND ReturnStatus = 'PENDING'";
        Object[] params = {reason, bankAccountInfo, note, returnRequestId, customerId};
        return execQuery(sql, params);
    }
/**
 * Create return request with details (atomic transaction)
 */
public int createReturnRequestWithDetails(ReturnRequest request, List<ReturnRequestDetail> details) throws SQLException {
    String sqlRequest = "INSERT INTO [ReturnRequest] (OrderId, CustomerId, ReturnStatus, RequestDate, Reason, BankAccountInfo, Note) "
            + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";
    
    Connection conn = null;
    try {
        conn = this.getConnection();
        conn.setAutoCommit(false);
        
        // Insert return request
        Object[] params = {
            request.getOrderId(),
            request.getCustomerId(),
            request.getReturnStatus(),
            request.getReason(),
            request.getBankAccountInfo(),
            request.getNote()
        };
        
        int newRequestId = -1;
        try (PreparedStatement ps = conn.prepareStatement(sqlRequest, Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating return request failed, no rows affected");
            }
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    newRequestId = rs.getInt(1);
                } else {
                    throw new SQLException("Creating return request failed, no ID obtained");
                }
            }
        }
        
        // Insert details using batch
        ReturnRequestDetailDAO detailDAO = new ReturnRequestDetailDAO();
        detailDAO.insertDetailsBatch(conn, newRequestId, details);
        
        conn.commit();
        return newRequestId;
        
    } catch (SQLException ex) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, "Rollback failed", e);
            }
        }
        throw ex;
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, "Failed to close connection", e);
            }
        }
    }
}
}
