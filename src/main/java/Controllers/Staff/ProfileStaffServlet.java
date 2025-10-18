package Controllers.Staff;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;

import DAOs.StaffDAO;
import Models.Staff;

@WebServlet(name="ProfileStaffServlet", urlPatterns={"/profilestaff"})
public class ProfileStaffServlet extends HttpServlet {
    private StaffDAO staffDAO;
    private static final boolean DEV_ALLOW_AS_PARAM = true;

    @Override public void init() { staffDAO = new StaffDAO(); }

    /** Ưu tiên lấy từ session; nếu DEV thì cho phép ?asStaffId= và cache lại vào session */
    private Integer resolveStaffId(HttpServletRequest request){
        HttpSession session = request.getSession();
        Integer staffId = (Integer) session.getAttribute("staffId");
        if (staffId == null && DEV_ALLOW_AS_PARAM){
            String asStaffId = request.getParameter("asStaffId");
            if (asStaffId != null && !asStaffId.trim().isEmpty()){
                if (!asStaffId.matches("\\d+")) return null;
                staffId = Integer.parseInt(asStaffId);
                session.setAttribute("staffId", staffId);
            }
        }
        return staffId;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer staffId = resolveStaffId(request);
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/staff-login.jsp");
            return;
        }
        Staff staff = staffDAO.getStaffById(staffId);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }
        request.setAttribute("staff", staff);
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/Staff/ProfileStaff.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());

        Integer staffId = resolveStaffId(request);
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/staff-login.jsp");
            return;
        }

        // Lấy data
        String name = safe(request.getParameter("name"));
        String phone = safe(request.getParameter("phoneNumber"));
        String avatar = safe(request.getParameter("avatar"));
        String gender = safe(request.getParameter("gender"));

        // Validate nhẹ
        if (name.isEmpty()){
            flash(request, "Name is required!", "error");
            forwardForm(request, response, staffId);
            return;
        }
        if (!phone.isEmpty() && !phone.matches("\\+?\\d{8,15}")){
            flash(request, "Phone number is invalid!", "error");
            forwardForm(request, response, staffId);
            return;
        }

        Staff staff = staffDAO.getStaffById(staffId);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        staff.setName(name);
        staff.setPhoneNumber(phone);
        staff.setAvatar(avatar);
        staff.setGender(gender);

        boolean ok = staffDAO.updateStaffProfile(staff);
        flash(request, ok ? "Profile updated successfully!" : "Failed to update profile!", ok ? "success" : "error");
        forwardForm(request, response, staffId);
    }

    private static String safe(String s){ return s == null ? "" : s.trim(); }

    private static void flash(HttpServletRequest req, String msg, String type){
        req.setAttribute("message", msg);
        req.setAttribute("messageType", type);
    }

    private void forwardForm(HttpServletRequest req, HttpServletResponse resp, int staffId)
            throws ServletException, IOException {
        req.setAttribute("staff", staffDAO.getStaffById(staffId));
        req.getRequestDispatcher("/WEB-INF/views/Staff/ProfileStaff.jsp").forward(req, resp);
    }
}
