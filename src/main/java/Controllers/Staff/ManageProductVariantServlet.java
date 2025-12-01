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
import jakarta.servlet.annotation.MultipartConfig;
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
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
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

    // Thêm annotation này vào đầu Servlet class của bạn
    private void createVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            // Get parameters (đã validate ở JSP)
            int productId = Integer.parseInt(request.getParameter("productId"));
            String color = request.getParameter("color").trim();
            String size = request.getParameter("size").trim();
            BigDecimal price = new BigDecimal(request.getParameter("price"));

            // BUSINESS LOGIC VALIDATION (bắt buộc phải có)
            // 1. Check product exists
            Product product = productDAO.getById(productId);
            if (product == null) {

                session.setAttribute("flash_error", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/staff/product");
                return;
            }

            // 2. Check duplicate variant (business rule)
            if (variantDAO.variantExists(productId, color, size)) {
                session.setAttribute("flash_error", "A variant with this color and size already exists!");
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
                return;
            }

            // Handle image upload
            String imageUrl = product.getDefaultImageUrl(); // Default fallback

            try {
                Part imagePart = request.getPart("imageFile");

                if (imagePart != null && imagePart.getSize() > 0) {

                    String uploadedUrl = CloudinaryConfig.uploadSingleImage(imagePart);

                    if (uploadedUrl != null && !uploadedUrl.isEmpty()) {
                        imageUrl = uploadedUrl;

                    } else {
                        session.setAttribute("flash_error", "WARNING: Cloudinary upload returned null/empty");

                    }
                } else {
                    session.setAttribute("flash_error", "WARNING: No image file uploaded, using product default image");

                }
            } catch (Exception e) {
                e.printStackTrace();
                // Continue with default image if upload fails
            }

            // Create variant object
            ProductVariant variant = new ProductVariant();
            variant.setProductId(productId);
            variant.setColor(color);
            variant.setSize(size);
            variant.setPrice(price);
            variant.setQuantityAvailable(0);
            variant.setImage(imageUrl);

            // Save to database
            int result = variantDAO.createVariant(variant);

            if (result > 0) {
                session.setAttribute("flash", "Variant created successfully!");
            } else {
                session.setAttribute("flash_error", "Failed to create variant!");
            }

            response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);

        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid data format!");
            response.sendRedirect(request.getContextPath() + "/staff/product");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Error while creating variant!");

            String productIdParam = request.getParameter("productId");
            if (productIdParam != null) {
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/product");
            }
        }

    }

   private void updateVariant(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    System.out.println("===== UPDATE VARIANT METHOD CALLED =====");
    
    HttpSession session = request.getSession();
    
    try {
        request.setCharacterEncoding("UTF-8");
        
        // Get parameters (đã validate ở JSP)
        int variantId = Integer.parseInt(request.getParameter("variantId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        String color = request.getParameter("color").trim();
        String size = request.getParameter("size").trim();
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        
        System.out.println("Variant ID: " + variantId);
        System.out.println("Product ID: " + productId);
        System.out.println("Color: " + color);
        System.out.println("Size: " + size);
        System.out.println("Price: " + price);
        
        // BUSINESS LOGIC VALIDATION (bắt buộc phải có)
        
        // 1. Get existing variant
        ProductVariant existingVariant = variantDAO.findById(variantId);
        if (existingVariant == null) {
            System.out.println("ERROR: Variant not found - ID: " + variantId);
            session.setAttribute("flash_error", "Variant not found!");
            response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
            return;
        }
        System.out.println("Existing variant found");
        
        // 2. Check duplicate variant (nếu color/size thay đổi)
        boolean colorChanged = !color.equals(existingVariant.getColor());
        boolean sizeChanged = !size.equals(existingVariant.getSize());
        
        if (colorChanged || sizeChanged) {
            if (variantDAO.variantExists(productId, color, size)) {
                System.out.println("ERROR: Duplicate variant - Color: " + color + ", Size: " + size);
                session.setAttribute("flash_error", "A variant with this color and size already exists!");
                response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
                return;
            }
        }
        System.out.println("No duplicate variant found");
        
        // 3. Handle image upload
        String imageUrl = existingVariant.getImage(); // Keep existing image as default
        
        try {
            Part imagePart = request.getPart("imageFile");
            System.out.println("Image part: " + (imagePart != null ? "exists" : "null"));
            
            if (imagePart != null && imagePart.getSize() > 0) {
                System.out.println("New image size: " + imagePart.getSize() + " bytes");
                
                String uploadedUrl = CloudinaryConfig.uploadSingleImage(imagePart);
                System.out.println("Uploaded URL: " + uploadedUrl);
                
                if (uploadedUrl != null && !uploadedUrl.isEmpty()) {
                    imageUrl = uploadedUrl;
                    System.out.println("Image updated successfully");
                } else {
                    System.out.println("WARNING: Cloudinary upload returned null/empty");
                }
            } else {
                System.out.println("No new image uploaded, keeping existing image");
            }
        } catch (Exception e) {
            System.out.println("ERROR uploading image: " + e.getMessage());
            e.printStackTrace();
            // Continue with existing image if upload fails
        }
        
        // 4. Update variant
        ProductVariant variant = new ProductVariant();
        variant.setProductVariantId(variantId);
        variant.setProductId(productId);
        variant.setColor(color);
        variant.setSize(size);
        variant.setPrice(price);
        variant.setImage(imageUrl);
        variant.setQuantityAvailable(existingVariant.getQuantityAvailable()); // Keep quantity
        
        System.out.println("Updating variant - Color: " + color + ", Size: " + size + ", Price: " + price);
        
        boolean success = variantDAO.updateVariant(variant);
        
        if (success) {
            System.out.println("SUCCESS: Variant updated successfully");
            session.setAttribute("flash", "Variant updated successfully!");
        } else {
            System.out.println("ERROR: Failed to update variant");
            session.setAttribute("flash_error", "Failed to update variant!");
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productId);
        
    } catch (NumberFormatException e) {
        System.out.println("ERROR: Invalid number format - " + e.getMessage());
        session.setAttribute("flash_error", "Invalid data format!");
        response.sendRedirect(request.getContextPath() + "/staff/product");
        
    } catch (Exception e) {
        System.out.println("ERROR: " + e.getMessage());
        e.printStackTrace();
        session.setAttribute("flash_error", "Error while updating variant!");
        
        String productIdParam = request.getParameter("productId");
        if (productIdParam != null) {
            response.sendRedirect(request.getContextPath() + "/staff/product?action=detail&productId=" + productIdParam);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/product");
        }
    }
    
    System.out.println("===== UPDATE VARIANT COMPLETED =====");
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
