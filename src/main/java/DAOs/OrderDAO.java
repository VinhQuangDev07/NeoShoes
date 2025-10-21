/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Order;
import Models.OrderDetail;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

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
                     "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt " +
                     "FROM dbo.[Order] o " +
                     "WHERE o.CustomerId = ? " +
                     "ORDER BY o.PlacedAt DESC";
        
        List<Order> orders = new ArrayList<>();
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
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
                     "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt " +
                     "FROM dbo.[Order] o " +
                     "WHERE o.OrderId = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
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
        String sql = "UPDATE dbo.[Order] SET UpdatedAt = ? WHERE OrderId = ?";
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
     * Delete an order and all its related data
     * @param orderId the order ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        try (Connection con = getConnection()) {
            con.setAutoCommit(false); // Start transaction
            
            try {
                // Delete OrderStatusHistory first (foreign key constraint)
                String deleteStatusHistorySql = "DELETE FROM dbo.OrderStatusHistory WHERE OrderId = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteStatusHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
                
                // Delete OrderDetail
                String deleteOrderDetailSql = "DELETE FROM dbo.OrderDetail WHERE OrderId = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteOrderDetailSql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }
                
                // Delete Order
                String deleteOrderSql = "DELETE FROM dbo.[Order] WHERE OrderId = ?";
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