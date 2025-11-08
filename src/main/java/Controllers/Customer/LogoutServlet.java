package Controllers.Customer;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Invalidate session
        HttpSession session = request.getSession(false);
        
        // 2. Optional: Remove remember cookie (uncomment if needed)
        // Cookie emailCookie = new Cookie("rememberedEmail", "");
        // emailCookie.setMaxAge(0);
        // emailCookie.setPath(request.getContextPath());
        // response.addCookie(emailCookie);
        
        // 3. Redirect to login page with success message
        String redirectUrl;

        if (session != null) {
            // Lưu tạm role trước khi xoá session
            String role = (String) session.getAttribute("role");
            session.invalidate();

            // Kiểm tra role để điều hướng
            if ("staff".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(role)) {
                redirectUrl = request.getContextPath() + "/staff/login";
            } else {
                redirectUrl = request.getContextPath() + "/home";
            }

        } else {
            // Không có session thì mặc định về home
            redirectUrl = request.getContextPath() + "/home";
        }

        response.sendRedirect(redirectUrl);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}