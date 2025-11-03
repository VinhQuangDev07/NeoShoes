package Controllers.Customer;

import DAOs.CustomerDAO;
import Models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;


@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verify-email"})
public class VerifyEmailServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    /**
     * Show verification form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String pendingEmail = (String) session.getAttribute("pendingEmail");
        
        if (pendingEmail == null) {
            session.setAttribute("flash_error", "No pending verification found!");
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        
        request.setAttribute("email", pendingEmail);
        request.getRequestDispatcher("/WEB-INF/views/customer/verify-email.jsp").forward(request, response);
    }

    /**
     * Process verification code
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String pendingEmail = (String) session.getAttribute("pendingEmail");
        
        if (pendingEmail == null) {
            session.setAttribute("flash_error", "No pending verification found!");
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        
        String action = request.getParameter("action");
        
        // ========================================
        // RESEND CODE
        // ========================================
        if ("resend".equals(action)) {
            
            // Get customer info
            int customerId = customerDAO.getCustomerIdByEmail(pendingEmail);
            
            if (customerId > 0) {
                // Generate new code
                String newCode = Utils.EmailService.generateVerificationCode();
                LocalDateTime expiry = LocalDateTime.now().plusMinutes(2);
                
                // Delete old code and create new one
                boolean codeCreated = customerDAO.resendVerificationCode(pendingEmail);
                
                if (codeCreated) {
                    // Send email with new code
                    // Note: Need to get customer name first
                    CustomerDAO dao = new DAOs.CustomerDAO();
                    Customer customer = dao.getCustomerByEmail(pendingEmail);
                    
                    if (customer != null) {
                        boolean emailSent = Utils.EmailService.sendVerificationCode(
                            pendingEmail, 
                            customer.getName(), 
                            newCode
                        );
                        
                        if (emailSent) {
                            session.setAttribute("flash", "Verification code resent! Please check your email.");
                        } else {
                            session.setAttribute("flash_error", "Failed to resend code. Please try again.");
                        }
                    }
                } else {
                    session.setAttribute("flash_error", "Failed to create new code. Please try again.");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/verify-email");
            return;
        }
        
        // ========================================
        // VERIFY CODE
        // ========================================
        String verificationCode = request.getParameter("code");
        
        if (verificationCode == null || verificationCode.trim().isEmpty()) {
            session.setAttribute("flash_error", "Please enter verification code!");
            response.sendRedirect(request.getContextPath() + "/verify-email");
            return;
        }
        
        boolean verified = customerDAO.verifyCustomer(pendingEmail, verificationCode.trim());
        
        if (verified) {
            session.removeAttribute("pendingEmail");
            session.setAttribute("flash", " Email verified successfully! You can now login.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            session.setAttribute("flash_error", "Invalid or expired verification code!");
            response.sendRedirect(request.getContextPath() + "/verify-email");
        }
    }
}