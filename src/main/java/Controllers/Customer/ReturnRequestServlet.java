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
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ReturnRequestServlet", urlPatterns = {"/returnRequest"})
public class ReturnRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            String requestIdParam = request.getParameter("requestId");

            // Validate requestId parameter
            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
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
                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                    return;
                }

                // Get return request details
                List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

                // Get related order information
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.findWithItems(returnRequest.getOrderId());

                // Calculate total refund
                BigDecimal totalRefund = order.getItems().stream()
                        .map(item -> item.getDetailPrice().multiply(BigDecimal.valueOf(item.getDetailQuantity())))
                        .reduce(BigDecimal.ZERO, BigDecimal::add)
                        .subtract(order.getShippingFee());

                if (totalRefund.compareTo(BigDecimal.ZERO) < 0) {
                    totalRefund = BigDecimal.ZERO;
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

                if (order != null && order.getPlacedAt() != null) {
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

                request.getRequestDispatcher("/WEB-INF/views/customer/returnRequest/view-detail.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while fetching return request", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }

        } else if ("edit".equals(action)) {
            String requestIdParam = request.getParameter("requestId");

            // Validate requestId parameter
            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
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
                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                    return;
                }

                // Only allow editing pending requests
                if (!"PENDING".equals(returnRequest.getReturnStatus())) {
                    request.setAttribute("errorMessage", "Only pending requests can be edited");
                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                    return;
                }

                // Get return request details
                List<ReturnRequestDetail> listDetail = dDAO.getDetailsByReturnRequestId(requestId);

                // Get related order information
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.findWithItems(returnRequest.getOrderId());

                // Format order date
                if (order != null && order.getPlacedAt() != null) {
                    request.setAttribute("formattedOrderDate",
                            order.getPlacedAt().format(
                                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                            )
                    );
                }

                request.setAttribute("returnRequest", returnRequest);
                request.setAttribute("returnRequestDetails", listDetail);
                request.setAttribute("order", order);

                request.getRequestDispatcher("/WEB-INF/views/customer/returnRequest/edit.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while fetching return request", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }

            // ===== ACTION: CREATE (default) =====
        } else {
            String orderIdParam = request.getParameter("orderId");

            // Validate orderId parameter
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/orders");
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdParam);
                OrderDAO orderDAO = new OrderDAO();

                // Get order information
                Order order = orderDAO.findWithItems(orderId);

                if (order == null) {
                    request.setAttribute("errorMessage", "Order not found");
                    response.sendRedirect(request.getContextPath() + "/customer/orders");
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
                request.getRequestDispatcher("/WEB-INF/views/customer/returnRequest/create.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid orderId format: " + orderIdParam, e);
                response.sendRedirect(request.getContextPath() + "/customer/orders");

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while fetching order", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }
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
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String reason = request.getParameter("reason");
            String bankName = request.getParameter("bankName");
            String accountNumber = request.getParameter("accountNumber");
            String accountHolder = request.getParameter("accountHolder");
            String note = request.getParameter("note");
            String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
            // Create request object
            ReturnRequest rr = new ReturnRequest();
            rr.setOrderId(orderId);
            rr.setCustomerId(customerId);
            rr.setReturnStatus("PENDING");
            rr.setRequestDate(LocalDateTime.now());
            rr.setReason(reason);
            rr.setBankAccountInfo(bankInfo);
            rr.setNote(note);

            ReturnRequestDAO rrDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO detaildao = new ReturnRequestDetailDAO();
            Order order = new Order();

            try {
                // Get requestId

                int requestId = rrDAO.createReturnRequest(rr);
                String[] selectedProducts = request.getParameterValues("productId");
                if (selectedProducts != null) {
                    for (String pid : selectedProducts) {
                        int productVariantId = Integer.parseInt(pid);
                        int quantity = Integer.parseInt(request.getParameter("qty_" + pid));

                        // Lấy giá sản phẩm
                        BigDecimal amount = order.getTotalAmount();                        
                        ReturnRequestDetail d = new ReturnRequestDetail();
                        d.setReturnRequestId(requestId);
                        d.setProductVariantId(productVariantId);
                        d.setQuantity(quantity);
                        d.setAmount(BigDecimal.ZERO);
                        d.setCreatedAt(LocalDateTime.now());
                        d.setUpdatedAt(LocalDateTime.now());

                        detaildao.addReturnRequestDetail(d);
                    }
                }

                response.sendRedirect(request.getContextPath() + "/orders?id=" + customerId);

            } catch (SQLException ex) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Error creating return request", ex);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }

            // ===== ACTION: UPDATE =====
        } else if ("update".equals(action)) {
            String requestIdParam = request.getParameter("requestId");

            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                return;
            }

            try {
                int requestId = Integer.parseInt(requestIdParam);
                int customerId = Integer.parseInt(request.getParameter("customerId")); // Cần thêm customerId vào form
                String reason = request.getParameter("reason");
                String bankName = request.getParameter("bankName");
                String accountNumber = request.getParameter("accountNumber");
                String accountHolder = request.getParameter("accountHolder");
                String note = request.getParameter("note");
                String bankInfo = bankName + "_" + accountNumber + "_" + accountHolder;
                String[] selectedProductVariantIds = request.getParameterValues("orderDetailIds");

                ReturnRequestDAO rrDAO = new ReturnRequestDAO();
                ReturnRequestDetailDAO detailDAO = new ReturnRequestDetailDAO();

                // Check if return request exists and is pending
                ReturnRequest existingRequest = rrDAO.getReturnRequestById(requestId);

                if (existingRequest == null) {
                    request.setAttribute("errorMessage", "Return request not found");
                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                    return;
                }

                if (!"PENDING".equals(existingRequest.getReturnStatus())) {
                    request.setAttribute("errorMessage", "Only pending requests can be edited");
                    response.sendRedirect(request.getContextPath() + "/returnRequest?action=detail&requestId=" + requestId);
                    return;
                }

                // Validate selected items
                if (selectedProductVariantIds == null || selectedProductVariantIds.length == 0) {
                    request.setAttribute("errorMessage", "Please select at least one item to return");
                    request.setAttribute("returnRequest", existingRequest);

                    OrderDAO orderDAO = new OrderDAO();
                    Order order = orderDAO.findWithItems(existingRequest.getOrderId());
                    request.setAttribute("order", order);

                    List<ReturnRequestDetail> listDetail = detailDAO.getDetailsByReturnRequestId(requestId);
                    request.setAttribute("returnRequestDetails", listDetail);

                    request.getRequestDispatcher("/WEB-INF/views/customer/returnRequest/edit.jsp")
                            .forward(request, response);
                    return;
                }

                // Update return request using existing method
                int updateResult = rrDAO.updateReturnRequest(requestId, customerId, reason, bankInfo, note);

                if (updateResult > 0) {
                    // Delete old details
                    detailDAO.deleteDetailsByReturnRequestId(requestId);

                    // Insert new details
                    for (String productVariantId : selectedProductVariantIds) {
                        int variantId = Integer.parseInt(productVariantId);

                        // Get quantity from request if needed
                        String qtyParam = request.getParameter("qty_" + productVariantId);
                        int quantity = (qtyParam != null && !qtyParam.isEmpty())
                                ? Integer.parseInt(qtyParam)
                                : 1; // default quantity

                        ReturnRequestDetail detail = new ReturnRequestDetail();
                        detail.setReturnRequestId(requestId);
                        detail.setProductVariantId(variantId);
                        detail.setQuantity(quantity);
                        detail.setAmount(BigDecimal.ZERO);
                        detail.setCreatedAt(LocalDateTime.now());
                        detail.setUpdatedAt(LocalDateTime.now());

                        detailDAO.addReturnRequestDetail(detail);
                    }

                    // Redirect to detail page
                    response.sendRedirect(request.getContextPath() + "/returnRequest?action=detail&requestId=" + requestId);
                } else {
                    request.setAttribute("errorMessage", "Failed to update return request");
                    response.sendRedirect(request.getContextPath() + "/returnRequest?action=detail&requestId=" + requestId);
                }

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid parameter format", e);
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while updating return request", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }

        } else if ("delete".equals(action)) {
            String requestIdParam = request.getParameter("requestId");

            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
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
                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                    return;
                }

                if (!"PENDING".equals(existingRequest.getReturnStatus())) {
                    request.setAttribute("errorMessage", "Only pending requests can be cancelled");
                    response.sendRedirect(request.getContextPath() + "/returnRequest?action=detail&requestId=" + requestId);
                    return;
                }

                // Delete return request (this will only work if status is PENDING - as per DAO method)
                int deleteResult = rrDAO.deleteReturnRequest(requestId, customerId);

                if (deleteResult > 0) {
                    // Also delete related details
                    ReturnRequestDetailDAO detailDAO = new ReturnRequestDetailDAO();
                    detailDAO.deleteDetailsByReturnRequestId(requestId);

                    response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                } else {
                    request.setAttribute("errorMessage", "Failed to cancel return request");
                    response.sendRedirect(request.getContextPath() + "/returnRequest?action=detail&requestId=" + requestId);
                }

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid requestId format", e);
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while cancelling return request", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
            }
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
