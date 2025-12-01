/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.ReturnRequestDAO;
import DAOs.ReturnRequestDetailDAO;
import Models.Customer;
import Models.Order;
import Models.OrderDetail;
import Models.ReturnRequest;
import Models.ReturnRequestDetail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ReturnRequestServlet", urlPatterns = {"/return-request"})
public class ReturnRequestServlet extends HttpServlet {

    private ReturnRequestDAO rDAO;
    private ReturnRequestDetailDAO dDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        rDAO = new ReturnRequestDAO();
        dDAO = new ReturnRequestDetailDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            handleViewDetail(request, response);
        } else if ("edit".equals(action)) {
            handleEditPage(request, response);
        } else {
            handleCreatePage(request, response);
        }
    }

    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdParam = request.getParameter("requestId");
        // Validate requestId parameter
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            // Get return request information
            ReturnRequest returnRequest = rDAO.getReturnRequestById(requestId);
            if (returnRequest == null) {
                request.setAttribute("flash_error", "Return request not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get return request details
            List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

            // Get related order information
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findWithItems(returnRequest.getOrderId());

            if (order == null) {
                request.setAttribute("flash_error", "Order not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // ✅ FIXED: Calculate total refund with null checks
            BigDecimal totalRefund = BigDecimal.ZERO; // Khởi tạo tổng tiền hoàn trả là 0

// Kiểm tra danh sách có dữ liệu không
            if (listDetail != null && !listDetail.isEmpty()) {
                // Duyệt từng phần tử trong danh sách
                for (ReturnRequestDetail detail : listDetail) {
                    BigDecimal amount = detail.getAmount(); // Lấy số tiền của từng chi tiết
                    if (amount != null) {
                        totalRefund = totalRefund.add(amount); // Cộng vào tổng
                    }
                    // Nếu amount là null thì bỏ qua, tổng giữ nguyên
                }
            }

// Sau vòng lặp, totalRefund là tổng tiền hoàn trả
            // ✅ FIXED: Check for full return with null safety
            boolean isFullReturn = false;
            if (order.getItems() != null && listDetail != null && !listDetail.isEmpty()) {
                isFullReturn = order.getItems().size() == listDetail.size();
            }

            // Optional: Subtract shipping fee if returning full order
            if (isFullReturn && order.getShippingFee() != null) {
                totalRefund = totalRefund.subtract(order.getShippingFee());
                if (totalRefund.compareTo(BigDecimal.ZERO) < 0) {
                    totalRefund = BigDecimal.ZERO;
                }
            }

            // Format dates for JSP
            if (returnRequest.getRequestDate() != null) {
                request.setAttribute("formattedRequestDate",
                        returnRequest.getRequestDate().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            if (returnRequest.getDecideDate() != null) {
                request.setAttribute("formattedDecideDate",
                        returnRequest.getDecideDate().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            if (order.getPlacedAt() != null) {
                request.setAttribute("formattedOrderDate",
                        order.getPlacedAt().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            request.setAttribute("returnRequest", returnRequest);
            request.setAttribute("returnRequestDetails", listDetail);
            request.setAttribute("order", order);
            request.setAttribute("totalRefund", totalRefund);

            request.getRequestDispatcher("/WEB-INF/views/customer/return-request/view-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
            response.sendRedirect(request.getContextPath() + "/orders");

        }
    }

    private void handleEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdParam = request.getParameter("requestId");

        // 1. VALIDATE REQUEST ID PARAMETER
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("flash_error", "Invalid return request ID");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            ReturnRequestDAO rDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO dDAO = new ReturnRequestDetailDAO();

            // 2. GET RETURN REQUEST
            ReturnRequest returnRequest = rDAO.getReturnRequestById(requestId);
            if (returnRequest == null) {
                request.getSession().setAttribute("flash_error", "Return request not found");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // 3. CHECK STATUS - ONLY PENDING CAN BE EDITED
            if (!"Pending".equalsIgnoreCase(returnRequest.getReturnStatus())) {
                request.getSession().setAttribute("flash_error", "Only pending requests can be edited");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=detail&requestId=" + requestId);
                return;
            }

            // 4. GET RETURN REQUEST DETAILS
            List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

            // 5. GET RELATED ORDER
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findWithItems(returnRequest.getOrderId());

            if (order == null) {
                request.getSession().setAttribute("flash_error", "Order not found");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            if (order.getItems() == null || order.getItems().isEmpty()) {
                request.getSession().setAttribute("flash_error", "Order has no items");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // 6. MAP SELECTED PRODUCT VARIANTS
            Set<Integer> selectedOrderDetailIds = new HashSet<>();
            if (listDetail != null) {
                for (ReturnRequestDetail detail : listDetail) {
                    for (OrderDetail item : order.getItems()) {
                        if (item.getProductVariantId() == detail.getProductVariantId()) {
                            selectedOrderDetailIds.add(item.getOrderDetailId());
                        }
                    }
                }
            }

            // 7. FORMAT ORDER DATE
            if (order.getPlacedAt() != null) {
                request.setAttribute("formattedOrderDate",
                        order.getPlacedAt().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            // 8. SET ATTRIBUTES AND FORWARD
            request.setAttribute("selectedOrderDetailIds", selectedOrderDetailIds);
            request.setAttribute("returnRequest", returnRequest);
            request.setAttribute("returnRequestDetails", listDetail);
            request.setAttribute("order", order);

            request.getRequestDispatcher("/WEB-INF/views/customer/return-request/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
            request.getSession().setAttribute("flash_error", "Invalid request ID format");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handleCreatePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdParam = request.getParameter("orderId");
        // Validate orderId parameter
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/return-request");
            return;
        }
        try {
            int orderId = Integer.parseInt(orderIdParam);
            OrderDAO orderDAO = new OrderDAO();
            // Get order information
            Order order = orderDAO.findWithItems(orderId);
            if (order == null) {
                request.setAttribute("flash_error", "Order not found");
                response.sendRedirect(request.getContextPath() + "/return-request");
                return;
            }
            // Format order date for create page
            if (order.getPlacedAt() != null) {
                request.setAttribute("formattedOrderDate",
                        order.getPlacedAt().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/WEB-INF/views/customer/return-request/create.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid orderId format: " + orderIdParam, e);
            response.sendRedirect(request.getContextPath() + "/return-request");

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
        Customer customer = (Customer) session.getAttribute("customer");

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int sessionCustomerId = customer.getId();
        String action = request.getParameter("action");

        // ===== ACTION: CREATE =====
        if ("create".equals(action)) {
            handleCreatePost(request, response, customer.getId());
        } else if ("update".equals(action)) {
            handleUpdatePost(request, response);
        } else if ("delete".equals(action)) {
            handleDeletePost(request, response, sessionCustomerId);
        }

    }

    private void handleCreatePost(HttpServletRequest request, HttpServletResponse response, int customerId)
            throws ServletException, IOException {
        try {
            // 1. VALIDATE ORDER ID
            int orderId;
            try {
                orderId = Integer.parseInt(request.getParameter("orderId"));
                if (orderId <= 0) {
                    throw new Exception();
                }
            } catch (Exception e) {
                request.getSession().setAttribute("flash_error", "Invalid order ID");
                response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId);
                return;
            }
            // 2. CHECK IF RETURN REQUEST ALREADY EXISTS
            if (rDAO.existsByOrderId(orderId)) {
                request.getSession().setAttribute("flash_error", "A return request already exists for this order");
                response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId);
                return;
            }
            // 3. GET PARAMETERS (validation đã làm ở JSP)
            String reason = request.getParameter("reason");
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String accountHolder = request.getParameter("accountHolder");
            String note = request.getParameter("note");
            String[] selectedProducts = request.getParameterValues("productId");

            // 4. DOUBLE-CHECK CRITICAL DATA (an toàn phía server)
            if (selectedProducts == null || selectedProducts.length == 0) {
                request.getSession().setAttribute("flash_error", "Please select at least one item to return");
                response.sendRedirect(request.getContextPath() + "/return-request?action=form&orderId=" + orderId);
                return;
            }
            // 5. PREPARE BANK INFO
            String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
            // 6. CREATE RETURN REQUEST OBJECT
            ReturnRequest rr = new ReturnRequest();
            rr.setOrderId(orderId);
            rr.setCustomerId(customerId);
            rr.setReturnStatus("PENDING");
            rr.setReason(reason);
            rr.setBankAccountInfo(bankInfo);
            rr.setNote(note);

            // 7. PREPARE DETAILS
            List<ReturnRequestDetail> details = new ArrayList<>();
            for (String pid : selectedProducts) {
                int productVariantId = Integer.parseInt(pid);
                int returnQty = Integer.parseInt(request.getParameter("qty_" + pid));
                String priceParam = request.getParameter("price_" + pid);
                BigDecimal itemPrice = new BigDecimal(priceParam);
                BigDecimal amount = itemPrice.multiply(new BigDecimal(returnQty));

                ReturnRequestDetail detail = new ReturnRequestDetail();
                detail.setProductVariantId(productVariantId);
                detail.setQuantity(returnQty);
                detail.setAmount(amount);
                detail.setNote(note);

                details.add(detail);
            }
            // 8. CREATE REQUEST AND DETAILS IN TRANSACTION
            int requestId = rDAO.createReturnRequestWithDetails(rr, details);
            if (requestId <= 0) {
                request.getSession().setAttribute("flash_error", "Failed to create return request. Please try again.");
                response.sendRedirect(request.getContextPath() + "/return-request?action=form&orderId=" + orderId);
                return;
            }
            // 9. SUCCESS REDIRECT
            request.getSession().setAttribute("flash", "Return request submitted successfully! We will process your request soon.");
            response.sendRedirect(request.getContextPath() + "/orders");

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Invalid number format", e);
            request.getSession().setAttribute("flash_error", "Invalid input format. Please check your data.");
            response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId);

        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Database error creating return request", ex);
            request.getSession().setAttribute("flash_error", "System error occurred. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId);
        }
    }

   private void handleUpdatePost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String requestIdParam = request.getParameter("requestId");

    // 1. VALIDATE REQUEST ID PARAMETER
    if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
        request.getSession().setAttribute("flash_error", "Invalid return request ID");
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    try {
        // 2. GET PARAMETERS
        int requestId = Integer.parseInt(requestIdParam);
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String reason = request.getParameter("reason");
        String bankName = request.getParameter("bankName");
        String accountNumber = request.getParameter("accountNumber");
        String accountHolder = request.getParameter("accountHolder");
        String note = request.getParameter("note");
        String[] selectedOrderDetailIds = request.getParameterValues("orderDetailIds");

        // 3. CHECK RETURN REQUEST EXISTS & IS PENDING
        ReturnRequest existingRequest = rDAO.getReturnRequestById(requestId);

        if (existingRequest == null) {
            request.getSession().setAttribute("flash_error", "Return request not found");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        if (!"Pending".equalsIgnoreCase(existingRequest.getReturnStatus())) {
            request.getSession().setAttribute("flash_error", "Only pending requests can be edited");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=detail&requestId=" + requestId);
            return;
        }

        // 4. VALIDATE SELECTED ITEMS (critical server-side check)
        if (selectedOrderDetailIds == null || selectedOrderDetailIds.length == 0) {
            request.getSession().setAttribute("flash_error", "Please select at least one item to return");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=edit&requestId=" + requestId);
            return;
        }

        // 5. GET ORDER TO MAP ORDER DETAILS
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.findWithItems(existingRequest.getOrderId());

        if (order == null || order.getItems() == null) {
            request.getSession().setAttribute("flash_error", "Order not found");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // 6. VALIDATE QUANTITIES FOR SELECTED ITEMS
        Map<Integer, Integer> returnQuantities = new HashMap<>();

        for (String orderDetailIdStr : selectedOrderDetailIds) {
            int orderDetailId = Integer.parseInt(orderDetailIdStr);

            // Get quantity from form
            String qtyParam = request.getParameter("qty_" + orderDetailId);

            if (qtyParam == null || qtyParam.trim().isEmpty()) {
                request.getSession().setAttribute("flash_error", "Quantity not provided for selected item");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=edit&requestId=" + requestId);
                return;
            }

            try {
                int returnQty = Integer.parseInt(qtyParam);

                // Find the order item to get max quantity
                OrderDetail orderItem = order.getItems().stream()
                        .filter(item -> item.getOrderDetailId() == orderDetailId)
                        .findFirst()
                        .orElse(null);

                if (orderItem == null) {
                    request.getSession().setAttribute("flash_error", "Order item not found");
                    response.sendRedirect(request.getContextPath()
                            + "/return-request?action=edit&requestId=" + requestId);
                    return;
                }

                // Validate quantity range (server-side safety check)
                if (returnQty < 1 || returnQty > orderItem.getDetailQuantity()) {
                    request.getSession().setAttribute("flash_error",
                            String.format("Invalid return quantity for %s. Must be between 1 and %d",
                                    orderItem.getProductName(), orderItem.getDetailQuantity()));
                    response.sendRedirect(request.getContextPath()
                            + "/return-request?action=edit&requestId=" + requestId);
                    return;
                }

                returnQuantities.put(orderDetailId, returnQty);

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("flash_error", "Invalid quantity format");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=edit&requestId=" + requestId);
                return;
            }
        }

        // 7. UPDATE RETURN REQUEST
        String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
        int updateResult = rDAO.updateReturnRequest(requestId, customerId, reason, bankInfo, note);

        if (updateResult > 0) {
            // 8. DELETE OLD DETAILS
            dDAO.deleteDetailsByReturnRequestId(requestId);

            // 9. INSERT NEW DETAILS
            for (String orderDetailIdStr : selectedOrderDetailIds) {
                int orderDetailId = Integer.parseInt(orderDetailIdStr);

                // Find corresponding order item
                OrderDetail orderItem = order.getItems().stream()
                        .filter(item -> item.getOrderDetailId() == orderDetailId)
                        .findFirst()
                        .orElse(null);

                if (orderItem != null) {
                    int returnQty = returnQuantities.get(orderDetailId);
                    BigDecimal amount = orderItem.getDetailPrice()
                            .multiply(BigDecimal.valueOf(returnQty));

                    ReturnRequestDetail detail = new ReturnRequestDetail();
                    detail.setReturnRequestId(requestId);
                    detail.setProductVariantId(orderItem.getProductVariantId());
                    detail.setQuantity(returnQty);
                    detail.setAmount(amount);
                    detail.setNote(null);

                    dDAO.addReturnRequestDetail(detail);
                }
            }

            // 10. SUCCESS REDIRECT
            request.getSession().setAttribute("flash", "Return request updated successfully!");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=detail&requestId=" + requestId);
        } else {
            request.getSession().setAttribute("flash_error", "Failed to update return request. Please try again.");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=edit&requestId=" + requestId);
        }

    } catch (NumberFormatException e) {
        Logger.getLogger(ReturnRequestServlet.class.getName())
                .log(Level.WARNING, "Invalid parameter format", e);
        request.getSession().setAttribute("flash_error", "Invalid input format");
        response.sendRedirect(request.getContextPath() + "/orders");

    } catch (SQLException e) {
        Logger.getLogger(ReturnRequestServlet.class.getName())
                .log(Level.SEVERE, "Database error while updating return request", e);
        request.getSession().setAttribute("flash_error", "System error occurred. Please try again later.");
        response.sendRedirect(request.getContextPath() + "/orders");
    }
}

   private void handleDeletePost(HttpServletRequest request, HttpServletResponse response, int customerId)
        throws ServletException, IOException {
    
    String requestIdParam = request.getParameter("requestId");
    
    // 1. VALIDATE REQUEST ID PARAMETER
    if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
        request.getSession().setAttribute("flash_error", "Invalid return request ID");
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }
    
    try {
        int requestId = Integer.parseInt(requestIdParam);
        
        // 2. CHECK IF RETURN REQUEST EXISTS
        ReturnRequest existingRequest = rDAO.getReturnRequestById(requestId);
        if (existingRequest == null) {
            request.getSession().setAttribute("flash_error", "Return request not found");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        // 3. CHECK IF REQUEST BELONGS TO CUSTOMER
        if (existingRequest.getCustomerId() != customerId) {
            request.getSession().setAttribute("flash_error", "You don't have permission to delete this request");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        // 4. CHECK IF STATUS IS PENDING (can only delete pending requests)
        if (!"Pending".equalsIgnoreCase(existingRequest.getReturnStatus())) {
            request.getSession().setAttribute("flash_error", "Only pending requests can be deleted");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=detail&requestId=" + requestId);
            return;
        }
        
        
        // 6. DELETE RETURN REQUEST
        int deleteResult = rDAO.deleteReturnRequest(requestId, customerId);
        
        if (deleteResult > 0) {
            request.getSession().setAttribute("flash", "Return request cancelled successfully");
            response.sendRedirect(request.getContextPath() + "/orders");
        } else {
            request.getSession().setAttribute("flash_error", "Failed to cancel return request. Please try again.");
            response.sendRedirect(request.getContextPath()
                    + "/return-request?action=detail&requestId=" + requestId);
        }
        
    } catch (NumberFormatException e) {
        Logger.getLogger(ReturnRequestServlet.class.getName())
                .log(Level.WARNING, "Invalid requestId format", e);
        request.getSession().setAttribute("flash_error", "Invalid request ID format");
        response.sendRedirect(request.getContextPath() + "/orders");
        
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
