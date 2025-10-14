/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class ReturnRequestDetails {

    private int returnRequestDetailId;
    private int returnRequestId;
    private int productVariantId;
    private int quantity;
    private Date createAt;
    private Date updateAt;
    private BigDecimal amount;
    private String note;
    private Date refundDate;

    public ReturnRequestDetails() {
    }

    public ReturnRequestDetails(int returnRequestDetailId, int returnRequestId, int productVariantId, int quantity, Date createAt, Date updateAt, BigDecimal amount, String note, Date refundDate) {
        this.returnRequestDetailId = returnRequestDetailId;
        this.returnRequestId = returnRequestId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.createAt = createAt;
        this.updateAt = updateAt;
        this.amount = amount;
        this.note = note;
        this.refundDate = refundDate;
    }

    public int getReturnRequestDetailId() {
        return returnRequestDetailId;
    }

    public void setReturnRequestDetailId(int returnRequestDetailId) {
        this.returnRequestDetailId = returnRequestDetailId;
    }

    public int getReturnRequestId() {
        return returnRequestId;
    }

    public void setReturnRequestId(int returnRequestId) {
        this.returnRequestId = returnRequestId;
    }

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public Date getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Date updateAt) {
        this.updateAt = updateAt;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getRefundDate() {
        return refundDate;
    }

    public void setRefundDate(Date refundDate) {
        this.refundDate = refundDate;
    }
    
}
