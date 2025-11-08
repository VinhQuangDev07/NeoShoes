package Models;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Product {

    private int productId;
    private int brandId;
    private int categoryId;
    private String name;
    private String description;
    private String defaultImageUrl;
    private String material;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private int totalQuantity;
    private String availableColors;
    private String availableSizes;
    private String brandName;
    private String categoryName;
    private int variantCount;
    private String isActive;

    // List of variants for this product
    private List<ProductVariant> variants;

    // Available colors and sizes as lists
    private List<String> colors;
    private List<String> sizes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Statistic
    private int totalSold;
    private BigDecimal totalRevenue;

    public Product() {
    }

    public Product(int productId, int brandId, int categoryId, String name, String description, String defaultImageUrl, String material, BigDecimal minPrice, BigDecimal maxPrice, int totalQuantity, String availableColors, String availableSizes, String brandName, String categoryName, int variantCount, String isActive, List<ProductVariant> variants, List<String> colors, List<String> sizes, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.productId = productId;
        this.brandId = brandId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.defaultImageUrl = defaultImageUrl;
        this.material = material;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.totalQuantity = totalQuantity;
        this.availableColors = availableColors;
        this.availableSizes = availableSizes;
        this.brandName = brandName;
        this.categoryName = categoryName;
        this.variantCount = variantCount;
        this.isActive = isActive;
        this.variants = variants;
        this.colors = colors;
        this.sizes = sizes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public void addVariant(ProductVariant variant) {
        if (this.variants == null) {
            this.variants = new ArrayList<>();
        }
        this.variants.add(variant);
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDefaultImageUrl() {
        return defaultImageUrl;
    }

    public void setDefaultImageUrl(String defaultImageUrl) {
        this.defaultImageUrl = defaultImageUrl;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public String getAvailableColors() {
        return availableColors;
    }

    public void setAvailableColors(String availableColors) {
        this.availableColors = availableColors;
    }

    public String getAvailableSizes() {
        return availableSizes;
    }

    public void setAvailableSizes(String availableSizes) {
        this.availableSizes = availableSizes;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getVariantCount() {
        return variantCount;
    }

    public void setVariantCount(int variantCount) {
        this.variantCount = variantCount;
    }

    public String getIsActive() {
        return isActive;
    }

    public void setIsActive(String isActive) {
        this.isActive = isActive;
    }

    public List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariant> variants) {
        this.variants = variants;
    }

    public List<String> getColors() {
        return colors;
    }

    public void setColors(List<String> colors) {
        this.colors = colors;
    }

    public List<String> getSizes() {
        return sizes;
    }

    public void setSizes(List<String> sizes) {
        this.sizes = sizes;
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

    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "N/A";
    }

    public String getFormattedUpdatedAt() {
        if (updatedAt != null) {
            return updatedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "N/A";
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    
}
