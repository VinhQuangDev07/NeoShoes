package Controllers.Staff;

import DAOs.BrandDAO;
import Models.Brand;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/managebrands", "/managebrands/*"})
public class BrandServlet extends HttpServlet {
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        brandDAO = new BrandDAO();
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
                    listBrands(request, response);
                    break;
                case "add":
                    if (canModify(role)) { // CHỈ admin mới được thêm
                        showAddForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "edit":
                    if (canModify(role)) { // CHỈ admin mới được sửa
                        showEditForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "delete":
                    if (canModify(role)) { // CHỈ admin mới được xóa
                        deleteBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listBrands(request, response); // Mặc định vẫn cho xem danh sách
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
                    if (canModify(role)) { // CHỈ admin mới được thêm
                        addBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "update":
                    if (canModify(role)) { // CHỈ admin mới được sửa
                        updateBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listBrands(request, response); // Mặc định vẫn cho xem danh sách
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    // === CÁC PHƯƠNG THỨC XỬ LÝ CHÍNH ===
    
    private void listBrands(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        
        String role = (String) request.getAttribute("userRole");
        boolean canModify = canModify(role); // CHỈ admin mới được sửa đổi
        request.setAttribute("canModify", canModify);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Brand-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra lại quyền trước khi hiển thị form
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
        request.setAttribute("formAction", "add");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Kiểm tra lại quyền trước khi hiển thị form
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDAO.getBrandById(id);
        
        if (brand != null) {
            request.setAttribute("brand", brand);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(404, "Brand not found");
        }
    }

    private void addBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        // Kiểm tra lại quyền trước khi thêm
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        String name = request.getParameter("name");
        String logo = request.getParameter("logo");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Brand name is required");
            showAddForm(request, response);
            return;
        }
        
        Brand brand = new Brand();
        brand.setName(name.trim());
        brand.setLogo(logo);
        
        boolean success = brandDAO.addBrand(brand);
        
        if (success) {
            String currentRole = (String) request.getAttribute("userRole");
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&success=added");
        } else {
            request.setAttribute("error", "Failed to add brand");
            showAddForm(request, response);
        }
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        // Kiểm tra lại quyền trước khi cập nhật
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String logo = request.getParameter("logo");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Brand name is required");
            Brand brand = new Brand();
            brand.setBrandId(id);
            brand.setName(name);
            brand.setLogo(logo);
            request.setAttribute("brand", brand);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        Brand brand = new Brand();
        brand.setBrandId(id);
        brand.setName(name.trim());
        brand.setLogo(logo);
        
        boolean success = brandDAO.updateBrand(brand);
        
        if (success) {
            String currentRole = (String) request.getAttribute("userRole");
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&success=updated");
        } else {
            request.setAttribute("error", "Failed to update brand");
            showEditForm(request, response);
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        // Kiểm tra lại quyền trước khi xóa
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = brandDAO.deleteBrand(id);
        
        String currentRole = (String) request.getAttribute("userRole");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&error=delete_failed");
        }
    }

    // === CÁC PHƯƠNG THỨC HỖ TRỢ ===
    
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && !"/".equals(pathInfo)) {
            String p = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
            return p.isEmpty() ? "list" : p;
        }
        String action = request.getParameter("action");
        return (action == null || action.trim().isEmpty()) ? "list" : action.trim();
    }

    // QUAN TRỌNG: Phân quyền đúng
    private boolean canModify(String role) {
        return "admin".equals(role); // CHỈ admin mới được thêm/sửa/xóa
    }
    
    private boolean canView(String role) {
        return "admin".equals(role) || "staff".equals(role); // Cả admin và staff đều được xem
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
            role = "staff"; // Mặc định là staff
        }
        
        return role;
    }
}