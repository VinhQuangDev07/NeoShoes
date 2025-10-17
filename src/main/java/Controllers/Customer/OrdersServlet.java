/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.CustomerDAO;
import Models.Order;
import Models.Customer;
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
    private final CustomerDAO customerDAO = new CustomerDAO();

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
        // For now, using hardcoded customer ID. In production, get from session
        // Using Customer ID = ?
        int customerId = 2;
        Customer customer = customerDAO.findById(customerId);
        List<Order> orders = orderDAO.listByCustomer(customerId);

        // Check for success/error messages
        String cancelled = request.getParameter("cancelled");
        String error = request.getParameter("error");
        
        if ("true".equals(cancelled)) {
            request.setAttribute("successMessage", "Order has been cancelled successfully!");
        } else if ("cancel_failed".equals(error)) {
            request.setAttribute("errorMessage", "Failed to cancel order. Please try again.");
        }

        request.setAttribute("orders", orders);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(request, response);
    }
}
