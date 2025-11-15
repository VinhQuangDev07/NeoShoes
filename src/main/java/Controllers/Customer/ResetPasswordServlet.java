package Controllers.Customer;

import java.io.IOException;

import DAOs.CustomerDAO;
import DAOs.StaffDAO;
import Utils.Utils;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String userType = request.getParameter("userType");
        
        // 🔥 Email được lấy từ SESSION, không phải từ request
        String email = (String) session.getAttribute("resetEmail");

        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            request.setAttribute("error", "Session expired. Please try again.");
            forwardToVerifyPage(request, response, userType);
            return;
        }

        // Validate password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Confirmation password does not match");
            forwardToVerifyPage(request, response, userType);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters");
            forwardToVerifyPage(request, response, userType);
            return;
        }

        if ("staff".equals(userType)) {
            processStaffResetPassword(request, response, email, otp, newPassword);
        } else {
            processCustomerResetPassword(request, response, email, otp, newPassword);
        }
    }

    // ================= CUSTOMER ==================
    private void processCustomerResetPassword(HttpServletRequest request, HttpServletResponse response,
                                              String email, String otp, String newPassword)
            throws ServletException, IOException {

        if (customerDAO.verifyResetOTP(email, otp)) {

            boolean updated = customerDAO.updatePassword(email, Utils.hashPassword(newPassword));

            if (updated) {
                customerDAO.clearResetOTP(email);

                //XÓA session email sau khi reset thành công
                request.getSession().removeAttribute("resetEmail");

                request.setAttribute("message", "Password updated successfully. Please log in.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp");
                dispatcher.forward(request, response);
                return;

            } else {
                request.setAttribute("error", "Unable to update password. Please try again.");
                forwardToVerifyPage(request, response, "customer");
            }

        } else {
            request.setAttribute("error", "The OTP code is incorrect or has expired.");
            forwardToVerifyPage(request, response, "customer");
        }
    }

    // ================= STAFF ==================
    private void processStaffResetPassword(HttpServletRequest request, HttpServletResponse response,
                                           String email, String otp, String newPassword)
            throws ServletException, IOException {

        if (staffDAO.verifyResetOTP(email, otp)) {

            boolean updated = staffDAO.updatePasswordByEmail(email, newPassword);

            if (updated) {
                staffDAO.clearResetOTP(email);

                // XÓA session email sau khi reset thành công
                request.getSession().removeAttribute("resetEmail");

                request.setAttribute("message", "Password updated successfully. Please log in.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/login.jsp");
                dispatcher.forward(request, response);
                return;

            } else {
                request.setAttribute("error", "Unable to update password. Please try again.");
                forwardToVerifyPage(request, response, "staff");
            }

        } else {
            request.setAttribute("error", "The OTP code is incorrect or has expired.");
            forwardToVerifyPage(request, response, "staff");
        }
    }

    private void forwardToVerifyPage(HttpServletRequest request, HttpServletResponse response, String userType)
            throws ServletException, IOException {
        String jspPath = "staff".equals(userType)
                ? "/WEB-INF/views/staff/verify-reset-otp.jsp"
                : "/WEB-INF/views/customer/verify-reset-otp.jsp";

        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }
}
