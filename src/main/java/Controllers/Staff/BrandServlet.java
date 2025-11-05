package Controllers.Staff;

import DAOs.BrandDAO;
import Models.Brand;
import Models.Staff;

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
                case "list":
                    listBrands(request, response);
                    break;
                case "add":
                    if (staff.isAdmin()) {
                        showAddForm(request, response);
                    }
                    break;
                case "edit":
                    if (staff.isAdmin()) {
                        showEditForm(request, response);
                    }
                    break;
                default:
                    listBrands(request, response);
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
                        addBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "update":
                    if (staff.isAdmin()) {
                        updateBrand(request, response);
                    } else {
                        response.sendError(403, "Access Denied - Admin only");
                    }
                    break;
                case "delete":
                    if (staff.isAdmin()) {
                        deleteBrand(request, response);
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

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/Brand-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(404, "Brand not found");
        }
    }

    private void addBrand(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

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

        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = brandDAO.deleteBrand(id);

        String currentRole = (String) request.getAttribute("userRole");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/managebrands/list?role=" + currentRole + "&error=delete_failed");
        }
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
