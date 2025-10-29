package Models;

//import java.sql.Timestamp;

public class Brand {
    private int brandId;
    private String Name;
    private String Logo;
    //private Timestamp isDeleted;
    private boolean isDeleted;

    public Brand() {
    }
     public Brand(String name, String logo) {
        this.Name = name;
        this.Logo = logo;
    }


    // Getters and Setters
    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }
    
    public String getName() { return Name; }
    public void setName(String name) { this.Name = name; }
    
    public String getLogo() { return Logo; }
    public void setLogo(String logo) { this.Logo = logo; }
    
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }
   
}