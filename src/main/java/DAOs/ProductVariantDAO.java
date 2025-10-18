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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ProductVariantDAO extends DB.DBContext {

    /**
     * Get all variants of a specific product
     *
     * @param productId Product ID
     * @return List of ProductVariant
     */
    public List<ProductVariant> getByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariant WHERE ProductId=? AND IsDeleted=0";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{productId})) {
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
            e.printStackTrace();
        }
        return variants;
    }

    /**
     * Get a product variant by product ID, color, and size
     *
     * @param productId Product ID
     * @param color Color value
     * @param size Size value
     * @return ProductVariant or null if not found
     */
    public ProductVariant findByProductColorSize(int productId, String color, String size) {
        String sql = "SELECT * FROM ProductVariant WHERE ProductId=? AND Color=? AND Size=? AND IsDeleted=0";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{productId, color, size})) {
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
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get a product variant by product variant ID
     *
     * @param variantId Product Variant ID
     * @return ProductVariant or null if not found
     */
    public ProductVariant findById(int variantId) {
        String sql = "SELECT * FROM ProductVariant WHERE ProductVariantId=? AND IsDeleted=0";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{variantId})) {
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
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all active product variants with product info
     */
    public List<ProductVariant> getAllActiveVariants() {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT pv.ProductVariantId, pv.ProductId, pv.Image, pv.Color, pv.Size, "
                + "        pv.Price, pv.QuantityAvailable, p.Name AS ProductName "
                + "FROM dbo.ProductVariant pv "
                + "JOIN dbo.Product p ON p.ProductId = pv.ProductId AND p.IsDeleted = 0 "
                + "WHERE pv.IsDeleted = 0 "
                + "ORDER BY p.Name, pv.Color, pv.Size";

        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                ProductVariant pv = new ProductVariant();
                pv.setProductVariantId(rs.getInt("ProductVariantId"));
                pv.setProductId(rs.getInt("ProductId"));
                pv.setImage(rs.getString("Image"));
                pv.setColor(rs.getString("Color"));
                pv.setSize(rs.getString("Size"));
                pv.setPrice(rs.getBigDecimal("Price"));
                pv.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                pv.setProductName(rs.getString("ProductName"));
                variants.add(pv);
            }
            return variants;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return variants;
    }

    /**
     * Create new product variant
     */
    public int createVariant(ProductVariant variant) {
        String sql = "INSERT INTO dbo.ProductVariant (ProductId, Image, Color, Size, Price, QuantityAvailable, CreatedAt, UpdatedAt, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?, ?, SYSUTCDATETIME(), SYSUTCDATETIME(), 0)";

        Object[] params = {
            variant.getProductId(),
            variant.getImage(),
            variant.getColor(),
            variant.getSize(),
            variant.getPrice(),
            variant.getQuantityAvailable()
        };

        try {
            return execQueryReturnId(sql, params);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Increase quantity available
     */
    public void increaseQuantityAvailable(int variantId, int quantity) {
        String sql = "UPDATE dbo.ProductVariant SET QuantityAvailable = QuantityAvailable + ?, UpdatedAt = SYSUTCDATETIME() "
                + "WHERE ProductVariantId = ? AND IsDeleted = 0";

        try {
            execQuery(sql, new Object[]{quantity, variantId});
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Decrease quantity available
     */
    public void decreaseQuantityAvailable(int variantId, int quantity) {
        String sql = "UPDATE dbo.ProductVariant SET QuantityAvailable = QuantityAvailable - ?, UpdatedAt = SYSUTCDATETIME() "
                + "WHERE ProductVariantId = ? AND IsDeleted = 0 AND QuantityAvailable >= ?";

        try {
            execQuery(sql, new Object[]{quantity, variantId, quantity});
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
