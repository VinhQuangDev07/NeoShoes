/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import Models.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orders/detail"})
public class OrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession(false);
//        System.out.println("🔍 Session: " + (session != null ? "exists" : "null"));
//        
//        if (session == null || session.getAttribute("customerId") == null) {
//            System.out.println("❌ No session or customerId - redirecting to login");
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
        int customerId = 2;
        try {
//            customerId = (int) session.getAttribute("customerId");

        } catch (Exception e) {
            // If customerId is not an integer, use default value
        }

        int orderId = Integer.parseInt(request.getParameter("id"));
        System.out.println("🔍 OrderDetailServlet: Looking for Order ID: " + orderId);
        Order order = orderDAO.findWithItems(orderId);
        System.out.println("🔍 OrderDetailServlet: Order found: " + (order != null ? "YES" : "NO"));
        
        if (order == null) {
            System.out.println("❌ OrderDetailServlet: Order not found, sending 404");
            response.sendError(404);
            return;
        }

        // For demo purposes, allow access to any order
        // In production, you should check: order.getCustomerId() != customerId
        request.setAttribute("order", order);
        request.getRequestDispatcher("/WEB-INF/views/customer/order-detail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            System.out.println("🗑️ OrderDetailServlet: Cancelling Order ID: " + orderId);
            
            boolean success = orderDAO.deleteOrder(orderId);
            
            if (success) {
                System.out.println("✅ OrderDetailServlet: Order cancelled successfully");
                // Redirect to orders page with success message
                response.sendRedirect(request.getContextPath() + "/orders?cancelled=true");
            } else {
                System.out.println("❌ OrderDetailServlet: Failed to cancel order");
                // Redirect to orders page with error message
                response.sendRedirect(request.getContextPath() + "/orders?error=cancel_failed");
            }
        } else {
            // Unknown action
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
