/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import Utils.Utils;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class Dashboard {
    private BigDecimal totalRevenue;
    private int totalOrders;
    private List<Product> topProducts;

    public Dashboard() {
    }

    public Dashboard(BigDecimal totalRevenue, int totalOrders, List<Product> topProducts) {
        this.totalRevenue = totalRevenue;
        this.totalOrders = totalOrders;
        this.topProducts = topProducts;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public List<Product> getTopProducts() {
        return topProducts;
    }

    public void setTopProducts(List<Product> topProducts) {
        this.topProducts = topProducts;
    }
    
}
