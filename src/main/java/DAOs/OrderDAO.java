/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import DAOs.ProductVariantDAO;

import Models.Order;
import Models.OrderDetail;
import Models.OrderStatusHistory;
import Models.Address;

/**
 * Data access for customer orders
 *
 * @author Chau Gia Huy - CE190386
 */
public class OrderDAO extends DB.DBContext {

    /**
     * Get PaymentStatusId for Complete status
     */
    public int getCompleteStatusId() {
        String sql = "SELECT PaymentStatusId FROM PaymentStatus WHERE Name = 'Complete'";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PaymentStatusId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 2; // Default fallback
    }

    /**
     * Get PaymentStatusId for Complete status using existing connection
     */
    private int getCompleteStatusId(Connection con) throws SQLException {
        String sql = "SELECT PaymentStatusId FROM PaymentStatus WHERE Name = 'Complete'";

        try ( PreparedStatement ps = con.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PaymentStatusId");
                }
            }
        }

        return 2; // Default fallback
    }

    /**
     * Get PaymentStatus name by ID
     */
    public String getPaymentStatusName(int statusId) {
        String sql = "SELECT Name FROM PaymentStatus WHERE PaymentStatusId = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, statusId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "Unknown"; // Default fallback
    }

    public List<Order> listByCustomerHaveAddress(int customerId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, o.PaymentStatusId, o.VoucherId, "
                + "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "ps.Name as PaymentStatusName "
                + "FROM [Order] o "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "WHERE o.CustomerId = ? "
                + "ORDER BY o.PlacedAt DESC";

        List<Order> orders = new ArrayList<>();
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));
                    // Load payment status name
                    order.setPaymentStatusName(rs.getString("PaymentStatusName"));
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

    public List<Order> listByCustomer(int customerId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderId, "
                + "o.CustomerId, "
                + "o.AddressId, "
                + "o.PaymentMethodId, "
                + "o.PaymentStatusId, "
                + "o.VoucherId, "
                + "o.TotalAmount, "
                + "o.ShippingFee, "
                + "o.PlacedAt, "
                + "o.UpdatedAt, "
                + "oh.OrderStatus, "
                + "a.AddressName, "
                + "a.AddressDetails, "
                + "a.RecipientName, "
                + "a.RecipientPhone, "
                + "ps.Name AS PaymentStatusName "
                + "FROM [NeoShoes].[dbo].[Order] o "
                + "LEFT JOIN ( "
                + "    SELECT OrderId, OrderStatus "
                + "    FROM ( "
                + "        SELECT OrderId, OrderStatus, "
                + "        ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "        FROM OrderStatusHistory "
                + "    ) t "
                + "    WHERE rn = 1 "
                + ") oh ON o.OrderId = oh.OrderId "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "WHERE o.CustomerId = ? "
                + "ORDER BY o.PlacedAt DESC";

        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Order order = createOrderFromResultSet(rs);
                // Load address info
                order.setAddressName(rs.getString("AddressName"));
                order.setAddressDetails(rs.getString("AddressDetails"));
                order.setRecipientName(rs.getString("RecipientName"));
                order.setRecipientPhone(rs.getString("RecipientPhone"));
                // Load payment status name
                order.setPaymentStatusName(rs.getString("PaymentStatusName"));
                // Load order items
                order.setItems(getOrderItems(order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }

    public Order findWithItems(int orderId) {
        String sql = "SELECT "
                + "o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, o.PaymentStatusId, o.VoucherId, "
                + "o.TotalAmount, o.ShippingFee, o.PlacedAt, o.UpdatedAt, oh.OrderStatus, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "pm.Name as PaymentMethodName, ps.Name as PaymentStatusName "
                + "FROM [NeoShoes].[dbo].[Order] o "
                + "LEFT JOIN ( "
                + "  SELECT OrderId, OrderStatus FROM ( "
                + "    SELECT OrderId, OrderStatus, ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "    FROM OrderStatusHistory "
                + "  ) t WHERE rn = 1 "
                + ") oh ON o.OrderId = oh.OrderId "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentMethod pm ON o.PaymentMethodId = pm.PaymentMethodId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "WHERE o.OrderId = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = createOrderFromResultSet(rs);
                    // Load payment info
                    order.setPaymentMethodName(rs.getString("PaymentMethodName"));
                    order.setPaymentStatusName(rs.getString("PaymentStatusName"));

                    // Load address info (try snapshot first, fallback to current address)
                    Address orderAddressSnapshot = getOrderAddressSnapshot(orderId);
                    if (orderAddressSnapshot != null) {
                        // Use snapshot data - this preserves original order information
                        order.setAddressName(orderAddressSnapshot.getAddressName());
                        order.setAddressDetails(orderAddressSnapshot.getAddressDetails());
                        order.setRecipientName(orderAddressSnapshot.getRecipientName());
                        order.setRecipientPhone(orderAddressSnapshot.getRecipientPhone());
                    } else {
                        // Fallback to current address data - this will change if customer updates profile
                        order.setAddressName(rs.getString("AddressName"));
                        order.setAddressDetails(rs.getString("AddressDetails"));
                        order.setRecipientName(rs.getString("RecipientName"));
                        order.setRecipientPhone(rs.getString("RecipientPhone"));
                    }

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
        String sql = "SELECT od.OrderDetailId, od.OrderId, od.ProductVariantId, od.DetailQuantity, od.DetailPrice, od.AddressDetail, "
                + "p.Name as ProductName, pv.Color "
                + "FROM OrderDetail od "
                + "INNER JOIN ProductVariant pv ON od.ProductVariantId = pv.ProductVariantId "
                + "INNER JOIN Product p ON pv.ProductId = p.ProductId "
                + "WHERE od.OrderId = ?";

        List<OrderDetail> items = new ArrayList<>();
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
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
        order.setStatus(rs.getString("OrderStatus"));
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
        try ( Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                // Update order timestamp
                String sql = "UPDATE [Order] SET UpdatedAt = ? WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(2, orderId);
                    ps.executeUpdate();
                }

                // Insert status history
                String insertHistorySql = "INSERT INTO OrderStatusHistory (OrderId, ChangedBy, OrderStatus, ChangedAt) VALUES (?, ?, ?, ?)";
                try ( PreparedStatement ps = con.prepareStatement(insertHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, 1); // System/Admin (hardcoded for now)
                    ps.setString(3, status);
                    ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    ps.executeUpdate();
                }

                // If cancelling order, restore inventory and update payment status
                if ("CANCELLED".equals(status) || "CANCELED".equals(status)) {
                    restoreInventoryForCancelledOrder(con, orderId);
                    updatePaymentStatusForCancelledOrder(con, orderId);
                }

                // If completing order, update payment status to complete
                if ("COMPLETED".equals(status)) {
                    updatePaymentStatusForCompletedOrder(con, orderId);
                }

                con.commit();
                return true;

            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update order status for staff (with history tracking)
     */
    public boolean updateOrderStatusForCustomer(int orderId, String status, int customerId) {
        try ( Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                // Update order timestamp
                String updateOrderSql = "UPDATE [Order] SET UpdatedAt = ?, PaymentStatusId = ?  WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(updateOrderSql)) {
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(2, 4);
                    ps.setInt(3, orderId);
                    ps.executeUpdate();
                }

                // Insert status history with customer ID
                String insertHistorySql = "INSERT INTO OrderStatusHistory (OrderId, ChangedBy, OrderStatus, ChangedAt) VALUES (?, ?, ?, ?)";
                try ( PreparedStatement ps = con.prepareStatement(insertHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, customerId); // Use customer ID instead of staff ID
                    ps.setString(3, status);
                    ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    ps.executeUpdate();
                }

                // If cancelling order, restore inventory and update payment status
                if ("CANCELLED".equals(status)) {
                    System.out.println("Cancelling order " + orderId + " - restoring inventory and updating payment status");
                    restoreInventoryForCancelledOrder(con, orderId);
                    updatePaymentStatusForCancelledOrder(con, orderId);
                    System.out.println("Order " + orderId + " cancelled successfully with inventory restored and payment status updated");
                }

                // If completing order, update payment status to complete
                if ("COMPLETED".equals(status)) {
                    updatePaymentStatusForCompletedOrder(con, orderId);
                }

                con.commit();
                return true;

            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOrderStatusForStaff(int orderId, String status, int staffId) {
        try ( Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                // Update order timestamp
                String updateOrderSql = "UPDATE [Order] SET UpdatedAt = ?, PaymentStatusId = ? WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(updateOrderSql)) {
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(2, 3);
                    ps.setInt(3, orderId);
                    ps.executeUpdate();
                }

                // Insert status history
                String insertHistorySql = "INSERT INTO OrderStatusHistory (OrderId, ChangedBy, OrderStatus, ChangedAt) VALUES (?, ?, ?, ?)";
                try ( PreparedStatement ps = con.prepareStatement(insertHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, staffId);
                    ps.setString(3, status);
                    ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    ps.executeUpdate();
                }

                // If cancelling order, restore inventory and update payment status
                if ("CANCELLED".equals(status)) {
                    System.out.println("Cancelling order " + orderId + " - restoring inventory and updating payment status");
                    restoreInventoryForCancelledOrder(con, orderId);
                    updatePaymentStatusForCancelledOrder(con, orderId);
                    System.out.println("Order " + orderId + " cancelled successfully with inventory restored and payment status updated");
                }

                // If completing order, update payment status to complete
                if ("COMPLETED".equals(status)) {
                    updatePaymentStatusForCompletedOrder(con, orderId);
                }

                con.commit();
                return true;

            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Restore inventory when order is cancelled
     */
    private void restoreInventoryForCancelledOrder(Connection con, int orderId) throws SQLException {
        System.out.println("Restoring inventory for order " + orderId);

        // Get order details to restore inventory
        String getOrderDetailsSql = "SELECT ProductVariantId, DetailQuantity FROM OrderDetail WHERE OrderId = ?";

        try ( PreparedStatement ps = con.prepareStatement(getOrderDetailsSql)) {
            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                int restoredItems = 0;
                while (rs.next()) {
                    int productVariantId = rs.getInt("ProductVariantId");
                    int quantity = rs.getInt("DetailQuantity");

                    // Restore inventory
                    String restoreInventorySql = "UPDATE ProductVariant SET QuantityAvailable = QuantityAvailable + ? WHERE ProductVariantId = ?";
                    try ( PreparedStatement restorePs = con.prepareStatement(restoreInventorySql)) {
                        restorePs.setInt(1, quantity);
                        restorePs.setInt(2, productVariantId);
                        int updated = restorePs.executeUpdate();
                        if (updated > 0) {
                            restoredItems++;
                            System.out.println("Restored " + quantity + " units for ProductVariant " + productVariantId);
                        }
                    }
                }
                System.out.println("Total items restored: " + restoredItems);
            }
        }
    }

    /**
     * Update payment status when order is cancelled
     */
    private void updatePaymentStatusForCancelledOrder(Connection con, int orderId) throws SQLException {
        System.out.println("Updating payment status for cancelled order " + orderId);

        // For cancelled orders, keep payment status as-is (no need to change)
        // Business logic: Payment status remains Pending (awaiting refund) or Complete (refund needed)
        System.out.println("Payment status kept as-is for cancelled order (no change needed)");
    }

    /**
     * Get PaymentStatusId for Cancelled status
     */
    private int getCancelledPaymentStatusId() {
        String sql = "SELECT PaymentStatusId FROM PaymentStatus WHERE Name = 'Cancelled'";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PaymentStatusId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 4; // Default fallback for Cancelled
    }

    /**
     * Get PaymentStatusId for Cancelled status using existing connection
     */
    private int getCancelledPaymentStatusId(Connection con) throws SQLException {
        String sql = "SELECT PaymentStatusId FROM PaymentStatus WHERE Name = 'Cancelled'";

        try ( PreparedStatement ps = con.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("PaymentStatusId");
                }
            }
        }

        return 4; // Default fallback for Cancelled
    }

    /**
     * Update payment status when order is completed
     */
    private void updatePaymentStatusForCompletedOrder(Connection con, int orderId) throws SQLException {
        // Get current payment status
        String getPaymentStatusSql = "SELECT PaymentStatusId FROM [Order] WHERE OrderId = ?";
        int currentPaymentStatusId = 0;

        try ( PreparedStatement ps = con.prepareStatement(getPaymentStatusSql)) {
            ps.setInt(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currentPaymentStatusId = rs.getInt("PaymentStatusId");
                }
            }
        }

        // Only update payment status if it's not already complete
        if (currentPaymentStatusId != 2) { // 2 = Complete
            // Get the appropriate payment status ID for completed orders
            int completedPaymentStatusId = getCompleteStatusId(con);

            // Update payment status
            String updatePaymentStatusSql = "UPDATE [Order] SET PaymentStatusId = ? WHERE OrderId = ?";
            try ( PreparedStatement ps = con.prepareStatement(updatePaymentStatusSql)) {
                ps.setInt(1, completedPaymentStatusId);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Create a new order from cart items
     *
     * @param customerId the customer ID
     * @param addressId the delivery address ID
     * @param voucherId the voucher ID (nullable)
     * @param cartItemIds array of cart item IDs to include in order
     * @return the created order ID, or -1 if failed
     */
    public int createOrderFromCart(int customerId, int addressId, Integer voucherId, int[] cartItemIds) {
        try ( Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                // Calculate total amount from cart items
                BigDecimal subtotal = calculateCartTotal(customerId, cartItemIds);
                BigDecimal shippingFee = new BigDecimal("10.00");
                BigDecimal totalBeforeDiscount = subtotal.add(shippingFee);
                BigDecimal totalAmount = totalBeforeDiscount;

                // Apply voucher discount if provided
                if (voucherId != null) {
                    BigDecimal discount = calculateVoucherDiscount(voucherId, totalBeforeDiscount);
                    totalAmount = totalBeforeDiscount.subtract(discount);
                }

                // Create order
                String insertOrderSql = "INSERT INTO [Order] (CustomerId, AddressId, PaymentMethodId, PaymentStatusId, VoucherId, TotalAmount, ShippingFee, PlacedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                int orderId;

                try ( PreparedStatement ps = con.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
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

                    try ( ResultSet generatedKeys = ps.getGeneratedKeys()) {
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

                ProductVariantDAO productVariantDAO = new ProductVariantDAO();
                String variantSql = "SELECT ProductVariantId, Quantity FROM CartItem WHERE CartItemId = ?";
                for (int cartItemId : cartItemIds) {
                    try ( PreparedStatement ps = con.prepareStatement(variantSql)) {
                        ps.setInt(1, cartItemId);
                        try ( ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                int variantId = rs.getInt("ProductVariantId");
                                int quantity = rs.getInt("Quantity");

                                productVariantDAO.decreaseQuantityAvailable(variantId, quantity);
                            }
                        }
                    }
                }

                // Clear cart items after successful order creation
                if (!clearCartItems(con, cartItemIds)) {
                    con.rollback();
                    return -1;
                }

                // Add default PENDING status to OrderStatusHistory
                String insertStatusSql = "INSERT INTO OrderStatusHistory (OrderId, ChangedBy, OrderStatus, ChangedAt) VALUES (?, ?, ?, ?)";
                try ( PreparedStatement ps = con.prepareStatement(insertStatusSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, 1); // System/Admin (hardcoded for now)
                    ps.setString(3, "PENDING");
                    ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    ps.executeUpdate();
                }

                // Save order address snapshot
                String getAddressSql = "SELECT a.RecipientName, a.RecipientPhone, a.AddressName, a.AddressDetails "
                        + "FROM Address a "
                        + "WHERE a.AddressId = ?";
                try ( PreparedStatement ps = con.prepareStatement(getAddressSql)) {
                    ps.setInt(1, addressId);
                    try ( ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            String recipientName = rs.getString("RecipientName");
                            String recipientPhone = rs.getString("RecipientPhone");
                            String addressName = rs.getString("AddressName");
                            String addressDetails = rs.getString("AddressDetails");

                            // Save snapshot
                            String saveSnapshotSql = "INSERT INTO OrderAddress (OrderId, RecipientName, RecipientPhone, AddressName, AddressDetails) "
                                    + "VALUES (?, ?, ?, ?, ?)";
                            try ( PreparedStatement snapshotPs = con.prepareStatement(saveSnapshotSql)) {
                                snapshotPs.setInt(1, orderId);
                                snapshotPs.setString(2, recipientName);
                                snapshotPs.setString(3, recipientPhone);
                                snapshotPs.setString(4, addressName);
                                snapshotPs.setString(5, addressDetails);
                                snapshotPs.executeUpdate();
                            }
                        }
                    }
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
        StringBuilder sql = new StringBuilder(
                "SELECT SUM(ci.Quantity * pv.Price) as Total "
                + "FROM CartItem ci "
                + "INNER JOIN ProductVariant pv ON ci.ProductVariantId = pv.ProductVariantId "
                + "WHERE ci.CustomerId = ? AND ci.CartItemId IN (");

        for (int i = 0; i < cartItemIds.length; i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, customerId);
            for (int i = 0; i < cartItemIds.length; i++) {
                ps.setInt(i + 2, cartItemIds[i]);
            }
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("Total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private BigDecimal calculateVoucherDiscount(int voucherId, BigDecimal totalAmount) {
        String sql = "SELECT Type, Value, MaxValue FROM Voucher WHERE VoucherId = ? AND IsActive = 1";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try ( ResultSet rs = ps.executeQuery()) {
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
        String sql = "INSERT INTO OrderDetail (OrderId, ProductVariantId, DetailQuantity, DetailPrice, AddressDetail) "
                + "SELECT ?, ci.ProductVariantId, ci.Quantity, pv.Price, "
                + "CONCAT(a.RecipientName, ', ', a.AddressDetails, ' | ', a.RecipientPhone) "
                + "FROM CartItem ci "
                + "INNER JOIN ProductVariant pv ON ci.ProductVariantId = pv.ProductVariantId "
                + "INNER JOIN Address a ON a.AddressId = (SELECT AddressId FROM [Order] WHERE OrderId = ?) "
                + "WHERE ci.CustomerId = ? AND ci.CartItemId = ?";

        try {
            for (int cartItemId : cartItemIds) {
                try ( PreparedStatement ps = con.prepareStatement(sql)) {
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
                try ( PreparedStatement ps = con.prepareStatement(sql)) {
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
     *
     * @param orderId the order ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        try ( Connection con = getConnection()) {
            con.setAutoCommit(false); // Start transaction

            try {
                // Delete OrderStatusHistory first (foreign key constraint)
                String deleteStatusHistorySql = "DELETE FROM OrderStatusHistory WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(deleteStatusHistorySql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // Delete OrderDetail
                String deleteOrderDetailSql = "DELETE FROM OrderDetail WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(deleteOrderDetailSql)) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // Delete Order
                String deleteOrderSql = "DELETE FROM [Order] WHERE OrderId = ?";
                try ( PreparedStatement ps = con.prepareStatement(deleteOrderSql)) {
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

    // ================================
// ✅ NEW METHODS - VOUCHER SUPPORT
// ================================
    /**
     * Get order with voucher information Use this when displaying order details
     * to customer
     */
    public Order findWithItemsAndVoucher(int orderId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, "
                + "o.PaymentStatusId, o.VoucherId, o.TotalAmount, o.ShippingFee, "
                + "o.PlacedAt, o.UpdatedAt, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "v.VoucherCode, v.Type as VoucherType, v.Value as VoucherValue, "
                + "v.MaxValue as VoucherMaxValue "
                + "FROM [Order] o "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN Voucher v ON o.VoucherId = v.VoucherId "
                + "WHERE o.OrderId = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Create order using existing method
                    Order order = createOrderFromResultSet(rs);

                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));

                    // ✅ Load voucher info if exists
                    Integer voucherId = order.getVoucherId();
                    if (voucherId != null) {
                        String voucherCode = rs.getString("VoucherCode");
                        if (voucherCode != null) {
                            Models.Voucher voucher = new Models.Voucher();
                            voucher.setVoucherId(voucherId);
                            voucher.setVoucherCode(voucherCode);
                            voucher.setType(rs.getString("VoucherType"));
                            voucher.setValue(rs.getBigDecimal("VoucherValue"));

                            BigDecimal maxValue = rs.getBigDecimal("VoucherMaxValue");
                            if (maxValue != null) {
                                voucher.setMaxValue(maxValue);
                            }

                            order.setVoucher(voucher);
                        }
                    }

                    // Load order items using existing method
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
     * Get customer orders with voucher information Use this for order history
     * page
     */
    public List<Order> listByCustomerWithVoucher(int customerId) {
        String sql = "SELECT o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, "
                + "o.PaymentStatusId, o.VoucherId, o.TotalAmount, o.ShippingFee, "
                + "o.PlacedAt, o.UpdatedAt, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "v.VoucherCode, v.Type as VoucherType, v.Value as VoucherValue "
                + "FROM [Order] o "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN Voucher v ON o.VoucherId = v.VoucherId "
                + "WHERE o.CustomerId = ? "
                + "ORDER BY o.PlacedAt DESC";

        List<Order> orders = new ArrayList<>();

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Create order using existing method
                    Order order = createOrderFromResultSet(rs);

                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));

                    // ✅ Load voucher info if exists
                    Integer voucherId = order.getVoucherId();
                    if (voucherId != null) {
                        String voucherCode = rs.getString("VoucherCode");
                        if (voucherCode != null) {
                            Models.Voucher voucher = new Models.Voucher();
                            voucher.setVoucherId(voucherId);
                            voucher.setVoucherCode(voucherCode);
                            voucher.setType(rs.getString("VoucherType"));
                            voucher.setValue(rs.getBigDecimal("VoucherValue"));
                            order.setVoucher(voucher);
                        }
                    }

                    // Load order items using existing method
                    order.setItems(getOrderItems(order.getOrderId()));

                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

// ================================
// STAFF ORDER MANAGEMENT METHODS
// ================================
    /**
     * Get all orders for staff management with customer information
     */
    public List<Order> getAllOrdersForStaff() {
        String sql = "SELECT "
                + "o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, "
                + "o.PaymentStatusId, o.VoucherId, o.TotalAmount, o.ShippingFee, "
                + "o.PlacedAt, o.UpdatedAt, "
                + "c.Name as CustomerName, c.Email as CustomerEmail, c.PhoneNumber as CustomerPhone, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "ps.Name as PaymentStatusName, "
                + "oh.OrderStatus "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "LEFT JOIN ( "
                + "    SELECT OrderId, OrderStatus "
                + "    FROM ( "
                + "        SELECT OrderId, OrderStatus, "
                + "        ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "        FROM OrderStatusHistory "
                + "    ) t "
                + "    WHERE rn = 1 "
                + ") oh ON o.OrderId = oh.OrderId "
                + "ORDER BY o.PlacedAt DESC";

        List<Order> orders = new ArrayList<>();

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = createOrderFromResultSet(rs);

                    // Load customer info
                    order.setCustomerName(rs.getString("CustomerName"));
                    order.setCustomerEmail(rs.getString("CustomerEmail"));
                    order.setCustomerPhone(rs.getString("CustomerPhone"));

                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));

                    // Load payment status name
                    order.setPaymentStatusName(rs.getString("PaymentStatusName"));

                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    /**
     * Get total count of orders for staff (fast query)
     */
    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM [Order]";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get orders for staff with pagination (much faster)
     */
    public List<Order> getOrdersForStaffPaginated(int offset, int limit) {
        String sql = "SELECT "
                + "o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, "
                + "o.PaymentStatusId, o.VoucherId, o.TotalAmount, o.ShippingFee, "
                + "o.PlacedAt, o.UpdatedAt, "
                + "c.Name as CustomerName, c.Email as CustomerEmail, c.PhoneNumber as CustomerPhone, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "ps.Name as PaymentStatusName, "
                + "v.VoucherCode, v.Type as VoucherType, v.Value as VoucherValue, "
                + "oh.OrderStatus "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "LEFT JOIN Voucher v ON o.VoucherId = v.VoucherId "
                + "LEFT JOIN ( "
                + "    SELECT OrderId, OrderStatus "
                + "    FROM ( "
                + "        SELECT OrderId, OrderStatus, "
                + "        ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "        FROM OrderStatusHistory "
                + "    ) t "
                + "    WHERE rn = 1 "
                + ") oh ON o.OrderId = oh.OrderId "
                + "ORDER BY o.PlacedAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Order> orders = new ArrayList<>();

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = createOrderFromResultSet(rs);

                    // Load basic info
                    order.setCustomerName(rs.getString("CustomerName"));
                    order.setCustomerEmail(rs.getString("CustomerEmail"));
                    order.setCustomerPhone(rs.getString("CustomerPhone"));
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));
                    order.setPaymentStatusName(rs.getString("PaymentStatusName"));
                    order.setStatus(rs.getString("OrderStatus"));

                    // Load voucher info if exists
                    String voucherCode = rs.getString("VoucherCode");
                    if (voucherCode != null) {
                        Models.Voucher voucher = new Models.Voucher();
                        voucher.setVoucherCode(voucherCode);
                        voucher.setType(rs.getString("VoucherType"));
                        voucher.setValue(rs.getBigDecimal("VoucherValue"));
                        order.setVoucher(voucher);
                    }

                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    /**
     * Get order details for staff with full product information
     */
    public Order getOrderDetailForStaff(int orderId) {
        String sql = "SELECT "
                + "o.OrderId, o.CustomerId, o.AddressId, o.PaymentMethodId, "
                + "o.PaymentStatusId, o.VoucherId, o.TotalAmount, o.ShippingFee, "
                + "o.PlacedAt, o.UpdatedAt, "
                + "c.Name as CustomerName, c.Email as CustomerEmail, c.PhoneNumber as CustomerPhone, "
                + "a.AddressName, a.AddressDetails, a.RecipientName, a.RecipientPhone, "
                + "ps.Name as PaymentStatusName, "
                + "oh.OrderStatus "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON o.CustomerId = c.CustomerId "
                + "LEFT JOIN Address a ON o.AddressId = a.AddressId "
                + "LEFT JOIN PaymentStatus ps ON o.PaymentStatusId = ps.PaymentStatusId "
                + "LEFT JOIN ( "
                + "    SELECT OrderId, OrderStatus "
                + "    FROM ( "
                + "        SELECT OrderId, OrderStatus, "
                + "        ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "        FROM OrderStatusHistory "
                + "    ) t "
                + "    WHERE rn = 1 "
                + ") oh ON o.OrderId = oh.OrderId "
                + "WHERE o.OrderId = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = createOrderFromResultSet(rs);

                    // Load customer info
                    order.setCustomerName(rs.getString("CustomerName"));
                    order.setCustomerEmail(rs.getString("CustomerEmail"));
                    order.setCustomerPhone(rs.getString("CustomerPhone"));

                    // Load address info
                    order.setAddressName(rs.getString("AddressName"));
                    order.setAddressDetails(rs.getString("AddressDetails"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setRecipientPhone(rs.getString("RecipientPhone"));

                    // Load payment status name
                    order.setPaymentStatusName(rs.getString("PaymentStatusName"));

                    // Load order status
                    order.setStatus(rs.getString("OrderStatus"));

                    // Load address info (try snapshot first, fallback to current address)
                    Address orderAddressSnapshot = getOrderAddressSnapshot(orderId);
                    if (orderAddressSnapshot != null) {
                        // Use snapshot data - this preserves original order information
                        order.setAddressName(orderAddressSnapshot.getAddressName());
                        order.setAddressDetails(orderAddressSnapshot.getAddressDetails());
                        order.setRecipientName(orderAddressSnapshot.getRecipientName());
                        order.setRecipientPhone(orderAddressSnapshot.getRecipientPhone());
                        System.out.println("Using OrderAddress snapshot for OrderId: " + orderId);
                    } else {
                        // Fallback to current address data - this will change if customer updates profile
                        order.setAddressName(rs.getString("AddressName"));
                        order.setAddressDetails(rs.getString("AddressDetails"));
                        order.setRecipientName(rs.getString("RecipientName"));
                        order.setRecipientPhone(rs.getString("RecipientPhone"));
                        System.out.println("Using current Address data for OrderId: " + orderId + " (snapshot not found)");
                    }

                    // Load order items with full product details
                    order.setItems(getOrderItemsForStaff(orderId));

                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get customer's current address (latest address) This is used to compare
     * with order address to show if customer has changed address
     */
    public Address getCustomerCurrentAddress(int customerId) {
        String sql = "SELECT TOP 1 AddressId, AddressName, AddressDetails, RecipientName, RecipientPhone "
                + "FROM Address "
                + "WHERE CustomerId = ? "
                + "ORDER BY CreatedAt DESC";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Address address = new Address();
                    address.setAddressId(rs.getInt("AddressId"));
                    address.setAddressName(rs.getString("AddressName"));
                    address.setAddressDetails(rs.getString("AddressDetails"));
                    address.setRecipientName(rs.getString("RecipientName"));
                    address.setRecipientPhone(rs.getString("RecipientPhone"));
                    return address;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get order address snapshot from OrderAddress table This contains the
     * delivery information captured at order placement time
     */
    public Address getOrderAddressSnapshot(int orderId) {
        String sql = "SELECT OrderId, RecipientName, RecipientPhone, AddressName, AddressDetails, CreatedAt "
                + "FROM OrderAddress "
                + "WHERE OrderId = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Address address = new Address();
                    address.setAddressId(rs.getInt("OrderId")); // Using OrderId as identifier
                    address.setAddressName(rs.getString("AddressName"));
                    address.setAddressDetails(rs.getString("AddressDetails"));
                    address.setRecipientName(rs.getString("RecipientName"));
                    address.setRecipientPhone(rs.getString("RecipientPhone"));
                    return address;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Save order address snapshot when creating order This should be called
     * during order creation to preserve delivery information
     */
    public boolean saveOrderAddressSnapshot(int orderId, String recipientName, String recipientPhone,
            String addressName, String addressDetails) {
        String sql = "INSERT INTO OrderAddress (OrderId, RecipientName, RecipientPhone, AddressName, AddressDetails) "
                + "VALUES (?, ?, ?, ?, ?)";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setString(2, recipientName);
            ps.setString(3, recipientPhone);
            ps.setString(4, addressName);
            ps.setString(5, addressDetails);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get order items for staff with full product information
     */
    public List<OrderDetail> getOrderItemsForStaff(int orderId) {
        String sql = "SELECT "
                + "od.OrderDetailId, od.OrderId, od.ProductVariantId, od.DetailQuantity, "
                + "od.DetailPrice, od.AddressDetail, "
                + "p.Name as ProductName, p.Description as ProductDescription, "
                + "pv.Color, pv.Size, pv.Price as CurrentPrice, "
                + "b.Name as BrandName, c.Name as CategoryName "
                + "FROM OrderDetail od "
                + "INNER JOIN ProductVariant pv ON od.ProductVariantId = pv.ProductVariantId "
                + "INNER JOIN Product p ON pv.ProductId = p.ProductId "
                + "LEFT JOIN Brand b ON p.BrandId = b.BrandId "
                + "LEFT JOIN Category c ON p.CategoryId = c.CategoryId "
                + "WHERE od.OrderId = ?";

        List<OrderDetail> items = new ArrayList<>();

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
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

                    // Set additional product details for staff view
                    item.setProductDescription(rs.getString("ProductDescription"));
                    item.setSize(rs.getString("Size"));
                    item.setCurrentPrice(rs.getBigDecimal("CurrentPrice"));
                    item.setBrandName(rs.getString("BrandName"));
                    item.setCategoryName(rs.getString("CategoryName"));

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    /**
     * Get order status history for an order
     */
    public List<OrderStatusHistory> getOrderStatusHistory(int orderId) {
        String sql = "SELECT osh.OrderStatusHistoryId, osh.OrderId, osh.ChangedBy, "
                + "osh.OrderStatus, osh.ChangedAt, "
                + "COALESCE(s.Name, c.Name) as ChangedByName "
                + "FROM OrderStatusHistory osh "
                + "LEFT JOIN Staff s ON osh.ChangedBy = s.StaffId "
                + "LEFT JOIN Customer c ON osh.ChangedBy = c.CustomerId "
                + "WHERE osh.OrderId = ? "
                + "ORDER BY osh.ChangedAt ASC";

        List<OrderStatusHistory> history = new ArrayList<>();

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderStatusHistory statusHistory = new OrderStatusHistory();
                    statusHistory.setOrderStatusHistoryId(rs.getInt("OrderStatusHistoryId"));
                    statusHistory.setOrderId(rs.getInt("OrderId"));
                    statusHistory.setChangedBy(rs.getInt("ChangedBy"));
                    statusHistory.setOrderStatus(rs.getString("OrderStatus"));

                    Timestamp changedAt = rs.getTimestamp("ChangedAt");
                    statusHistory.setChangedAt(changedAt == null ? null : changedAt.toLocalDateTime());

                    // Set staff name for display
                    statusHistory.setChangedByName(rs.getString("ChangedByName"));

                    history.add(statusHistory);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return history;
    }

// ================================
// END - STAFF ORDER MANAGEMENT METHODS
// ================================
}
