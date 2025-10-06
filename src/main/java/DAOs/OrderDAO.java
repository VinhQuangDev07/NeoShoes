/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Order;
import Models.OrderItem;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access for customer orders
 */
public class OrderDAO extends DBContext {

    public List<Order> listByCustomer(int customerId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, " +
                    "osh.OrderStatus " +
                    "FROM dbo.[Order] o " +
                    "LEFT JOIN dbo.OrderStatusHistory osh ON o.OrderId = osh.OrderId " +
                    "WHERE o.CustomerId = ? " +
                    "ORDER BY o.PlacedAt DESC";
        List<Order> orders = new ArrayList<>();
        try {
            Connection con = getConnection();
            if (con == null) {
                System.out.println("❌ Database connection failed");
                return new ArrayList<>();
            }
            System.out.println("✅ Database connected successfully");
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerId);
            System.out.println("🔍 Querying orders for customer ID: " + customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    Order o = new Order();
                    o.setId(rs.getInt("OrderId"));
                    o.setCustomerId(rs.getInt("CustomerId"));
                    o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    o.setShippingFee(rs.getBigDecimal("ShippingFee"));
                    LocalDateTime placedAt = rs.getTimestamp("PlacedAt").toLocalDateTime();
                    LocalDateTime updatedAt = rs.getTimestamp("UpdatedAt").toLocalDateTime();
                    o.setCreatedAt(placedAt);
                    o.setUpdatedAt(updatedAt);
                    
                    // Get status from OrderStatusHistory
                    String status = rs.getString("OrderStatus");
                    if (status != null) {
                        o.setStatus(status);
                    } else {
                        o.setStatus("PENDING"); // Default status
                    }
                    
                    // Load order items
                    List<OrderItem> items = getOrderItems(o.getId());
                    o.setItems(items);
                    
                    System.out.println("📦 Found order: " + o.getId() + " - " + o.getStatus() + " - $" + o.getTotalAmount() + " - Items: " + items.size());
                    orders.add(o);
                }
                System.out.println("📊 Total orders found: " + count);
            }
        } catch (SQLException e) {
            System.out.println("❌ SQL Error: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
        
        // If no orders found, return empty list
        if (orders.isEmpty()) {
            System.out.println("⚠️ No orders found in database");
        }
        
        return orders;
    }
    
    private List<OrderItem> getOrderItems(int orderId) {
        String sql = "SELECT od.OrderDetailId, od.ProductVariantId, pv.Color, od.DetailQuantity, od.DetailPrice, p.Name AS ProductName "
                + "FROM dbo.OrderDetail od "
                + "JOIN dbo.ProductVariant pv ON pv.ProductVariantId = od.ProductVariantId "
                + "JOIN dbo.Product p ON p.ProductId = pv.ProductId "
                + "WHERE od.OrderId = ?";
        List<OrderItem> items = new ArrayList<>();
        try {
            Connection con = getConnection();
            if (con == null) {
                return new ArrayList<>();
            }
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("OrderDetailId"));
                    item.setOrderId(orderId);
                    item.setProductId(rs.getInt("ProductVariantId"));
                    item.setProductName(rs.getString("ProductName"));
                    item.setColor(rs.getString("Color"));
                    item.setQuantity(rs.getInt("DetailQuantity"));
                    BigDecimal unitPrice = rs.getBigDecimal("DetailPrice");
                    item.setUnitPrice(unitPrice);
                    item.setLineTotal(unitPrice.multiply(new BigDecimal(item.getQuantity())));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error loading order items: " + e.getMessage());
            return new ArrayList<>();
        }
        
        // If no items found, return empty list
        if (items.isEmpty()) {
            System.out.println("⚠️ No items found for order: " + orderId);
        }
        
        return items;
    }
    
    
    public int createOrder(Order order) {
        String sql = "INSERT INTO [Order] (CustomerId, Status, SubtotalAmount, DiscountAmount, ShippingFee, TotalAmount, VoucherCode, PlacedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection con = getConnection();
            if (con == null) {
                return -1;
            }
            
            PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getCustomerId());
            ps.setString(2, order.getStatus());
            ps.setBigDecimal(3, order.getSubtotalAmount());
            ps.setBigDecimal(4, order.getDiscountAmount());
            ps.setBigDecimal(5, order.getShippingFee());
            ps.setBigDecimal(6, order.getTotalAmount());
            ps.setString(7, order.getVoucherCode());
            ps.setTimestamp(8, java.sql.Timestamp.valueOf(order.getCreatedAt()));
            ps.setTimestamp(9, java.sql.Timestamp.valueOf(order.getUpdatedAt()));
            
            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1);
                        
                        // Insert order items
                        insertOrderItems(orderId, order.getItems());
                        
                        return orderId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    private void insertOrderItems(int orderId, List<OrderItem> items) {
        String sql = "INSERT INTO OrderDetail (OrderId, ProductVariantId, DetailQuantity, DetailPrice) VALUES (?, ?, ?, ?)";
        try {
            Connection con = getConnection();
            if (con == null) {
                return;
            }
            
            PreparedStatement ps = con.prepareStatement(sql);
            for (OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProductId()); // Assuming ProductVariantId
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getUnitPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET Status = ?, UpdatedAt = ? WHERE OrderId = ?";
        try {
            Connection con = getConnection();
            if (con == null) {
                return false;
            }
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, orderId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    

    public Order findWithItems(int orderId) {
        System.out.println("🔍 OrderDAO.findWithItems() called for Order ID: " + orderId);
        
        String sqlOrder = "SELECT o.OrderId, o.CustomerId, o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, " +
                         "osh.OrderStatus " +
                         "FROM dbo.[Order] o " +
                         "LEFT JOIN dbo.OrderStatusHistory osh ON o.OrderId = osh.OrderId " +
                         "WHERE o.OrderId = ?";
        String sqlItems = "SELECT od.OrderDetailId, od.ProductVariantId, pv.Color, od.DetailQuantity, od.DetailPrice, p.Name AS ProductName "
                + "FROM dbo.OrderDetail od "
                + "JOIN dbo.ProductVariant pv ON pv.ProductVariantId = od.ProductVariantId "
                + "JOIN dbo.Product p ON p.ProductId = pv.ProductId "
                + "WHERE od.OrderId=?";
        try {
            Connection con = getConnection();
            if (con == null) {
                System.out.println("❌ Database connection failed");
                return null;
            }
            System.out.println("✅ Database connected successfully for order detail");
            PreparedStatement ps = con.prepareStatement(sqlOrder);
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    System.out.println("⚠️ Order not found in database");
                    return null;
                }
                System.out.println("📦 Found order in database: " + orderId);
                
                Order o = new Order();
                o.setId(rs.getInt("OrderId"));
                o.setCustomerId(rs.getInt("CustomerId"));
                o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                o.setShippingFee(rs.getBigDecimal("ShippingFee"));
                LocalDateTime placedAt = rs.getTimestamp("PlacedAt").toLocalDateTime();
                LocalDateTime updatedAt = rs.getTimestamp("UpdatedAt").toLocalDateTime();
                o.setCreatedAt(placedAt);
                o.setUpdatedAt(updatedAt);
                
                // Get status from OrderStatusHistory
                String status = rs.getString("OrderStatus");
                if (status != null) {
                    o.setStatus(status);
                } else {
                    o.setStatus("PENDING"); // Default status
                }
                
                System.out.println("📦 Order details: ID=" + o.getId() + ", Customer=" + o.getCustomerId() + 
                                 ", Total=$" + o.getTotalAmount() + ", Status=" + o.getStatus());

                try (PreparedStatement ips = con.prepareStatement(sqlItems)) {
                    ips.setInt(1, orderId);
                    try (ResultSet irs = ips.executeQuery()) {
                        List<OrderItem> items = new ArrayList<>();
                        int itemCount = 0;
                        while (irs.next()) {
                            itemCount++;
                            OrderItem it = new OrderItem();
                            it.setId(irs.getInt("OrderDetailId"));
                            it.setOrderId(orderId);
                            it.setProductId(irs.getInt("ProductVariantId"));
                            it.setProductName(irs.getString("ProductName"));
                            it.setColor(irs.getString("Color"));
                            it.setQuantity(irs.getInt("DetailQuantity"));
                            BigDecimal unit = irs.getBigDecimal("DetailPrice");
                            it.setUnitPrice(unit);
                            it.setLineTotal(unit.multiply(new BigDecimal(it.getQuantity())));
                            items.add(it);
                            
                            System.out.println("📦 Item " + itemCount + ": " + it.getProductName() + 
                                             " x" + it.getQuantity() + " - $" + it.getUnitPrice());
                        }
                        o.setItems(items);
                        System.out.println("📊 Total items loaded: " + items.size());
                    }
                }

                System.out.println("✅ Order detail loaded successfully from database");
                return o;
            }
        } catch (SQLException e) {
            System.out.println("❌ SQL Error in findWithItems: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
}



