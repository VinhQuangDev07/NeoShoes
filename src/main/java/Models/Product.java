package Models;

import java.util.ArrayList;
import java.util.List;

public class Product {

    private int productId;
    private int brandId;
    private int categoryId;
    private String name;
    private String description;
    private String defaultImageUrl;
    private String material;
    private double minPrice;
    private double maxPrice;
    private int totalQuantity;
    private String availableColors;
    private String availableSizes;
    private String brandName;
    private String categoryName;
    private int variantCount;
    
    // List of variants for this product
    private List<ProductVariant> variants;
    
    // Available colors and sizes as lists
    private List<String> colors;
    private List<String> sizes;

    public Product() {
        this.variants = new ArrayList<>();
        this.colors = new ArrayList<>();
        this.sizes = new ArrayList<>();
    }

    public Product(int productId, int brandId, int categoryId, String name, String description, String defaultImageUrl, String material, double minPrice, double maxPrice, int totalQuantity, String availableColors, String availableSizes, String brandName, String categoryName) {
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

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(double maxPrice) {
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

    public List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariant> variants) {
        this.variants = variants;
    }
    
    public void addVariant(ProductVariant variant) {
        if (this.variants == null) {
            this.variants = new ArrayList<>();
        }
        this.variants.add(variant);
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
    
    
}