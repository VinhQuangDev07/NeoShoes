/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.CartItem;
import Models.Product;
import Models.ProductVariant;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class CartDAO extends DB.DBContext{
    
    // Get a list of a customer's shopping cart
    public List<CartItem> getItemsByCustomerId(int customerId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.CartItemID, c.CustomerID, c.ProductVariantId, c.Quantity, c.CreatedAt, "
                   + "v.Size, v.Color, v.QuantityAvailable, v.Price, v.Image, "
                   + "p.ProductID, p.Name, p.DefaultImageUrl "
                   + "FROM CartItem c "
                   + "JOIN ProductVariant v ON c.ProductVariantId = v.ProductVariantId "
                   + "JOIN Product p ON v.ProductId = p.ProductID "
                   + "WHERE c.CustomerID = ? AND v.IsDeleted = 0 AND p.isDeleted = 0";
        try (ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setDefaultImageUrl(rs.getString("DefaultImageUrl"));

                ProductVariant v = new ProductVariant();
                v.setProductVariantId(rs.getInt("ProductVariantId"));
                v.setSize(rs.getString("Size"));
                v.setColor(rs.getString("Color"));
                v.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                v.setPrice(rs.getBigDecimal("Price"));
                v.setImage(rs.getString("Image"));
                v.setProduct(p);

                CartItem c = new CartItem();
                c.setCartItemId(rs.getInt("CartItemID"));
                c.setCustomerId(rs.getInt("CustomerID"));
                c.setVariant(v);
                c.setQuantity(rs.getInt("Quantity"));
                Timestamp cr = rs.getTimestamp("CreatedAt");
                c.setCreatedAt(cr == null ? null : cr.toLocalDateTime());

                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Check if the variant product is in the cart
    public CartItem findCartItem(int customerId, int variantId) {
        String sql = "SELECT * FROM CartItem WHERE CustomerID=? AND ProductVariantId=?";
        try (ResultSet rs = execSelectQuery(sql, new Object[]{customerId, variantId})) {
            if (rs.next()) {
                CartItem c = new CartItem();
                c.setCartItemId(rs.getInt("CartItemID"));
                c.setCustomerId(rs.getInt("CustomerID"));
                c.setQuantity(rs.getInt("Quantity"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add to cart
    public boolean addToCart(int customerId, int variantId, int quantity) {
        CartItem existing = findCartItem(customerId, variantId);
        if (existing != null) {
            return updateQuantity(existing.getCartItemId(), existing.getQuantity() + quantity);
        }

        String sql = "INSERT INTO CartItem (CustomerID, ProductVariantId, Quantity, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try {
            return execQuery(sql, new Object[]{customerId, variantId, quantity}) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update quantity
    public boolean updateQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE CartItem SET Quantity=? WHERE CartItemID=?";
        try {
            return execQuery(sql, new Object[]{quantity, cartItemId}) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Remove item from cart
    public boolean removeItem(int cartItemId) {
        String sql = "DELETE FROM CartItem WHERE CartItemID=?";
        try {
            return execQuery(sql, new Object[]{cartItemId}) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count total products in cart
    public int countItems(int customerId) {
        String sql = "SELECT COUNT(*) FROM CartItem WHERE CustomerID=?";
        try (ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Calculate total price of cart items
    public BigDecimal calculateTotalPrice(int customerId) {
        String sql = "SELECT SUM(c.Quantity * v.Price) as TotalPrice "
                   + "FROM CartItem c "
                   + "JOIN ProductVariant v ON c.ProductVariantId = v.ProductVariantId "
                   + "WHERE c.CustomerID = ? AND v.IsDeleted = 0";
        try (ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) {
                java.math.BigDecimal total = rs.getBigDecimal("TotalPrice");
                return total != null ? total : java.math.BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    // Update variant for a cart item
    public boolean updateVariant(int cartItemId, int variantId) {
        String sql = "UPDATE CartItem SET ProductVariantId=? WHERE CartItemID=?";
        try {
            return execQuery(sql, new Object[]{variantId, cartItemId}) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
