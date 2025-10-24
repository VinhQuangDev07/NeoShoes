package DAOs;

import DB.DBContext;
import Models.Category;
import java.sql.*;  
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private DBContext dbContext;

    public CategoryDAO() {
        this.dbContext = new DBContext();
    }

    // Lấy tất cả categories active
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted " +
                      "FROM Category WHERE IsActive = 1 AND IsDeleted = 0 " +
                      "ORDER BY Name";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryId"),
                    rs.getString("Name"),
                    rs.getString("Image"),
                    rs.getBoolean("IsActive"),
                    rs.getBoolean("IsDeleted")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }   
    
    // Lấy danh sách categories theo brand
    public List<Category> getCategoriesByBrand(int brandId) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT DISTINCT c.CategoryId, c.Name, c.Image, c.IsActive, c.IsDeleted " +
                       "FROM Category c " +
                       "INNER JOIN Product p ON c.CategoryId = p.CategoryId " +
                       "WHERE p.BrandId = ? AND c.IsActive = 1 AND c.IsDeleted = 0 " +
                       "ORDER BY c.Name";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, brandId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryId"),    
                    rs.getString("Name"),   
                    rs.getString("Image"),
                    rs.getBoolean("IsActive"),
                    rs.getBoolean("IsDeleted")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    // Lấy tất cả categories (bao gồm cả inactive) - cho staff quản lý
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted " +
                      "FROM Category WHERE IsDeleted = 0 " +
                      "ORDER BY CategoryId DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("CategoryId"),
                    rs.getString("Name"),
                    rs.getString("Image"),
                    rs.getBoolean("IsActive"),
                    rs.getBoolean("IsDeleted")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy category theo ID
    public Category getCategoryById(int id) {
        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted " +
                      "FROM Category WHERE CategoryId = ? AND IsDeleted = 0";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                        rs.getInt("CategoryId"),
                        rs.getString("Name"),
                        rs.getString("Image"),
                        rs.getBoolean("IsActive"),
                        rs.getBoolean("IsDeleted")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm category mới
    public boolean addCategory(Category category) {
        String query = "INSERT INTO Category (Name, Image, IsActive, IsDeleted) VALUES (?, ?, ?, 0)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getImage());
            ps.setBoolean(3, category.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật category
    public boolean updateCategory(Category category) {
        String query = "UPDATE Category SET Name = ?, Image = ?, IsActive = ? " +
                      "WHERE CategoryId = ? AND IsDeleted = 0";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, category.getName());
            ps.setString(2, category.getImage());
            ps.setBoolean(3, category.isActive());
            ps.setInt(4, category.getCategoryId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa mềm category
    public boolean deleteCategory(int id) {
        String query = "UPDATE Category SET IsDeleted = 1, IsActive = 0 WHERE CategoryId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra tên category đã tồn tại chưa
    public boolean isCategoryNameExists(String name, Integer excludeId) {
        String query = "SELECT COUNT(*) FROM Category WHERE Name = ? AND IsDeleted = 0";
        if (excludeId != null) {
            query += " AND CategoryId != ?";
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, name);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}