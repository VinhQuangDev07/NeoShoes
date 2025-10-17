package DAOs;

import Models.ReturnRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReturnRequestDAO extends DB.DBContext {

    /**
     * Get return request by ID
     */
    public ReturnRequest getReturnRequestById(int returnRequestId) throws SQLException {
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
        }
        return null;
    }

    /**
     * Get all return requests by customer ID
     */
    public List<ReturnRequest> getReturnRequestsByCustomerId(int customerId) throws SQLException {
        List<ReturnRequest> list = new ArrayList<>();
        String sql = "SELECT [ReturnRequestId], [OrderId], [CustomerId], [ReturnStatus], "
                + "[RequestDate], [DecideDate], [Reason], [BankAccountInfo], [Note] "
                + "FROM [ReturnRequest] WHERE [CustomerId] = ? ORDER BY [RequestDate] DESC";
        Object[] params = {customerId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
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
     * Update return request (only if status is PENDING)
     */
    public int updateReturnRequest(int returnRequestId, int customerId,
            String reason, String bankAccountInfo, String note) throws SQLException {
        String sql = "UPDATE [ReturnRequest] SET Reason = ?, BankAccountInfo = ?, Note = ? "
                + "WHERE ReturnRequestId = ? AND CustomerId = ? AND ReturnStatus = 'PENDING'";
        Object[] params = {reason, bankAccountInfo, note, returnRequestId, customerId};
        return execQuery(sql, params);
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
    public int deleteReturnRequest(int returnRequestId, int customerId) throws SQLException {
        String sql = "DELETE FROM [ReturnRequest] "
                + "WHERE ReturnRequestId = ? AND CustomerId = ? AND ReturnStatus = 'PENDING'";
        Object[] params = {returnRequestId, customerId};
        return execQuery(sql, params);
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

}
