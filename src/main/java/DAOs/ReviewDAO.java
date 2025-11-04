/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Review;
import Models.StaffReply;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Review operations
 * @author Chau Gia Huy - CE190386
 */
public class ReviewDAO extends DB.DBContext {
    
    /**
     * Retrieves all reviews for a specific product
     * @param productId The product ID to get reviews for
     * @return List of Review objects
     */
    public List<Review> getReviewsByProduct(int productId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                     "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                     "c.Name as CustomerName, " +
                     "p.Name as ProductName, " +
                     "pv.Color, " +
                     "rep.ReplyId, rep.ReplyContent, rep.CreatedAt as ReplyCreatedAt, " +
                     "s.Name as StaffName " +
                     "FROM Review r " +
                     "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                     "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "LEFT JOIN Reply rep ON r.ReviewId = rep.ReviewId AND rep.IsDeleted = 0 " +
                     "LEFT JOIN Staff s ON rep.StaffId = s.StaffId " +
                     "WHERE p.ProductId = ? AND r.IsDeleted = 0 " +
                     "ORDER BY r.CreatedAt DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = createReviewFromResultSet(rs);
                    
                    // Load staff reply if exists
                    if (rs.getObject("ReplyId") != null) {
                        StaffReply staffReply = new StaffReply();
                        staffReply.setStaffReplyId(rs.getInt("ReplyId"));
                        staffReply.setContent(rs.getString("ReplyContent"));
                        Timestamp replyCreatedAt = rs.getTimestamp("ReplyCreatedAt");
                        staffReply.setCreatedAt(replyCreatedAt == null ? null : replyCreatedAt.toLocalDateTime());
                        staffReply.setStaffName(rs.getString("StaffName"));
                        review.setStaffReply(staffReply);
                    }
                    
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Retrieves reviews filtered by rating, keyword, and time for a specific product
     * @param productId The product ID to get reviews for
     * @param rating The rating to filter by (null for all ratings)
     * @param keyword The keyword to search in review content (null for no keyword filter)
     * @param timeFilter The time filter ("today", "week", "month", or "all"/null for all time)
     * @return List of filtered Review objects
     */
    public List<Review> getReviewsByFilter(int productId, Integer rating, String keyword, String timeFilter) {
        List<Review> reviews = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                                             "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                                             "c.Name as CustomerName, " +
                                             "p.Name as ProductName, " +
                                             "pv.Color, " +
                                             "rep.ReplyId, rep.ReplyContent, rep.CreatedAt as ReplyCreatedAt, " +
                                             "s.Name as StaffName " +
                                             "FROM Review r " +
                                             "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                                             "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                                             "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                                             "LEFT JOIN Reply rep ON r.ReviewId = rep.ReviewId AND rep.IsDeleted = 0 " +
                                             "LEFT JOIN Staff s ON rep.StaffId = s.StaffId " +
                                             "WHERE p.ProductId = ? AND r.IsDeleted = 0");
        
        // Add rating filter if specified
        if (rating != null) {
            sql.append(" AND r.Star = ?");
        }
        
        // Add keyword filter if specified
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (r.ReviewContent LIKE ? OR c.Name LIKE ?)");
        }
        
        // Add time filter if specified
        if (timeFilter != null && !timeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(timeFilter)) {
            sql.append(" AND r.CreatedAt >= ?");
        }
        
