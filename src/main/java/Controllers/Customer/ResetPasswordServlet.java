package Controllers.Customer;

import java.io.IOException;

import DAOs.CustomerDAO;
import DAOs.StaffDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    
    private CustomerDAO customerDAO = new CustomerDAO();
    private StaffDAO staffDAO = new StaffDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            forwardToVerifyPage(request, response, userType);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            forwardToVerifyPage(request, response, userType);
            return;
        }
        
        if ("staff".equals(userType)) {
            processStaffResetPassword(request, response, email, otp, newPassword);
        } else {
            processCustomerResetPassword(request, response, email, otp, newPassword);
        }
    }
    
    // ========== CUSTOMER ==========
    private void processCustomerResetPassword(HttpServletRequest request, HttpServletResponse response, 
                                              String email, String otp, String newPassword)
            throws ServletException, IOException {
        
        if (customerDAO.verifyResetOTP(email, otp)) {
            boolean updated = customerDAO.updatePassword(email, newPassword);
            
            if (updated) {
                customerDAO.clearResetOTP(email);
                request.setAttribute("message", "Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                request.setAttribute("email", email);
                request.setAttribute("userType", "customer");
                forwardToVerifyPage(request, response, "customer");
            }
        } else {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn");
            request.setAttribute("email", email);
            request.setAttribute("userType", "customer");
            forwardToVerifyPage(request, response, "customer");
        }
    }
    
    // ========== STAFF ==========
    private void processStaffResetPassword(HttpServletRequest request, HttpServletResponse response, 
                                           String email, String otp, String newPassword)
            throws ServletException, IOException {
        
        if (staffDAO.verifyResetOTP(email, otp)) {
            boolean updated = staffDAO.updatePasswordByEmail(email, newPassword);
            
            if (updated) {
                staffDAO.clearResetOTP(email);
                request.setAttribute("message", "Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/login.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                request.setAttribute("email", email);
                request.setAttribute("userType", "staff");
                forwardToVerifyPage(request, response, "staff");
            }
        } else {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn");
            request.setAttribute("email", email);
            request.setAttribute("userType", "staff");
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