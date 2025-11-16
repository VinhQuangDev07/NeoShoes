/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.OrderStatus;
import Models.Product;
import Models.Revenue;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class DashboardDAO extends DB.DBContext {

    /**
     * Get total revenue from all completed orders
     */
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(o.TotalAmount - o.ShippingFee), 0) AS TotalRevenue "
                + "FROM [Order] o "
                + "JOIN OrderStatusHistory osh ON o.OrderId = osh.OrderId "
                + "WHERE osh.OrderStatus = 'COMPLETED' "
                + "AND NOT EXISTS ("
                + "    SELECT 1 "
                + "    FROM OrderStatusHistory osh2 "
                + "    WHERE osh2.OrderId = o.OrderId "
                + "    AND osh2.OrderStatus = 'RETURNED'"
                + ")";

        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getBigDecimal("TotalRevenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /**
     * Get total number of orders
     */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) AS TotalOrders FROM [Order]";
        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("TotalOrders");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total number of customers
     */
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS TotalCustomers FROM Customer WHERE IsDeleted = 0";
        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("TotalCustomers");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total number of staff
     */
    public int getTotalStaff() {
        String sql = "SELECT COUNT(*) AS TotalStaff FROM Staff WHERE IsDeleted = 0";
        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("TotalStaff");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get revenue by day within date range
     */
    public List<Revenue> getRevenueByDay(String startDate, String endDate) {
        List<Revenue> list = new ArrayList<>();
        String sql = "SELECT CONVERT(VARCHAR, o.PlacedAt, 23) AS Period, "
                + "SUM(o.TotalAmount - o.ShippingFee) AS Revenue "
                + "FROM [Order] o "
                + "JOIN OrderStatusHistory osh ON o.OrderId = osh.OrderId "
                + "WHERE osh.OrderStatus = 'COMPLETED' "
                + "AND CONVERT(DATE, o.PlacedAt) BETWEEN ? AND ? "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 FROM OrderStatusHistory osh2 "
                + "    WHERE osh2.OrderId = o.OrderId "
                + "      AND osh2.OrderStatus = 'RETURNED' "
                + ") "
                + "GROUP BY CONVERT(VARCHAR, o.PlacedAt, 23) "
                + "ORDER BY Period";

        Object[] params = {startDate, endDate};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Revenue data = new Revenue();
                data.setPeriod(rs.getString("Period"));
                data.setRevenue(rs.getBigDecimal("Revenue"));
                list.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get revenue by month within month range
     */
    public List<Revenue> getRevenueByMonth(String startMonth, String endMonth) {
        List<Revenue> list = new ArrayList<>();
        String sql = "SELECT FORMAT(o.PlacedAt, 'yyyy-MM') AS Period, "
                + "SUM(o.TotalAmount - o.ShippingFee) AS Revenue "
                + "FROM [Order] o "
                + "JOIN OrderStatusHistory osh ON o.OrderId = osh.OrderId "
                + "WHERE osh.OrderStatus = 'COMPLETED' "
                + "AND FORMAT(o.PlacedAt, 'yyyy-MM') BETWEEN ? AND ? "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 FROM OrderStatusHistory osh2 "
                + "    WHERE osh2.OrderId = o.OrderId "
                + "      AND osh2.OrderStatus = 'RETURNED' "
                + ") "
                + "GROUP BY FORMAT(o.PlacedAt, 'yyyy-MM') "
                + "ORDER BY Period";

        Object[] params = {startMonth, endMonth};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Revenue data = new Revenue();
                data.setPeriod(rs.getString("Period"));
                data.setRevenue(rs.getBigDecimal("Revenue"));
                list.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get revenue by year within year range
     */
    public List<Revenue> getRevenueByYear(int startYear, int endYear) {
        List<Revenue> list = new ArrayList<>();
        String sql = "SELECT YEAR(o.PlacedAt) AS Period, "
                + "SUM(o.TotalAmount - o.ShippingFee) AS Revenue "
                + "FROM [Order] o "
                + "JOIN OrderStatusHistory osh ON o.OrderId = osh.OrderId "
                + "WHERE osh.OrderStatus = 'COMPLETED' "
                + "AND YEAR(o.PlacedAt) BETWEEN ? AND ? "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 FROM OrderStatusHistory osh2 "
                + "    WHERE osh2.OrderId = o.OrderId "
                + "      AND osh2.OrderStatus = 'RETURNED' "
                + ") "
                + "GROUP BY YEAR(o.PlacedAt) "
                + "ORDER BY Period";

        Object[] params = {startYear, endYear};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Revenue data = new Revenue();
                data.setPeriod(String.valueOf(rs.getInt("Period")));
                data.setRevenue(rs.getBigDecimal("Revenue"));
                list.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get top 10 best selling products
     */
    public List<Product> getTopProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 10 "
                + "p.ProductId, "
                + "p.Name AS ProductTitle, "
                + "p.DefaultImageUrl AS ImageUrl, "
                + "SUM(od.DetailQuantity) AS TotalSold, "
                + "SUM(o.TotalAmount - o.ShippingFee) AS TotalRevenue "
                + "FROM OrderDetail od "
                + "JOIN ProductVariant pv ON od.ProductVariantId = pv.ProductVariantId "
                + "JOIN Product p ON pv.ProductId = p.ProductId "
                + "JOIN [Order] o ON od.OrderId = o.OrderId "
                + "JOIN OrderStatusHistory osh ON o.OrderId = osh.OrderId "
                + "WHERE osh.OrderStatus = 'COMPLETED' "
                + "AND p.IsDeleted = 0 "
                + "AND NOT EXISTS ("
                + "    SELECT 1 "
                + "    FROM OrderStatusHistory osh2 "
                + "    WHERE osh2.OrderId = o.OrderId "
                + "    AND osh2.OrderStatus = 'RETURNED'"
                + ") "
                + "GROUP BY p.ProductId, p.Name, p.DefaultImageUrl "
                + "ORDER BY TotalSold DESC";

        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("ProductId"));
                product.setName(rs.getString("ProductTitle"));
                product.setDefaultImageUrl(rs.getString("ImageUrl"));
                product.setTotalSold(rs.getInt("TotalSold"));
                product.setTotalRevenue(rs.getBigDecimal("TotalRevenue"));
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get order status statistics
     */
    public OrderStatus getOrderStatusStatistics() {
        OrderStatus data = new OrderStatus();
        String sql = "SELECT "
                + "SUM(CASE WHEN osh.OrderStatus = 'PENDING' THEN 1 ELSE 0 END) AS Pending, "
                + "SUM(CASE WHEN osh.OrderStatus = 'PROCESSING' THEN 1 ELSE 0 END) AS Processing, "
                + "SUM(CASE WHEN osh.OrderStatus = 'SHIPPED' THEN 1 ELSE 0 END) AS Shipped, "
                + "SUM(CASE WHEN osh.OrderStatus = 'COMPLETED' THEN 1 ELSE 0 END) AS Delivered, "
                + "SUM(CASE WHEN osh.OrderStatus = 'RETURNED' THEN 1 ELSE 0 END) AS Returned, "
                + "SUM(CASE WHEN osh.OrderStatus = 'CANCELLED' THEN 1 ELSE 0 END) AS Cancelled "
                + "FROM ( "
                + "    SELECT OrderId, OrderStatus, "
                + "           ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY ChangedAt DESC) AS rn "
                + "    FROM OrderStatusHistory "
                + ") osh "
                + "WHERE osh.rn = 1";

        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                data.setPending(rs.getInt("Pending"));
                data.setProcessing(rs.getInt("Processing"));
                data.setShipped(rs.getInt("Shipped"));
                data.setDelivered(rs.getInt("Delivered"));
                data.setReturned(rs.getInt("Returned"));
                data.setCancelled(rs.getInt("Cancelled"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

}
