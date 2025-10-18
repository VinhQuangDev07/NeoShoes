/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers.Customer;

import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import DAOs.ReviewDAO;
import Models.Product;
import Models.ProductVariant;
import Models.Review;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name="ProductDetailServlet", urlPatterns={"/product-detail"})
public class ProductDetailServlet extends HttpServlet {
   
    private ProductDAO productDAO;
    private ProductVariantDAO variantDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        variantDAO = new ProductVariantDAO();
        reviewDAO = new ReviewDAO();
    }


    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String productIdParam = request.getParameter("id");
        
        if (productIdParam == null || productIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // Load List<ProductVariant>
            List<ProductVariant> variants = variantDAO.getByProductId(productId);
            // Extract unique colors and sizes from variants
            List<String> colors = new ArrayList<>();
            List<String> sizes = new ArrayList<>();
            
            for (ProductVariant variant : variants) {
                // Add unique colors
                if (!colors.contains(variant.getColor()) && variant.getColor() != null) {
                    colors.add(variant.getColor());
                }
                // Add unique sizes
                if (!sizes.contains(variant.getSize()) && variant.getSize() != null) {
                    sizes.add(variant.getSize());
                }
            }
            
            // Get filter parameters for reviews
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
            
            // Load reviews for the product (filtered or all)
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
            
            // Load all reviews for statistics calculation (unfiltered)
            List<Review> allReviews = reviewDAO.getReviewsByProduct(productId);
            
            // Calculate review statistics from all reviews
            int totalReviews = allReviews.size();
            double averageRating = 0.0;
            int[] ratingCounts = new int[6]; // 0-5 stars
            
            if (totalReviews > 0) {
                int totalStars = 0;
                for (Review review : allReviews) {
                    int star = review.getStar();
                    totalStars += star;
                    ratingCounts[star]++;
                }
                averageRating = (double) totalStars / totalReviews;
            }
            
            // Set attributes for JSP
            request.setAttribute("product", product);
            request.setAttribute("variants", variants);
            request.setAttribute("colors", colors);
            request.setAttribute("sizes", sizes);
            request.setAttribute("reviews", reviews);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("formattedRating", formatRating(averageRating));
            request.setAttribute("ratingCounts", ratingCounts);
            
            // Set filter attributes for JSP
            request.setAttribute("selectedRating", rating);
            request.setAttribute("selectedTime", timeParam);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/customer/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "An error occurred while loading product details");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Format average rating to 1 decimal place
     */
    private String formatRating(double rating) {
        return String.format("%.1f", rating);
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
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Product Detail Servlet with Reviews";
    }

}
