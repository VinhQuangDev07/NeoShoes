/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.CustomerDAO;
import Models.Customer;
import Models.Staff;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "ManageCustomerServlet", urlPatterns = {"/manage-customer"})
public class ManageCustomerServlet extends HttpServlet {

    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        super.init();
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Tạo staff mẫu (Admin)
        Staff staff = new Staff();
        staff.setStaffId(1);
        staff.setRole(true); // true = Admin
        staff.setEmail("admin@neoshoes.com");
        staff.setPasswordHash("hashed_password_here");
        staff.setName("Nguyễn Văn Admin");
        staff.setPhoneNumber("0912345678");
        staff.setAvatar("https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg");
        staff.setGender("Male");
        staff.setCreatedAt(LocalDateTime.now().minusMonths(6));
        staff.setUpdatedAt(LocalDateTime.now());
        staff.setDeleted(false);

        // Set vào session
        session.setAttribute("staff", staff);
        session.setAttribute("role", "admin"); // hoặc "staff"

        // Check if user is logged in and has staff or admin role
//        String role = (String) session.getAttribute("role");
//        if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
//            response.sendRedirect("login");
//            return;
//        }
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
        List<Customer> customers;

        // Get all customers
        customers = customerDAO.getAllCustomers();
        
        int totalRecords = customers.size();
        
        // Calculate start and end positions
        int startIndex = (currentPage - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);
        
        // 5. Lấy dữ liệu cho trang hiện tại
        List<Customer> pageData;
        if (startIndex < totalRecords) {
            pageData = customers.subList(startIndex, endIndex);
        } else {
            pageData = new ArrayList<>();
        }

        // Set attributes
        request.setAttribute("customers", pageData);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("baseUrl", request.getRequestURI()); 

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/staff/manage-customer.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        String role = (String) session.getAttribute("role");
//        if (role == null) {
//            response.sendRedirect("login");
//            return;
//        }
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/manage-customer");
            return;
        }

        if ("view-detail".equals(action)) {
            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                Customer customer = customerDAO.findById(customerId);

                if (customer != null) {
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/WEB-INF/views/staff/customer-detail.jsp").forward(request, response);
                } else {
                    session.setAttribute("flash_error", "Customer not found!");
                    response.sendRedirect(request.getContextPath() + "/manage-customer");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flash_error", "Invalid customer ID!");
                response.sendRedirect(request.getContextPath() + "/manage-customer");
            }
        } else if ("block".equals(action)) {
            // Only admin can block customers
            if (!role.equals("admin")) {
                session.setAttribute("flash_error", "You don't have permission to block customers!");
                response.sendRedirect(request.getContextPath() + "/manage-customer");
                return;
            }

            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                boolean success = customerDAO.updateBlockStatus(customerId, true);

                if (success) {
                    session.setAttribute("flash", "Customer blocked successfully!");
                } else {
                    session.setAttribute("flash_error", "Failed to block customer!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flash_error", "Invalid customer ID!");
            }

            response.sendRedirect(request.getContextPath() + "/manage-customer");
        } else if ("unblock".equals(action)) {
            // Only admin can unblock customers
            if (!role.equals("admin")) {
                session.setAttribute("flash_error", "You don't have permission to unblock customers!");
                response.sendRedirect(request.getContextPath() + "/manage-customer");
                return;
            }

            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                boolean success = customerDAO.updateBlockStatus(customerId, false);

                if (success) {
                    session.setAttribute("flash", "Customer unblocked successfully!");
                } else {
                    session.setAttribute("flash_error", "Failed to unblock customer!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flash_error", "Invalid customer ID!");
            }

            response.sendRedirect(request.getContextPath() + "/manage-customer");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
