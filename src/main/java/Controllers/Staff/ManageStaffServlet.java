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

        // ✅ ĐƠN GIẢN: Không cần login, chỉ routing
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            viewStaffDetail(request, response);
        } else {
            listStaff(request, response);
        }
    }

    // ===== LIST STAFF =====
    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("roleFilter");

        List<Staff> staffList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            staffList = staffDAO.searchStaff(keyword.trim());
            System.out.println("Search: " + keyword + " → " + staffList.size() + " results");
        } else if (roleFilter != null && !roleFilter.isEmpty()) {
            boolean isAdmin = "admin".equalsIgnoreCase(roleFilter);
            staffList = staffDAO.getStaffByRole(isAdmin);
            System.out.println("Filter: " + roleFilter + " → " + staffList.size() + " results");
        } else {
            staffList = staffDAO.getAllStaff();
            System.out.println("Get all staff → " + staffList.size() + " results");
        }

        
        
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

            System.out.println("👁️ View staff: " + staff.getName() + " (ID: " + staffId + ")");

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/WEB-INF/views/staff/view-staff-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manage-staff");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Add/Edit/Delete staff
        response.sendRedirect(request.getContextPath() + "/manage-staff");
    }
}