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
import java.io.IOException;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orders/detail"})
public class OrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // TODO: Implement session-based authentication when login is ready
        // Hardcode customerId = 2 for testing (no login functionality yet)
        // TODO: Use this for access control when login is implemented
        @SuppressWarnings("unused")
        int customerId = 2;

        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.findWithItems(orderId);
        
        if (order == null) {
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
            
            boolean success = orderDAO.deleteOrder(orderId);
            
            if (success) {
                // Redirect to orders page with success message
                response.sendRedirect(request.getContextPath() + "/orders?cancelled=true");
            } else {
                // Redirect to orders page with error message
                response.sendRedirect(request.getContextPath() + "/orders?error=cancel_failed");
            }
        } else {
            // Unknown action
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
