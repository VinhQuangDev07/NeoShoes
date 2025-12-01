package DAOs;

import DB.DBContext;
import Models.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    // Lấy tất cả categories active
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();

        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted "
                + "FROM Category WHERE IsActive = 1 AND IsDeleted = 0 "
                + "ORDER BY Name";

        try ( ResultSet rs = execSelectQuery(query)) {

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

        String query = "SELECT DISTINCT c.CategoryId, c.Name, c.Image, c.IsActive, c.IsDeleted "
                + "FROM Category c "
                + "INNER JOIN Product p ON c.CategoryId = p.CategoryId "
                + "WHERE p.BrandId = ? AND c.IsActive = 1 AND c.IsDeleted = 0 "
                + "ORDER BY c.Name";

        Object[] params = {brandId};

        try ( ResultSet rs = execSelectQuery(query, params)) {

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

        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted "
                + "FROM Category WHERE IsDeleted = 0 "
                + "ORDER BY CategoryId DESC";

        try ( ResultSet rs = execSelectQuery(query)) {

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
        String query = "SELECT CategoryId, Name, Image, IsActive, IsDeleted "
                + "FROM Category WHERE CategoryId = ? AND IsDeleted = 0";

        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {

            if (rs.next()) {
                return new Category(
                        rs.getInt("CategoryId"),
                        rs.getString("Name"),
                        rs.getString("Image"),
                        rs.getBoolean("IsActive"),
                        rs.getBoolean("IsDeleted")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm category mới
    public boolean addCategory(Category category) {
        String query = "INSERT INTO Category (Name, Image, IsActive, IsDeleted) VALUES (?, ?, ?, 0)";

        Object[] params = {
            category.getName(),
            category.getImage(),
            category.isActive()
        };

        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật category
    public boolean updateCategory(Category category) {
        String query = "UPDATE Category SET Name = ?, Image = ?, IsActive = ? "
                + "WHERE CategoryId = ? AND IsDeleted = 0";

        Object[] params = {
            category.getName(),
            category.getImage(),
            category.isActive(),
            category.getCategoryId()
        };

        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa mềm category
    public boolean deleteCategory(int id) {
        String query = "UPDATE Category SET IsDeleted = 1, IsActive = 0 WHERE CategoryId = ?";

        Object[] params = {id};

        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Kiểm tra tên category đã tồn tại chưa
    public boolean isCategoryNameExists(String name, Integer excludeId) {
        String query = "SELECT COUNT(*) FROM Category WHERE Name = ? AND IsDeleted = 0";
        List<Object> paramList = new ArrayList<>();
        paramList.add(name);

        if (excludeId != null) {
            query += " AND CategoryId != ?";
            paramList.add(excludeId);
        }

        Object[] params = paramList.toArray();

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

}
