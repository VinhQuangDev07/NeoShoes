package Controllers.Customer;

import java.io.IOException;

import DAOs.CustomerDAO;
import Models.Customer;
import Utils.Utils;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    
    private CustomerDAO customerDAO = new CustomerDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate password match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("email", email);
            forwardToVerifyPage(request, response);
            return;
        }
        
        // Validate password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("email", email);
            forwardToVerifyPage(request, response);
            return;
        }
        
        try {
            Customer customer = customerDAO.getCustomerByEmail(email);
            
            if (customer == null) {
                request.setAttribute("error", "Email không tồn tại");
                forwardToVerifyPage(request, response);
                return;
            }
            
            System.out.println("=== DEBUG INFO ===");
            System.out.println("Customer ID: " + customer.getId());
            System.out.println("Email: " + email);
            System.out.println("OTP từ form: " + otp);
            
            // Verify OTP - truyền EMAIL thay vì ID
            boolean isValidOTP = customerDAO.verifyResetOTP(email, otp);
            
            System.out.println("OTP hợp lệ: " + isValidOTP);
            
            if (!isValidOTP) {
                request.setAttribute("error", "OTP không đúng hoặc đã hết hạn");
                request.setAttribute("email", email);
                forwardToVerifyPage(request, response);
                return;
            }
            
            // Hash password trước khi lưu
            String hashedPassword = Utils.hashPassword(newPassword);
            System.out.println("Hashed password: " + hashedPassword);
            
            // Update password - truyền EMAIL thay vì ID
            boolean updateSuccess = customerDAO.updatePassword(email, hashedPassword);
            System.out.println("Update password success: " + updateSuccess);
            
            if (!updateSuccess) {
                request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                request.setAttribute("email", email);
                forwardToVerifyPage(request, response);
                return;
            }
            
            // Delete used OTP - truyền EMAIL
            customerDAO.clearResetOTP(email);
            
            // Success - redirect to login
            request.getSession().setAttribute("successMessage", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception: " + e.getMessage());
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            forwardToVerifyPage(request, response);
        }
    
    }
    
    private void forwardToVerifyPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/verify-reset-otp.jsp");
        dispatcher.forward(request, response);
    }
}