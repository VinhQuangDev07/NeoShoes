/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class OrderStatusHistory {
    private int orderStatusHistoryId;
    private int orderId;
    private int changedBy;
    private String orderStatus;
    private LocalDateTime changedAt;
    private String changedByName; // Staff name who made the change

    public OrderStatusHistory() {
    }

    public OrderStatusHistory(int orderStatusHistoryId, int orderId, int changedBy, String orderStatus, LocalDateTime changedAt) {
        this.orderStatusHistoryId = orderStatusHistoryId;
        this.orderId = orderId;
        this.changedBy = changedBy;
        this.orderStatus = orderStatus;
        this.changedAt = changedAt;
    }

    public int getOrderStatusHistoryId() {
        return orderStatusHistoryId;
    }

    public void setOrderStatusHistoryId(int orderStatusHistoryId) {
        this.orderStatusHistoryId = orderStatusHistoryId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public LocalDateTime getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(LocalDateTime changedAt) {
        this.changedAt = changedAt;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }
    
}
