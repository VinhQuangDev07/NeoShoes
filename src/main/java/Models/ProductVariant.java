package Models;

import java.time.LocalDateTime;

public class ProductVariant {
    private int productVariantId;
    private int productId;
    private String image;
    private String color;
    private String size;
    private double price;
    private int quantityAvailable;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;

    public ProductVariant() {}

    public ProductVariant(int productVariantId, int productId, String image, String color, 
                         String size, double price, int quantityAvailable) {
        this.productVariantId = productVariantId;
        this.productId = productId;
        this.image = image;
        this.color = color;
        this.size = size;
        this.price = price;
        this.quantityAvailable = quantityAvailable;
    }

    // Getters and Setters
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public int getQuantityAvailable() { return quantityAvailable; }
    public void setQuantityAvailable(int quantityAvailable) { this.quantityAvailable = quantityAvailable; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }
}