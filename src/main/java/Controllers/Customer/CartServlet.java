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
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductVariantDAO variantDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
        variantDAO = new ProductVariantDAO();
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

//        HttpSession session = request.getSession();
//        Customer customer = (Customer) session.getAttribute("customer");
//
//        if (customer == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
        // For now, using hardcoded customer ID. In production, get from session
        // Using Customer ID = ?
        int customerId = 2;
        // Get cart items for the customer
        List<CartItem> cartItems = cartDAO.getItemsByCustomerId(customerId);

        // For each cart item, load variant list for its product
        Map<Integer, List<ProductVariant>> variantsByProduct = new HashMap<>();
        Map<Integer, Set<String>> colorsByProduct = new HashMap<>();
        Map<Integer, Set<String>> sizesByProduct = new HashMap<>();

        for (CartItem item : cartItems) {
            int productId = item.getVariant().getProduct().getProductId();

            if (!variantsByProduct.containsKey(productId)) {
                List<ProductVariant> variants = variantDAO.getByProductId(productId);
                variantsByProduct.put(productId, variants);

                // Extract unique colors và sizes
                Set<String> colors = variants.stream()
                        .map(ProductVariant::getColor)
                        .collect(Collectors.toSet());

                Set<String> sizes = variants.stream()
                        .map(ProductVariant::getSize)
                        .collect(Collectors.toSet());

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
        // Using Customer ID = ?
        int customerId = 2;

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
            CartItem existingItem = cartDAO.getExistItem(customerId, variantId);
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
                session.setAttribute("cartQuantity", itemCount);
                session.setAttribute("flash", "Added to cart successfully");
            } else {
                session.setAttribute("flash_error", "Error adding to cart");
            }

            // reload page (redirect)
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + variant.getProductId());
        } else if ("updateQuantity".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity must be greater than 0");
                return;
            }

            CartItem cartItem = cartDAO.findCartItem(customerId, cartItemId);
            if (cartItem == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Cart item not found");
                return;
            }

            ProductVariant variant = variantDAO.findById(cartItem.getProductVariantId());

            int available = variant.getQuantityAvailable();
            if (quantity > available) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Only " + available + " items available in stock");
                return;
            }

            boolean success = cartDAO.updateQuantity(cartItemId, quantity);
            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\",\"available\":" + available + "}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating quantity");
            }
        } else if ("updateVariant".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int variantId = Integer.parseInt(request.getParameter("productVariantId"));

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
        } else if ("remove".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

            boolean success = cartDAO.removeItem(cartItemId);
            if (success) {
                int itemCount = cartDAO.countItems(customerId);
                session.setAttribute("cartQuantity", itemCount);
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
