package Controllers.Staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;

import DAOs.StaffDAO;
import Models.Staff;

@WebServlet(name="ProfileStaffServlet", urlPatterns={"/profilestaff"})
public class ProfileStaffServlet extends HttpServlet {
    private StaffDAO staffDAO;

    // CHỈ DEV: cho phép lấy staffId qua query param ?asStaffId=
    // Nhớ đặt = false hoặc bỏ hẳn khi deploy!
    private static final boolean DEV_ALLOW_AS_PARAM = true;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }

    /** Trả về staffId:
     *  1) từ session nếu có
     *  2) nếu không có và DEV_ALLOW_AS_PARAM = true -> thử lấy từ ?asStaffId=
     *     và lưu vào session để lần sau không cần truyền lại
     */
   private Integer resolveStaffId(HttpServletRequest request) {
    HttpSession session = request.getSession();
    Integer staffId = (Integer) session.getAttribute("staffId");

    if (staffId == null && DEV_ALLOW_AS_PARAM) {
        String asStaffId = request.getParameter("asStaffId");
        if (asStaffId != null && !asStaffId.trim().isEmpty()) { // <= thay isBlank()
            try {
                // (khuyến nghị) kiểm tra là số
                if (!asStaffId.matches("\\d+")) return null;

                staffId = Integer.parseInt(asStaffId);
                session.setAttribute("staffId", staffId); // lưu cho các request sau
            } catch (NumberFormatException ignore) {
                staffId = null;
            }
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
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/ProfileStaff.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer staffId = resolveStaffId(request);

        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/staff-login.jsp");
            return;
        }

        // Lấy data từ form
        String name = request.getParameter("name");
        String phoneNumber = request.getParameter("phoneNumber");
        String avatar = request.getParameter("avatar");
        String gender = request.getParameter("gender");

        Staff staff = staffDAO.getStaffById(staffId);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        // Cập nhật model
        staff.setName(name);
        staff.setPhoneNumber(phoneNumber);
        staff.setAvatar(avatar);
        staff.setGender(gender);

        boolean ok = staffDAO.updateStaffProfile(staff);
        request.setAttribute("message", ok ? "Profile updated successfully!" : "Failed to update profile!");
        request.setAttribute("messageType", ok ? "success" : "error");
        request.setAttribute("staff", staff);

       RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/ProfileStaff.jsp");
        dispatcher.forward(request, response);
    }
}
