package Controllers.Staff;

import DAOs.CategoryDAO;
import Models.Category;
import Models.Staff;
import Utils.CloudinaryConfig;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageCategoriesServlet", urlPatterns = {"/staff/manage-categories", "/staff/manage-categories/*"})
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
                    listCategories(request, response);
                    break;
                case "add":
                    if (staff.isAdmin()) {
                        showAddForm(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
                    }
                    break;
                case "edit":
                    if (staff.isAdmin()) {
                        showEditForm(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
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

        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        request.setAttribute("userRole", session.getAttribute("role"));

        String action = getAction(request);

        try {
            switch (action) {
                case "add":
                    if (staff.isAdmin()) {
                        addCategory(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
                    }
                    break;
                case "update":
                    if (staff.isAdmin()) {
                        updateCategory(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
                    }
                    break;
                case "delete":
                    if (staff.isAdmin()) {
                        deleteCategory(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
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

        int totalRecords = categories.size();

        // Calculate start and end positions
        int startIndex = (currentPage - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);

        // 5. Lấy dữ liệu cho trang hiện tại
        List<Category> pageData;
        if (startIndex < totalRecords) {
            pageData = categories.subList(startIndex, endIndex);
        } else {
            pageData = new ArrayList<>();
        }

        // Set attributes
        request.setAttribute("categories", pageData);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("baseUrl", request.getRequestURI());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/manage-categories.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/category-form.jsp");
        request.setAttribute("formAction", "add");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDAO.getCategoryById(id);

            if (category != null) {
                request.setAttribute("category", category);
                request.setAttribute("formAction", "update");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/category-form.jsp");
                dispatcher.forward(request, response);
            } else {
                request.getSession().setAttribute("flash_error", "Category not found");
                response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException, ServletException {

        try {
            String name = request.getParameter("name");
            String isActiveStr = request.getParameter("isActive");
            boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);

            // Validate tên trống
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("flash_error", "Category name cannot be empty");
                showAddForm(request, response);
                return;
            }

            // Kiểm tra trùng tên trước khi upload
            if (categoryDAO.isCategoryNameExists(name.trim(), null)) {
                request.setAttribute("flash_error", "Category name already exists");
                Category category = new Category();
                category.setName(name.trim());
                category.setIsActive(isActive);
                request.setAttribute("category", category);
                request.setAttribute("formAction", "add");
                request.getRequestDispatcher("/WEB-INF/views/staff/category-form.jsp").forward(request, response);
                return;
            }

            // Upload ảnh (sau khi qua validate)
            Part imagePart = request.getPart("image");
            String imageUrl = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    imageUrl = CloudinaryConfig.uploadSingleImage(imagePart);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("flash_error", "Image upload failed!");
                    showAddForm(request, response);
                    return;
                }
            }

            // Tạo object
            Category category = new Category();
            category.setName(name.trim());
            category.setImage(imageUrl);
            category.setIsActive(isActive);

            boolean success = categoryDAO.addCategory(category);

            if (success) {
                session.setAttribute("flash", "Category added successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
            } else {
                session.setAttribute("flash_error", "Failed to add category!");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String isActiveStr = request.getParameter("isActive");
            boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);

            // Lấy ảnh hiện tại
            Category oldCategory = categoryDAO.getCategoryById(id);
            String imageUrl = oldCategory.getImage();

            // Upload ảnh mới nếu có
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    imageUrl = CloudinaryConfig.uploadSingleImage(imagePart);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("flash_error", "Image upload failed!");
                }
            }

            // Validate tên trống
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("flash_error", "Category name cannot be empty");
                oldCategory.setName(name);
                oldCategory.setImage(imageUrl);
                oldCategory.setIsActive(isActive);
                request.setAttribute("category", oldCategory);
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/staff/category-form.jsp").forward(request, response);
                return;
            }

            // Validate trùng tên
            if (categoryDAO.isCategoryNameExists(name.trim(), id)) {
                session.setAttribute("flash_error", "Category name already exists");
                oldCategory.setName(name);
                oldCategory.setImage(imageUrl);
                oldCategory.setIsActive(isActive);
                request.setAttribute("category", oldCategory);
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/staff/category-form.jsp").forward(request, response);
                return;
            }

            // Cập nhật
            Category updated = new Category();
            updated.setCategoryId(id);
            updated.setName(name.trim());
            updated.setImage(imageUrl);
            updated.setIsActive(isActive);

            boolean success = categoryDAO.updateCategory(updated);

            if (success) {
                session.setAttribute("flash", "Category updated successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
            } else {
                session.setAttribute("flash_error", "Failed to update category!");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = categoryDAO.deleteCategory(id);

            if (success) {
                session.setAttribute("flash", "Category deleted successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to delete category!");
            }

            response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-categories");
        }
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

}
