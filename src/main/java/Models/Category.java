package Models;

public class Category {
    private int categoryId;
    private String name;
    private String image;
    private boolean isActive;
    private boolean isDeleted;

    // Constructors
    public Category() {}
    
    public Category(int categoryId, String name, String image, boolean isActive, boolean isDeleted) {
        this.categoryId = categoryId;
        this.name = name;
        this.image = image;
        this.isActive = isActive;
        this.isDeleted = isDeleted;
    }

    // Getters and Setters
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
            
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    // Thêm getter/setter theo chuẩn JavaBean
    public boolean getIsActive() { return isActive; }
    public void setIsActive(boolean active) { isActive = active; }
    
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }
    
    public boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean deleted) { isDeleted = deleted; }
}