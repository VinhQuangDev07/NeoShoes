/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import Models.Order;
import Models.OrderStatusHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrdersServlet", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hardcode customerId = 2 for testing (no login functionality yet)
        int customerId = 1;

        List<Order> orders;
        try {
            orders = orderDAO.listByCustomer(customerId);
            request.setAttribute("orders", orders);
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Check for success/error messages
        String cancelled = request.getParameter("cancelled");
        String error = request.getParameter("error");

        if ("true".equals(cancelled)) {
            request.setAttribute("successMessage", "Order has been cancelled successfully!");
        } else if ("cancel_failed".equals(error)) {
            request.setAttribute("errorMessage", "Failed to cancel order. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(request, response);
    }
}
