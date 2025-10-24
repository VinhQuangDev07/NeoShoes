/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.CustomerDAO;
import DAOs.ReviewDAO;
import Models.Order;
import Models.OrderDetail;
import Models.Customer;
import Models.Review;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hardcode customerId = 2 for testing (no login functionality yet)
        int customerId = 2;

        // Pagination
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int recordsPerPage = 5; // 5 orders per page
        List<Order> orders;
        try {
            orders = orderDAO.listByCustomer(customerId);
            
            int totalRecords = orders.size();
            
            // Calculate start and end positions
            int startIndex = (currentPage - 1) * recordsPerPage;
            int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);
            
            // Get data for current page
            List<Order> pageData;
            if (startIndex < totalRecords) {
                pageData = orders.subList(startIndex, endIndex);
            } else {
                pageData = new ArrayList<>();
            }
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            request.setAttribute("orders", pageData);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("baseUrl", request.getRequestURI());
            for (Order order : pageData) {
                if (order.getItems() != null) {
                    for (OrderDetail item : order.getItems()) {
                        Review existingReview = reviewDAO.getExistingReview(item.getProductVariantId(), customerId);
                        item.setReview(existingReview);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        // For now, using hardcoded customer ID. In production, get from session
        Customer customer = customerDAO.findById(customerId);
        // Load existing reviews for each order item

        // Check for error messages only
        String error = request.getParameter("error");

        if ("cancel_failed".equals(error)) {
            request.setAttribute("errorMessage", "Failed to cancel order. Please try again.");
        }

        // Get complete status ID from database
        int completeStatusId = orderDAO.getCompleteStatusId();

     
        request.setAttribute("customer", customer);
        request.setAttribute("completeStatusId", completeStatusId);
        request.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(request, response);
    }


@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // For now, using hardcoded customer ID. In production, get from session
        int customerId = 2;

        try {
            if ("createReview".equals(action)) {
                handleCreateReview(request, response, customerId);
            } else if ("updateReview".equals(action)) {
                handleUpdateReview(request, response, customerId);
            } else if ("deleteReview".equals(action)) {
                handleDeleteReview(request, response, customerId);
            } else {
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "An error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handleCreateReview(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            int productVariantId = Integer.parseInt(request.getParameter("productVariantId"));
            int star = Integer.parseInt(request.getParameter("star"));
            String reviewContent = request.getParameter("reviewContent");

            // Validate input
            if (star < 1 || star > 5 || reviewContent == null || reviewContent.trim().isEmpty()) {
                session.setAttribute("flash_error", "Please provide valid rating and review content.");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Check if review already exists
            Review existingReview = reviewDAO.getExistingReview(productVariantId, customerId);
            if (existingReview != null) {
                session.setAttribute("flash_error", "You have already reviewed this product.");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Create new review
            Review review = new Review();
            review.setProductVariantId(productVariantId);
            review.setCustomerId(customerId);
            review.setStar(star);
            review.setReviewContent(reviewContent.trim());

            boolean success = reviewDAO.createReview(review);

            if (success) {
                session.setAttribute("flash", "Review submitted successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to submit review. Please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid input. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }

    private void handleUpdateReview(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int star = Integer.parseInt(request.getParameter("star"));
            String reviewContent = request.getParameter("reviewContent");

            // Validate input
            if (star < 1 || star > 5 || reviewContent == null || reviewContent.trim().isEmpty()) {
                session.setAttribute("flash_error", "Please provide valid rating and review content.");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Verify review belongs to customer
            Review existingReview = reviewDAO.getReviewById(reviewId, customerId);
            if (existingReview == null) {
                session.setAttribute("flash_error", "Review not found.");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Update review
            existingReview.setStar(star);
            existingReview.setReviewContent(reviewContent.trim());

            boolean success = reviewDAO.updateReview(existingReview);

            if (success) {
                session.setAttribute("flash", "Review updated successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to update review. Please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid input. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }

    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));

            boolean success = reviewDAO.deleteReview(reviewId, customerId);

            if (success) {
                session.setAttribute("flash", "Review deleted successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to delete review.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid review ID.");
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }
}
