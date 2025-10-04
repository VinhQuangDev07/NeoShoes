/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import Models.Customer;
import Models.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🔍 OrdersServlet.doGet() called");
        
//        HttpSession session = request.getSession(false);
//        System.out.println("🔍 Session: " + (session != null ? "exists" : "null"));
//        
//        if (session == null || session.getAttribute("customerId") == null) {
//            System.out.println("❌ No session or customerId - redirecting to login");
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
        
        int customerId =1;
        try {
//            customerId = (int) session.getAttribute("customerId");
            System.out.println("✅ Customer ID from session: " + customerId);
        } catch (Exception e) {
            // If customerId is not an integer, use default value
            
            System.out.println("⚠️ Customer ID not integer, using default: " + customerId);
        }
        
        System.out.println("🔍 Calling orderDAO.listByCustomer(" + customerId + ")");
        List<Order> orders = orderDAO.listByCustomer(customerId);
        System.out.println("📊 Orders returned: " + (orders != null ? orders.size() : "null"));
        
        if (orders != null && !orders.isEmpty()) {
            for (Order order : orders) {
                System.out.println("📦 Order: " + order.getId() + " - " + order.getStatus() + " - $" + order.getTotalAmount());
            }
        }
        
        request.setAttribute("orders", orders);
        System.out.println("🔍 Forwarding to orders.jsp");
        request.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(request, response);
    }
}


