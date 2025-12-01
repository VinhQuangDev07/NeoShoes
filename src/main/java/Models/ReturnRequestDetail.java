/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class ReturnRequestDetail {

    private int returnRequestDetailId;
    private int returnRequestId;
    private int productVariantId;
    private int quantity;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BigDecimal amount;
    private String note;
    private LocalDateTime refundDate;

    public ReturnRequestDetail() {
    }

    public ReturnRequestDetail(int returnRequestDetailId, int returnRequestId, int productVariantId, int quantity, LocalDateTime createdAt, LocalDateTime updatedAt, BigDecimal amount, String note, LocalDateTime refundDate) {
        this.returnRequestDetailId = returnRequestDetailId;
        this.returnRequestId = returnRequestId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
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

    public LocalDateTime getRefundDate() {
        return refundDate;
    }

    public void setRefundDate(LocalDateTime refundDate) {
        this.refundDate = refundDate;
    }
public String getFormattedRefundDate() {
        if (refundDate != null) {
            return refundDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "N/A";
    }
public String getFormattedUpdatedAt() {
        if (updatedAt != null) {
            return updatedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "N/A";
    }
public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "N/A";
    }
}
