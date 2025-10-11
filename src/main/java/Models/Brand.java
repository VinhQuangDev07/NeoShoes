package Models;

public class Brand {
    private int brandId;
    private String name;
    private String logo;
    private boolean isDeleted;

    public Brand() {}

    public Brand(int brandId, String name, String logo, boolean isDeleted) {
        this.brandId = brandId;
        this.name = name;
        this.logo = logo;
        this.isDeleted = isDeleted;
    }

    // Getters and Setters
    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }
    
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }
}