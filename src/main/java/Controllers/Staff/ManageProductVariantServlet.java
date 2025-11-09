/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Product;
import Models.ProductVariant;
import Models.Staff;
import Utils.CloudinaryConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ManageProductVariantServlet", urlPatterns = {"/staff/variant"})
public class ManageProductVariantServlet extends HttpServlet {

    private ProductDAO productDAO;
    private ProductVariantDAO variantDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        variantDAO = new ProductVariantDAO();
    }

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
            out.println("<title>Servlet ManageProductVariantServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageProductVariantServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        if (!staff.isAdmin()) {
            session.setAttribute("flash_info", "Access Denied - Admin only");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }
        String view = request.getParameter("view");
        if ("create".equalsIgnoreCase(view)) {
            String paramProductId = request.getParameter("productId");
            int productId = Integer.parseInt(paramProductId);
            Product product = productDAO.getById(productId);
            request.setAttribute("product", product);

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/create-product-variant.jsp")
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
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        if (!staff.isAdmin()) {
            session.setAttribute("flash_info", "Access Denied - Admin only");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }
        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            createVariant(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            updateVariant(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {

            String productIdStr = request.getParameter("productId");
            int productId = Integer.parseInt(productIdStr);

            String variantIdStr = request.getParameter("variantId");
            int variantId = Integer.parseInt(variantIdStr);

            variantDAO.deleteVariant(variantId);
            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + productId);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/product");
        }

    }

    // Create new variant
    private void createVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            request.setCharacterEncoding("UTF-8");

            int productId = Integer.parseInt(request.getParameter("productId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String priceStr = request.getParameter("price");
            String imageUrl = request.getParameter("image");
            Part imagePart = request.getPart("imageFile");

            // Validate basic fields
            if (color == null || color.trim().isEmpty()
                    || size == null || size.trim().isEmpty()
                    || priceStr == null || priceStr.trim().isEmpty()) {

                session.setAttribute("flash_error", "Please fill in all required fields!");
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
                return;
            }

            BigDecimal price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                session.setAttribute("flash_error", "Price must be 0 or greater!");
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
                return;
            }

            // Check product
            Product product = productDAO.getById(productId);
            if (product == null) {
                session.setAttribute("flash_error", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/staff/product");
                return;
            }

            // Check duplicate variant
            if (variantDAO.variantExists(productId, color.trim(), size.trim())) {
                session.setAttribute("flash_error", "A variant with this color and size already exists!");
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
                return;
            }

            // Handle image upload (Cloudinary)
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadedUrl = CloudinaryConfig.uploadSingleImage(imagePart);
                if (uploadedUrl != null && !uploadedUrl.isEmpty()) {
                    imageUrl = uploadedUrl;
                }
            }

            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = product.getDefaultImageUrl(); // fallback nếu không upload
            }

            // Create variant
            ProductVariant variant = new ProductVariant();
            variant.setProductId(productId);
            variant.setColor(color.trim());
            variant.setSize(size.trim());
            variant.setPrice(price);
            variant.setQuantityAvailable(0);
            variant.setImage(imageUrl);

            boolean success = variantDAO.createVariant(variant) > 0;

            if (success) {
                session.setAttribute("flash", "Variant created successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to create variant!");
            }

            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error while creating variant!");
            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + request.getParameter("productId"));
        }
    }

    private void updateVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            request.setCharacterEncoding("UTF-8");

            int variantId = Integer.parseInt(request.getParameter("variantId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String imageUrl = request.getParameter("image");
            Part imagePart = request.getPart("imageFile");

            if (color == null || color.trim().isEmpty()
                    || size == null || size.trim().isEmpty()
                    || price.compareTo(BigDecimal.ZERO) < 0) {
                session.setAttribute("flash_error", "Please fill in all required fields!");
                response.sendRedirect(request.getContextPath()
                        + "/staff/product?action=detail&productId=" + productId);
                return;
            }

            // Upload new image if available
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadedUrl = CloudinaryConfig.uploadSingleImage(imagePart);
                if (uploadedUrl != null && !uploadedUrl.isEmpty()) {
                    imageUrl = uploadedUrl;
                }
            }

            // Update variant
            ProductVariant variant = new ProductVariant();
            variant.setProductVariantId(variantId);
            variant.setProductId(productId);
            variant.setColor(color.trim());
            variant.setSize(size.trim());
            variant.setPrice(price);
            variant.setImage(imageUrl);

            boolean success = variantDAO.updateVariant(variant);

            if (success) {
                session.setAttribute("flash", "Variant updated successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to update variant!");
            }

            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error while updating variant!");
            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + request.getParameter("productId"));
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
