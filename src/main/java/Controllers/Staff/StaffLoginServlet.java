package Controllers.Staff;

import java.io.IOException;

import DAOs.StaffDAO;
import Models.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffLoginServlet", urlPatterns = {"/staff/login"})
public class StaffLoginServlet extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("staff") != null) {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/staff/login.jsp").forward(request, response);
            return;
        }

        Staff staff = staffDAO.login(email.trim(), password);
        if (staff == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/staff/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("staff", staff);
        session.setAttribute("staffId", staff.getStaffId());
        session.setAttribute("role", staff.isRole() ? "admin" : "staff");
        session.setMaxInactiveInterval(30 * 60);

        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
        }
    }
}


