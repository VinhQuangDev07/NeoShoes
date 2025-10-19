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
 * @author Le Huu Nghia - CE181052
 */
public class ImportProductDetail {
    private int importProductDetailId;
    private int importProductId;
    private int productVariantId;
    private int quantity;
    private BigDecimal costPrice;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Additional fields for display (joined from ProductVariant & Product)
    private String productName;
    private String color;
    private String size;
    private String variantImage;

    public ImportProductDetail() {
    }

    public ImportProductDetail(int importProductId, int productVariantId, int quantity, BigDecimal costPrice) {
        this.importProductId = importProductId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.costPrice = costPrice;
    }
    
    public ImportProductDetail(int importProductDetailId, int importProductId, int productVariantId, int quantity, BigDecimal costPrice, LocalDateTime createdAt, LocalDateTime updatedAt, String productName, String color, String size, String variantImage) {
        this.importProductDetailId = importProductDetailId;
        this.importProductId = importProductId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.costPrice = costPrice;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.productName = productName;
        this.color = color;
        this.size = size;
        this.variantImage = variantImage;
    }

    public int getImportProductDetailId() {
        return importProductDetailId;
    }

    public void setImportProductDetailId(int importProductDetailId) {
        this.importProductDetailId = importProductDetailId;
    }

    public int getImportProductId() {
        return importProductId;
    }

    public void setImportProductId(int importProductId) {
        this.importProductId = importProductId;
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

    public BigDecimal getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(BigDecimal costPrice) {
        this.costPrice = costPrice;
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

    // Getters & Setters - Display fields
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

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getVariantImage() {
        return variantImage;
    }

    public void setVariantImage(String variantImage) {
        this.variantImage = variantImage;
    }
    
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "N/A";
    }
    
    public String getFormattedUpdatedAt() {
        if (updatedAt != null) {
            return updatedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "N/A";
    }

    @Override
    public String toString() {
        return "ImportProductDetail{" + "importProductDetailId=" + importProductDetailId 
                + ", importProductId=" + importProductId 
                + ", productVariantId=" + productVariantId 
                + ", quantity=" + quantity 
                + ", costPrice=" + costPrice 
                + ", createdAt=" + createdAt 
                + ", updatedAt=" + updatedAt 
                + ", productName=" + productName 
                + ", color=" + color 
                + ", size=" + size 
                + ", variantImage=" + variantImage + '}';
    }
    
}
