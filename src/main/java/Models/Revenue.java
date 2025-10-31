/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class Revenue {
    private String period;  // Ngày/Tháng/Năm
    private BigDecimal revenue;

    public Revenue() {
    }

    public Revenue(String period, BigDecimal revenue) {
        this.period = period;
        this.revenue = revenue;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }
    
    
}
