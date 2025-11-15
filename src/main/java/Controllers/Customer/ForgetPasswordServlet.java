package Controllers.Customer;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Random;

import DAOs.CustomerDAO;
import DAOs.StaffDAO;
import Models.Customer;
import Models.Staff;
import Utils.EmailService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forget-password")
public class ForgetPasswordServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userType = request.getParameter("type"); // "customer" or "staff"
//
//        if ("staff".equals(userType)) {
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/forget-password.jsp");
//            dispatcher.forward(request, response);
//        } else {
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/forget-password.jsp");
//            dispatcher.forward(request, response);
//        }
// LẤY EMAIL TỪ URL
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            // Nếu user truy cập trực tiếp hoặc không có email
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Gửi email sang JSP
        request.setAttribute("email", email);

//        // Load trang customer forget password
//        RequestDispatcher dispatcher= request.getRequestDispatcher("/WEB-INF/views/customer/forget-password.jsp");
//        dispatcher.forward(request, response);
        String view = "/WEB-INF/views/customer/forget-password.jsp";
        if ("staff".equals(userType)) {
            view = "/WEB-INF/views/staff/forget-password.jsp";
        }

        request.getRequestDispatcher(view).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userType = request.getParameter("userType"); // Hidden input trong form
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            // Không có email → quay lại login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("email", email);

        if ("staff".equals(userType)) {
            processStaffPasswordReset(request, response, email);
        } else {
            processCustomerPasswordReset(request, response, email);
        }
    }

    // ========== CUSTOMER ==========
    private void processCustomerPasswordReset(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        try {
            Customer customer = customerDAO.getCustomerByEmail(email);

            if (customer != null) {
                request.getSession().setAttribute("resetEmail", email);
                String otp = generateOTP();
                LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(10);

                customerDAO.deleteOldVerifyCode(customer.getId());
                customerDAO.saveVerifyCode(customer.getId(), otp, expiryTime);

                boolean emailSent = EmailService.sendPasswordResetOTP(
                        customer.getEmail(),
                        customer.getName(),
                        otp
                );

                if (emailSent) {
                    System.out.println("OTP sent to customer: " + customer.getEmail());
                    request.setAttribute("email", email);
                    request.setAttribute("userType", "customer");
                    request.setAttribute("message", "Mã OTP đã được gửi đến email của bạn");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/verify-reset-otp.jsp");
                    dispatcher.forward(request, response);
                } else {
                    System.err.println("Failed to send OTP to customer: " + customer.getEmail());
                    request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại");
                    request.setAttribute("userType", "customer");
                    forwardToForgetPassword(request, response, "customer");
                }
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống");
                request.setAttribute("userType", "customer");
                forwardToForgetPassword(request, response, "customer");
            }

        } catch (Exception e) {
            System.err.println("processCustomerPasswordReset error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại");
            request.setAttribute("userType", "customer");
            forwardToForgetPassword(request, response, "customer");
        }
    }

    // ========== STAFF ==========
    private void processStaffPasswordReset(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        try {
            Staff staff = staffDAO.findByEmail(email);

            if (staff != null) {
                request.getSession().setAttribute("resetEmail", email);
                String otp = generateOTP();
                LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(10);

                staffDAO.deleteOldVerifyCode(staff.getStaffId());
                staffDAO.saveVerifyCode(staff.getStaffId(), otp, expiryTime);

                boolean emailSent = EmailService.sendPasswordResetOTP(
                        staff.getEmail(),
                        staff.getName(),
                        otp
                );

                if (emailSent) {
                    System.out.println("OTP sent to staff: " + staff.getEmail());
                    request.setAttribute("email", email);
                    request.setAttribute("userType", "staff");
                    request.setAttribute("message", "Mã OTP đã được gửi đến email của bạn");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/verify-reset-otp.jsp");
                    dispatcher.forward(request, response);
                } else {
                    System.err.println("Failed to send OTP to staff: " + staff.getEmail());
                    request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại");
                    request.setAttribute("userType", "staff");
                    forwardToForgetPassword(request, response, "staff");
                }
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống");
                request.setAttribute("userType", "staff");
                forwardToForgetPassword(request, response, "staff");
            }

        } catch (Exception e) {
            System.err.println("processStaffPasswordReset error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại");
            request.setAttribute("userType", "staff");
            forwardToForgetPassword(request, response, "staff");
        }
    }

    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    private void forwardToForgetPassword(HttpServletRequest request, HttpServletResponse response, String userType)
            throws ServletException, IOException {
        String jspPath = "staff".equals(userType)
                ? "/WEB-INF/views/staff/forget-password.jsp"
                : "/WEB-INF/views/customer/forget-password.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }
}
