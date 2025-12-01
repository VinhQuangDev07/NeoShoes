/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import Models.Voucher;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.MessageDigest;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class Utils {

    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }
        String hashedInput = hashPassword(plainPassword);
        return hashedInput.equalsIgnoreCase(storedHash);
    }

    /**
     * Get default date range (last 30 days)
     */
    public static String[] getDefaultDateRange() {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(29);
        return new String[]{startDate.toString(), endDate.toString()};
    }

    /**
     * Get default month range (last 12 months)
     */
    public static String[] getDefaultMonthRange() {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusMonths(11).withDayOfMonth(1);
        return new String[]{
            startDate.toString().substring(0, 7),
            endDate.toString().substring(0, 7)
        };
    }

    /**
     * Get default year range (last 5 years)
     */
    public static int[] getDefaultYearRange() {
        int currentYear = LocalDate.now().getYear();
        return new int[]{currentYear - 4, currentYear};
    }
    
    public static double calculateDiscount(Voucher voucher, double orderTotal) {
        if ("PERCENTAGE".equalsIgnoreCase(voucher.getType())) {
            double discount = orderTotal * voucher.getValue().doubleValue() / 100;
            if (voucher.getMaxValue() != null && discount > voucher.getMaxValue().doubleValue()) {
                return voucher.getMaxValue().doubleValue();
            }
            return discount;
        } else {
            // Fixed amount
            return voucher.getValue().doubleValue();
        }
    }

}
