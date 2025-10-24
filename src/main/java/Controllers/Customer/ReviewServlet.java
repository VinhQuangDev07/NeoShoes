/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers.Customer;

import DAOs.ReviewDAO;
import Models.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling review display and filter requests
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/reviews"})
public class ReviewServlet extends HttpServlet {
    
    private final ReviewDAO reviewDAO = new ReviewDAO();
    
    /**
     * Displays reviews for a specific product to guests
     * Also handles filtering by rating and keyword
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get product ID from request parameter
            String productIdParam = request.getParameter("productId");
            
            if (productIdParam == null || productIdParam.trim().isEmpty()) {
                // Invalid product ID - show error
                request.setAttribute("errorMessage", "Product ID is required");
                request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
                return;
            }
            
            int productId = Integer.parseInt(productIdParam);
            
            // Validate product ID (basic validation)
            if (productId <= 0) {
                request.setAttribute("errorMessage", "Invalid product ID");
                request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
                return;
            }
            
            // Get filter parameters
            String ratingParam = request.getParameter("rating");
            String timeParam = request.getParameter("time");
            
            // Parse rating filter
            Integer rating = null;
            if (ratingParam != null && !ratingParam.trim().isEmpty() && !"all".equals(ratingParam)) {
                try {
                    rating = Integer.parseInt(ratingParam);
                    if (rating < 1 || rating > 5) {
                        rating = null;
                    }
                } catch (NumberFormatException e) {
                    rating = null;
                }
            }
            
            List<Review> reviews;
            
            if (rating != null) {
                // Get filtered reviews by rating
                reviews = reviewDAO.getReviewsByFilter(productId, rating, null);
            } else {
                // Get all reviews for the product
                reviews = reviewDAO.getReviewsByProduct(productId);
            }
            
            // Apply time filter if specified
            if (timeParam != null && !timeParam.trim().isEmpty() && !"all".equals(timeParam)) {
                reviews = filterReviewsByTime(reviews, timeParam);
            }
            
            // Set filter attributes for JSP
            request.setAttribute("selectedRating", rating);
            request.setAttribute("selectedTime", timeParam);
            
            // Load all reviews for statistics calculation (unfiltered)
            List<Review> allReviews = reviewDAO.getReviewsByProduct(productId);
            
            // Calculate review statistics from all reviews
            int totalReviews = allReviews.size();
            double averageRating = 0.0;
            
            if (totalReviews > 0) {
                int totalStars = 0;
                for (Review review : allReviews) {
                    int star = review.getStar();
                    totalStars += star;
                }
                averageRating = (double) totalStars / totalReviews;
            }
            
            // Format rating to 1 decimal place
            String formattedRating = String.format("%.1f", averageRating);
            
            // Set attributes for JSP
            request.setAttribute("productId", productId);
            request.setAttribute("reviews", reviews);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("formattedRating", formattedRating);
            request.setAttribute("reviewCount", reviews.size());
            
            // Check if no matching reviews (for filtered results)
            if (rating != null && reviews.isEmpty()) {
                request.setAttribute("noMatchingMessage", "No reviews match your filter criteria.");
            }
            
            // Forward to reviews JSP
            request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Invalid product ID format
            request.setAttribute("errorMessage", "Invalid product ID format");
            request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Server error
            System.err.println("Error in ReviewServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load reviews. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests for staff replies
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("reply-review".equals(action)) {
            // Handle staff reply to review
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                String replyContent = request.getParameter("replyContent");
                
                if (replyContent == null || replyContent.trim().isEmpty()) {
                    response.sendRedirect("reviews?productId=" + productId + "&error=Reply content cannot be empty");
                    return;
                }
                
                // Get staff ID from session (for staff users)
                Integer staffId = (Integer) request.getSession().getAttribute("staffId");
                if (staffId == null) {
                    // For testing: set staffId = 1 (first staff in database)
                    staffId = 1;
                    System.out.println("Testing mode: Using staffId = 1");
                }
                
                boolean success = reviewDAO.addStaffReply(reviewId, replyContent, staffId);
                
                if (success) {
                    response.sendRedirect("reviews?productId=" + productId + "&success=Reply sent successfully");
                } else {
                    response.sendRedirect("reviews?productId=" + productId + "&error=Failed to send reply");
                }
                
            } catch (NumberFormatException e) {
                response.sendRedirect("reviews?error=Invalid review ID");
            }
        } else if ("edit-reply".equals(action)) {
            // Handle edit staff reply
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                int replyId = Integer.parseInt(request.getParameter("replyId"));
                String replyContent = request.getParameter("replyContent");
                
                if (replyContent == null || replyContent.trim().isEmpty()) {
                    response.sendRedirect("reviews?productId=" + productId + "&error=Reply content cannot be empty");
                    return;
                }
                
                // Get staff ID from session (for staff users)
                Integer staffId = (Integer) request.getSession().getAttribute("staffId");
                if (staffId == null) {
                    // For testing: set staffId = 1 (first staff in database)
                    staffId = 1;
                    System.out.println("Testing mode: Using staffId = 1");
                }
                
                boolean success = reviewDAO.updateStaffReply(replyId, replyContent, staffId);
                
                if (success) {
                    response.sendRedirect("reviews?productId=" + productId + "&success=Reply updated successfully");
                } else {
                    response.sendRedirect("reviews?productId=" + productId + "&error=Failed to update reply");
                }
                
            } catch (NumberFormatException e) {
                response.sendRedirect("reviews?error=Invalid reply ID");
            }
        } else {
            // Default behavior for other POST requests
            doGet(request, response);
        }
    }
    
    /**
     * Filter reviews by time period
     * @param reviews List of reviews to filter
     * @param timeParam Time filter parameter (today, week, month)
     * @return Filtered list of reviews
     */
    private List<Review> filterReviewsByTime(List<Review> reviews, String timeParam) {
        if (reviews == null || reviews.isEmpty()) {
            return reviews;
        }
        
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime cutoff;
        
        switch (timeParam.toLowerCase()) {
            case "today":
                cutoff = now.minusDays(1);
                break;
            case "week":
                cutoff = now.minusWeeks(1);
                break;
            case "month":
                cutoff = now.minusMonths(1);
                break;
            default:
                return reviews; // No filtering for unknown time periods
        }
        
        return reviews.stream()
                .filter(review -> review.getCreatedAt().isAfter(cutoff))
                .collect(java.util.stream.Collectors.toList());
    }
    
}
