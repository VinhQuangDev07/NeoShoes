/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.CustomerDAO;
import Models.Customer;
import Utils.CloudinaryConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.Objects;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig
public class ProfileServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

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
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("customerId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//        int customerId = (int) session.getAttribute("customerId");

        int customerId = Integer.parseInt(request.getParameter("id"));

        Customer customer = customerDAO.findById(customerId);

//        if (customer == null || customer.isDeleted()|| customer.isBlock()) {
//            response.sendError(403);
//            return;
//        }
        if (customer != null) {
            request.setAttribute("customer", customer);
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
//        request.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(request, response);
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

        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("customerId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

//        int customerId = (int) session.getAttribute("customerId");
        String action = request.getParameter("action");
        int customerId = Integer.parseInt(request.getParameter("id"));

        boolean success = false;

        if ("updateProfile".equals(action)) {

            Customer currentCustomer = customerDAO.findById(customerId);

            // ====== Update profile ======
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            Part avatarPart = request.getPart("avatar");
            String avatarUrl = null;
            String gender = request.getParameter("gender");

            boolean unchanged = false;
            if (Objects.equals(name, currentCustomer.getName())
                    & Objects.equals(phone, currentCustomer.getPhoneNumber())
                    & (avatarPart.getSize() == 0 || avatarPart.getSubmittedFileName() == "")
                    & Objects.equals(gender, currentCustomer.getGender())) {
                unchanged = true;
            } 

            if (unchanged) {
                session.setAttribute("flash_info", "No change in profile information.");
            } else {
                avatarUrl = CloudinaryConfig.uploadSingleImage(avatarPart);
                System.out.println("upload avatar to cloudinary");
                success = customerDAO.updateProfile(customerId, name, phone, avatarUrl, gender);
                if (success) {
                    session.setAttribute("flash", "Profile updated successfully.");
                } else {
                    session.setAttribute("flash_error", "Failed to update profile.");
                }
            }

        } else if ("changePassword".equals(action)) {
            // ====== Change password ======
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword == null || newPassword.length() < 8 || !newPassword.equals(confirmPassword)) {
                session.setAttribute("flash_error", "Password must be >= 8 chars and match confirmation.");
            } else {
                success = customerDAO.changePassword(customerId, currentPassword, newPassword);
                if (success) {
                    session.setAttribute("flash", "Password changed successfully.");
                } else {
                    session.setAttribute("flash_error", "Current password is incorrect.");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile?id=2");
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
