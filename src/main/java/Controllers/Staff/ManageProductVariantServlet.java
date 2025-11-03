/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Product;
import Models.ProductVariant;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        } else if ("update".equalsIgnoreCase(action)) {

        }

    }
// Create new variant

    private void createVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdStr = request.getParameter("productId");
        String color = request.getParameter("color");
        String size = request.getParameter("size");
        String priceStr = request.getParameter("price");

        String imageUrl = request.getParameter("image");

        // Validate input
        if (productIdStr == null || color == null || size == null
                || priceStr == null || imageUrl == null) {

            request.setAttribute("errorMessage", "All fields are required!");

            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            int quantity = 0;

            // Validate values
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("errorMessage", "Price must be 0 or greater!");

                return;
            }

            // Get product to verify it exists
            Product product = productDAO.getById(productId);
            if (product == null) {
                request.setAttribute("errorMessage", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/staff/product");
                return;
            }

            // Check if variant with same color and size already exists
            if (variantDAO.variantExists(productId, color.trim(), size.trim())) {
                request.setAttribute("errorMessage", "A variant with this color and size already exists!");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/create-product-variant.jsp")
                        .forward(request, response);
                return;
            }

            // Create variant object
            ProductVariant variant = new ProductVariant();
            variant.setProductId(productId);
            variant.setColor(color.trim());
            variant.setSize(size.trim());
            variant.setPrice(price);
            variant.setQuantityAvailable(quantity);
            variant.setImage(imageUrl.trim());

            // Save to database
            int success = variantDAO.createVariant(variant);

            if (success > 0) {
                // Set success message in session
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Variant created successfully!");

                // Redirect to product detail page
                response.sendRedirect(request.getContextPath()
                        + "/staff/product?action=detail&productId=" + productId);
            } else {
                request.setAttribute("errorMessage", "Failed to create variant. Please try again.");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/views/staff/create-variant.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsessage", "Invalid number format!");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());

        }

    }

    private void updateVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int variantId = Integer.parseInt(request.getParameter("variantId"));
        int productId = Integer.parseInt(request.getParameter("productId"));

        ProductVariant variant = new ProductVariant();
        variant.setProductVariantId(variantId);
        variant.setColor(request.getParameter("color"));
        variant.setSize(request.getParameter("size"));
        variant.setPrice(new BigDecimal(request.getParameter("price")));  
        variant.setImage(request.getParameter("image"));

        boolean success = variantDAO.updateVariant(variant);

        if (success) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + productId
                    + "&success=Variant updated successfully!");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/staff/product?action=detail&productId=" + productId
                    + "&error=Failed to update variant!");
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
