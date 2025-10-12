package Controllers.Customer;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAOs.VoucherDAO;
import Models.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

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
     * Lấy customerId từ session hoặc sử dụng giá trị mặc định
     * Khi tích hợp đăng nhập, chỉ cần sửa method này
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

        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("usedVouchers", usedVouchers);
        request.setAttribute("customerId", customerId); // Truyền customerId để hiển thị

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/views/customer/voucher-list.jsp");
        dispatcher.forward(request, response);
    }

    private void listAvailableVouchers(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customerId);
        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("customerId", customerId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/voucher-available.jsp");
        dispatcher.forward(request, response);
    }

    private void listUsedVouchers(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {

        List<Voucher> usedVouchers = voucherDAO.getUsedVouchersForCustomer(customerId);
        request.setAttribute("usedVouchers", usedVouchers);
        request.setAttribute("customerId", customerId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/voucher-used.jsp");
        dispatcher.forward(request, response);
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
        
        try {
            double orderTotal = orderTotalParam != null ? Double.parseDouble(orderTotalParam) : 0;
            
            // Kiểm tra voucher
            Voucher voucher = voucherDAO.getVoucherByCode(voucherCode, customerId);
            
            if (voucher == null) {
                request.setAttribute("errorMessage", "Voucher code không tồn tại!");
            } else if (!voucher.isActive()) {
                request.setAttribute("errorMessage", "Voucher không còn hoạt động!");
            } else if (voucher.isExpired()) {
                request.setAttribute("errorMessage", "Voucher đã hết hạn!");
            } else if (voucher.getMinValue() != null && orderTotal < voucher.getMinValue().doubleValue()) {
                request.setAttribute("errorMessage", 
                    "Đơn hàng phải có giá trị tối thiểu $" + voucher.getMinValue());
            } else if (!voucherDAO.isVoucherUsable(voucher.getVoucherId(), customerId)) {
                request.setAttribute("errorMessage", "Voucher không thể sử dụng!");
            } else {
                // Tính toán discount
                double discount = calculateDiscount(voucher, orderTotal);
                double finalAmount = orderTotal - discount;
                
                request.setAttribute("successMessage", "Áp dụng voucher thành công!");
                request.setAttribute("voucher", voucher);
                request.setAttribute("discount", discount);
                request.setAttribute("finalAmount", finalAmount);
                request.setAttribute("originalAmount", orderTotal);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Số tiền đơn hàng không hợp lệ!");
        }
        
        request.setAttribute("customerId", customerId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/apply-voucher.jsp");
        dispatcher.forward(request, response);
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
            throws ServletException, IOException {

        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForCustomer(customerId);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"count\": " + availableVouchers.size() + "}");
        out.flush();
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