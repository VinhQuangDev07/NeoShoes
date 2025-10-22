package Controllers.Staff;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.MultipartConfig;
import DAOs.StaffDAO;
import Models.Staff;

@MultipartConfig
@WebServlet(name = "ProfileStaffServlet", urlPatterns = {"/profilestaff"})
public class ProfileStaffServlet extends HttpServlet {

    private StaffDAO staffDAO;
    private static final boolean DEV_ALLOW_AS_PARAM = true;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }

    /**
     * Ưu tiên lấy từ session; nếu DEV thì cho phép ?asStaffId= và cache lại vào
     * session
     */
    private Integer resolveStaffId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer staffId = (Integer) session.getAttribute("staffId");
        if (staffId == null && DEV_ALLOW_AS_PARAM) {
            String asStaffId = request.getParameter("asStaffId");
            if (asStaffId != null && !asStaffId.trim().isEmpty()) {
                if (!asStaffId.matches("\\d+")) {
                    return null;
                }
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
        HttpSession session = request.getSession();
        Integer staffId = resolveStaffId(request);
        if (staffId == null) {
            session.setAttribute("flash_error", "Phiên đăng nhập hết hạn!");
            response.sendRedirect(request.getContextPath() + "/staff-login.jsp");
            return;
        }

        String action = safe(request.getParameter("action"));

        // Lấy bản ghi hiện tại để fallback khi param thiếu (do input bị disabled)
        Staff current = staffDAO.getStaffById(staffId);
        if (current == null) {
            flash(request, "Staff not found.", "error");
            forwardForm(request, response, staffId);
            return;
        }

        if ("updateProfile".equals(action)) {
            // Lấy param (có thể null nếu input disabled)
            String phoneParam = request.getParameter("phoneNumber");
            String avatarParam = request.getParameter("avatar");
            String genderParam = request.getParameter("gender");
            String addressParam = request.getParameter("address");
            String dobStr = request.getParameter("dateOfBirth");

            // Fallback sang giá trị hiện tại nếu param trống/không gửi
            String phone = (phoneParam == null || phoneParam.trim().isEmpty()) ? current.getPhoneNumber() : phoneParam.trim();
            String avatar = (avatarParam == null || avatarParam.trim().isEmpty()) ? current.getAvatar() : avatarParam.trim();
            String gender = (genderParam == null || genderParam.trim().isEmpty()) ? current.getGender() : genderParam.trim();
            String address = (addressParam == null || addressParam.trim().isEmpty()) ? current.getAddress() : addressParam.trim();

            // Parse DOB nếu có; nếu không, giữ cũ
            java.time.LocalDate dob = current.getDateOfBirth();
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    dob = java.time.LocalDate.parse(dobStr.trim()); // "yyyy-MM-dd"
                } catch (Exception e) {
                    flash(request, "Date of birth is invalid.", "error");
                    forwardForm(request, response, staffId);
                    return;
                }
            }

            // HTML5 pattern có thể chặn submit -> validate lại server-side cho chắc
            if (phone != null && !phone.isEmpty() && !phone.matches("^\\+?\\d[\\d\\s-]{7,19}$")) {
                flash(request, "Phone number is invalid!", "error");
                forwardForm(request, response, staffId);
                return;
            }

            boolean ok = staffDAO.updateProfile(staffId, phone, avatar, gender, address, dob);
            flash(request, ok ? "Profile updated successfully!" : "Failed to update profile!", ok ? "success" : "error");
            forwardForm(request, response, staffId);
            return;
        }

        if ("changePassword".equals(action)) {
            String currentPw = safe(request.getParameter("currentPassword"));
            String newPw = safe(request.getParameter("newPassword"));
            String confirm = safe(request.getParameter("confirmPassword"));

            // Luôn mở lại form Change Password khi xử lý xong (dù OK hay lỗi)
            request.setAttribute("forceOpenChangePassword", true);

            // 1) Validate strength: 8+ ký tự, 1 hoa, 1 thường, 1 số
            boolean strong = newPw.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");
            if (!strong) {
                flash(request, "Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.", "error");
                forwardForm(request, response, staffId);
                return;
            }

            // 2) Mismatch
            if (!newPw.equals(confirm)) {
                flash(request, "Passwords do not match.", "error");
                forwardForm(request, response, staffId);
                return;
            }

            // 3) Check current + update
            boolean ok = staffDAO.changePassword(staffId, currentPw, newPw);
            // CHÚ Ý: text bên dưới PHẢI đúng y chang để JSP hiển thị lỗi ở ô Current
            if (!ok) {
                flash(request, "Current password is incorrect.", "error");
            } else {
                flash(request, "Password changed successfully!", "success");
            }
            forwardForm(request, response, staffId);
            return;
        }

        flash(request, "Unsupported action.", "error");
        forwardForm(request, response, staffId);
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static void flash(HttpServletRequest req, String msg, String type) {
        HttpSession session = req.getSession();
        if ("success".equals(type)) {
            session.setAttribute("flash", msg);
        } else if ("error".equals(type)) {
            session.setAttribute("flash_error", msg);
        } else {
            session.setAttribute("flash_info", msg);
        }
    }

    private void forwardForm(HttpServletRequest req, HttpServletResponse resp, int staffId)
            throws ServletException, IOException {
        req.setAttribute("staff", staffDAO.getStaffById(staffId));
        req.getRequestDispatcher("/WEB-INF/views/Staff/ProfileStaff.jsp").forward(req, resp);
    }
}
