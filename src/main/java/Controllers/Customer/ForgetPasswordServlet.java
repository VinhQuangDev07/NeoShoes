package Controllers.Customer;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Random;

import DAOs.CustomerDAO;
import Models.Customer;
import Utils.EmailService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forget-password")
public class ForgetPasswordServlet extends HttpServlet {
    
    private final CustomerDAO customerDAO = new CustomerDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                // Lấy email từ parameter (nếu có)
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/forget-password.jsp");
                dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processPasswordReset(request, response);
    }
    
    private void processPasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try {
            Customer customer = customerDAO.getCustomerByEmail(email);
            
            if (customer != null) {
                // Tạo OTP 6 chữ số
                String otp = generateOTP();
                LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(10);
                
                // Xóa OTP cũ rồi lưu OTP mới
                customerDAO.deleteOldVerifyCode(customer.getId());
                customerDAO.saveVerifyCode(customer.getId(), otp, expiryTime);
                
                // Gửi OTP qua email (thay vì gửi link)
                boolean emailSent = EmailService.sendPasswordResetOTP(
                    customer.getEmail(), 
                    customer.getName(), 
                    otp
                );
                
                if (emailSent) {
                    System.out.println("OTP sent to: " + customer.getEmail());
                    request.setAttribute("email", email);
                    request.setAttribute("message", "Mã OTP đã được gửi đến email của bạn");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/verify-reset-otp.jsp");
                    dispatcher.forward(request, response);
                } else {
                    System.err.println("Failed to send OTP to: " + customer.getEmail());
                    request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại");
                    forwardToForgetPassword(request, response);
                }
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống");
                forwardToForgetPassword(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("processPasswordReset error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại");
            forwardToForgetPassword(request, response);
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private void forwardToForgetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/forget-password.jsp");
        dispatcher.forward(request, response);
    }
}
