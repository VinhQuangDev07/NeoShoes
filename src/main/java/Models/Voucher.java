package Models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Voucher {
    private int voucherId;
    private String voucherCode;
    private String type;
    private BigDecimal value;
    private BigDecimal maxValue;
    private BigDecimal minValue;
    private String voucherDescription;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private Integer totalUsageLimit;
    private Integer userUsageLimit;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;
    private Integer usageCount;

    // Constructors
    public Voucher() {}

    public Voucher(int voucherId, String voucherCode, String type, BigDecimal value, 
                  String voucherDescription, LocalDateTime startDate, LocalDateTime endDate,
                  boolean isActive) {
        this.voucherId = voucherId;
        this.voucherCode = voucherCode;
        this.type = type;
        this.value = value;
        this.voucherDescription = voucherDescription;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public String getVoucherCode() { return voucherCode; }
    public void setVoucherCode(String voucherCode) { this.voucherCode = voucherCode; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public BigDecimal getValue() { return value; }
    public void setValue(BigDecimal value) { this.value = value; }

    public BigDecimal getMaxValue() { return maxValue; }
    public void setMaxValue(BigDecimal maxValue) { this.maxValue = maxValue; }

    public BigDecimal getMinValue() { return minValue; }
    public void setMinValue(BigDecimal minValue) { this.minValue = minValue; }

    public String getVoucherDescription() { return voucherDescription; }
    public void setVoucherDescription(String voucherDescription) { this.voucherDescription = voucherDescription; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public Integer getTotalUsageLimit() { return totalUsageLimit; }
    public void setTotalUsageLimit(Integer totalUsageLimit) { this.totalUsageLimit = totalUsageLimit; }

    public Integer getUserUsageLimit() { return userUsageLimit; }
    public void setUserUsageLimit(Integer userUsageLimit) { this.userUsageLimit = userUsageLimit; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public Integer getUsageCount() { return usageCount; }
    public void setUsageCount(Integer usageCount) { this.usageCount = usageCount; }

    // Helper methods
    public String getDisplayValue() {
        if ("PERCENTAGE".equalsIgnoreCase(type)) {
            return value + "% OFF";
        } else {
            return "$" + value + " OFF";
        }
    }

    public boolean isExpired() {
        return endDate != null && endDate.isBefore(LocalDateTime.now());
    }
    

    public boolean canUseVoucher() {
        if (!isActive || isDeleted || isExpired()) {
            return false;
        }
        
        if (userUsageLimit != null && usageCount != null && usageCount >= userUsageLimit) {
            return false;
        }
        
        return true;
    }
}