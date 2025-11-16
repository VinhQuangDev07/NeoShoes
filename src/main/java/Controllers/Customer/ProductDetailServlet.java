
package Controllers.Customer;

import java.io.IOException;
import java.util.List;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import DAOs.ReviewDAO;
import Models.Product;
import Models.ProductVariant;
import Models.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;


@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
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
            request.getSession().setAttribute("flash_error", "Product ID is required!");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getById(productId);
            if (product == null) {
                request.getSession().setAttribute("flash_error", "Product not found");
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Product already has variants, colors, and sizes loaded from ProductDAO
            List<ProductVariant> variants = variantDAO.getVariantListByProductId(productId);
            List<String> colors = variantDAO.getColorsByProductId(productId);
            List<String> sizes = variantDAO.getSizesByProductId(productId);

            int totalQuantityOfProduct = 0;
            BigDecimal minPrice = null;
            BigDecimal maxPrice = null;

            for (ProductVariant variant : variants) {
                totalQuantityOfProduct += variant.getQuantityAvailable();

                BigDecimal price = variant.getPrice();

                // cập nhật minPrice
                if (minPrice == null || price.compareTo(minPrice) < 0) {
                    minPrice = price;
                }

                // cập nhật maxPrice
                if (maxPrice == null || price.compareTo(maxPrice) > 0) {
                    maxPrice = price;
                }
            }

            product.setTotalQuantity(totalQuantityOfProduct);
            product.setMinPrice(minPrice);
            product.setMaxPrice(maxPrice);

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
            // All filters (rating and time) are now handled at database level
            List<Review> reviews;
            if (rating != null || (timeParam != null && !timeParam.trim().isEmpty() && !"all".equals(timeParam))) {
                // Get filtered reviews by rating and/or time
                reviews = reviewDAO.getReviewsByFilter(productId, rating, null, timeParam);
            } else {
                // Get all reviews for the product
                reviews = reviewDAO.getReviewsByProduct(productId);
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
            request.setAttribute("ratingCounts", ratingCounts);

            // Set filter attributes for JSP
            request.setAttribute("selectedRating", rating);
            request.setAttribute("selectedTime", timeParam);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/customer/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format");
            request.getSession().setAttribute("flash_error", "Invalid product ID format!");
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "An error occurred while loading product details");
            request.getSession().setAttribute("flash_error", "Internal server error!");
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Product Detail Servlet with Reviews";
    }

}
