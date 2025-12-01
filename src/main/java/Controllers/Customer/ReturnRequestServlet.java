/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Customer;

import DAOs.OrderDAO;
import DAOs.ReturnRequestDAO;
import DAOs.ReturnRequestDetailDAO;
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
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ReturnRequestServlet", urlPatterns = {"/return-request"})
public class ReturnRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

            ReturnRequestDAO rDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO dDAO = new ReturnRequestDetailDAO();

            // Get return request information
            ReturnRequest returnRequest = rDAO.getReturnRequestById(requestId);
            if (returnRequest == null) {
                request.setAttribute("errorMessage", "Return request not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Get return request details
            List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

            // Get related order information
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findWithItems(returnRequest.getOrderId());

            if (order == null) {
                request.setAttribute("errorMessage", "Order not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // ✅ FIXED: Calculate total refund with null checks
            BigDecimal totalRefund = BigDecimal.ZERO;
            if (listDetail != null && !listDetail.isEmpty()) {
                totalRefund = listDetail.stream()
                        .map(detail -> detail.getAmount() != null ? detail.getAmount() : BigDecimal.ZERO)
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
            }

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

        } catch (Exception e) {
            // ✅ ADDED: Catch-all for unexpected errors
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Unexpected error in handleViewDetail", e);
            request.setAttribute("errorMessage", "An unexpected error occurred");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private void handleEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestIdParam = request.getParameter("requestId");

        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            ReturnRequestDAO rDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO dDAO = new ReturnRequestDetailDAO();

            // Get return request information
            ReturnRequest returnRequest = rDAO.getReturnRequestById(requestId);

            if (returnRequest == null) {
                // ✅ FIXED: Forward to error page instead of redirect (to keep errorMessage)
                request.setAttribute("errorMessage", "Return request not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Only allow editing pending requests
            if (!"Pending".equalsIgnoreCase(returnRequest.getReturnStatus())) {
                // ✅ FIXED: Use session to preserve message across redirect
                request.getSession().setAttribute("errorMessage", "Only pending requests can be edited");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=detail&requestId=" + requestId);
                return;
            }

            // Get return request details
            List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

            // Get related order information
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findWithItems(returnRequest.getOrderId());

            // ✅ ADDED: Validate order exists
            if (order == null) {
                request.setAttribute("errorMessage", "Order not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // ✅ ADDED: Validate order has items
            if (order.getItems() == null || order.getItems().isEmpty()) {
                request.setAttribute("errorMessage", "Order has no items");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // ✅ FIXED: Map productVariantId to orderDetailId with null safety
            Set<Integer> selectedOrderDetailIds = new HashSet<>();
            if (listDetail != null && !listDetail.isEmpty()) {
                for (ReturnRequestDetail detail : listDetail) {
                    order.getItems().stream()
                            .filter(item -> item.getProductVariantId() == detail.getProductVariantId())
                            .forEach(item -> selectedOrderDetailIds.add(item.getOrderDetailId()));
                }
            }

            // Format order date
            if (order.getPlacedAt() != null) {
                request.setAttribute("formattedOrderDate",
                        order.getPlacedAt().format(
                                DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                        )
                );
            }

            request.setAttribute("selectedOrderDetailIds", selectedOrderDetailIds);
            request.setAttribute("returnRequest", returnRequest);
            request.setAttribute("returnRequestDetails", listDetail);
            request.setAttribute("order", order);

            request.getRequestDispatcher("/WEB-INF/views/customer/return-request/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
            response.sendRedirect(request.getContextPath() + "/orders");

        } catch (Exception e) {
            // ✅ ADDED: Catch-all for unexpected errors
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Unexpected error in handleEditPage", e);
            request.setAttribute("errorMessage", "An unexpected error occurred");
            try {
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Failed to forward to error page", ex);
                response.sendRedirect(request.getContextPath() + "/orders");
            }
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
                request.setAttribute("errorMessage", "Order not found");
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
        String action = request.getParameter("action");

        // ===== ACTION: CREATE =====
        if ("create".equals(action)) {
            handleCreatePost(request, response);
        } else if ("update".equals(action)) {
            handleUpdatePost(request, response);
        } else if ("delete".equals(action)) {
            handleDeletePost(request, response);
        }

    }

    private void handleCreatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1-5. VALIDATION (giữ nguyên code cũ)
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int customerId = 1;
            String reason = request.getParameter("reason");
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String accountHolder = request.getParameter("accountHolder");
            String note = request.getParameter("note");

            // ... (các validation code cũ) ...
            ReturnRequestDAO rrDAO = new ReturnRequestDAO();

            if (rrDAO.existsByOrderId(orderId)) {
                request.setAttribute("errorMessage", "A return request already exists for this order");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            String[] selectedProducts = request.getParameterValues("productId");
            if (selectedProducts == null || selectedProducts.length == 0) {
                request.setAttribute("errorMessage", "Please select at least one item to return");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // Validate quantity
            for (String pid : selectedProducts) {
                // ... (validation code cũ) ...
            }

            // 6. CHUẨN BỊ DỮ LIỆU
            String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
            ReturnRequest rr = new ReturnRequest();
            rr.setOrderId(orderId);
            rr.setCustomerId(customerId);
            rr.setReturnStatus("PENDING");
            rr.setReason(reason);
            rr.setBankAccountInfo(bankInfo);
            rr.setNote(note);

            // 7. CHUẨN BỊ DETAILS
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
                detail.setNote(null);

                details.add(detail);
            }

            // 8. TẠO REQUEST VÀ DETAILS TRONG 1 TRANSACTION
            int requestId = rrDAO.createReturnRequestWithDetails(rr, details);

            if (requestId <= 0) {
                request.setAttribute("errorMessage", "Failed to create return request");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            // 9. REDIRECT THÀNH CÔNG
            response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId + "&success=return_created");

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Invalid number format", e);
            request.setAttribute("errorMessage", "Invalid input format");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Database error creating return request", ex);
            request.setAttribute("errorMessage", "System error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private void handleUpdatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdParam = request.getParameter("requestId");

        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            // 1. GET PARAMETERS
            int requestId = Integer.parseInt(requestIdParam);
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String reason = request.getParameter("reason");
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String accountHolder = request.getParameter("accountHolder");
            String note = request.getParameter("note");

            // ✅ FIXED: Get orderDetailIds from JSP (not productVariantId)
            String[] selectedOrderDetailIds = request.getParameterValues("orderDetailIds");

            // 2. VALIDATE INPUT
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please select a return reason");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            if (bankName == null || accountNumber == null || accountHolder == null
                    || bankName.trim().isEmpty() || accountNumber.trim().isEmpty()
                    || accountHolder.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please provide complete bank information");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            ReturnRequestDAO rrDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO detailDAO = new ReturnRequestDetailDAO();

            // 3. CHECK RETURN REQUEST EXISTS & IS PENDING
            ReturnRequest existingRequest = rrDAO.getReturnRequestById(requestId);

            if (existingRequest == null) {
                request.setAttribute("errorMessage", "Return request not found");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            if (!"Pending".equalsIgnoreCase(existingRequest.getReturnStatus())) {
                request.setAttribute("errorMessage", "Only pending requests can be edited");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=detail&requestId=" + requestId);
                return;
            }

            // 4. VALIDATE SELECTED ITEMS
            if (selectedOrderDetailIds == null || selectedOrderDetailIds.length == 0) {
                request.setAttribute("errorMessage", "Please select at least one item to return");

                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.findWithItems(existingRequest.getOrderId());
                request.setAttribute("order", order);
                request.setAttribute("returnRequest", existingRequest);

                List<ReturnRequestDetail> listDetail = detailDAO.getDetailsByReturnRequestId(requestId);
                request.setAttribute("returnRequestDetails", listDetail);

                // Map selected items for re-display
                Set<Integer> selectedIds = new HashSet<>();
                if (order != null && order.getItems() != null && listDetail != null) {
                    for (ReturnRequestDetail detail : listDetail) {
                        order.getItems().stream()
                                .filter(item -> item.getProductVariantId() == detail.getProductVariantId())
                                .forEach(item -> selectedIds.add(item.getOrderDetailId()));
                    }
                }
                request.setAttribute("selectedOrderDetailIds", selectedIds);

                // Format order date
                if (order != null && order.getPlacedAt() != null) {
                    request.setAttribute("formattedOrderDate",
                            order.getPlacedAt().format(
                                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                            )
                    );
                }

                request.getRequestDispatcher("/WEB-INF/views/customer/return-request/edit.jsp")
                        .forward(request, response);
                return;
            }

            // 5. GET ORDER TO MAP ORDER DETAILS
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.findWithItems(existingRequest.getOrderId());

            if (order == null || order.getItems() == null) {
                request.setAttribute("errorMessage", "Order not found");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // 6. UPDATE RETURN REQUEST
            String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
            int updateResult = rrDAO.updateReturnRequest(requestId, customerId, reason, bankInfo, note);

            if (updateResult > 0) {
                // 7. DELETE OLD DETAILS
                detailDAO.deleteDetailsByReturnRequestId(requestId);

                // 8. INSERT NEW DETAILS
                for (String orderDetailIdStr : selectedOrderDetailIds) {
                    int orderDetailId = Integer.parseInt(orderDetailIdStr);

                    // ✅ FIXED: Find corresponding order item to get all info
                    OrderDetail orderItem = order.getItems().stream()
                            .filter(item -> item.getOrderDetailId() == orderDetailId)
                            .findFirst()
                            .orElse(null);

                    if (orderItem != null) {
                        // Calculate amount
                        BigDecimal amount = orderItem.getDetailPrice()
                                .multiply(BigDecimal.valueOf(orderItem.getDetailQuantity()));

                        ReturnRequestDetail detail = new ReturnRequestDetail();
                        detail.setReturnRequestId(requestId);
                        detail.setProductVariantId(orderItem.getProductVariantId());
                        detail.setQuantity(orderItem.getDetailQuantity());
                        detail.setAmount(amount);
                        detail.setNote(null);

                        detailDAO.addReturnRequestDetail(detail);
                    }
                }

                // 9. REDIRECT SUCCESS
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=detail&requestId=" + requestId);
            } else {
                request.setAttribute("errorMessage", "Failed to update return request");
                response.sendRedirect(request.getContextPath()
                        + "/return-request?action=detail&requestId=" + requestId);
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid parameter format", e);
            response.sendRedirect(request.getContextPath() + "/orders");

        } catch (SQLException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Database error while updating return request", e);
            request.setAttribute("errorMessage", "System error occurred");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdParam = request.getParameter("requestId");

        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/return-request");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            int customerId = Integer.parseInt(request.getParameter("customerId")); // Cần thêm customerId

            ReturnRequestDAO rrDAO = new ReturnRequestDAO();

            // Check if return request exists and is pending
            ReturnRequest existingRequest = rrDAO.getReturnRequestById(requestId);

            if (existingRequest == null) {
                request.setAttribute("errorMessage", "Return request not found");
                response.sendRedirect(request.getContextPath() + "/return-request");
                return;
            }

            // Delete return request (this will only work if status is PENDING - as per DAO method)
            int deleteResult = rrDAO.deleteReturnRequest(requestId, customerId);

            if (deleteResult > 0) {
                // Also delete related details
                ReturnRequestDetailDAO detailDAO = new ReturnRequestDetailDAO();
                detailDAO.deleteDetailsByReturnRequestId(requestId);

                response.sendRedirect(request.getContextPath() + "/orders");
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.WARNING, "Invalid requestId format", e);
            response.sendRedirect(request.getContextPath() + "/return-request");

        } catch (SQLException e) {
            Logger.getLogger(ReturnRequestServlet.class.getName())
                    .log(Level.SEVERE, "Database error while cancelling return request", e);
            request.setAttribute("errorMessage", "System error occurred");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                    .forward(request, response);
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
