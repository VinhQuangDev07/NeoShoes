package Controllers.Customer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import DAOs.VoucherDAO;
import Models.Voucher;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucher"})
public class VoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạm thời sử dụng customerId mặc định để test
        // Khi tích hợp đăng nhập sau này, sẽ thay bằng customerId từ session
        Integer customerId = getCustomerIdFromSessionOrDefault(request);

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "available":
                    listAvailableVouchers(request, response, customerId);
                    break;
                case "used":
                    listUsedVouchers(request, response, customerId);
                    break;
                case "count":
                    getVoucherCount(request, response, customerId);
                    break;
                case "apply":
                    showApplyVoucherForm(request, response, customerId);
                    break;
                case "check":
                    showCheckVoucherForm(request, response, customerId);
                    break;
                case "list":
                default:
                    listAllVouchers(request, response, customerId);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạm thời sử dụng customerId mặc định để test
        Integer customerId = getCustomerIdFromSessionOrDefault(request);

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "apply":
                    applyVoucher(request, response, customerId);
                    break;
                case "check":
                    checkVoucher(request, response, customerId);
                    break;
                default:
                    listAllVouchers(request, response, customerId);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Lấy customerId từ session hoặc sử dụng giá trị mặc định Khi tích hợp đăng
     * nhập, chỉ cần sửa method này
     */
    private Integer getCustomerIdFromSessionOrDefault(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        // Nếu chưa có session (chưa đăng nhập), sử dụng customerId mặc định
        // Đây là tạm thời, khi tích hợp đăng nhập sẽ bỏ phần này
        if (customerId == null) {
            // Có thể lấy từ parameter để test, hoặc dùng giá trị mặc định
            String customerIdParam = request.getParameter("customerId");
            if (customerIdParam != null) {
                try {
                    customerId = Integer.parseInt(customerIdParam);
                } catch (NumberFormatException e) {
                    customerId = 1; // Giá trị mặc định để test
                }
            } else {
                customerId = 1; // Giá trị mặc định để test
            }

            // Lưu vào session để các request sau sử dụng
            session.setAttribute("customerId", customerId);
        }

        return customerId;
    }

    private void listAllVouchers(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customerId);
        List<Voucher> usedVouchers = voucherDAO.getUsedVouchersForCustomer(customerId);

        // ✅ Không để null đẩy sang JSP
        request.setAttribute("availableVouchers",
                availableVouchers != null ? availableVouchers : Collections.emptyList());
        request.setAttribute("usedVouchers",
                usedVouchers != null ? usedVouchers : Collections.emptyList());
        request.setAttribute("customerId", customerId);

        // ✅ Forward bằng đường dẫn tuyệt đối
        request.getRequestDispatcher("/WEB-INF/views/customer/voucher-list.jsp")
                .forward(request, response);
    }

    private void listAvailableVouchers(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customerId);
        request.setAttribute("availableVouchers",
                availableVouchers != null ? availableVouchers : Collections.emptyList());
        request.setAttribute("customerId", customerId);

        request.getRequestDispatcher("/views/voucher-available.jsp").forward(request, response);
    }

    private void listUsedVouchers(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        List<Voucher> usedVouchers = voucherDAO.getUsedVouchersForCustomer(customerId);
        request.setAttribute("usedVouchers",
                usedVouchers != null ? usedVouchers : Collections.emptyList());
        request.setAttribute("customerId", customerId);

        request.getRequestDispatcher("/views/voucher-used.jsp").forward(request, response);
    }

    private void showApplyVoucherForm(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        request.setAttribute("customerId", customerId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/apply-voucher.jsp");
        dispatcher.forward(request, response);
    }

    private void showCheckVoucherForm(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        request.setAttribute("customerId", customerId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/check-voucher.jsp");
        dispatcher.forward(request, response);
    }

    private void applyVoucher(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        String voucherCode = request.getParameter("voucherCode");
        String orderTotalParam = request.getParameter("orderTotal");

        // ✅ SET response type là JSON
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // ✅ THÊM LOG DEBUG
            System.out.println("=== APPLY VOUCHER DEBUG ===");
            System.out.println("Customer ID: " + customerId);
            System.out.println("Voucher Code: " + voucherCode);
            System.out.println("Order Total: " + orderTotalParam);
            
            double orderTotal = orderTotalParam != null ? Double.parseDouble(orderTotalParam) : 0;

            // Kiểm tra voucher
            System.out.println("Querying voucher from database...");
            Voucher voucher = voucherDAO.getVoucherByCode(voucherCode, customerId);

            if (voucher == null) {
                System.err.println("Voucher NOT FOUND");
                out.print("{\"success\": false, \"message\": \"Voucher code does not exist!\"}");
            } else if (!voucher.isActive()) {
                System.err.println("Voucher NOT ACTIVE");
                out.print("{\"success\": false, \"message\": \"Voucher is no longer active!\"}");
            } else if (voucher.isExpired()) {
                System.err.println("Voucher EXPIRED");
                out.print("{\"success\": false, \"message\": \"Voucher has expired!\"}");
            } else if (voucher.getMinValue() != null && orderTotal < voucher.getMinValue().doubleValue()) {
                System.err.println("Order total too low: " + orderTotal + " < " + voucher.getMinValue());
                out.print("{\"success\": false, \"message\": \"Order must have a minimum value of $" + voucher.getMinValue() + "\"}");
            } else if (!voucherDAO.isVoucherUsable(voucher.getVoucherId(), customerId)) {
                System.err.println("Voucher NOT USABLE (usage limit reached)");
                out.print("{\"success\": false, \"message\": \"You have used up all attempts for this voucher!\"}");
            } else {
                // Calculate discount
                double discount = calculateDiscount(voucher, orderTotal);
                double finalAmount = orderTotal - discount;

                // Save to session
                HttpSession session = request.getSession();
                session.setAttribute("appliedVoucherCode", voucher.getVoucherCode());
                session.setAttribute("appliedVoucherId", voucher.getVoucherId());
                session.setAttribute("voucherDiscount", discount);

                System.out.println("✅ Voucher applied successfully!");
                System.out.println("  - Discount: $" + discount);
                System.out.println("  - Final Amount: $" + finalAmount);
                System.out.println("===========================");

                // RETURN JSON SUCCESS
                out.print("{\"success\": true, " +
                         "\"message\": \"Voucher applied successfully! Discount $" + String.format("%.2f", discount) + "\", " +
                         "\"voucherCode\": \"" + voucher.getVoucherCode() + "\", " +
                         "\"discount\": " + discount + ", " +
                         "\"finalAmount\": " + finalAmount + "}");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid number format: " + e.getMessage());
            out.print("{\"success\": false, \"message\": \"Invalid order amount!\"}");
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"System error!\"}");
        } finally {
            out.flush();
        }
    }

    private void checkVoucher(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        String voucherCode = request.getParameter("voucherCode");

        // Kiểm tra voucher
        Voucher voucher = voucherDAO.getVoucherByCode(voucherCode, customerId);

        if (voucher != null && voucher.canUseVoucher()) {
            request.setAttribute("voucherInfo", voucher);
            request.setAttribute("message", "Voucher có thể sử dụng!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Voucher không thể sử dụng!");
            request.setAttribute("messageType", "error");
        }

        request.setAttribute("customerId", customerId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/check-voucher.jsp");
        dispatcher.forward(request, response);
    }

    private void getVoucherCount(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws IOException {

        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customerId);
        int count = (availableVouchers == null) ? 0 : availableVouchers.size();

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"count\":" + count + "}");
    }

    private double calculateDiscount(Voucher voucher, double orderTotal) {
        if ("PERCENTAGE".equalsIgnoreCase(voucher.getType())) {
            double discount = orderTotal * voucher.getValue().doubleValue() / 100;
            if (voucher.getMaxValue() != null && discount > voucher.getMaxValue().doubleValue()) {
                return voucher.getMaxValue().doubleValue();
            }
            return discount;
        } else {
            // Fixed amount
            return voucher.getValue().doubleValue();
        }
    }
}
