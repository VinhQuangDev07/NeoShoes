

package Controllers.Staff;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAOs.StaffDAO;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="ChangePasswordServlet", urlPatterns={"/changepassword"})
public class ChangePasswordServlet extends HttpServlet {
   
  private StaffDAO staffDAO;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    } 

   
     
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer staffId = (Integer) session.getAttribute("staffId");
        
        if (staffId == null) {
            response.sendRedirect("staff-login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate passwords
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "New passwords do not match!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // TODO: Add password hashing (use BCrypt or similar)
        // For now, we'll assume the password is already hashed
        String newPasswordHash = newPassword; // In reality, hash this password

        boolean success = staffDAO.changePassword(staffId, newPasswordHash);
        
        if (success) {
            request.setAttribute("message", "Password changed successfully!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Failed to change password!");
            request.setAttribute("messageType", "error");
        }
        
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}
    
