/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.ProductVariant;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ProductVariantDAO extends DB.DBContext{
    /**
     * Get all variants of a specific product
     * @param productId Product ID
     * @return List of ProductVariant
     */
    public List<ProductVariant> getByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariant WHERE ProductId=? AND IsDeleted=0";

        try (ResultSet rs = execSelectQuery(sql, new Object[]{productId})) {
            while (rs.next()) {
                ProductVariant variant = new ProductVariant();
                variant.setProductVariantId(rs.getInt("ProductVariantId"));
                variant.setProductId(rs.getInt("ProductId"));
                variant.setImage(rs.getString("Image"));
                variant.setColor(rs.getString("Color"));
                variant.setSize(rs.getString("Size"));
                variant.setPrice(rs.getBigDecimal("Price"));
                variant.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                variant.setIsDeleted(rs.getInt("IsDeleted"));
                Timestamp cr = rs.getTimestamp("CreatedAt");
                variant.setCreatedAt(cr.toLocalDateTime());
                Timestamp up = rs.getTimestamp("UpdatedAt");
                variant.setUpdatedAt(up.toLocalDateTime());
                variants.add(variant);
            }
        } catch (SQLException e) {
            System.err.println("*** Error in getByProductId: " + e.getMessage());
        }
        return variants;
    }

    /**
     * Get a product variant by product ID, color, and size
     * @param productId Product ID
     * @param color Color value
     * @param size Size value
     * @return ProductVariant or null if not found
     */
    public ProductVariant findByProductColorSize(int productId, String color, String size) {
        String sql = "SELECT * FROM ProductVariant WHERE ProductId=? AND Color=? AND Size=? AND IsDeleted=0";

        try (ResultSet rs = execSelectQuery(sql, new Object[]{productId, color, size})) {
            if (rs.next()) {
                ProductVariant variant = new ProductVariant();
                variant.setProductVariantId(rs.getInt("ProductVariantId"));
                variant.setProductId(rs.getInt("ProductId"));
                variant.setColor(rs.getString("Color"));
                variant.setSize(rs.getString("Size"));
                variant.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                variant.setPrice(rs.getBigDecimal("Price"));
                variant.setImage(rs.getString("Image"));
                variant.setIsDeleted(rs.getInt("IsDeleted"));
                Timestamp cr = rs.getTimestamp("CreatedAt");
                variant.setCreatedAt(cr.toLocalDateTime());
                Timestamp up = rs.getTimestamp("UpdatedAt");
                variant.setUpdatedAt(up.toLocalDateTime());
                return variant;
            }
        } catch (SQLException e) {
            System.err.println("*** Error in findByProductColorSize: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get a product variant by product variant ID
     * @param variantId Product Variant ID
     * @return ProductVariant or null if not found
     */
    public ProductVariant findById(int variantId) {
        String sql = "SELECT * FROM ProductVariant WHERE ProductVariantId=? AND IsDeleted=0";

        try (ResultSet rs = execSelectQuery(sql, new Object[]{variantId})) {
            if (rs.next()) {
                ProductVariant variant = new ProductVariant();
                variant.setProductVariantId(rs.getInt("ProductVariantId"));
                variant.setProductId(rs.getInt("ProductId"));
                variant.setColor(rs.getString("Color"));
                variant.setSize(rs.getString("Size"));
                variant.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                variant.setPrice(rs.getBigDecimal("Price"));
                variant.setImage(rs.getString("Image"));
                variant.setIsDeleted(rs.getInt("IsDeleted"));
                Timestamp cr = rs.getTimestamp("CreatedAt");
                variant.setCreatedAt(cr.toLocalDateTime());
                Timestamp up = rs.getTimestamp("UpdatedAt");
                variant.setUpdatedAt(up.toLocalDateTime());
                return variant;
            }
        } catch (SQLException e) {
            System.err.println("*** Error in findById: " + e.getMessage());
        }
        return null;
    }
}
