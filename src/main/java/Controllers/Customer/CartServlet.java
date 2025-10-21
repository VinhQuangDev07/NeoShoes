/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.CartDAO;
import DAOs.ProductVariantDAO;
import Models.CartItem;
import Models.ProductVariant;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    CartDAO cartDAO = new CartDAO();
    ProductVariantDAO variantDAO = new ProductVariantDAO();

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
        
//        HttpSession session = request.getSession();
//        Customer customer = (Customer) session.getAttribute("customer");
//
//        if (customer == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        // For now, using hardcoded customer ID. In production, get from session
        int customerId = 1;
        
        // Get cart items for the customer
        List<CartItem> cartItems = cartDAO.getItemsByCustomerId(customerId);
        
        // For each cart item, load variant list for its product
        Map<Integer, List<ProductVariant>> variantsByProduct = new HashMap<>();
        Map<Integer, List<String>> colorsByProduct = new HashMap<>();
        Map<Integer, List<String>> sizesByProduct = new HashMap<>();

        for (CartItem item : cartItems) {
            int productId = item.getVariant().getProductId();

            if (!variantsByProduct.containsKey(productId)) {
                List<ProductVariant> variants = variantDAO.getByProductId(productId);
                variantsByProduct.put(productId, variants);

                // extract unique color and size
                List<String> colors = new ArrayList<>();
                List<String> sizes = new ArrayList<>();
                for (ProductVariant v : variants) {
                    if (v.getColor() != null && !colors.contains(v.getColor())) {
                        colors.add(v.getColor());
                    }
                    if (v.getSize() != null && !sizes.contains(v.getSize())) {
                        sizes.add(v.getSize());
                    }
                }
                colorsByProduct.put(productId, colors);
                sizesByProduct.put(productId, sizes);
            }
        }
        
        // Calculate totals
        int itemCount = cartDAO.countItems(customerId);
//        BigDecimal totalPrice = cartDAO.calculateTotalPrice(customerId);
        
        // Set attributes for JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("variantsByProduct", variantsByProduct);
        request.setAttribute("colorsByProduct", colorsByProduct);
        request.setAttribute("sizesByProduct", sizesByProduct);
        
        request.setAttribute("itemCount", itemCount);
//        request.setAttribute("totalPrice", totalPrice);
        
        // Forward to cart.jsp
        request.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(request, response);
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

        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("customerId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        String action = request.getParameter("action");
        int customerId = 1;

        if ("add".equals(action)) {
            int variantId = Integer.parseInt(request.getParameter("variantId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                session.setAttribute("flash_info", "Quantity must be greater than 0");
                return;
            }

            // Check variant exists and has quantity available
            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) {
                session.setAttribute("flash_info", "Product variant not found");
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + variant.getProductId());
                return;
            }

            // Check if item already in cart
            CartItem existingItem = cartDAO.findCartItem(customerId, variantId);
            int newQuantity = (existingItem != null) ? existingItem.getQuantity() + quantity : quantity;

            // Check total quantity against available stock
            if (newQuantity > variant.getQuantityAvailable()) {
                session.setAttribute("flash_info", "Only " + variant.getQuantityAvailable() + " items available");
                return;
            }

            // Add to cart (DAO handles update if exists)
            boolean success = cartDAO.addToCart(customerId, variantId, quantity);

            if (success) {
                int itemCount = cartDAO.countItems(customerId);
                session.setAttribute("flash", "Added to cart successfully");
            } else {
                session.setAttribute("flash_error", "Error adding to cart");
            }

            // reload page (redirect)
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + variant.getProductId());
        } 
        else if ("update".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity must be greater than 0");
                return;
            }
            
            boolean success = cartDAO.updateQuantity(cartItemId, quantity);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating quantity");
            }
        }
        else if ("updateVariant".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int variantId = Integer.parseInt(request.getParameter("variantId"));
            
            // Check if variant exists and has quantity available
            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) {
                session.setAttribute("flash_error", "Product variant not found");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // Update cart item with new variant
            boolean success = cartDAO.updateVariant(cartItemId, variantId);
            if (success) {
                session.setAttribute("flash", "Variant updated successfully");
            } else {
                session.setAttribute("flash_error", "Error updating variant");
            }
            
            // Redirect back to cart page
            response.sendRedirect(request.getContextPath() + "/cart");
        }
        else if ("remove".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            
            boolean success = cartDAO.removeItem(cartItemId);
            if (success) {
                session.setAttribute("flash", "Item removed successfully");
            } else {
                session.setAttribute("flash_error", "Error removing item");
            }
            
            // Redirect back to cart page
            response.sendRedirect(request.getContextPath() + "/cart");
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
