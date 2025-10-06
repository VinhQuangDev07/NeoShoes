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
        System.out.println("🔍 OrderDetailServlet.doGet() called");
        
//        HttpSession session = request.getSession(false);
//        System.out.println("🔍 Session: " + (session != null ? "exists" : "null"));
//        
//        if (session == null || session.getAttribute("customerId") == null) {
//            System.out.println("❌ No session or customerId - redirecting to login");
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
        
        int customerId = 1;
        try {
//            customerId = (int) session.getAttribute("customerId");
            System.out.println("✅ Customer ID from session: " + customerId);
        } catch (Exception e) {
            // If customerId is not an integer, use default value
      
            System.out.println("⚠️ Customer ID not integer, using default: " + customerId);
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        System.out.println("🔍 Requested Order ID: " + orderId);
        
        System.out.println("🔍 Calling orderDAO.findWithItems(" + orderId + ")");
        Order order = orderDAO.findWithItems(orderId);
        
        if (order == null) {
            System.out.println("❌ Order not found - returning 404");
            response.sendError(404);
            return;
        }
        
        System.out.println("📦 Order found: ID=" + order.getId() + ", Customer=" + order.getCustomerId() + 
                         ", Total=$" + order.getTotalAmount() + ", Items=" + order.getItems().size());
        
        // For demo purposes, allow access to any order
        // In production, you should check: order.getCustomerId() != customerId
        request.setAttribute("order", order);
        System.out.println("🔍 Forwarding to order-detail.jsp");
        request.getRequestDispatcher("/WEB-INF/views/customer/order-detail.jsp").forward(request, response);
    }
}


