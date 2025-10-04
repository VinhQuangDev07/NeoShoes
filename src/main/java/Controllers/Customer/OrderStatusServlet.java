/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrderStatusServlet", urlPatterns = {"/orders/status"})
public class OrderStatusServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("customerId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            String action = request.getParameter("action");

            // Validate action
            if (action == null || (!action.equals("cancel"))) {
                response.sendError(400, "Invalid action");
                return;
            }

            boolean success = false;
            String message = "";

            if (action.equals("cancel")) {
                // Cancel order
                success = orderDAO.updateOrderStatus(orderId, "CANCELED");
                message = success ? "Order canceled successfully!" : "Failed to cancel order.";
            } 

            // Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String jsonResponse = String.format(
                "{\"success\": %s, \"message\": \"%s\"}", 
                success, message
            );
            
            response.getWriter().write(jsonResponse);

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid order ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Internal server error");
        }
    }
}
