/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.ReturnRequestDAO;
import Models.Order;
import Models.Customer;
import Models.OrderStatusHistory;
import Controllers.Customer.ReviewServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders", "/orders/detail"})
public class OrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ReturnRequestDAO returnRequestDAO = new ReturnRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Customer customer = (Customer) request.getSession().getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }        
        // Check if viewing order detail
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            handleOrderDetail(request, response, customer);
            return;
        }
        
        // Otherwise show order list
        handleOrderList(request, response, customer);
    }
    
    /**
     * Handle order list display
     */
    private void handleOrderList(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        
        int customerId = customer.getId();

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
            
            // Load reviews for order items in batch (moved to ReviewServlet)
            ReviewServlet.loadReviewsForOrders(pageData, customerId);
            
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

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
    
    /**
     * Handle order detail display
     */
    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || !idParam.matches("\\d+")) {
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }
            
            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.findWithItems(orderId);
            
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Ownership check
            if (order.getCustomerId() != customer.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            // Return request flags
            int requestId = 0;
            boolean hasRequest = returnRequestDAO.existsByOrderId(orderId);
            if (hasRequest) {
                requestId = returnRequestDAO.getRequestIdByOrderId(orderId);
            }
            
            // Status history
            List<OrderStatusHistory> statusHistory = orderDAO.getOrderStatusHistory(orderId);
            
            // Set attributes
            request.setAttribute("customer", customer);
            request.setAttribute("order", order);
            request.setAttribute("statusHistory", statusHistory);
            request.setAttribute("hasRequest", hasRequest);
            request.setAttribute("requestId", requestId);
            
            request.getRequestDispatcher("/WEB-INF/views/customer/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid order ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders");
        } catch (Exception e) {
            System.err.println("Error loading order detail: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            handleCancelOrder(request, response, customer);
        } else {
            // Unknown action - redirect back
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
    
    /**
     * Handle cancel order
     */
    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String oid = request.getParameter("orderId");
            if (oid == null || !oid.matches("\\d+")) {
                session.setAttribute("flash_error", "Invalid order ID");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }
            
            int orderId = Integer.parseInt(oid);
            Order order = orderDAO.findWithItems(orderId);
            
            if (order == null || order.getCustomerId() != customer.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            // Check if cancellable
            String status = order.getStatus();
            if (status == null || !(status.equals("PENDING") || status.equals("APPROVED"))) {
                session.setAttribute("flash_error", "Order cannot be cancelled at this stage");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }
            
            // Cancel order
            boolean success = orderDAO.updateOrderStatusForCustomer(orderId, "CANCELLED", customer.getId());
            
            if (success) {
                session.setAttribute("flash", "Order #" + orderId + " has been cancelled");
            } else {
                session.setAttribute("flash_error", "Failed to cancel order. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/orders");
            
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid order ID format");
            response.sendRedirect(request.getContextPath() + "/orders");
        } catch (Exception e) {
            System.err.println("Error cancelling order: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("flash_error", "An error occurred while cancelling order");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
