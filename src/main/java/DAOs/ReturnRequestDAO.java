package DAOs;

import Models.ReturnRequest;
import com.sun.mail.imap.ResyncData;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class ReturnRequestDAO extends DB.DBContext {

    public ReturnRequest getReturnRequestById(int id) {
        ReturnRequest rr = new ReturnRequest();
        String sql = "SELECT [ReturnRequestId], [OrderId], [ReturnStatus], [RequestDate], "
                + "[DecideDate], [Reason], [BankAccountInfo], [Note] "
                + "FROM [NeoShoes].[dbo].[ReturnRequest] WHERE CustomerId = ?";
        Object[] params = {id};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                rr.setReturnRequestId(rs.getInt("ReturnRequestId"));
                rr.setOrderId(rs.getInt("OrderId"));
                rr.setReturnStatus(rs.getString("ReturnStatus"));
                rr.setRequestDate(rs.getDate("RequestDate"));
                rr.setDecideDate(rs.getDate("DecideDate"));
                rr.setReason(rs.getString("Reason"));
                rr.setBankAccountInfo(rs.getString("BankAccountInfo"));
                rr.setNote(rs.getString("Note"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rr;
    }

    public int createReturnRequest(ReturnRequest request) throws SQLException {
        String sql = "INSERT INTO ReturnRequest (OrderId, CustomerId, ReturnStatus, RequestDate, "
                + "Reason, BankAccountInfo, Note) VALUES (?, ?,GETDATE(), ?, ?, ?, ?)";
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

    public void deleteReturnRequest(int id, int customerId) throws SQLException {
        String sql = "DELETE FROM ReturnRequest WHERE ReturnRequestId = ? AND CustomerId = ? AND ReturnStatus = 'Pending'";
        Object[] params = {id, customerId};
        execQuery(sql, params);
    }

    public void updateReturnRequest(int id, int customerId, String reason, String bankAccountInfo, String note) throws SQLException {
        String sql = "UPDATE ReturnRequest SET Reason = ?, BankAccountInfo = ?, Note = ? WHERE ReturnRequestId = ? AND CustomerId = ? AND ReturnStatus = 'Pending'";
        Object[] params = {reason, bankAccountInfo, note, id, customerId};
        execQuery(sql, params);
    }
}
