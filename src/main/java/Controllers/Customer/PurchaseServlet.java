package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.CartDAO;
import DAOs.AddressDAO;
import DAOs.VoucherDAO;
import DAOs.CustomerDAO;
import Models.Order;
import Models.Customer;
import Models.Address;
import Models.Voucher;
import Models.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet(name = "PurchaseServlet", urlPatterns = {"/purchase"})
public class PurchaseServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private AddressDAO addressDAO;
    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
        addressDAO = new AddressDAO();
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        // Using Customer ID = ? for testing 
        int customerId = 2;
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.findById(customerId);

        String action = request.getParameter("action");
        
        if ("checkout".equals(action)) {
            // Handle checkout process - show purchase confirmation page
            handleCheckout(request, response, customer);
        } else {
            // Default: show purchase history
            handlePurchaseHistory(request, response, customer);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Using Customer ID = ? for testing 
        int customerId = 2;
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.findById(customerId);

        String action = request.getParameter("action");
        
        if ("placeOrder".equals(action)) {
            // Handle placing order
            handlePlaceOrder(request, response, customer);
        } else {
            // Default: show purchase history
            handlePurchaseHistory(request, response, customer);
        }
    }
    
    private void handleCheckout(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException {
        try {
            // Get selected cart item IDs from request parameters
            String[] selectedCartItemIds = request.getParameterValues("cartItemIds");
            
            List<CartItem> cartItems;
            if (selectedCartItemIds != null && selectedCartItemIds.length > 0) {
             
                
                List<CartItem> allCartItems = cartDAO.getItemsByCustomerId(customer.getId());
                cartItems = new ArrayList<>();
                
                for (String cartItemIdStr : selectedCartItemIds) {
                    try {
                        int cartItemId = Integer.parseInt(cartItemIdStr);
                        
                        for (CartItem item : allCartItems) {
                            if (item.getCartItemId() == cartItemId) {
                                cartItems.add(item);
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        // Skip invalid cart item IDs
                    }
                }
            } else {
                // Get all cart items for the customer
                // Using Customer ID = 2 for cart items (has addresses but NO cart items)
                cartItems = cartDAO.getItemsByCustomerId(customer.getId());
            }
            
            if (cartItems.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("flash_error", "Your cart is empty or no items selected");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // Get customer addresses
            List<Address> addresses = new ArrayList<>();
            try {
                addresses = addressDAO.getAllAddressByCustomerId(customer.getId());
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            // Check if customer has addresses - redirect to profile if none
            if (addresses.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("flash_error", "You need to add a delivery address before placing an order. Please add an address in the profile page.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            
            // Get available vouchers
            List<Voucher> availableVouchers = new ArrayList<>();
            try {
                availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customer.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Calculate totals
            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                subtotal = subtotal.add(item.getVariant().getPrice().multiply(new BigDecimal(item.getQuantity())));
            }
            BigDecimal shippingFee = new BigDecimal("10.00");
            BigDecimal total = subtotal.add(shippingFee);
            
            // Set attributes for JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("addresses", addresses);
            request.setAttribute("availableVouchers", availableVouchers);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("total", total);
            request.setAttribute("customer", customer);
            
            // Forward to purchase confirmation page
            request.getRequestDispatcher("/WEB-INF/views/customer/purchase.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            String errorMsg = "Có lỗi xảy ra khi tải thông tin thanh toán: " + 
                            (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName());
            session.setAttribute("flash_error", errorMsg);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get parameters
            String[] cartItemIdsStr = request.getParameterValues("cartItemIds");
            String addressIdStr = request.getParameter("addressId");
            String voucherCode = request.getParameter("voucherCode");
            
            if (cartItemIdsStr == null || cartItemIdsStr.length == 0) {
                session.setAttribute("flash_error", "No items selected for order");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            if (addressIdStr == null || addressIdStr.trim().isEmpty()) {
                session.setAttribute("flash_error", "Please select a delivery address");
                response.sendRedirect(request.getContextPath() + "/purchase?action=checkout");
                return;
            }
            
            // Convert parameters
            int[] cartItemIds = new int[cartItemIdsStr.length];
            for (int i = 0; i < cartItemIdsStr.length; i++) {
                cartItemIds[i] = Integer.parseInt(cartItemIdsStr[i]);
            }
            
            int addressId = Integer.parseInt(addressIdStr);
            Integer voucherId = null;
            
            // Validate and get voucher if provided
            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                Voucher voucher = voucherDAO.getVoucherByCode(voucherCode.trim(), customer.getId());
                if (voucher != null && voucher.canUseVoucher()) {
                    voucherId = voucher.getVoucherId();
                } else {
                    session.setAttribute("flash_error", "Invalid or expired voucher code");
                    response.sendRedirect(request.getContextPath() + "/purchase?action=checkout");
                    return;
                }
            }
            
            // Create order
            // Using Customer ID = 2 for both cart items and order owner
            int orderId = orderDAO.createOrderFromCart(customer.getId(), addressId, voucherId, cartItemIds);
            
            if (orderId > 0) {
                // Increment voucher usage if voucher was used
                if (voucherId != null) {
                    voucherDAO.incrementVoucherUsage(voucherId, customer.getId());
                }
                
                // Update cart quantity in session
                int itemCount = cartDAO.countItems(customer.getId());
                session.setAttribute("cartQuantity", itemCount);
                
                session.setAttribute("flash", "Order placed successfully! Order ID: " + orderId);
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                session.setAttribute("flash_error", "Failed to place order. Please try again.");
                response.sendRedirect(request.getContextPath() + "/purchase?action=checkout");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "An error occurred while placing your order");
            response.sendRedirect(request.getContextPath() + "/purchase?action=checkout");
        }
    }
    
    private void handlePurchaseHistory(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException {
        try {
            // Get all orders for the customer
            List<Order> allOrders = orderDAO.listByCustomer(customer.getId());
            
            // Calculate purchase analytics
            double totalSpent = allOrders.stream()
                    .mapToDouble(order -> order.getTotalAmount().doubleValue())
                    .sum();
            
            int totalOrders = allOrders.size();
            
            int totalItems = allOrders.stream()
                    .mapToInt(order -> order.getItems().size())
                    .sum();
            
            // Get recent orders (last 5)
            List<Order> recentOrders = allOrders.stream()
                    .limit(5)
                    .collect(java.util.stream.Collectors.toList());
            
            // Set attributes for JSP
            request.setAttribute("allOrders", allOrders);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("customer", customer);
            
            // Forward to purchase page
            request.getRequestDispatcher("/WEB-INF/views/customer/purchase.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu mua hàng");
            request.getRequestDispatcher("/WEB-INF/views/customer/purchase.jsp").forward(request, response);
        }
    }
}
