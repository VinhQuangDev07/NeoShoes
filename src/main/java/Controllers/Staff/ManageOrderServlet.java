/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers.Staff;

import DAOs.OrderDAO;
import Models.Order;
import Models.OrderStatusHistory;
import Models.Staff;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Staff Order Management Servlet
 * Handles viewing all orders and order details for staff
 * 
 * @author AI Assistant
 */
@WebServlet(name = "ManageOrderServlet", urlPatterns = {"/staff/orders", "/staff/order-detail"})
public class ManageOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        super.init();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays order list or order detail based on orderId parameter
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        // Check if viewing order detail
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            handleOrderDetail(request, response, staff);
            return;
        }

        // Otherwise show order list
        handleOrderList(request, response);
    }
    
    /**
     * Handle order list display
     */
    private void handleOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int recordsPerPage = 10;
        
        // Get total count first (faster query)
        int totalRecords = orderDAO.getTotalOrdersCount();
        
        // Calculate pagination
        int startIndex = (currentPage - 1) * recordsPerPage;
        
        // Get only current page data from database (much faster)
        List<Order> pageData = orderDAO.getOrdersForStaffPaginated(startIndex, recordsPerPage);

        // Set attributes
        request.setAttribute("orders", pageData);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("baseUrl", request.getRequestURI());

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/staff/orders-management.jsp").forward(request, response);
    }
    
    /**
     * Handle order detail display
     */
    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, Staff staff)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            session.setAttribute("flash_error", "Order ID is required!");
            response.sendRedirect(request.getContextPath() + "/staff/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            // Get order details for staff
            Order order = orderDAO.getOrderDetailForStaff(orderId);
            
            if (order == null) {
                session.setAttribute("flash_error", "Order not found!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
                return;
            }

            // Get order status history
            List<OrderStatusHistory> statusHistory = orderDAO.getOrderStatusHistory(orderId);
            
            // Set attributes for JSP
            request.setAttribute("order", order);
            request.setAttribute("statusHistory", statusHistory);
            
            // Forward to order detail JSP
            request.getRequestDispatcher("/WEB-INF/views/staff/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid Order ID!");
            response.sendRedirect(request.getContextPath() + "/staff/orders");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "An error occurred while loading order details!");
            response.sendRedirect(request.getContextPath() + "/staff/orders");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Handles order status update from both list and detail pages
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("update-status".equals(action) || action == null) {
            // Handle status update (from list page via AJAX or detail page via form)
            handleUpdateOrderStatus(request, response, staff);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/orders");
        }
    }
    
    /**
     * Handle update order status
     */
    private void handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response, Staff staff)
            throws IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String orderIdStr = request.getParameter("orderId");
            String newStatus = request.getParameter("newStatus");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty() || 
                newStatus == null || newStatus.trim().isEmpty()) {
                
                // Check if AJAX request (from list page)
                String contentType = request.getContentType();
                if (contentType != null && contentType.contains("application/x-www-form-urlencoded")) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                    return;
                }
                
                session.setAttribute("flash_error", "Order ID and status are required!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            int staffId = staff != null ? staff.getStaffId() : 1;
            
            // Update order status
            boolean success = orderDAO.updateOrderStatusForStaff(orderId, newStatus, staffId);
            
            // Check if request is from AJAX (list page) or form (detail page)
            // AJAX requests typically have X-Requested-With header or ajax parameter
            boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) 
                                 || request.getParameter("ajax") != null;
            
            if (isAjaxRequest) {
                // AJAX response for list page
                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.setContentType("text/plain");
                    response.getWriter().write("Status updated successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update status");
                }
            } else {
                // Form response for detail page
                if (success) {
                    session.setAttribute("flash_success", "Order status updated successfully!");
                } else {
                    session.setAttribute("flash_error", "Failed to update order status!");
                }
                
                // Redirect back to order detail or orders list
                String redirectUrl = request.getParameter("redirect");
                if ("detail".equals(redirectUrl)) {
                    response.sendRedirect(request.getContextPath() + "/staff/order-detail?orderId=" + orderId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/orders");
                }
            }
            
        } catch (NumberFormatException e) {
            boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) 
                                 || request.getParameter("ajax") != null;
            
            if (isAjaxRequest) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
            } else {
                session.setAttribute("flash_error", "Invalid Order ID!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
            boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) 
                                 || request.getParameter("ajax") != null;
            
            if (isAjaxRequest) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
            } else {
                session.setAttribute("flash_error", "An error occurred while updating order status!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Staff Order Management Servlet";
    }
}
