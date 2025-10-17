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
        String requestIdParam = request.getParameter("requestId");
        String orderIdParam = request.getParameter("orderId");

        // Handle detail view action
        if ("detail".equals(action)) {
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

                // ✅ Calculate total refund
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
                request.setAttribute("totalRefund", totalRefund); // ✅ ADDED

                request.getRequestDispatcher("/WEB-INF/views/customer/returnRequest/view-detail.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.WARNING, "Invalid requestId format: " + requestIdParam, e);
                response.sendRedirect(request.getContextPath() + "/customer/returnRequests");
                return;

            } catch (SQLException e) {
                Logger.getLogger(ReturnRequestServlet.class.getName())
                        .log(Level.SEVERE, "Database error while fetching return request", e);
                request.setAttribute("errorMessage", "System error occurred");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                        .forward(request, response);
                return;
            }
        }
      

        // Handle create return request (default action)
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

            // ✅ Format order date for create page
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
        if ("create".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String reason = request.getParameter("reason");
            String bankInfo = request.getParameter("bankAccountInfo");
            String note = request.getParameter("note");
            //Create request object
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

            try {
                // Get requestId
                int requestId = rrDAO.createReturnRequest(rr);

                String[] selectedProducts = request.getParameterValues("productId");
                if (selectedProducts != null) {
                    for (String pid : selectedProducts) {
                        int productVariantId = Integer.parseInt(pid);
                        int quantity = Integer.parseInt(request.getParameter("qty_" + pid));

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
                Logger.getLogger(ReturnRequestServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else if("confirrmEdit".equals(action)){
            
        }
        else if("delete".equals(action)){
            
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
