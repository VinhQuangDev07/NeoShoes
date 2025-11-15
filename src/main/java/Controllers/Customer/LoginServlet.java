package Controllers.Customer;

import DAOs.CartDAO;
import java.io.IOException;

import DAOs.CustomerDAO;
import Models.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("customer") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Check for remembered email from cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedEmail".equals(cookie.getName())) {
                    request.setAttribute("rememberedEmail", cookie.getValue());
                    break;
                }
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // 1. Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // 2. Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            return;
        }

        // 3. Authenticate with database
        try {
            Customer customer = customerDAO.login(email.trim(), password);

            if (customer != null) {
                // ✅ LOGIN SUCCESSFUL
                
                // 3a. Update last login time
                customerDAO.updateLastLogin(customer.getId());
                
                // 3b. Create session
                HttpSession session = request.getSession();
                session.setAttribute("customer", customer);
                session.setAttribute("role", "customer");
                
                CartDAO cartDAO = new CartDAO();
                int itemCount = cartDAO.countItems(customer.getId());
                session.setAttribute("cartQuantity", itemCount);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // 3c. Handle "Remember me"
                if ("on".equals(remember)) {
                    Cookie emailCookie = new Cookie("rememberedEmail", email.trim());
                    emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                } else {
                    // Remove remember cookie if unchecked
                    Cookie emailCookie = new Cookie("rememberedEmail", "");
                    emailCookie.setMaxAge(0);
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                }
                
                // 3d. Redirect to intended page or home
                String redirectUrl = (String) session.getAttribute("redirectUrl");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    session.removeAttribute("redirectUrl");
                    response.sendRedirect(redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                
            } else {
                // ❌ LOGIN FAILED
                request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            // Handle unexpected errors
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi! Vui lòng thử lại sau.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        }
    }
}
