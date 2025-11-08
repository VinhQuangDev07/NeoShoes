/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ReturnRequestDAO;
import DAOs.ReturnRequestDetailDAO;
import Models.ReturnRequest;
import Models.ReturnRequestDetail;
import Models.Staff;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ManageReturnRequestServlet", urlPatterns = {"/staff/manage-return-request"})
public class ManageReturnRequestServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        if (!staff.isAdmin()) {
            session.setAttribute("flash_info", "Access Denied - Admin only");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }
        String action = request.getParameter("action");

        if (("detail".equals(action))) {
            String idParam = request.getParameter("requestId");

            // ✅ FIX 1: Validate idParam trước khi parseInt
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Request ID is required");
                request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/list.jsp")
                        .forward(request, response);
                return;
            }

            int requestId;
            try {
                requestId = Integer.parseInt(idParam.trim());
                // ✅ FIX 2: Validate requestId > 0
                if (requestId <= 0) {
                    request.setAttribute("errorMessage", "Invalid Request ID");
                    request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/list.jsp")
                            .forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Request ID format");
                request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/list.jsp")
                        .forward(request, response);
                return;
            }

            ReturnRequestDAO rrDAO = new ReturnRequestDAO();
            ReturnRequest returnRequest = rrDAO.getReturnRequestById(requestId);

            // ✅ FIX 3: Check nếu returnRequest không tồn tại
            if (returnRequest == null) {
                request.setAttribute("errorMessage", "Return request #" + requestId + " not found");
                request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/list.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("returnRequest", returnRequest);

            ReturnRequestDetailDAO rrdDAO = new ReturnRequestDetailDAO();
            List<ReturnRequestDetail> returnDetails = rrdDAO.getDetailsByReturnRequestId(returnRequest.getReturnRequestId());

            // ✅ FIX 4: Đảm bảo returnDetails không null
            if (returnDetails == null) {
                returnDetails = new ArrayList<>();
            }
            request.setAttribute("returnDetails", returnDetails);

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/request-detail.jsp")
                    .forward(request, response);

        } else {
            ReturnRequestDAO rDAO = new ReturnRequestDAO();
            List<ReturnRequest> requests = rDAO.getAllReturnRequests();

            // ✅ FIX 5: Đảm bảo requests không null
            if (requests == null) {
                requests = new ArrayList<>();
            }

            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam.trim());
                    // ✅ FIX 6: Validate currentPage > 0
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int recordsPerPage = 10;
            int totalRecords = requests.size();

            // ✅ FIX 7: Logic để tránh totalPages = 0
            int totalPages = totalRecords > 0
                    ? (int) Math.ceil((double) totalRecords / recordsPerPage)
                    : 1;

            // ✅ FIX 8: Đảm bảo currentPage trong phạm vi hợp lệ
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            int startIndex = (currentPage - 1) * recordsPerPage;
            int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);

            // ✅ FIX 9: Kiểm tra startIndex hợp lệ trước khi subList
            List<ReturnRequest> pageData;
            if (startIndex >= 0 && startIndex < totalRecords) {
                pageData = requests.subList(startIndex, endIndex);
            } else {
                pageData = new ArrayList<>();
            }

            // Set all required attributes
            request.setAttribute("requests", pageData);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            request.setAttribute("baseUrl", request.getRequestURI());

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/list.jsp")
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
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        if (!staff.isAdmin()) {
            session.setAttribute("flash_info", "Access Denied - Admin only");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            // ✅ FIX 1: Validate requestId parameter
            String requestIdParam = request.getParameter("requestId");
            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Request ID is required");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            int requestId;
            try {
                requestId = Integer.parseInt(requestIdParam.trim());
                // ✅ FIX 2: Validate requestId > 0
                if (requestId <= 0) {
                    session.setAttribute("errorMessage", "Invalid Request ID");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Request ID format");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            // ✅ FIX 3: Validate status parameter
            String newStatus = request.getParameter("status");
            if (newStatus == null || newStatus.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Status is required");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            newStatus = newStatus.trim();
            // ✅ FIX 4: Validate status value
            if (!newStatus.equals("PENDING") && !newStatus.equals("APPROVED") && !newStatus.equals("REJECTED")) {
                session.setAttribute("errorMessage", "Invalid status. Must be PENDING, APPROVED, or REJECTED");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            try {
                ReturnRequestDAO rrDAO = new ReturnRequestDAO();

                // ✅ FIX 5: Check return request tồn tại trước khi update
                ReturnRequest returnRequest = rrDAO.getReturnRequestById(requestId);
                if (returnRequest == null) {
                    session.setAttribute("errorMessage", "Return request #" + requestId + " not found");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }

                // ✅ FIX 6: Validate status transition (business logic)
                String currentStatus = returnRequest.getReturnStatus();
                // Không cho phép thay đổi từ APPROVED/REJECTED (đã finalized)
                if (("APPROVED".equals(currentStatus) || "REJECTED".equals(currentStatus))
                        && !newStatus.equals(currentStatus)) {
                    session.setAttribute("errorMessage",
                            "Cannot change status from " + currentStatus + ". Request is already finalized");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }

                // Update status
                int result = rrDAO.updateReturnRequestStatusByAdmin(requestId, newStatus);

                // ✅ FIX 7: Chỉ xử lý details nếu update thành công
                if (result > 0) {
                    ReturnRequestDetailDAO rrdDAO = new ReturnRequestDetailDAO();
                    List<ReturnRequestDetail> details = rrdDAO.getDetailsByReturnRequestId(requestId);

                    // ✅ FIX 8: Check details null
                    if (details != null && !details.isEmpty()) {
                        // ✅ FIX 9: Cập nhật status/refund date cho details
                        // Chỉ update refund date nếu status = APPROVED
                        if ("APPROVED".equals(newStatus)) {
                            rrdDAO.updateRefundDateByRequestId(requestId);
                        }
                    }

                    session.setAttribute("successMessage",
                            "Return request #" + requestId + " status updated to " + newStatus + " successfully");
                } else {
                    session.setAttribute("errorMessage", "Failed to update status. Please try again");
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Error updating status: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");

        } else if ("delete".equals(action)) {
            // ✅ FIX 10: Validate requestId
            String requestIdParam = request.getParameter("requestId");
            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Request ID is required");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            int requestId;
            try {
                requestId = Integer.parseInt(requestIdParam.trim());
                if (requestId <= 0) {
                    session.setAttribute("errorMessage", "Invalid Request ID");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Request ID format");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            // ✅ FIX 11: Validate orderId
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Order ID is required");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            int orderId;
            try {
                orderId = Integer.parseInt(orderIdParam.trim());
                if (orderId <= 0) {
                    session.setAttribute("errorMessage", "Invalid Order ID");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid Order ID format");
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                return;
            }

            try {
                ReturnRequestDAO rrDAO = new ReturnRequestDAO();

                // ✅ FIX 12: Check return request tồn tại
                ReturnRequest returnRequest = rrDAO.getReturnRequestById(requestId);
                if (returnRequest == null) {
                    session.setAttribute("errorMessage", "Return request #" + requestId + " not found");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }

                // ✅ FIX 13: Validate orderId khớp với returnRequest
                if (returnRequest.getOrderId() != orderId) {
                    session.setAttribute("errorMessage", "Order ID mismatch. Invalid delete request");
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }

                // ✅ FIX 14: Business logic - chỉ delete APPROVED/REJECTED
                String status = returnRequest.getReturnStatus();
                if (!"APPROVED".equals(status) && !"REJECTED".equals(status)) {
                    session.setAttribute("errorMessage",
                            "Only finalized requests (APPROVED/REJECTED) can be deleted. Current status: " + status);
                    response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
                    return;
                }

                // Delete request
                rrDAO.deleteReturnRequest(requestId, orderId);
                session.setAttribute("successMessage",
                        "Return request #" + requestId + " deleted successfully");

            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Invalid request ID or order ID");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Error deleting return request: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");

        } else {
            // ✅ FIX 15: Handle invalid action
            session.setAttribute("errorMessage", "Invalid action");
            response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
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
