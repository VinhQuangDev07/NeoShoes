package Controllers.Staff;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import DAOs.VoucherDAO;
import Models.Staff;
import Models.Voucher;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/staff/manage-voucher", "/staff/manage-voucher/*"})
public class VoucherManagementServlet extends HttpServlet {

    private VoucherDAO voucherDAO;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        String action = getAction(request);

        try {
            switch (action) {
                case "list":
                    listVouchers(request, response);
                    break;
                case "detail":
                    viewVoucherDetail(request, response);
                    break;
                case "add":
                    // Chỉ admin mới được add
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    showAddForm(request, response);
                    break;
                case "edit":
                    // Chỉ admin mới được edit
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    showEditForm(request, response);
                    break;
                case "delete":
                    // Chỉ admin mới được delete
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    deleteVoucher(request, response);
                    break;
                case "toggle":
                    // Chỉ admin mới được toggle
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    toggleVoucherStatus(request, response);
                    break;
                default:
                    listVouchers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        String action = getAction(request);

        try {
            switch (action) {
                case "add":
                    // Chỉ admin mới được add
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    addVoucher(request, response);
                    break;
                case "update":
                    // Chỉ admin mới được update
                    if (!staff.isRole()) {
                        session.setAttribute("flash_error", "Access denied! Admin only.");
                        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
                        return;
                    }
                    updateVoucher(request, response);
                    break;
                default:
                    listVouchers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    // ========== MAIN HANDLERS ==========
    private void listVouchers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        
        List<Voucher> vouchers = voucherDAO.getAllVouchersWithUsageCount();
        request.setAttribute("vouchers", vouchers);
        // Chỉ admin mới có quyền modify (thêm/sửa/xóa)
        request.setAttribute("canModify", staff.isRole());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/voucher-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("formAction", "add");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/voucher-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher voucher = voucherDAO.getVoucherById(id);

        if (voucher != null) {
            request.setAttribute("voucher", voucher);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/voucher-form.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("flash_error", "Voucher not found!");
            response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
        }
    }

    private void addVoucher(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        try {
            Voucher voucher = extractVoucherFromRequest(request);
            boolean success = voucherDAO.addVoucher(voucher);

            if (success) {
                session.setAttribute("flash", "Voucher added successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
            } else {
                session.setAttribute("flash_error", "Failed to add voucher!");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
        }
    }

    private void updateVoucher(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher voucher = extractVoucherFromRequest(request);
            voucher.setVoucherId(id);

            boolean success = voucherDAO.updateVoucher(voucher);

            if (success) {
                session.setAttribute("flash", "Voucher updated successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
            } else {
                session.setAttribute("flash_error", "Failed to update voucher!");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
        }
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = voucherDAO.deleteVoucher(id);

            if (success) {
                session.setAttribute("flash", "Voucher deleted successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to delete voucher!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
    }

    private void toggleVoucherStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = voucherDAO.toggleVoucherStatus(id);

            if (success) {
                session.setAttribute("flash", "Voucher status updated successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to update voucher status!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
    }

    private void viewVoucherDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher voucher = voucherDAO.getVoucherById(id);

        if (voucher != null) {
            request.setAttribute("voucher", voucher);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/voucher-detail.jsp");
            dispatcher.forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("flash_error", "Voucher not found!");
            response.sendRedirect(request.getContextPath() + "/staff/manage-voucher");
        }
    }

    // ========== HELPER METHODS ==========
    private Voucher extractVoucherFromRequest(HttpServletRequest request) {
        Voucher voucher = new Voucher();

        // VoucherCode
        voucher.setVoucherCode(request.getParameter("voucherCode"));

        // Type (PERCENTAGE hoặc FIXED)
        voucher.setType(request.getParameter("type"));

        // Value
        String valueStr = request.getParameter("value");
        if (valueStr != null && !valueStr.trim().isEmpty()) {
            voucher.setValue(new BigDecimal(valueStr));
        }

        // MaxValue
        String maxValueStr = request.getParameter("maxValue");
        if (maxValueStr != null && !maxValueStr.trim().isEmpty()) {
            voucher.setMaxValue(new BigDecimal(maxValueStr));
        }

        // MinValue
        String minValueStr = request.getParameter("minValue");
        if (minValueStr != null && !minValueStr.trim().isEmpty()) {
            voucher.setMinValue(new BigDecimal(minValueStr));
        }

        // VoucherDescription
        voucher.setVoucherDescription(request.getParameter("voucherDescription"));

        // StartDate
        String startDateStr = request.getParameter("startDate");
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            voucher.setStartDate(LocalDateTime.parse(startDateStr + "T00:00:00"));
        }

        // EndDate
        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            voucher.setEndDate(LocalDateTime.parse(endDateStr + "T23:59:59"));
        }

        // TotalUsageLimit
        String totalUsageLimitStr = request.getParameter("totalUsageLimit");
        if (totalUsageLimitStr != null && !totalUsageLimitStr.trim().isEmpty()) {
            voucher.setTotalUsageLimit(Integer.parseInt(totalUsageLimitStr));
        }

        // UserUsageLimit
        String userUsageLimitStr = request.getParameter("userUsageLimit");
        if (userUsageLimitStr != null && !userUsageLimitStr.trim().isEmpty()) {
            voucher.setUserUsageLimit(Integer.parseInt(userUsageLimitStr));
        }

        // IsActive
        String activeStr = request.getParameter("isActive");
        voucher.setActive(activeStr != null && (activeStr.equals("1") || activeStr.equalsIgnoreCase("true")));

        return voucher;
    }

    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && !"/".equals(pathInfo)) {
            String p = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
            return p.isEmpty() ? "list" : p;
        }
        String action = request.getParameter("action");
        return (action == null || action.trim().isEmpty()) ? "list" : action.trim();
    }
}