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
    
    private final CustomerDAO customerDAO = new CustomerDAO();
    private static final int MIN_PASSWORD_LENGTH = 6;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (!isValidToken(token)) {
            request.setAttribute("error", "Invalid or missing reset token");
            forwardToResetPassword(request, response);
            return;
        }
        
        if (!customerDAO.isValidResetToken(token)) {
            request.setAttribute("error", "This password reset link has expired or is invalid");
            request.setAttribute("tokenExpired", true);
        }
        
        request.setAttribute("token", token);
        forwardToResetPassword(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (!validatePasswordInput(request, token, password, confirmPassword)) {
            forwardToResetPassword(request, response);
            return;
        }
        
        // Validate token and get customer
        Customer customer = customerDAO.findByResetToken(token);
        
        if (!isValidCustomerAndToken(request, customer, token)) {
            forwardToResetPassword(request, response);
            return;
        }
        
        // Update password
        String hashedPassword = Utils.hashPassword(password);
        boolean updated = customerDAO.updatePasswordById(customer.getId(), hashedPassword);
        
        if (updated) {
            // Mark token as used
            customerDAO.markTokenAsUsed(token);
            
            request.setAttribute("success", "Password reset successfully! You can now login with your new password.");
            forwardToLogin(request, response);
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.setAttribute("token", token);
            forwardToResetPassword(request, response);
        }
    }
    
    private boolean isValidToken(String token) {
        return token != null && !token.trim().isEmpty();
    }
    
    private boolean validatePasswordInput(HttpServletRequest request, String token, 
                                          String password, String confirmPassword) {
        request.setAttribute("token", token);
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            return false;
        }
        
        if (password.length() < MIN_PASSWORD_LENGTH) {
            request.setAttribute("error", "Password must be at least " + MIN_PASSWORD_LENGTH + " characters");
            return false;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            return false;
        }
        
        return true;
    }
    
    private boolean isValidCustomerAndToken(HttpServletRequest request, Customer customer, String token) {
        if (customer == null || !customerDAO.isValidResetToken(token)) {
            request.setAttribute("error", "This password reset link has expired or is invalid");
            request.setAttribute("token", token);
            request.setAttribute("tokenExpired", true);
            return false;
        }
        return true;
    }
    
    private void forwardToResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/reset-password.jsp");
        dispatcher.forward(request, response);
    }
    
    private void forwardToLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp");
        dispatcher.forward(request, response);
    }
}