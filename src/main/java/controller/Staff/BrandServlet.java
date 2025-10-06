package controller.Staff;

import DAO.BrandDAO;
import Models.Brand;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/managebrands", "/managebrands/*"})
public class BrandServlet extends HttpServlet {
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        brandDAO = new BrandDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Nhận role từ parameter, mặc định là "admin"
        String role = request.getParameter("role");
        if (role == null) {
            role = "admin"; // default role
        }
        request.setAttribute("userRole", role);
        
        String action = getAction(request);
        
        try {
            switch (action) {
                case "list":
                    listBrands(request, response);
                    break;
                case "add":
                    if (canEdit(role)) {
                        showAddForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "edit":
                    if (canEdit(role)) {
                        showEditForm(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "delete":
                    if (canEdit(role)) {
                        deleteBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listBrands(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Nhận role từ parameter, mặc định là "admin"
        String role = request.getParameter("role");
        if (role == null) {
            role = "admin"; // default role
        }
        request.setAttribute("userRole", role);
        
        String action = getAction(request);
        
        try {
            switch (action) {
                case "add":
                    if (canEdit(role)) {
                        addBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "update":
                    if (canEdit(role)) {
                        updateBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listBrands(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    // === CÁC PHƯƠNG THỨC XỬ LÝ CHÍNH ===
    
    private void listBrands(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        
        // Kiểm tra quyền để hiển thị nút
        String role = (String) request.getAttribute("userRole");
        boolean canEdit = canEdit(role);
        request.setAttribute("canEdit", canEdit);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/Brand-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/brand-form.jsp");
        request.setAttribute("formAction", "add");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDAO.getBrandById(id);
        
        if (brand != null) {
            request.setAttribute("brand", brand);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/Staff/brand-form.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(404, "Brand not found");
        }
    }

    private void addBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String name = request.getParameter("name");
        String logo = request.getParameter("logo");
        
        // Validation cơ bản
        if (name == null || name.trim().isEmpty()) {
            response.sendError(400, "Brand name is required");
            return;
        }
        
        Brand brand = new Brand(name.trim(), logo);
        boolean success = brandDAO.addBrand(brand);
        
        if (success) {
            // Lấy role để redirect đúng
            String role = (String) request.getAttribute("userRole");
            //response.sendRedirect("list?role=" + role);
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + role);
        } else {
            response.sendError(500, "Failed to add brand");
        }
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String logo = request.getParameter("logo");
        
        // Validation cơ bản
        if (name == null || name.trim().isEmpty()) {
            response.sendError(400, "Brand name is required");
            return;
        }
        
        Brand brand = new Brand(name.trim(), logo);
        brand.setBrandId(id);
        boolean success = brandDAO.updateBrand(brand);
        
        if (success) {
            // Lấy role để redirect đúng
            String role = (String) request.getAttribute("userRole");
            //response.sendRedirect("list?role=" + role);
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + role);
        } else {
            response.sendError(500, "Failed to update brand");
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = brandDAO.deleteBrand(id);
        
        if (success) {
            // Lấy role để redirect đúng
            String role = (String) request.getAttribute("userRole");
            //response.sendRedirect("list?role=" + role);
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + role);
        } else {
            response.sendError(500, "Failed to delete brand");
        }
    }

    // === CÁC PHƯƠNG THỨC HỖ TRỢ ===
    
//    private String getAction(HttpServletRequest request) {
//        String pathInfo = request.getPathInfo();
//        if (pathInfo == null || pathInfo.equals("/")) {
//            return "list";
//        }
//        return pathInfo.substring(1); // bỏ dấu "/"
//    }
    
    private String getAction(HttpServletRequest request) {
    String pathInfo = request.getPathInfo(); // /list, /add, ...
    if (pathInfo != null && !"/".equals(pathInfo)) {
        // tránh lỗi nếu path chỉ có "/" hoặc rỗng
        String p = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        return p.isEmpty() ? "list" : p;
    }
    String action = request.getParameter("action");
    return (action == null || action.trim().isEmpty()) ? "list" : action.trim();
}



    private boolean canEdit(String role) {
        return "admin".equals(role);
    }
}