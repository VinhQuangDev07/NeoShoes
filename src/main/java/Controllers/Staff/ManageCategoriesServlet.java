package Controllers.Staff;

import DAOs.CategoryDAO;
import Models.Category;
import Utils.CloudinaryConfig;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ManageCategoriesServlet", urlPatterns = {"/managecategoriesforstaff", "/managecategoriesforstaff/*"})
@MultipartConfig
public class ManageCategoriesServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
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
                    listCategories(request, response);
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
                        deleteCategory(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "toggle-status":
                    if (canModify(role)) {
                        toggleStatus(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String role = getRoleFromRequest(request);
        request.setAttribute("userRole", role);
        
        String action = getAction(request);
        
        try {
            switch (action) {
                case "add":
                    if (canModify(role)) {
                        addCategory(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "update":
                    if (canModify(role)) {
                        updateCategory(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error: " + ex.getMessage(), ex);
        }
    }

    // === MAIN PROCESSING METHODS ===
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        String role = (String) request.getAttribute("userRole");
        boolean canModify = canModify(role);
        request.setAttribute("canModify", canModify);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Manage-Categories.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Category-form.jsp");
        request.setAttribute("formAction", "add");
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
        Category category = categoryDAO.getCategoryById(id);
        
        if (category != null) {
            request.setAttribute("category", category);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Category-form.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(404, "Category not found");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        String name = request.getParameter("name");
        
        Part imagePart = request.getPart("image");
        String imageUrl = null;
        imageUrl = CloudinaryConfig.uploadSingleImage(imagePart);
        
        String isActiveStr = request.getParameter("isActive");
        boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Category name cannot be empty");
            showAddForm(request, response);
            return;
        }
        
        if (categoryDAO.isCategoryNameExists(name.trim(), null)) {
            request.setAttribute("error", "Category name already exists");
            Category category = new Category();
            category.setName(name);
            category.setImage(imageUrl);
            category.setIsActive(isActive);
            request.setAttribute("category", category);
            request.setAttribute("formAction", "add");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Category-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        Category category = new Category();
        category.setName(name.trim());
        category.setImage(imageUrl);
        category.setIsActive(isActive);
        
        boolean success = categoryDAO.addCategory(category);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flash", "Category added successfully!");
            response.sendRedirect(request.getContextPath() + "/managecategoriesforstaff/list?role=" + role);
        } else {
            session.setAttribute("flash_error", "Failed to add category!");
            showAddForm(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        
        Part imagePart = request.getPart("image");
        String imageUrl = null;
        imageUrl = CloudinaryConfig.uploadSingleImage(imagePart);
        
        String isActiveStr = request.getParameter("isActive");
        boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Category name cannot be empty");
            Category category = new Category();
            category.setCategoryId(id);
            category.setName(name);
            category.setImage(imageUrl);
            category.setIsActive(isActive);
            request.setAttribute("category", category);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Category-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (categoryDAO.isCategoryNameExists(name.trim(), id)) {
            request.setAttribute("error", "Category name already exists");
            Category category = categoryDAO.getCategoryById(id);
            category.setName(name);
            category.setImage(imageUrl);
            category.setIsActive(isActive);
            request.setAttribute("category", category);
            request.setAttribute("formAction", "update");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Category-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        Category category = new Category();
        category.setCategoryId(id);
        category.setName(name.trim());
        category.setImage(imageUrl);
        category.setIsActive(isActive);
        
        boolean success = categoryDAO.updateCategory(category);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flash", "Category updated successfully!");
            response.sendRedirect(request.getContextPath() + "/managecategoriesforstaff/list?role=" + role);
        } else {
            session.setAttribute("flash_error", "Failed to update category!");
            showEditForm(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = categoryDAO.deleteCategory(id);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("flash", "Category deleted successfully!");
        } else {
            session.setAttribute("flash_error", "Failed to delete category!");
        }
        
        response.sendRedirect(request.getContextPath() + "/managecategoriesforstaff/list?role=" + role);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String role = (String) request.getAttribute("userRole");
        if (!canModify(role)) {
            response.sendError(403, "Access Denied - Admin only");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.getCategoryById(id);
        
        if (category != null) {
            category.setIsActive(!category.isActive());
            boolean success = categoryDAO.updateCategory(category);
            
            HttpSession session = request.getSession();
            if (success) {
                String status = category.isActive() ? "activated" : "deactivated";
                session.setAttribute("flash", "Category " + status + " successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to change status!");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/managecategoriesforstaff/list?role=" + role);
    }

    // === HELPER METHODS ===
    
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

    private String getRoleFromRequest(HttpServletRequest request) {
        String role = request.getParameter("role");
        
        if (role == null || role.trim().isEmpty()) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                role = (String) session.getAttribute("role");
            }
        }
        
        if (role == null || role.trim().isEmpty()) {
            role = "admin"; // Default role
        }
        
        return role;
    }
}
