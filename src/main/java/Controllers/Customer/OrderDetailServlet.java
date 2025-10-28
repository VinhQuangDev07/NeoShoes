/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.ReturnRequestDAO;
import Models.Order;

import DAOs.CustomerDAO;

import Models.Customer;
import Models.Order;
import Models.OrderStatusHistory;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orders/detail"})
public class OrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // For now, using hardcoded customer ID. In production, get from session
           // int customerId = 2;
            //Customer customer = customerDAO.findById(customerId);

        // For now, using hardcoded customer ID. In production, get from session
        int customerId = 1;
        Customer customer = customerDAO.findById(customerId);
            int orderId = Integer.parseInt(request.getParameter("id"));
            int requestId = 0;
            try {

                Order order = orderDAO.findWithItems(orderId);
                request.setAttribute("order", order);
                
                // Load order status history for timeline
                List<OrderStatusHistory> statusHistory = orderDAO.getOrderStatusHistory(orderId);
                request.setAttribute("statusHistory", statusHistory);

                ReturnRequestDAO rrDAO = new ReturnRequestDAO();
                boolean hasRequest = rrDAO.existsByOrderId(orderId);

                if (hasRequest) {
                    requestId = rrDAO.getRequestIdByOrderId(orderId);
                }
                request.setAttribute("hasRequest", hasRequest);
                request.setAttribute("requestId", requestId);
                if (order == null) {
                    response.sendError(404);
                    return;
                }
            } catch (SQLException ex) {
                Logger.getLogger(OrderDetailServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            // For demo purposes, allow access to any order
            // In production, you should check: order.getCustomerId() != customerId
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/customer/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid order ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders");
        } catch (Exception e) {
            System.err.println("Error loading order detail: " + e.getMessage());
            e.printStackTrace();
            response.sendError(500, "Internal Server Error");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("cancel".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                
                // Get customer ID from session
                int customerId = 2;
//                if (customerId == null) {
//                    System.err.println("Customer not logged in");
//                    response.sendRedirect(request.getContextPath() + "/orders?error=not_logged_in");
//                    return;
//                }

                // Update order status to CANCELLED using customer method
                boolean success = orderDAO.updateOrderStatusForCustomer(orderId, "CANCELLED", customerId);

                if (success) {
                    System.out.println("Order " + orderId + " cancelled successfully");
                    response.sendRedirect(request.getContextPath() + "/orders");
                } else {
                    System.err.println("Failed to cancel order " + orderId);
                    response.sendRedirect(request.getContextPath() + "/orders?error=cancel_failed");
                }
            } else {
                // Unknown action
                //response.sendRedirect(request.getContextPath() + "/orders");
                System.err.println("Unknown action: " + action);
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid order ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders?error=invalid_order");
        } catch (Exception e) {
            System.err.println("Error processing order action: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders?error=unknown");
        }
    }
}
