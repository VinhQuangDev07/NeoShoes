package Models;

import java.sql.Timestamp;

public class Brand {
    private int brandId;
    private String brandName;
    private String description;
    private Timestamp createdDate;
    
    // Constructors
    public Brand() {}
    
    public Brand(int brandId, String brandName, String description, Timestamp createdDate) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.description = description;
        this.createdDate = createdDate;
    }
    
    // Getters and Setters
    public int getBrandId() {
        return brandId;
    }
    
    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }
    
    public String getBrandName() {
        return brandName;
    }
    
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
}