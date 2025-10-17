/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class ReturnRequest {

    private int returnRequestId;
    private int orderId;
    private int customerId;
    private String returnStatus;
    private LocalDateTime requestDate;
    private LocalDateTime decideDate;
    private String reason;
    private String bankAccountInfo;
    private String note;

    public ReturnRequest() {
    }

    public ReturnRequest(int returnRequestId, int orderId, int customerId, String returnStatus, LocalDateTime requestDate, LocalDateTime decideDate, String reason, String bankAccountInfo, String note) {
        this.returnRequestId = returnRequestId;
        this.orderId = orderId;
        this.customerId = customerId;
        this.returnStatus = returnStatus;
        this.requestDate = requestDate;
        this.decideDate = decideDate;
        this.reason = reason;
        this.bankAccountInfo = bankAccountInfo;
        this.note = note;
    }

    public int getReturnRequestId() {
        return returnRequestId;
    }

    public void setReturnRequestId(int returnRequestId) {
        this.returnRequestId = returnRequestId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getReturnStatus() {
        return returnStatus;
    }

    public void setReturnStatus(String returnStatus) {
        this.returnStatus = returnStatus;
    }

    public LocalDateTime getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(LocalDateTime requestDate) {
        this.requestDate = requestDate;
    }

    public LocalDateTime getDecideDate() {
        return decideDate;
    }

    public void setDecideDate(LocalDateTime decideDate) {
        this.decideDate = decideDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getBankAccountInfo() {
        return bankAccountInfo;
    }

    public void setBankAccountInfo(String bankAccountInfo) {
        this.bankAccountInfo = bankAccountInfo;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

}
