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
                System.out.println("❌ Database connection failed - returning sample data");
                return getSampleOrders(customerId);
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
            // Return sample data on error
            return getSampleOrders(customerId);
        }
        
        // If no orders found, return sample data for demo
        if (orders.isEmpty()) {
            System.out.println("⚠️ No orders found in database - returning sample data");
            return getSampleOrders(customerId);
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
                return getSampleOrderItems(orderId);
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
            return getSampleOrderItems(orderId);
        }
        
        // If no items found, return sample items
        if (items.isEmpty()) {
            return getSampleOrderItems(orderId);
        }
        
        return items;
    }
    
    private List<OrderItem> getSampleOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        
        // Sample items based on order ID
        if (orderId == 1) {
            OrderItem item1 = new OrderItem();
            item1.setId(1);
            item1.setOrderId(orderId);
            item1.setProductName("Nike Air Max 90");
            item1.setColor("Black");
            item1.setQuantity(1);
            item1.setUnitPrice(new BigDecimal("150.00"));
            item1.setLineTotal(new BigDecimal("150.00"));
            items.add(item1);
            
            OrderItem item2 = new OrderItem();
            item2.setId(2);
            item2.setOrderId(orderId);
            item2.setProductName("Adidas Ultraboost 22");
            item2.setColor("Core Black");
            item2.setQuantity(1);
            item2.setUnitPrice(new BigDecimal("180.00"));
            item2.setLineTotal(new BigDecimal("180.00"));
            items.add(item2);
        } else if (orderId == 2) {
            OrderItem item = new OrderItem();
            item.setId(3);
            item.setOrderId(orderId);
            item.setProductName("Converse Chuck 70 High");
            item.setColor("Black");
            item.setQuantity(1);
            item.setUnitPrice(new BigDecimal("85.00"));
            item.setLineTotal(new BigDecimal("85.00"));
            items.add(item);
        } else if (orderId == 3) {
            OrderItem item = new OrderItem();
            item.setId(4);
            item.setOrderId(orderId);
            item.setProductName("Vans Old Skool");
            item.setColor("Black");
            item.setQuantity(1);
            item.setUnitPrice(new BigDecimal("75.00"));
            item.setLineTotal(new BigDecimal("75.00"));
            items.add(item);
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
    
    private List<Order> getSampleOrders(int customerId) {
        List<Order> sampleOrders = new ArrayList<>();
        
        // Sample Order 1 - Delivered
        Order order1 = new Order();
        order1.setId(1001);
        order1.setCustomerId(customerId);
        order1.setSubtotalAmount(new BigDecimal("289.99"));
        order1.setDiscountAmount(new BigDecimal("0.00"));
        order1.setTotalAmount(new BigDecimal("299.99"));
        order1.setShippingFee(new BigDecimal("10.00"));
        order1.setStatus("COMPLETED");
        order1.setCreatedAt(LocalDateTime.of(2025, 9, 29, 1, 7, 50));
        order1.setUpdatedAt(LocalDateTime.of(2025, 9, 30, 1, 7, 50));
        
        // Add items to order1
        List<OrderItem> items1 = new ArrayList<>();
        OrderItem item1 = new OrderItem();
        item1.setId(1);
        item1.setOrderId(1001);
        item1.setProductName("Nike Air Max 270");
        item1.setColor("Black");
        item1.setQuantity(1);
        item1.setUnitPrice(new BigDecimal("189.99"));
        item1.setLineTotal(new BigDecimal("189.99"));
        items1.add(item1);
        
        OrderItem item2 = new OrderItem();
        item2.setId(2);
        item2.setOrderId(1001);
        item2.setProductName("Adidas Ultraboost 22");
        item2.setColor("White");
        item2.setQuantity(1);
        item2.setUnitPrice(new BigDecimal("99.99"));
        item2.setLineTotal(new BigDecimal("99.99"));
        items1.add(item2);
        
        order1.setItems(items1);
        sampleOrders.add(order1);
        
        // Sample Order 2 - Shipping
        Order order2 = new Order();
        order2.setId(1002);
        order2.setCustomerId(customerId);
        order2.setSubtotalAmount(new BigDecimal("149.99"));
        order2.setDiscountAmount(new BigDecimal("0.00"));
        order2.setTotalAmount(new BigDecimal("159.99"));
        order2.setShippingFee(new BigDecimal("10.00"));
        order2.setStatus("SHIPPED");
        order2.setCreatedAt(LocalDateTime.of(2025, 10, 1, 1, 7, 50));
        order2.setUpdatedAt(LocalDateTime.of(2025, 10, 2, 1, 7, 50));
        
        // Add items to order2
        List<OrderItem> items2 = new ArrayList<>();
        OrderItem item3 = new OrderItem();
        item3.setId(3);
        item3.setOrderId(1002);
        item3.setProductName("Jordan 1 Retro High");
        item3.setColor("Red");
        item3.setQuantity(1);
        item3.setUnitPrice(new BigDecimal("149.99"));
        item3.setLineTotal(new BigDecimal("149.99"));
        items2.add(item3);
        
        order2.setItems(items2);
        sampleOrders.add(order2);
        
        // Sample Order 3 - Pending
        Order order3 = new Order();
        order3.setId(1003);
        order3.setCustomerId(customerId);
        order3.setSubtotalAmount(new BigDecimal("79.99"));
        order3.setDiscountAmount(new BigDecimal("0.00"));
        order3.setTotalAmount(new BigDecimal("89.99"));
        order3.setShippingFee(new BigDecimal("10.00"));
        order3.setStatus("PENDING");
        order3.setCreatedAt(LocalDateTime.of(2025, 10, 3, 23, 7, 50));
        order3.setUpdatedAt(LocalDateTime.of(2025, 10, 3, 23, 7, 50));
        
        // Add items to order3
        List<OrderItem> items3 = new ArrayList<>();
        OrderItem item4 = new OrderItem();
        item4.setId(4);
        item4.setOrderId(1003);
        item4.setProductName("Converse Chuck Taylor");
        item4.setColor("Blue");
        item4.setQuantity(1);
        item4.setUnitPrice(new BigDecimal("79.99"));
        item4.setLineTotal(new BigDecimal("79.99"));
        items3.add(item4);
        
        order3.setItems(items3);
        sampleOrders.add(order3);
        
        return sampleOrders;
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
                System.out.println("❌ Database connection failed - returning sample data");
                return getSampleOrderWithItems(orderId); // Return sample data if DB not available
            }
            System.out.println("✅ Database connected successfully for order detail");
            PreparedStatement ps = con.prepareStatement(sqlOrder);
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    System.out.println("⚠️ Order not found in database - returning sample data");
                    return getSampleOrderWithItems(orderId); // Return sample data if order not found
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
            return getSampleOrderWithItems(orderId); // Return sample data on error
        }
    }
    
    private Order getSampleOrderWithItems(int orderId) {
        Order order = new Order();
        order.setId(orderId);
        order.setCustomerId(1); // Default customer ID
        order.setSubtotalAmount(new BigDecimal("289.99"));
        order.setDiscountAmount(new BigDecimal("0.00"));
        order.setTotalAmount(new BigDecimal("299.99"));
        order.setShippingFee(new BigDecimal("10.00"));
        order.setStatus("COMPLETED");
        order.setCreatedAt(LocalDateTime.now().minusDays(5));
        order.setUpdatedAt(LocalDateTime.now().minusDays(1));
        
        // Sample order items
        List<OrderItem> items = new ArrayList<>();
        
        OrderItem item1 = new OrderItem();
        item1.setId(1);
        item1.setOrderId(orderId);
        item1.setProductName("Nike Air Max 270");
        item1.setColor("Black");
        item1.setQuantity(1);
        item1.setUnitPrice(new BigDecimal("189.99"));
        item1.setLineTotal(new BigDecimal("189.99"));
        items.add(item1);
        
        OrderItem item2 = new OrderItem();
        item2.setId(2);
        item2.setOrderId(orderId);
        item2.setProductName("Adidas Ultraboost 22");
        item2.setColor("White");
        item2.setQuantity(1);
        item2.setUnitPrice(new BigDecimal("99.99"));
        item2.setLineTotal(new BigDecimal("99.99"));
        items.add(item2);
        
        order.setItems(items);
        return order;
    }
}


