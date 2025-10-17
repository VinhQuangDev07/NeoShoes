/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Order;
import Models.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * Data access for customer orders
 * @author Chau Gia Huy - CE190386
 */
public class OrderDAO extends DB.DBContext {

    /**
     * Get all orders for a customer
     */
    public List<Order> listByCustomer(int customerId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, o.PaymentStatusId, o.VoucherId, " +
                     "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, " +
                     "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone " +
                     "FROM [Order] o " +
                     "LEFT JOIN Address a ON o.AddressId = a.AddressId " +
                     "WHERE o.CustomerId = ? " +
                     "ORDER BY o.PlacedAt DESC";
        
        List<Order> orders = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));
                    // Load order items
                    order.setItems(getOrderItems(order.getOrderId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get a specific order with its items
     */
    public Order findWithItems(int orderId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, o.PaymentStatusId, o.VoucherId, " +
                     "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, " +
                     "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone " +
                     "FROM [Order] o " +
                     "LEFT JOIN Address a ON o.AddressId = a.AddressId " +
                     "WHERE o.OrderId = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));
                    // Load order items
                    order.setItems(getOrderItems(order.getOrderId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get order items for a specific order
     */
    public List<OrderDetail> getOrderItems(int orderId) {
        String sql = "SELECT od.OrderDetailId, od.OrderId, od.ProductVariantId, od.DetailQuantity, od.DetailPrice, od.AddressDetail, " +
                     "p.Name as ProductName, pv.Color " +
                     "FROM OrderDetail od " +
                     "INNER JOIN ProductVariant pv ON od.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "WHERE od.OrderId = ?";
        
        List<OrderDetail> items = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail item = new OrderDetail();
                    item.setOrderDetailId(rs.getInt("OrderDetailId"));
                    item.setOrderId(rs.getInt("OrderId"));
                    item.setProductVariantId(rs.getInt("ProductVariantId"));
                    item.setDetailQuantity(rs.getInt("DetailQuantity"));
                    item.setDetailPrice(rs.getBigDecimal("DetailPrice"));
                    item.setAddressDetail(rs.getString("AddressDetail"));
                    item.setProductName(rs.getString("ProductName"));
                    item.setColor(rs.getString("Color"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Create Order object from ResultSet
     */
    private Order createOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("OrderId"));
        order.setCustomerId(rs.getInt("CustomerId"));
        order.setAddressId(rs.getInt("AddressId"));
        order.setPaymentMethodId(rs.getInt("PaymentMethodId"));
        order.setPaymentStatusId(rs.getInt("PaymentStatusId"));
        order.setVoucherId(rs.getObject("VoucherId", Integer.class));
        order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        order.setShippingFee(rs.getBigDecimal("ShippingFee"));
        
        // Handle LocalDateTime conversion like CustomerDAO
        Timestamp placedAt = rs.getTimestamp("PlacedAt");
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        order.setPlacedAt(placedAt == null ? null : placedAt.toLocalDateTime());
        order.setUpdatedAt(updatedAt == null ? null : updatedAt.toLocalDateTime());
        
        return order;
    }

    /**
     * Update order status
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET UpdatedAt = ? WHERE OrderId = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create a new order from cart items
     * @param customerId the customer ID
     * @param addressId the delivery address ID
     * @param voucherId the voucher ID (nullable)
     * @param cartItemIds array of cart item IDs to include in order
     * @return the created order ID, or -1 if failed
     */
    public int createOrderFromCart(int customerId, int addressId, Integer voucherId, int[] cartItemIds) {
        try (Connection con = getConnection()) {
            con.setAutoCommit(false); // Start transaction
            
            try {
                // Calculate total amount from cart items
                BigDecimal totalAmount = calculateCartTotal(customerId, cartItemIds);
                BigDecimal shippingFee = new BigDecimal("10.00"); // Fixed shipping fee
                
                // Apply voucher discount if provided
                if (voucherId != null) {
                    BigDecimal discount = calculateVoucherDiscount(voucherId, totalAmount);
                    totalAmount = totalAmount.subtract(discount);
                }
                
                // Create order
                String insertOrderSql = "INSERT INTO [Order] (CustomerId, AddressId, PaymentMethodId, PaymentStatusId, VoucherId, TotalAmount, ShippingFee, PlacedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                int orderId;
                
                try (PreparedStatement ps = con.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, addressId);
                    ps.setInt(3, 1); // Default payment method (Cash on Delivery)
                    ps.setInt(4, 1); // Default payment status (Pending)
                    ps.setObject(5, voucherId);
                    ps.setBigDecimal(6, totalAmount);
                    ps.setBigDecimal(7, shippingFee);
                    
                    Timestamp now = Timestamp.valueOf(LocalDateTime.now());
                    ps.setTimestamp(8, now);
                    ps.setTimestamp(9, now);
                    
                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected <= 0) {
                        con.rollback();
                        return -1;
                    }
                    
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            orderId = generatedKeys.getInt(1);
                        } else {
                            con.rollback();
                            return -1;
                        }
                    }
                }
                
                // Create order details from cart items
                if (!createOrderDetailsFromCart(con, orderId, customerId, cartItemIds)) {
                    con.rollback();
                    return -1;
                }
                
                // Clear cart items after successful order creation
                if (!clearCartItems(con, cartItemIds)) {
                    con.rollback();
                    return -1;
                }
                
                con.commit(); // Commit transaction
                return orderId;
                
            } catch (SQLException e) {
                con.rollback(); // Rollback on error
                e.printStackTrace();
                return -1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    /**
     * Calculate total amount from cart items
     */
    private BigDecimal calculateCartTotal(int customerId, int[] cartItemIds) {
        String sql = "SELECT SUM(ci.Quantity * pv.Price) as Total " +
                    "FROM CartItem ci " +
                    "INNER JOIN ProductVariant pv ON ci.ProductVariantId = pv.ProductVariantId " +
                    "WHERE ci.CustomerId = ? AND ci.CartItemId = ?";
        
        BigDecimal total = BigDecimal.ZERO;
        try (Connection con = getConnection()) {
            for (int cartItemId : cartItemIds) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, cartItemId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            total = total.add(rs.getBigDecimal("Total"));
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
    
    /**
     * Calculate voucher discount amount
     */
    private BigDecimal calculateVoucherDiscount(int voucherId, BigDecimal totalAmount) {
        String sql = "SELECT Type, Value, MaxValue FROM Voucher WHERE VoucherId = ? AND IsActive = 1";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String type = rs.getString("Type");
                    BigDecimal value = rs.getBigDecimal("Value");
                    BigDecimal maxValue = rs.getBigDecimal("MaxValue");
                    
                    if ("PERCENTAGE".equalsIgnoreCase(type)) {
                        BigDecimal discount = totalAmount.multiply(value).divide(new BigDecimal("100"));
                        return maxValue != null && discount.compareTo(maxValue) > 0 ? maxValue : discount;
                    } else {
                        return maxValue != null && value.compareTo(maxValue) > 0 ? maxValue : value;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Create order details from cart items
     */
    private boolean createOrderDetailsFromCart(Connection con, int orderId, int customerId, int[] cartItemIds) {
        String sql = "INSERT INTO OrderDetail (OrderId, ProductVariantId, DetailQuantity, DetailPrice, AddressDetail) " +
                    "SELECT ?, ci.ProductVariantId, ci.Quantity, pv.Price, " +
                    "CONCAT(a.RecipientName, ', ', a.AddressDetails, ' | ', a.RecipientPhone) " +
                    "FROM CartItem ci " +
                    "INNER JOIN ProductVariant pv ON ci.ProductVariantId = pv.ProductVariantId " +
                    "INNER JOIN Address a ON a.AddressId = (SELECT AddressId FROM [Order] WHERE OrderId = ?) " +
                    "WHERE ci.CustomerId = ? AND ci.CartItemId = ?";
        
        try {
            for (int cartItemId : cartItemIds) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, orderId);
                    ps.setInt(3, customerId);
                    ps.setInt(4, cartItemId);
                    
                    if (ps.executeUpdate() <= 0) {
                        return false;
                    }
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Clear cart items after successful order creation
     */
    private boolean clearCartItems(Connection con, int[] cartItemIds) {
        String sql = "DELETE FROM CartItem WHERE CartItemId = ?";
        try {
            for (int cartItemId : cartItemIds) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, cartItemId);
                    ps.executeUpdate();
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete an order and all its related data
     * @param orderId the order ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        try (Connection con = getConnection()) {
            con.setAutoCommit(false); // Start transaction
            
            try {
                // Delete OrderStatusHistory first (foreign key constraint)
                String deleteStatusHistorySql = "DELETE FROM OrderStatusHistory WHERE OrderId = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteStatusHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
                
                // Delete OrderDetail
                String deleteOrderDetailSql = "DELETE FROM OrderDetail WHERE OrderId = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteOrderDetailSql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
                
                // Delete Order
                String deleteOrderSql = "DELETE FROM [Order] WHERE OrderId = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteOrderSql)) {
                    ps.setInt(1, orderId);
                    int rowsAffected = ps.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        con.commit(); // Commit transaction
                        return true;
                    } else {
                        con.rollback(); // Rollback if no rows affected
                        return false;
                    }
                }
            } catch (SQLException e) {
                con.rollback(); // Rollback on error
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}