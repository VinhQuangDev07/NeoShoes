package Controllers.Staff;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import DAOs.StaffDAO;
import Models.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ManageStaffServlet", urlPatterns = {"/manage-staff"})
public class ManageStaffServlet extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
        System.out.println("ManageStaffServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewStaffDetail(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            default:
                listStaff(request, response);
                break;
        }
    }

   

    // ===== SHOW EDIT FORM =====
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int staffId = Integer.parseInt(request.getParameter("id"));
            Staff staff = staffDAO.getStaffById(staffId);

            if (staff == null) {
                HttpSession session = request.getSession();
                session.setAttribute("flash_error", "Staff not found!");
                response.sendRedirect(request.getContextPath() + "/manage-staff");
                return;
            }

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/WEB-INF/views/staff/staff-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
        }
    }

    // ===== LIST STAFF =====
    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("roleFilter");

        List<Staff> staffList;
        staffList = staffDAO.getAllStaff();
        System.out.println("Get all staff → " + staffList.size() + " results");

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int recordsPerPage = 10;

        int totalRecords = staffList.size();

        // Calculate start and end positions
        int startIndex = (currentPage - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);

        // 5. Lấy dữ liệu cho trang hiện tại
        List<Staff> pageData;
        if (startIndex < totalRecords) {
            pageData = staffList.subList(startIndex, endIndex);
        } else {
            pageData = new ArrayList<>();
        }

        request.setAttribute("staffList", pageData);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("baseUrl", request.getRequestURI());
        //request.setAttribute("totalStaff", staffDAO.getTotalStaffCount());
        request.setAttribute("keyword", keyword);
        request.setAttribute("roleFilter", roleFilter);

        request.getRequestDispatcher("/WEB-INF/views/staff/view-staff-list.jsp").forward(request, response);
    }

    // ===== VIEW STAFF DETAIL =====
    private void viewStaffDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int staffId = Integer.parseInt(request.getParameter("id"));
            Staff staff = staffDAO.getStaffById(staffId);

            if (staff == null) {
                HttpSession session = request.getSession();
                session.setAttribute("flash_error", "Staff not found!");
                response.sendRedirect(request.getContextPath() + "/manage-staff");
                return;
            }

            System.out.println("View staff: " + staff.getName() + " (ID: " + staffId + ")");

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/WEB-INF/views/staff/view-staff-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
            return;
        }

        switch (action) {
            case "create":
                createStaff(request, response, session);
                break;
            case "update":
                updateStaff(request, response, session);
                break;
            case "delete":
                deleteStaff(request, response, session);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/manage-staff");
                break;
        }
    }

    // ===== CREATE STAFF =====
    private void createStaff(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            // Get form data
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String name = request.getParameter("name");

            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String avatar = request.getParameter("avatar");
            String dobStr = request.getParameter("dateOfBirth");

            // Validate required fields
            if (email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || name == null || name.trim().isEmpty()) {
                session.setAttribute("flash_error", "Email, password and name are required!");
                response.sendRedirect(request.getContextPath() + "/manage-staff?action=add");
                return;
            }

            // Check if email exists
            if (staffDAO.isEmailExists(email)) {
                session.setAttribute("flash_error", "Email already exists!");
                response.sendRedirect(request.getContextPath() + "/manage-staff?action=add");
                return;
            }

            // Create staff object
            Staff staff = new Staff();
            staff.setEmail(email.trim());
            staff.setPasswordHash(password); // In production, hash this!
            staff.setName(name.trim());
            staff.setPhoneNumber(phone);
            staff.setRole("admin".equals(roleStr));
            staff.setGender(gender);
            staff.setAddress(address);
            staff.setAvatar(avatar);

            // Parse date of birth
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    staff.setDateOfBirth(java.time.LocalDate.parse(dobStr));
                } catch (Exception e) {
                    System.err.println("Invalid date format: " + dobStr);
                }
            }

            // Create staff
            if (staffDAO.createStaff(staff)) {
                session.setAttribute("flash_success", "Staff created successfully!");
                System.out.println("✅ Created staff: " + name);
            } else {
                session.setAttribute("flash_error", "Failed to create staff!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-staff");
    }

    // ===== UPDATE STAFF =====
    private void updateStaff(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roleStr = request.getParameter("role");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dateOfBirth");
            String avatar = request.getParameter("avatar");

            // Get existing staff
            Staff staff = staffDAO.getStaffById(staffId);
            if (staff == null) {
                session.setAttribute("flash_error", "Staff not found!");
                response.sendRedirect(request.getContextPath() + "/manage-staff");
                return;
            }

            // Validate & update email
            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("flash_error", "Email is required!");
                response.sendRedirect(request.getContextPath() + "/manage-staff?action=edit&id=" + staffId);
                return;
            }
            email = email.trim();
            String emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
            if (!email.matches(emailRegex)) {
                session.setAttribute("flash_error", "Invalid email format!");
                response.sendRedirect(request.getContextPath() + "/manage-staff?action=edit&id=" + staffId);
                return;
            }

            // Check uniqueness only if email changed
            if (!email.equalsIgnoreCase(staff.getEmail()) && staffDAO.isEmailExists(email)) {
                session.setAttribute("flash_error", "Email already exists!");
                response.sendRedirect(request.getContextPath() + "/manage-staff?action=edit&id=" + staffId);
                return;
            }

            // Update fields
            staff.setEmail(email);
            staff.setName(name != null ? name.trim() : staff.getName());
            staff.setPhoneNumber(phone);
            staff.setRole("admin".equals(roleStr));
            staff.setGender(gender);
            staff.setAddress(address);
            staff.setAvatar(avatar);

            // Parse date of birth
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    staff.setDateOfBirth(java.time.LocalDate.parse(dobStr));
                } catch (Exception e) {
                    System.err.println("Invalid date format: " + dobStr);
                }
            }

            // Update staff
            if (staffDAO.updateStaff(staff)) {
                session.setAttribute("flash_success", "Staff updated successfully!");
                System.out.println("✅ Updated staff: " + name);
            } else {
                session.setAttribute("flash_error", "Failed to update staff!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-staff");
    }

    // ===== DELETE STAFF =====
    private void deleteStaff(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            int staffId = Integer.parseInt(request.getParameter("id"));

            // Check if staff exists
            Staff staff = staffDAO.getStaffById(staffId);
            if (staff == null) {
                session.setAttribute("flash_error", "Staff not found!");
                response.sendRedirect(request.getContextPath() + "/manage-staff");
                return;
            }

            // Delete staff
            if (staffDAO.deleteStaff(staffId)) {
                session.setAttribute("flash_success", "Staff deleted successfully!");
                System.out.println("✅ Deleted staff: " + staff.getName());
            } else {
                session.setAttribute("flash_error", "Failed to delete staff!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-staff");
    }

    // ===== SHOW ADD FORM =====
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/staff/staff-form.jsp").forward(request, response);
    }
}
