/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers.Staff;

import DAOs.OrderDAO;
import Models.Order;
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
 * Handles viewing all orders for staff
 * 
 * @author AI Assistant
 */
@WebServlet(name = "ManageOrderServlet", urlPatterns = {"/staff/orders"})
public class ManageOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        super.init();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays all orders for staff management
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Set hardcoded staff info (like ManageProductServlet)
        Staff staff = new Staff();
        staff.setStaffId(1);
        staff.setRole(true); // true = Admin
        staff.setEmail("admin@shoestore.com");
        staff.setName("Admin");
        staff.setPhoneNumber("+1-202-555-0101");
        staff.setAvatar("https://cdn.shoestore.com/staff/admin.jpg");
        staff.setGender("Male");

        // Set into session
        session.setAttribute("staff", staff);
        session.setAttribute("role", "admin");

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
     * Handles the HTTP <code>POST</code> method.
     * Currently not used for this servlet
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String orderIdStr = request.getParameter("orderId");
            String newStatus = request.getParameter("newStatus");
            
            if (orderIdStr == null || newStatus == null || orderIdStr.isEmpty() || newStatus.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            
            // Get staff ID from session
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("staff");
            int staffId = staff != null ? staff.getStaffId() : 1; // Default to 1 if no staff in session
            
            // Update order status
            boolean success = orderDAO.updateOrderStatusForStaff(orderId, newStatus, staffId);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Status updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update status");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
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
