package Controllers.Customer;

import DAOs.OrderDAO;
import Models.Order;
import Models.Customer;
import Utils.Common;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PurchaseServlet", urlPatterns = {"/purchase"})
public class PurchaseServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        // Create demo customer if not logged in
        if (customer == null) {
            customer = new Customer();
            customer.setId(1);
            customer.setEmail("demo@neoshoes.com");
            customer.setName("Demo Customer");
            customer.setPhoneNumber("0123456789");
            session.setAttribute("customer", customer);
        }

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
