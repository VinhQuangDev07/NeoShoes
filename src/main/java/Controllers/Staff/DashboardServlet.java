/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.DashboardDAO;
import Models.Dashboard;
import Models.OrderStatus;
import Models.Product;
import Models.Revenue;
import Models.Staff;
import Utils.Utils;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/staff/dashboard"})
public class DashboardServlet extends HttpServlet {
    
    private DashboardDAO dashboardDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        dashboardDAO = new DashboardDAO();
        gson = new Gson();
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
        HttpSession session = request.getSession();
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        // Get filter type (default: daily)
        String filterType = request.getParameter("filterType");
        if (filterType == null || filterType.isEmpty()) {
            filterType = "daily";
        }

        // Get overall statistics
        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue();
        int totalOrders = dashboardDAO.getTotalOrders();
        int totalCustomers = dashboardDAO.getTotalCustomers();
        int totalStaff = dashboardDAO.getTotalStaff();

        // Get top products
        List<Product> topProducts = dashboardDAO.getTopProducts();

        // Create dashboard data object
        Dashboard dashboardData = new Dashboard();
        dashboardData.setTotalRevenue(totalRevenue);
        dashboardData.setTotalOrders(totalOrders);
        dashboardData.setTopProducts(topProducts);

        // Get order status statistics
        OrderStatus orderStatus = dashboardDAO.getOrderStatusStatistics();

        // Get revenue data based on filter type
        List<Revenue> revenueDaily = null;
        List<Revenue> revenueMonthly = null;
        List<Revenue> revenueYearly = null;

        String startDate = null, endDate = null;
        String startMonth = null, endMonth = null;
        String startYear = null, endYear = null;

        switch (filterType) {
            case "daily":
                startDate = request.getParameter("startDate");
                endDate = request.getParameter("endDate");

                // Use default if not provided
                if (startDate == null || endDate == null) {
                    String[] defaultRange = Utils.getDefaultDateRange();
                    startDate = defaultRange[0];
                    endDate = defaultRange[1];
                }

                revenueDaily = dashboardDAO.getRevenueByDay(startDate, endDate);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                break;

            case "monthly":
                startMonth = request.getParameter("startMonth");
                endMonth = request.getParameter("endMonth");

                // Use default if not provided
                if (startMonth == null || endMonth == null) {
                    String[] defaultRange = Utils.getDefaultMonthRange();
                    startMonth = defaultRange[0];
                    endMonth = defaultRange[1];
                }

                revenueMonthly = dashboardDAO.getRevenueByMonth(startMonth, endMonth);
                request.setAttribute("startMonth", startMonth);
                request.setAttribute("endMonth", endMonth);
                break;

            case "yearly":
                startYear = request.getParameter("startYear");
                endYear = request.getParameter("endYear");

                // Use default if not provided
                if (startYear == null || endYear == null) {
                    int[] defaultRange = Utils.getDefaultYearRange();
                    startYear = String.valueOf(defaultRange[0]);
                    endYear = String.valueOf(defaultRange[1]);
                }

                revenueYearly = dashboardDAO.getRevenueByYear(
                        Integer.parseInt(startYear),
                        Integer.parseInt(endYear)
                );
                request.setAttribute("startYear", startYear);
                request.setAttribute("endYear", endYear);
                break;
        }

        // Set attributes for JSP
        request.setAttribute("dashboardData", dashboardData);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("filterType", filterType);

        // Convert data to JSON for charts
        request.setAttribute("revenueDaily", gson.toJson(revenueDaily != null ? revenueDaily : Collections.emptyList()));
        request.setAttribute("revenueMonthly", gson.toJson(revenueMonthly != null ? revenueMonthly : Collections.emptyList()));
        request.setAttribute("revenueYearly", gson.toJson(revenueYearly != null ? revenueYearly : Collections.emptyList()));

        // Convert order status data to JSON
        Map<String, Integer> statusMap = new HashMap<>();
        statusMap.put("Pending", orderStatus.getPending());
        statusMap.put("Processing", orderStatus.getProcessing());
        statusMap.put("Shipped", orderStatus.getShipped());
        statusMap.put("Delivered", orderStatus.getDelivered());
        request.setAttribute("orderStatus", gson.toJson(statusMap));

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/staff/dashboard.jsp").forward(request, response);
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
        doGet(request, response);
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
