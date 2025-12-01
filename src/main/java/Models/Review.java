/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;

/**
 * Review model representing customer reviews for products
 * @author Chau Gia Huy - CE190386
 */
public class Review {
    
    private int reviewId;
    private int productVariantId;
    private int customerId;
    private int star;
    private String reviewContent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;
    
    // Additional fields for display purposes (populated by DAO)
    private String customerName;
    private String productName;
    private String color;
    
    public Review() {
    }
    
    public Review(int reviewId, int productVariantId, int customerId, int star, 
                  String reviewContent, LocalDateTime createdAt, LocalDateTime updatedAt, boolean isDeleted) {
        this.reviewId = reviewId;
        this.productVariantId = productVariantId;
        this.customerId = customerId;
        this.star = star;
        this.reviewContent = reviewContent;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }
    
    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public int getProductVariantId() {
        return productVariantId;
    }
    
    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }
    
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public int getStar() {
        return star;
    }
    
    public void setStar(int star) {
        this.star = star;
    }
    
    public String getReviewContent() {
        return reviewContent;
    }
    
    public void setReviewContent(String reviewContent) {
        this.reviewContent = reviewContent;
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
    
    public boolean isDeleted() {
        return isDeleted;
    }
    
    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", productVariantId=" + productVariantId +
                ", customerId=" + customerId +
                ", star=" + star +
                ", reviewContent='" + reviewContent + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", isDeleted=" + isDeleted +
                '}';
    }
}
