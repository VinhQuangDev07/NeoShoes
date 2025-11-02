package Controllers.Customer;

import java.io.IOException;

import DAOs.CustomerDAO;
import Models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import Utils.Utils;
import Utils.EmailService;

/**
 * Customer Registration Servlet Handles customer account creation
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    /**
     * Show registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/customer/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // ========================================
            // STEP 1: GET FORM DATA
            // ========================================
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");

            // ========================================
            // STEP 2: VALIDATE
            // ========================================
            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("flash_error", "Email is required!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (password == null || password.trim().isEmpty()) {
                session.setAttribute("flash_error", "Password is required!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("flash_error", "Name is required!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (!password.equals(confirmPassword)) {
                session.setAttribute("flash_error", "Passwords do not match!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (password.length() < 6) {
                session.setAttribute("flash_error", "Password must be at least 6 characters!");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            if (customerDAO.isEmailExists(email.trim())) {
                session.setAttribute("flash_error", "Email already exists! Please use another email.");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            // ========================================
            // STEP 3: CREATE CUSTOMER (IsVerified = 0)
            // ========================================
            Customer customer = new Customer();
            customer.setEmail(email.trim());
            customer.setPasswordHash(password); // TODO: Hash password with BCrypt later
            customer.setName(name.trim());
            customer.setPhoneNumber(phone != null ? phone.trim() : null);
            customer.setGender(gender);
            customer.setAvatar("https://ui-avatars.com/api/?name="
                    + name.trim().replace(" ", "+")
                    + "&background=667eea&color=fff&size=200");

            boolean created = customerDAO.createCustomer(customer);

            if (!created) {
                session.setAttribute("flash_error", "Registration failed! Please try again.");
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            } else {
                System.out.println("✅ Created customer: " + email);

                // ========================================
                // STEP 4: GET CUSTOMER ID
                // ========================================
                int customerId = customerDAO.getCustomerIdByEmail(email.trim());

                if (customerId == 0) {
                    session.setAttribute("flash_error", "Error getting customer ID!");
                    response.sendRedirect(request.getContextPath() + "/register");
                    return;
                }

                //System.out.println("✅ Customer ID: " + customerId);
                // ========================================
                // STEP 5: GENERATE & SAVE VERIFICATION CODE
                // ========================================
                String verificationCode = Utils.EmailService.generateVerificationCode();
                java.time.LocalDateTime expiry = java.time.LocalDateTime.now().plusMinutes(10);

                boolean codeCreated = customerDAO.createVerificationCode(customerId, verificationCode, expiry);

                if (!codeCreated) {
                    session.setAttribute("flash_error", "Error creating verification code!");
                    response.sendRedirect(request.getContextPath() + "/register");
                    return;
                }

                System.out.println("✅ Verification code created: " + verificationCode);

                // ========================================
                // STEP 6: SEND EMAIL
                // ========================================
                boolean emailSent = Utils.EmailService.sendVerificationCode(
                        email.trim(),
                        name.trim(),
                        verificationCode
                );

                if (emailSent) {
                    session.setAttribute("pendingEmail", email.trim());
                    session.setAttribute("flash", "Registration successful! Please check your email for verification code.");
                    response.sendRedirect(request.getContextPath() + "/verify-email");
                } else {
                    session.setAttribute("flash_error", "Account created but failed to send verification email. Please contact support.");
                    response.sendRedirect(request.getContextPath() + "/register");
                }
            }

        } catch (Exception e) {
            System.err.println(" Registration error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("flash_error", "System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/register");
        }
    }
}
