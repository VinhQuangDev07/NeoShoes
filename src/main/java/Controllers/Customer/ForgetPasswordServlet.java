package Controllers.Customer;

import java.io.IOException;
import java.time.LocalDateTime;

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
        forwardToForgetPassword(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address");
            forwardToForgetPassword(request, response);
            return;
        }
        
        Customer customer = customerDAO.findByEmail(email);
        
        if (customer != null) {
            processPasswordReset(request, customer);
        }
        
        // Luôn hiển thị success message (security best practice)
        request.setAttribute("message", 
            "If an account with that email exists, a password reset link has been sent.");
        forwardToForgetPassword(request, response);
    }
    
    private boolean isValidEmail(String email) {
        return email != null && !email.trim().isEmpty() && email.contains("@");
    }
    
    private void processPasswordReset(HttpServletRequest request, Customer customer) {
        try {
            // Delete old tokens
            customerDAO.deleteExpiredTokens(customer.getId());
            
            // Generate new token
            String token = EmailService.generateResetToken();
            LocalDateTime expiry = LocalDateTime.now().plusHours(24);
            
            // Save token to database
            boolean tokenCreated = customerDAO.createPasswordResetToken(
                customer.getId(), token, expiry);
            
            if (tokenCreated) {
                // Build reset link
                String resetLink = buildResetLink(request, token);
                
                // Send email
                boolean emailSent = EmailService.sendPasswordResetEmail(
                    customer.getEmail(), 
                    customer.getName(), 
                    resetLink
                );
                
                if (emailSent) {
                    System.out.println("Password reset email sent to: " + customer.getEmail());
                } else {
                    System.err.println("Failed to send email to: " + customer.getEmail());
                }
            }
            
        } catch (Exception e) {
            System.err.println("processPasswordReset error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private String buildResetLink(HttpServletRequest request, String token) {
        return request.getScheme() + "://" 
             + request.getServerName() + ":" 
             + request.getServerPort() 
             + request.getContextPath() 
             + "/reset-password?token=" + token;
    }
    
    private void forwardToForgetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/forget-password.jsp");
        dispatcher.forward(request, response);
    }
}
