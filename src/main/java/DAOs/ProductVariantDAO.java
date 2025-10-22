/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.ProductVariant;
import java.math.BigDecimal;
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
    public List<ProductVariant> getVariantListByProductId(int productId) {
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
     * Lấy danh sách các màu sắc khác nhau của product
     */
    public List<String> getColorsByProductId(int productId) {
        List<String> colors = new ArrayList<>();
        String sql = "SELECT DISTINCT Color FROM ProductVariant "
                + "WHERE ProductId = ? AND IsDeleted = 0 "
                + "ORDER BY Color";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{productId})) {
            while (rs.next()) {
                String color = rs.getString("Color");
                if (color != null && !color.isEmpty()) {
                    colors.add(color);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return colors;
    }

    /**
     * Lấy danh sách các kích cỡ khác nhau của product
     */
    public List<String> getSizesByProductId(int productId) {
        List<String> sizes = new ArrayList<>();
        String sql = "SELECT DISTINCT Size FROM ProductVariant "
                + "WHERE ProductId = ? AND IsDeleted = 0 "
                + "ORDER BY Size";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{productId})) {
            while (rs.next()) {
                String size = rs.getString("Size");
                if (size != null && !size.isEmpty()) {
                    sizes.add(size);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sizes;
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
    
    public int getTotalQuantityAvailable() {
        try {
            String sql = "SELECT SUM(QuantityAvailable) AS TotalQuantity FROM ProductVariant";
            ResultSet rs = execSelectQuery(sql);
            int total = 0;
            if (rs.next()) {
                total = rs.getInt("TotalQuantity");
            }
            return total;
        } catch (SQLException ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    /**
     * Get current quantity available for a product variant
     */
    public int getQuantityAvailable(int variantId) {
        String sql = "SELECT QuantityAvailable FROM dbo.ProductVariant WHERE ProductVariantId = ?";
        Object[] params = {variantId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("QuantityAvailable");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Adjust quantity available (delta > 0 => increase, delta < 0 => decrease)
     */
    public boolean adjustQuantityAvailable(int variantId, int delta) {
        String sql = "UPDATE dbo.ProductVariant "
                + "SET QuantityAvailable = CASE "
                + "WHEN QuantityAvailable + ? < 0 THEN 0 " // đảm bảo không âm tồn
                + "ELSE QuantityAvailable + ? END, "
                + "UpdatedAt = GETDATE() "
                + "WHERE ProductVariantId = ? AND IsDeleted = 0";

        Object[] params = {delta, delta, variantId};

        try {
            int rowsAffected = execQuery(sql, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public BigDecimal getTotalInventoryValue() {
        try {
            String sql = "SELECT SUM(QuantityAvailable * Price) AS TotalPrice FROM ProductVariant";
            ResultSet rs = execSelectQuery(sql);
            BigDecimal totalPrice = BigDecimal.ZERO;
            if (rs.next()) {
                totalPrice = rs.getBigDecimal("TotalPrice");
                if (totalPrice == null) {
                    totalPrice = BigDecimal.ZERO;
                }
            }
            return totalPrice;
        } catch (SQLException ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

}
