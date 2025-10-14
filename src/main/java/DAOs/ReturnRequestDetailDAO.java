/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import java.math.BigDecimal;
import java.sql.SQLException;
import Models.ReturnRequestDetails;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class ReturnRequestDetailDAO extends DB.DBContext {

    public int addReturnRequestDetail(ReturnRequestDetails detail) throws SQLException {
        String sql = "INSERT INTO ReturnRequestDetails (ReturnRequestId, ProductVariantId, "
                + "Quantity, Amount, Note, CreateAt, UpdateAt) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        Object[] params = {detail.getReturnRequestId(), detail.getProductVariantId(), detail.getQuantity(), detail.getAmount(), detail.getNote()};
        return execQueryReturnId(sql, params);
    }
    public void updateReturnRequestDetail(int detailId, int quantity,
            BigDecimal amount, String note) throws SQLException {
        String sql = "UPDATE ReturnRequestDetails SET Quantity = ?, Amount = ?, "
                + "Note = ?, UpdateAt = GETDATE() WHERE ReturnRequestDetailId = ?";
        Object[] params = {quantity, amount, note, detailId};
        execQuery(sql, params);
    }
    
    public List<ReturnRequestDetails> getDetailsByReturnRequestId(int returnRequestId) 
            throws SQLException {
        List<ReturnRequestDetails> list = new ArrayList<>();
        String sql = "SELECT * FROM ReturnRequestDetails WHERE ReturnRequestId = ?";
         Object[] params = {returnRequestId};        
        try (ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                ReturnRequestDetails detail = new ReturnRequestDetails();
                detail.setReturnRequestDetailId(rs.getInt("ReturnRequestDetailId"));
                detail.setReturnRequestId(rs.getInt("ReturnRequestId"));
                detail.setProductVariantId(rs.getInt("ProductVariantId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setAmount(rs.getBigDecimal("Amount"));
                detail.setNote(rs.getString("Note"));
                detail.setCreateAt(rs.getDate("CreateAt"));
                detail.setUpdateAt(rs.getDate("UpdateAt"));
                detail.setRefundDate(rs.getDate("RefundDate"));
                list.add(detail);
            }
        }
        return list;
    }
}
