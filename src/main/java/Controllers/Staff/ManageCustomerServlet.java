/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.CustomerDAO;
import Models.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        session.setAttribute("role", "admin");

        // Check if user is logged in and has staff or admin role
//        String role = (String) session.getAttribute("role");
//        if (role == null || (!role.equals("staff") && !role.equals("admin"))) {
//            response.sendRedirect("login");
//            return;
//        }
        List<Customer> customers;

        // Get all customers
        customers = customerDAO.getAllCustomers();

        // Set attributes
        request.setAttribute("customers", customers);
        request.setAttribute("totalCustomers", customers.size());

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
