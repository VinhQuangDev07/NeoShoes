/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Review;
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
                     "pv.Color " +
                     "FROM Review r " +
                     "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                     "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                     "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                     "WHERE p.ProductId = ? AND r.IsDeleted = 0 " +
                     "ORDER BY r.CreatedAt DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = createReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Retrieves reviews filtered by rating for a specific product
     * @param productId The product ID to get reviews for
     * @param rating The rating to filter by (null for all ratings)
     * @param keyword The keyword to search in review content (null for no keyword filter)
     * @return List of filtered Review objects
     */
    public List<Review> getReviewsByFilter(int productId, Integer rating, String keyword) {
        List<Review> reviews = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT r.ReviewId, r.ProductVariantId, r.CustomerId, r.Star, r.ReviewContent, " +
                                             "r.CreatedAt, r.UpdatedAt, r.IsDeleted, " +
                                             "c.Name as CustomerName, " +
                                             "p.Name as ProductName, " +
                                             "pv.Color " +
                                             "FROM Review r " +
                                             "INNER JOIN Customer c ON r.CustomerId = c.CustomerId " +
                                             "INNER JOIN ProductVariant pv ON r.ProductVariantId = pv.ProductVariantId " +
                                             "INNER JOIN Product p ON pv.ProductId = p.ProductId " +
                                             "WHERE p.ProductId = ? AND r.IsDeleted = 0");
        
        // Add rating filter if specified
        if (rating != null) {
            sql.append(" AND r.Star = ?");
        }
        
        // Add keyword filter if specified
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (r.ReviewContent LIKE ? OR c.Name LIKE ?)");
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
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = createReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return reviews;
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
}
