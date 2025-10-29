/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ReturnRequestDAO;
import DAOs.ReturnRequestDetailDAO;
import Models.ReturnRequest;
import Models.ReturnRequestDetail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ManageReturnRequestServlet", urlPatterns = {"/staff/manage-return-request"})
public class ManageReturnRequestServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageReturnRequestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageReturnRequestServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        String action = request.getParameter("action");
        if (("detail".equals(action))) {
            String idParam = request.getParameter("requestId");
            int requestId = Integer.parseInt(idParam);
            ReturnRequestDAO rrDAO = new ReturnRequestDAO();

            ReturnRequest returnRequest = rrDAO.getReturnRequestById(requestId);
            request.setAttribute("returnRequest", returnRequest);

            ReturnRequestDetailDAO rrdDAO = new ReturnRequestDetailDAO();
            List<ReturnRequestDetail> returnDetails = rrdDAO.getDetailsByReturnRequestId(returnRequest.getReturnRequestId());

            request.setAttribute("returnDetails", returnDetails);
            request.getRequestDispatcher("/WEB-INF/views/staff/manage-return-request/request-detail.jsp").forward(request, response);
        } else {
            ReturnRequestDAO rDAO = new ReturnRequestDAO();
            List<ReturnRequest> requests = rDAO.getAllReturnRequests();

            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Math.max(1, Integer.parseInt(pageParam));
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int recordsPerPage = 10;
            int totalRecords = requests.size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

// Ensure currentPage is within valid range
            currentPage = Math.min(currentPage, Math.max(1, totalPages));

            int startIndex = (currentPage - 1) * recordsPerPage;
            int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);

            List<ReturnRequest> pageData = (startIndex < totalRecords)
                    ? requests.subList(startIndex, endIndex)
                    : new ArrayList<>();

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
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String newStatus = request.getParameter("status");
            if (newStatus == null || newStatus.trim().isEmpty()) {
                request.setAttribute("error", "Status is required!");
                return;
            }

            ReturnRequestDAO rrDAO = new ReturnRequestDAO();
            ReturnRequestDetailDAO rrdDAO = new ReturnRequestDetailDAO();

            int r = rrDAO.updateReturnRequestStatusByAdmin(requestId, newStatus);
            if (r > 0) {
                List<ReturnRequestDetail> details = rrdDAO.getDetailsByReturnRequestId(requestId);
                for (ReturnRequestDetail detail : details) {
                    // Cập nhật status của từng detail theo status của request

                }
            }
            rrdDAO.updateRefundDateByRequestId(requestId);
            response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");
        } else if ("delete".equals(action)) {  // ĐỔI THÀNH CHỮ THƯỜNG
            try {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                int orderId = Integer.parseInt(request.getParameter("orderId"));

                ReturnRequestDAO rrDAO = new ReturnRequestDAO();
                rrDAO.deleteReturnRequest(requestId, orderId);

                // Dùng full context path giống như updateStatus
                response.sendRedirect(request.getContextPath() + "/staff/manage-return-request");

            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid request ID or order ID!");
                request.getRequestDispatcher("/staff/manage-return-request").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error deleting return request: " + e.getMessage());
                request.getRequestDispatcher("/staff/manage-return-request").forward(request, response);
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
