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
}