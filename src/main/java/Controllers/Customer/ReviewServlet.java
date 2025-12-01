/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers.Customer;

import DAOs.ReviewDAO;
import Models.Review;
import Models.Order;
import Models.OrderDetail;
import Models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

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
            
            // All filters (rating and time) are now handled at database level
            if (rating != null || (timeParam != null && !timeParam.trim().isEmpty() && !"all".equals(timeParam))) {
                // Get filtered reviews by rating and/or time
                reviews = reviewDAO.getReviewsByFilter(productId, rating, null, timeParam);
            } else {
                // Get all reviews for the product
                reviews = reviewDAO.getReviewsByProduct(productId);
            }
            
            // Set filter attributes for JSP
            request.setAttribute("selectedRating", rating);
            request.setAttribute("selectedTime", timeParam);
            
            
            // Calculate review statistics from all reviews
            int totalReviews = reviews.size();
            double averageRating = 0.0;
            
            if (totalReviews > 0) {
                int totalStars = 0;
                for (Review review : reviews) {
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
     * Handles POST requests for both customer reviews and staff replies
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "createReview":
                handleCreateReview(request, response);
                break;
            case "updateReview":
                handleUpdateReview(request, response);
                break;
            case "deleteReview":
                handleDeleteReview(request, response);
                break;
            case "reply-review":
                handleStaffReply(request, response);
                break;
            case "edit-reply":
                handleEditStaffReply(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    /**
     * Helper: Validate review input
     */
    private boolean isValidReviewInput(int star, String reviewContent) {
        return star >= 1 && star <= 5 && reviewContent != null && !reviewContent.trim().isEmpty();
    }
    
    /**
     * Helper: Set flash message and redirect to orders
     */
    private void redirectToOrders(HttpServletRequest request, HttpServletResponse response, String message, boolean isError) throws IOException {
        String attr = isError ? "flash_error" : "flash";
        request.getSession().setAttribute(attr, message);
        response.sendRedirect(request.getContextPath() + "/orders");
    }
    
    /**
     * Handle create review
     */
    private void handleCreateReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
            int star = Integer.parseInt(request.getParameter("star"));
            String reviewContent = request.getParameter("reviewContent");

            if (!isValidReviewInput(star, reviewContent)) {
                redirectToOrders(request, response, "Please provide valid rating and review content.", true);
                return;
            }

            // Check if already reviewed
            Models.Review existing = reviewDAO.getExistingReview(productVariantId, customer.getId());
            if (existing != null) {
                redirectToOrders(request, response, "You have already reviewed this product.", true);
                return;
            }

            // Create review
            Models.Review review = new Models.Review();
            review.setProductVariantId(productVariantId);
            review.setCustomerId(customer.getId());
            review.setStar(star);
            review.setReviewContent(reviewContent.trim());

            boolean success = reviewDAO.createReview(review);
            String message = success ? "Review submitted successfully!" : "Failed to submit review. Please try again.";
            redirectToOrders(request, response, message, !success);
            
        } catch (NumberFormatException e) {
            redirectToOrders(request, response, "Invalid input. Please try again.", true);
        }
    }
    
    /**
     * Handle update review
     */
    private void handleUpdateReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int star = Integer.parseInt(request.getParameter("star"));
            String reviewContent = request.getParameter("reviewContent");

            if (!isValidReviewInput(star, reviewContent)) {
                redirectToOrders(request, response, "Please provide valid rating and review content.", true);
                return;
            }

            // Verify ownership
            Models.Review existing = reviewDAO.getReviewById(reviewId, customer.getId());
            if (existing == null) {
                redirectToOrders(request, response, "Review not found.", true);
                return;
            }

            // Update review
            existing.setStar(star);
            existing.setReviewContent(reviewContent.trim());
            boolean success = reviewDAO.updateReview(existing);
            String message = success ? "Review updated successfully!" : "Failed to update review. Please try again.";
            redirectToOrders(request, response, message, !success);
            
        } catch (NumberFormatException e) {
            redirectToOrders(request, response, "Invalid input. Please try again.", true);
        }
    }
    
    /**
     * Handle delete review
     */
    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            boolean success = reviewDAO.deleteReview(reviewId, customer.getId());
            String message = success ? "Review deleted successfully!" : "Failed to delete review.";
            redirectToOrders(request, response, message, !success);
            
        } catch (NumberFormatException e) {
            redirectToOrders(request, response, "Invalid review ID.", true);
        }
    }
    
    /**
     * Handle staff reply to review
     */
    private void handleStaffReply(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String replyContent = request.getParameter("replyContent");
            
            if (replyContent == null || replyContent.trim().isEmpty()) {
                response.sendRedirect("reviews?productId=" + productId + "&error=Reply content cannot be empty");
                return;
            }
            
            Integer staffId = (Integer) request.getSession().getAttribute("staffId");
            if (staffId == null) {
                staffId = 1; // Testing mode
                System.out.println("Testing mode: Using staffId = 1");
            }
            
            boolean success = reviewDAO.addStaffReply(reviewId, replyContent, staffId);
            String result = success ? "success=Reply sent successfully" : "error=Failed to send reply";
            response.sendRedirect("reviews?productId=" + productId + "&" + result);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("reviews?error=Invalid review ID");
        }
    }
    
    /**
     * Handle edit staff reply
     */
    private void handleEditStaffReply(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int replyId = Integer.parseInt(request.getParameter("replyId"));
            String replyContent = request.getParameter("replyContent");
            
            if (replyContent == null || replyContent.trim().isEmpty()) {
                response.sendRedirect("reviews?productId=" + productId + "&error=Reply content cannot be empty");
                return;
            }
            
            Integer staffId = (Integer) request.getSession().getAttribute("staffId");
            if (staffId == null) {
                staffId = 1; // Testing mode
                System.out.println("Testing mode: Using staffId = 1");
            }
            
            boolean success = reviewDAO.updateStaffReply(replyId, replyContent, staffId);
            String result = success ? "success=Reply updated successfully" : "error=Failed to update reply";
            response.sendRedirect("reviews?productId=" + productId + "&" + result);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("reviews?error=Invalid reply ID");
        }
    }
    
    // Time filter is now handled in ReviewDAO.getReviewsByFilter() at database level
    // This method is no longer needed but kept for backward compatibility if needed elsewhere
    
    /**
     * Load reviews for order items in batch to avoid N+1 query
     * This method can be called from OrdersServlet or other servlets
     * @param orders List of orders with items
     * @param customerId Customer ID to filter reviews
     */
    public static void loadReviewsForOrders(List<Order> orders, int customerId) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        
        ReviewDAO reviewDAO = new ReviewDAO();
        
        // Collect all productVariantIds from all order items
        List<Integer> productVariantIds = new ArrayList<>();
        for (Order order : orders) {
            if (order.getItems() != null) {
                for (OrderDetail item : order.getItems()) {
                    productVariantIds.add(item.getProductVariantId());
                }
            }
        }
        
        if (productVariantIds.isEmpty()) {
            return;
        }
        
        // Load all reviews in one batch query
        Map<Integer, Review> reviewMap = reviewDAO.getReviewsByProductVariantsAndCustomer(productVariantIds, customerId);
        
        // Map reviews to order items
        for (Order order : orders) {
            if (order.getItems() != null) {
                for (OrderDetail item : order.getItems()) {
                    Review existingReview = reviewMap.get(item.getProductVariantId());
                    item.setReview(existingReview);
                }
            }
        }
    }
    
}
