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

@WebServlet(name = "StaffOrderDetailServlet", urlPatterns = {"/staff/order-detail"})
public class StaffOrderDetailServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Hardcoded staff for testing (no login required)
        Staff staff = new Staff();
        staff.setStaffId(1);
        staff.setName("Admin Staff");
        staff.setEmail("admin@neoshoes.com");
        staff.setAvatar("https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg");
        staff.setRole(true); // Admin role
        
        session.setAttribute("staff", staff);
        session.setAttribute("role", "admin");

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/orders");
            return;
        }

        String action = request.getParameter("action");
        
        if ("update-status".equals(action)) {
            String orderIdParam = request.getParameter("orderId");
            String newStatus = request.getParameter("newStatus");
            
            if (orderIdParam == null || orderIdParam.isEmpty() || newStatus == null || newStatus.isEmpty()) {
                session.setAttribute("flash_error", "Order ID and status are required!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdParam);
                
                // Update order status
                boolean success = orderDAO.updateOrderStatusForStaff(orderId, newStatus, staff.getStaffId());
                
                if (success) {
                    session.setAttribute("flash_success", "Order status updated successfully!");
                } else {
                    session.setAttribute("flash_error", "Failed to update order status!");
                }
                
                // Redirect back to order detail
                response.sendRedirect(request.getContextPath() + "/staff/order-detail?orderId=" + orderId);
                
            } catch (NumberFormatException e) {
                session.setAttribute("flash_error", "Invalid Order ID!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flash_error", "An error occurred while updating order status!");
                response.sendRedirect(request.getContextPath() + "/staff/orders");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/orders");
        }
    }
}