/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Customer order aggregate root
 *
 * @author Chau Gia Huy - CE190386
 */
public class Order {

    private int orderId;
    private int customerId;
    private int addressId;
    private int paymentMethodId;
    private int paymentStatusId;
    private Integer voucherId; // nullable
    private BigDecimal totalAmount;
    private BigDecimal shippingFee;
    private LocalDateTime placedAt;
    private LocalDateTime updatedAt;
    private String status;
    private List<OrderDetail> items = new ArrayList<>();
    

    public Order() {
    }

    public Order(int orderId, int customerId, int addressId, int paymentMethodId, int paymentStatusId, Integer voucherId, BigDecimal totalAmount, BigDecimal shippingFee, LocalDateTime placedAt, LocalDateTime updatedAt, String status) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.addressId = addressId;
        this.paymentMethodId = paymentMethodId;
        this.paymentStatusId = paymentStatusId;
        this.voucherId = voucherId;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.placedAt = placedAt;
        this.updatedAt = updatedAt;
        this.status = status;
    }
    // Address information for display
    private String addressName;
    private String addressDetails;
    private String recipientName;
    private String recipientPhone;
    
    // Payment status name for display
    private String paymentStatusName;

    private transient Voucher voucher;

    public Voucher getVoucher() {
        return voucher;
    }
    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
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

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getPaymentMethodId() {
        return paymentMethodId;
    }

    public void setPaymentMethodId(int paymentMethodId) {
        this.paymentMethodId = paymentMethodId;
    }

    public int getPaymentStatusId() {
        return paymentStatusId;
    }

    public void setPaymentStatusId(int paymentStatusId) {
        this.paymentStatusId = paymentStatusId;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public LocalDateTime getPlacedAt() {
        return placedAt;
    }

    public void setPlacedAt(LocalDateTime placedAt) {
        this.placedAt = placedAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderDetail> getItems() {
        return items;
    }

    public void setItems(List<OrderDetail> items) {
        this.items = items;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

   

    public String getAddressName() {
        return addressName;
    }

    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }

    public String getAddressDetails() {
        return addressDetails;
    }

    public void setAddressDetails(String addressDetails) {
        this.addressDetails = addressDetails;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    /**
 * Calculate discount amount from order data
 * Formula: (Subtotal + Shipping) - Total
 */
public BigDecimal getDiscount() {
    if (voucherId == null || items == null || items.isEmpty()) {
        return BigDecimal.ZERO;
    }
    
    try {
        BigDecimal subtotal = getSubtotal();
        BigDecimal beforeDiscount = subtotal.add(shippingFee != null ? shippingFee : BigDecimal.ZERO);
        BigDecimal discount = beforeDiscount.subtract(totalAmount);
        
        return discount.compareTo(BigDecimal.ZERO) > 0 ? discount : BigDecimal.ZERO;
    } catch (Exception e) {
        return BigDecimal.ZERO;
    }
}

/**
 * Calculate subtotal from order items
 */
public BigDecimal getSubtotal() {
    if (items == null || items.isEmpty()) {
        return BigDecimal.ZERO;
    }
    
    BigDecimal subtotal = BigDecimal.ZERO;
    for (OrderDetail item : items) {
        if (item != null && item.getDetailPrice() != null) {
            BigDecimal itemTotal = item.getDetailPrice()
                .multiply(new BigDecimal(item.getDetailQuantity()));
            subtotal = subtotal.add(itemTotal);
        }
    }
    return subtotal;
}
    public String getPaymentStatusName() {
        return paymentStatusName;
    }

    public void setPaymentStatusName(String paymentStatusName) {
        this.paymentStatusName = paymentStatusName;
    }
}
