/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Brand;
import Models.Category;
import DAOs.ReviewDAO;
import Models.Product;
import Models.ProductVariant;
import Models.Review;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/staff/product"})
public class ManageProductServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO pDAO = new ProductDAO();
        ProductVariantDAO pvDAO = new ProductVariantDAO();
        // ⭐ Dùng if-else để đảm bảo chỉ 1 nhánh được thực thi
        if ("detail".equals(action)) {
            // XỬ LÝ DETAIL
            String productIdStr = request.getParameter("productId");

            if (productIdStr == null || productIdStr.isEmpty()) {
                response.sendRedirect("manage-product?error=Missing product ID");
                return;
            }

            try {
                int productId = Integer.parseInt(productIdStr);
                Product product = pDAO.getById(productId);

                if (product == null) {
                    response.sendRedirect("manage-product?error=Product not found");
                    return;
                }

                List<ProductVariant> productVariants = pvDAO.getVariantListByProductId(productId);

                // Tính toán thống kê...
                int totalQuantity = 0;
                BigDecimal minPrice = null;
                BigDecimal maxPrice = null;

                for (ProductVariant variant : productVariants) {
                    totalQuantity += variant.getQuantityAvailable();
                    if (minPrice == null || variant.getPrice().compareTo(minPrice) < 0) {
                        minPrice = variant.getPrice();
                    }
                    if (maxPrice == null || variant.getPrice().compareTo(maxPrice) > 0) {
                        maxPrice = variant.getPrice();
                    }
                }

                // Get reviews count for display
                ReviewDAO reviewDAO = new ReviewDAO();
                List<Review> reviews = reviewDAO.getReviewsByProduct(productId);

                request.setAttribute("product", product);
                request.setAttribute("productVariants", productVariants);
                request.setAttribute("totalQuantity", totalQuantity);
                request.setAttribute("minPrice", minPrice != null ? minPrice : BigDecimal.ZERO);
                request.setAttribute("maxPrice", maxPrice != null ? maxPrice : BigDecimal.ZERO);
                request.setAttribute("reviews", reviews);

                request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/product-detail.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("manage-product?error=Invalid product ID");
            }

        } else if ("create".equals(action)) {
            // Load brands và categories
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Brand> brands = brandDAO.getAllBrands();
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/create.jsp")
                    .forward(request, response);
        } else if ("edit".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            // Load product info
            BrandDAO brandDAO = new BrandDAO();
            Product product = pDAO.getById(productId);
            List<Brand> brands = brandDAO.getAllBrands();
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("product", product);
            request.setAttribute("brands", brands);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/update.jsp")
                    .forward(request, response);
        } else {

            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Math.max(1, Integer.parseInt(pageParam));
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;

// 2. Lấy ĐÚNG số lượng data cần hiển thị từ DB
            List<Product> listProduct = pDAO.getAllProductsForStaff(offset, recordsPerPage);

// 3. Chỉ load variants cho products hiển thị trên page hiện tại
            Map<Integer, List<ProductVariant>> productVariantsMap = new HashMap<>();
            for (Product p : listProduct) {
                List<ProductVariant> variants = pvDAO.getVariantListByProductId(p.getProductId());
                productVariantsMap.put(p.getProductId(), variants);
            }

// 4. Lấy tổng số records để tính số trang
            int totalProduct = pDAO.getTotalProductStaff();
            int totalPages = (int) Math.ceil((double) totalProduct / recordsPerPage);

// 5. Lấy các thống kê
            int totalQuantity = pvDAO.getTotalQuantityAvailable();
            BigDecimal totalPrice = pvDAO.getTotalInventoryValue();

// 6. Set attributes
            request.setAttribute("productVariantsMap", productVariantsMap);
            request.setAttribute("listProduct", listProduct);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalProduct);
            request.setAttribute("totalQuantity", totalQuantity);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("baseUrl", request.getRequestURI());

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/list.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();
        if ("create".equals(action)) {
            try {
                // Get và validate parameters
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String material = request.getParameter("material");
                String imageUrl = request.getParameter("defaultImageUrl");

                // Check required fields
                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException("Product name is required!");
                }

                // Parse IDs
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                // Create product
                Product product = new Product();
                product.setName(name.trim());
                product.setDescription(description != null ? description.trim() : "");
                product.setBrandId(brandId);
                product.setCategoryId(categoryId);
                product.setMaterial(material != null ? material.trim() : "");
                product.setDefaultImageUrl(imageUrl != null ? imageUrl.trim() : "");
                product.setIsActive("1".equals(request.getParameter("isActive")) ? "active" : "inactive");

                boolean success = productDAO.createProduct(product);

                if (success && product.getProductId() > 0) {
                    request.getSession().setAttribute("successMessage", "Product created successfully!");
                    response.sendRedirect(request.getContextPath()
                            + "/staff/product?action=detail&productId=" + product.getProductId());
                } else {
                    throw new Exception("Failed to create product!");
                }

            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error: " + e.getMessage());
                request.getRequestDispatcher("/staff/create-product.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            try {
                // Parse và validate
                int productId = Integer.parseInt(request.getParameter("productId"));
                String name = request.getParameter("name");

                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException("Product name is required!");
                }

                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                // Create product
                Product product = new Product();
                product.setProductId(productId);
                product.setName(name.trim());
                product.setDescription(request.getParameter("description"));
                product.setBrandId(brandId);
                product.setCategoryId(categoryId);
                product.setMaterial(request.getParameter("material"));
                product.setDefaultImageUrl(request.getParameter("defaultImageUrl"));
                product.setIsActive("1".equals(request.getParameter("isActive")) ? "active" : "inactive");

                // Update
                boolean success = productDAO.updateProduct(product);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Product updated successfully!");
                    response.sendRedirect(request.getContextPath()
                            + "/staff/product?action=detail&productId=" + productId);
                } else {
                    throw new Exception("Failed to update product!");
                }

            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
                // Redirect về detail page
                String productIdStr = request.getParameter("productId");
                if (productIdStr != null && !productIdStr.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/staff/product");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/product");
                }
            }
        } else if ("delete".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));

                // Soft delete: set IsDeleted = 1
                boolean success = productDAO.deleteProduct(productId);

                if (success) {
                    request.getSession().setAttribute("successMessage",
                            "Product deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage",
                            "Failed to delete product! It may not exist or already deleted.");
                }

                response.sendRedirect(request.getContextPath() + "/staff/product");

            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage",
                        "Error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/staff/product");
            }
        }

        
        if ("reply-review".equals(action)) {
            // Handle staff reply to review
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                String replyContent = request.getParameter("replyContent");
                
                if (replyContent == null || replyContent.trim().isEmpty()) {
                    response.sendRedirect("product?action=detail&productId=" + productId + "&error=Reply content cannot be empty");
                    return;
                }
                
                // Get staff ID from session (you may need to adjust this based on your session management)
                Integer staffId = (Integer) request.getSession().getAttribute("staffId");
                if (staffId == null) {
                    response.sendRedirect("product?action=detail&productId=" + productId + "&error=Staff not logged in");
                    return;
                }
                
                ReviewDAO reviewDAO = new ReviewDAO();
                boolean success = reviewDAO.addStaffReply(reviewId, replyContent, staffId);
                
                if (success) {
                    response.sendRedirect("product?action=detail&productId=" + productId + "&success=Reply sent successfully");
                } else {
                    response.sendRedirect("product?action=detail&productId=" + productId + "&error=Failed to send reply");
                }
                
            } catch (NumberFormatException e) {
                response.sendRedirect("product?action=detail&error=Invalid review ID");
            }
        } else {
            processRequest(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
