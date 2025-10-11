/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Product;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ProductDAO extends DB.DBContext{
    /**
     * Get product by ID
     * @param productId Product ID
     * @return Product object or null if not found
     */
    public Product getById(int productId) {
        String query = "SELECT * FROM Product WHERE ProductId=? AND IsDeleted=0";
                
        try (ResultSet rs = execSelectQuery(query, new Object[]{productId})) {
            if (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("ProductId"));
                product.setProductName(rs.getString("Name"));
                product.setDescription(rs.getString("Description"));
                product.setCategoryId(rs.getInt("CategoryId"));
                product.setBrandId(rs.getInt("BrandId"));
                product.setImageUrl(rs.getString("DefaultImageUrl"));
                product.setDeleted(rs.getBoolean("IsDeleted"));
                product.setCreatedAt(rs.getTimestamp("CreatedAt"));
                product.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
