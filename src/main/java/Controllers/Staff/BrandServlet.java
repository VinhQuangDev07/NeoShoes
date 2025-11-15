package Controllers.Staff;

import DAOs.BrandDAO;
import Models.Brand;
import Models.Staff;
import Utils.CloudinaryConfig;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/staff/manage-brands", "/staff/manage-brands/*"})
@MultipartConfig
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

        String action = getAction(request);

        try {
            switch (action) {
                case "list":
                    listBrands(request, response);
                    break;
                case "add":
                    if (staff.isAdmin()) {
                        showAddForm(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
                    }
                    break;
                case "edit":
                    if (staff.isAdmin()) {
                        showEditForm(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
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

        String action = getAction(request);

        try {
            switch (action) {
                case "add":
                    if (staff.isAdmin()) {
                        addBrand(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
                    }
                    break;
                case "update":
                    if (staff.isAdmin()) {
                        updateBrand(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
                    }
                    break;
                case "delete":
                    if (staff.isAdmin()) {
                        deleteBrand(request, response, session);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
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

    // === CÁC PHƯƠNG THỨC XỬ LÝ CHÍNH ===
    private void listBrands(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Brand> brands = brandDAO.getAllBrands();

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

        int totalRecords = brands.size();

        // Calculate start and end positions
        int startIndex = (currentPage - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);

        // 5. Lấy dữ liệu cho trang hiện tại
        List<Brand> pageData;
        if (startIndex < totalRecords) {
            pageData = brands.subList(startIndex, endIndex);
        } else {
            pageData = new ArrayList<>();
        }

        // Set attributes
        request.setAttribute("brands", pageData);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("baseUrl", request.getRequestURI());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-list.jsp");
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
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Brand brand = brandDAO.getBrandById(id);

            if (brand != null) {
                request.setAttribute("brand", brand);
                request.setAttribute("formAction", "update");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp");
                dispatcher.forward(request, response);
            } else {
                request.getSession().setAttribute("flash_error", "Brand not found");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
        }
    }

    private void addBrand(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException, ServletException {
        try {
            String name = request.getParameter("name");

            // Validate tên rỗng
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("flash_error", "Brand name is required.");
                Brand brand = new Brand();
                brand.setName("");
                request.setAttribute("brand", brand);
                request.setAttribute("formAction", "add");
                request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp").forward(request, response);
                return;
            }


            if (brandDAO.existsByName(name.trim())) {
                request.setAttribute("flash_error", "The brand name already exists.");
                Brand brand = new Brand();
                brand.setName(name);
                request.setAttribute("brand", brand);
                request.setAttribute("formAction", "add");
                request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp").forward(request, response);
                return;
            }

            // Upload logo (nếu có)
            String logoUrl = null;
    Part logoPart = request.getPart("logoFile");
    if (logoPart != null && logoPart.getSize() > 0) {
        try {
            logoUrl = CloudinaryConfig.uploadSingleImage(logoPart);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("flash_error", "Logo upload failed!");
            Brand brand = new Brand();
            brand.setName(name);
            request.setAttribute("brand", brand);
            request.setAttribute("formAction", "add");
            request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp").forward(request, response);
            return;
        }
    }

            Brand brand = new Brand();
            brand.setName(name.trim());
            brand.setLogo(logoUrl);

            boolean success = brandDAO.addBrand(brand);

            if (success) {
                session.setAttribute("flash", "Brand added successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
            } else {
                session.setAttribute("flash_error", "Failed to add brand!");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
        }
    }

    private void updateBrand(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");

            // Lấy brand hiện tại
            Brand existingBrand = brandDAO.getBrandById(id);
            if (existingBrand == null) {
                session.setAttribute("flash_error", "Brand not found!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
                return;
            }

            // Validate tên rỗng
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("flash_error", "Brand name is required.");
                request.setAttribute("brand", existingBrand);
                request.setAttribute("formAction", "update");
                request.getRequestDispatcher("/WEB-INF/views/staff/brand-form.jsp").forward(request, response);
                return;
            }

            // Upload logo mới (nếu có)
            String logoUrl = existingBrand.getLogo();
            Part logoPart = request.getPart("logoFile");
            if (logoPart != null && logoPart.getSize() > 0) {
                try {
                    logoUrl = CloudinaryConfig.uploadSingleImage(logoPart);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("flash_error", "Logo upload failed!");
                    showEditForm(request, response);
                    return;
                }
            }

            Brand brand = new Brand();
            brand.setBrandId(id);
            brand.setName(name.trim());
            brand.setLogo(logoUrl);

            boolean success = brandDAO.updateBrand(brand);

            if (success) {
                session.setAttribute("flash", "Brand updated successfully!");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
            } else {
                session.setAttribute("flash_error", "Failed to update brand!");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
        }
    }

    private void deleteBrand(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = brandDAO.deleteBrand(id);

            if (success) {
                session.setAttribute("flash", "Deleted successfully");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands/list");
            } else {
                session.setAttribute("flash_error", "Failed to delete brand");
                response.sendRedirect(request.getContextPath() + "/staff/manage-brands/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-brands");
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