        sql.append(" ORDER BY r.CreatedAt DESC");
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, productId);
            
            if (rating != null) {
                ps.setInt(paramIndex++, rating);
            }
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            // Add time filter parameter if specified
            if (timeFilter != null && !timeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(timeFilter)) {
                java.time.LocalDateTime cutoff = calculateTimeCutoff(timeFilter);
                if (cutoff != null) {
                    ps.setTimestamp(paramIndex++, java.sql.Timestamp.valueOf(cutoff));
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = createReviewFromResultSet(rs);
                    
                    // Load staff reply if exists
                    if (rs.getObject("ReplyId") != null) {
                        StaffReply staffReply = new StaffReply();
                        staffReply.setStaffReplyId(rs.getInt("ReplyId"));
                        staffReply.setContent(rs.getString("ReplyContent"));
                        Timestamp replyCreatedAt = rs.getTimestamp("ReplyCreatedAt");
                        staffReply.setCreatedAt(replyCreatedAt == null ? null : replyCreatedAt.toLocalDateTime());
                        staffReply.setStaffName(rs.getString("StaffName"));
                        review.setStaffReply(staffReply);
                    }
                    
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Helper method to calculate cutoff date for time filter
     * @param timeFilter The time filter parameter ("today", "week", "month")
     * @return LocalDateTime cutoff date, or null if invalid timeFilter
     */
    private java.time.LocalDateTime calculateTimeCutoff(String timeFilter) {
        if (timeFilter == null || timeFilter.trim().isEmpty()) {
            return null;
        }
        
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        switch (timeFilter.toLowerCase()) {
            case "today":
                return now.minusDays(1);
            case "week":
                return now.minusWeeks(1);
            case "month":
                return now.minusMonths(1);
            default:
                return null; // Unknown time filter, no cutoff
        }
    }
    
    /**
     * Creates a new review
     * @param review The Review object to create
     * @return true if successful, false otherwise
     */
    public boolean createReview(Review review) {
        String sql = "INSERT INTO Review (ProductVariantId, CustomerId, Star, ReviewContent, CreatedAt, UpdatedAt, IsDeleted) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getProductVariantId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getStar());
            ps.setString(4, review.getReviewContent());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Updates an existing review
     * @param review The Review object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateReview(Review review) {
        String sql = "UPDATE Review SET Star = ?, ReviewContent = ?, UpdatedAt = GETDATE() " +
                     "WHERE ReviewId = ? AND CustomerId = ? AND IsDeleted = 0";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getStar());
            ps.setString(2, review.getReviewContent());
            ps.setInt(3, review.getReviewId());
            ps.setInt(4, review.getCustomerId());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Soft deletes a review
     * @param reviewId The ID of the review to delete
     * @param customerId The ID of the customer (for security)
     * @return true if successful, false otherwise
     */
    public boolean deleteReview(int reviewId, int customerId) {
        String sql = "UPDATE Review SET IsDeleted = 1, UpdatedAt = GETDATE() " +
                     "WHERE ReviewId = ? AND CustomerId = ? AND IsDeleted = 0";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, customerId);
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Checks if a customer has already reviewed a product variant
     * @param productVariantId The product variant ID
     * @param customerId The customer ID
     * @return Review object if exists, null otherwise
     */
    public Review getExistingReview(int productVariantId, int customerId) {
        String sql = "SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                     "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                     "c.Name as CustomerName, " +
                     "p.Name as ProductName, " +
                     "pv.Color " +
                     "FROM Review r " +
                     "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                     "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "WHERE r.ProductVariantId = ? AND r.CustomerId = ? AND r.IsDeleted = 0";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productVariantId);
            ps.setInt(2, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return createReviewFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Batch load reviews for multiple product variants by a customer
     * Optimizes N+1 query problem when loading reviews for order items
     * @param productVariantIds List of product variant IDs
     * @param customerId The customer ID
     * @return Map of ProductVariantId -> Review (null if no review exists)
     */
    public java.util.Map<Integer, Review> getReviewsByProductVariantsAndCustomer(List<Integer> productVariantIds, int customerId) {
        java.util.Map<Integer, Review> reviewMap = new java.util.HashMap<>();
        
        if (productVariantIds == null || productVariantIds.isEmpty()) {
            return reviewMap;
        }
        
        // Build IN clause for multiple product variant IDs
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < productVariantIds.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        
        String sql = "SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                     "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                     "c.Name as CustomerName, " +
                     "p.Name as ProductName, " +
                     "pv.Color " +
                     "FROM Review r " +
                     "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                     "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "WHERE r.ProductVariantId IN (" + placeholders.toString() + ") " +
                     "AND r.CustomerId = ? AND r.IsDeleted = 0";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            int paramIndex = 1;
            for (Integer variantId : productVariantIds) {
                ps.setInt(paramIndex++, variantId);
            }
            ps.setInt(paramIndex, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = createReviewFromResultSet(rs);
                    reviewMap.put(review.getProductVariantId(), review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reviewMap;
    }
    
    /**
     * Gets a review by ID for a specific customer
     * @param reviewId The review ID
     * @param customerId The customer ID
     * @return Review object if found, null otherwise
     */
    public Review getReviewById(int reviewId, int customerId) {
        String sql = "SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                     "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                     "c.Name as CustomerName, " +
                     "p.Name as ProductName, " +
                     "pv.Color " +
                     "FROM Review r " +
                     "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                     "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "WHERE r.ReviewId = ? AND r.CustomerId = ? AND r.IsDeleted = 0";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return createReviewFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Creates a Review object from ResultSet
     * @param rs The ResultSet containing review data
     * @return Review object
     * @throws SQLException if database error occurs
     */
    private Review createReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        
        review.setReviewId(rs.getInt("ReviewId"));
        review.setProductVariantId(rs.getInt("ProductVariantId"));
        review.setCustomerId(rs.getInt("CustomerId"));
        review.setStar(rs.getInt("Star"));
        review.setReviewContent(rs.getString("ReviewContent"));
        
        // Handle LocalDateTime conversion like CustomerDAO
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        review.setCreatedAt(createdAt == null ? null : createdAt.toLocalDateTime());
        review.setUpdatedAt(updatedAt == null ? null : updatedAt.toLocalDateTime());
        
        review.setDeleted(rs.getBoolean("IsDeleted"));
        
        // Set additional display fields
        review.setCustomerName(rs.getString("CustomerName"));
        review.setProductName(rs.getString("ProductName"));
        review.setColor(rs.getString("Color"));
        
        return review;
    }
    
    /**
     * Add staff reply to a review
     * @param reviewId The ID of the review to reply to
     * @param replyContent The content of the staff reply
     * @return true if successful, false otherwise
     */
    public boolean addStaffReply(int reviewId, String replyContent, int staffId) {
        String sql = "INSERT INTO Reply (ReviewId, StaffId, ReplyContent, CreatedAt, UpdatedAt, IsDeleted) VALUES (?, ?, ?, GETDATE(), GETDATE(), 0)";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ps.setInt(2, staffId);
            ps.setString(3, replyContent);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding staff reply: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Updates an existing staff reply
     * @param replyId The ID of the reply to update
     * @param replyContent The new content of the reply
     * @param staffId The ID of the staff member updating
     * @return true if successful, false otherwise
     */
    public boolean updateStaffReply(int replyId, String replyContent, int staffId) {
        String sql = "UPDATE Reply SET ReplyContent = ?, UpdatedAt = GETDATE() WHERE ReplyId = ? AND StaffId = ? AND IsDeleted = 0";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, replyContent);
            ps.setInt(2, replyId);
            ps.setInt(3, staffId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating staff reply: " + e.getMessage());
            return false;
        }
    }
}
