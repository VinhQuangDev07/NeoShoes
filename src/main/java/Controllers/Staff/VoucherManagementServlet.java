package Controllers.Staff;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import DAOs.VoucherDAO;
import Models.Voucher;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/vouchermanage", "/vouchermanage/*"})
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
        
        String role = getRoleFromRequest(request);
        request.setAttribute("userRole", role);
        
        String action = getAction(request);
        
        try {
            switch (action) {
                case "list":
                    listVouchers(request, response);
                    break;
                case "add":
                    if (canModify(role)) {
                        showAddForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "edit":
                    if (canModify(role)) {
                        showEditForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "delete":
                    if (canModify(role)) {
                        deleteVoucher(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "toggle":
                    if (canModify(role)) {
                        toggleVoucherStatus(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
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
        
        String role = getRoleFromRequest(request);
        request.setAttribute("userRole", role);
        
        String action = getAction(request);
        
        try {
            switch (action) {
                case "add":
                    if (canModify(role)) {
                        addVoucher(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "update":
                    if (canModify(role)) {
                        updateVoucher(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
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
        List<Voucher> vouchers = voucherDAO.getAllVouchersWithUsageCount();
        request.setAttribute("vouchers", vouchers);
        
        String role = (String) request.getAttribute("userRole");
        boolean canModify = canModify(role);
        request.setAttribute("canModify", canModify);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/voucher-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        request.setAttribute("formAction", "add");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/voucher-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher voucher = voucherDAO.getVoucherById(id);
        
        if (voucher != null) {
            request.setAttribute("voucher", voucher);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/voucher-form.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(404, "Voucher not found");
        }
    }

    private void addVoucher(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        try {
            Voucher voucher = extractVoucherFromRequest(request);
            
            // Validate voucher code
            if (voucher.getVoucherCode() == null || voucher.getVoucherCode().trim().isEmpty()) {
                request.setAttribute("error", "Voucher code is required");
                showAddForm(request, response);
                return;
            }
            
            // Check if code already exists
            Voucher existingVoucher = voucherDAO.getVoucherByCode(voucher.getVoucherCode());
            if (existingVoucher != null) {
                request.setAttribute("error", "Voucher code already exists");
                request.setAttribute("voucher", voucher);
                showAddForm(request, response);
                return;
            }
            
            boolean success = voucherDAO.addVoucher(voucher);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&success=added");
            } else {
                request.setAttribute("error", "Failed to add voucher");
                request.setAttribute("voucher", voucher);
                showAddForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showAddForm(request, response);
        }
    }

    private void updateVoucher(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Voucher voucher = extractVoucherFromRequest(request);
            voucher.setVoucherId(id);
            
            boolean success = voucherDAO.updateVoucher(voucher);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&success=updated");
            } else {
                request.setAttribute("error", "Failed to update voucher");
                request.setAttribute("voucher", voucher);
                showEditForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = voucherDAO.deleteVoucher(id);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&error=delete_failed");
        }
    }

    private void toggleVoucherStatus(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = voucherDAO.toggleVoucherStatus(id);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&success=toggled");
        } else {
            response.sendRedirect(request.getContextPath() + "/vouchermanage/list?role=" + role + "&error=toggle_failed");
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
            LocalDateTime startDate = LocalDateTime.parse(startDateStr + "T00:00:00");
            voucher.setStartDate(startDate);
        }
        
        // EndDate
        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            LocalDateTime endDate = LocalDateTime.parse(endDateStr + "T23:59:59");
            voucher.setEndDate(endDate);
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
    
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher voucher = new Voucher();
        voucher.setVoucherId(rs.getInt("VoucherId"));
        voucher.setVoucherCode(rs.getString("VoucherCode"));
        voucher.setType(rs.getString("Type"));
        voucher.setValue(rs.getBigDecimal("Value"));
        voucher.setMaxValue(rs.getBigDecimal("MaxValue"));
        voucher.setMinValue(rs.getBigDecimal("MinValue"));
        voucher.setVoucherDescription(rs.getString("VoucherDescription"));
        
        Timestamp startTimestamp = rs.getTimestamp("StartDate");
        if (startTimestamp != null) {
            voucher.setStartDate(startTimestamp.toLocalDateTime());
        }
        
        Timestamp endTimestamp = rs.getTimestamp("EndDate");
        if (endTimestamp != null) {
            voucher.setEndDate(endTimestamp.toLocalDateTime());
        }
        
        voucher.setTotalUsageLimit(rs.getInt("TotalUsageLimit"));
        voucher.setUserUsageLimit(rs.getInt("UserUsageLimit"));
        voucher.setActive(rs.getBoolean("IsActive"));
        
        Timestamp createdTimestamp = rs.getTimestamp("CreatedAt");
        if (createdTimestamp != null) {
            voucher.setCreatedAt(createdTimestamp.toLocalDateTime());
        }
        
        Timestamp updatedTimestamp = rs.getTimestamp("UpdatedAt");
        if (updatedTimestamp != null) {
            voucher.setUpdatedAt(updatedTimestamp.toLocalDateTime());
        }
        
        voucher.setDeleted(rs.getBoolean("IsDeleted"));
        
        // ✅ KHÔNG lấy UsageCount từ bảng Voucher
        // Sẽ tính từ bảng VoucherUserUsage
        
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

    private boolean canModify(String role) {
        return "admin".equals(role);
    }
    
    private boolean canView(String role) {
        return "admin".equals(role) || "staff".equals(role);
    }

    private String getRoleFromRequest(HttpServletRequest request) {
        String role = request.getParameter("role");
        
        if (role == null || role.trim().isEmpty()) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                role = (String) session.getAttribute("role");
            }
        }
        
        if (role == null || role.trim().isEmpty()) {
            role = "staff";
        }
        
        return role;
    }
    
  
}
