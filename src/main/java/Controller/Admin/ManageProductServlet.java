/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Admin;

import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.Product;
import Models.ProductVariant;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
@WebServlet(name = "ManageProductServlet", urlPatterns = {"/admin-manage-product"})
public class ManageProductServlet extends HttpServlet {

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
            out.println("<title>Servlet ManageProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageProductServlet at " + request.getContextPath() + "</h1>");
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

        ProductDAO pDAO = new ProductDAO();
        ProductVariantDAO pvDAO = new ProductVariantDAO();

        // ⭐ Dùng if-else để đảm bảo chỉ 1 nhánh được thực thi
        if ("detail".equals(action)) {
            // XỬ LÝ DETAIL
            String productIdStr = request.getParameter("productId");

            if (productIdStr == null || productIdStr.isEmpty()) {
                response.sendRedirect("manage-product?error=Missing product ID");
                return;
            }

            try {
                int productId = Integer.parseInt(productIdStr);
                Product product = pDAO.getById(productId);

                if (product == null) {
                    response.sendRedirect("manage-product?error=Product not found");
                    return;
                }

                List<ProductVariant> productVariants = pvDAO.getByProductId(productId);

                // Tính toán thống kê...
                int totalQuantity = 0;
                BigDecimal minPrice = null;
                BigDecimal maxPrice = null;

                for (ProductVariant variant : productVariants) {
                    totalQuantity += variant.getQuantityAvailable();
                    if (minPrice == null || variant.getPrice().compareTo(minPrice) < 0) {
                        minPrice = variant.getPrice();
                    }
                    if (maxPrice == null || variant.getPrice().compareTo(maxPrice) > 0) {
                        maxPrice = variant.getPrice();
                    }
                }

                request.setAttribute("product", product);
                request.setAttribute("productVariants", productVariants);
                request.setAttribute("totalQuantity", totalQuantity);
                request.setAttribute("minPrice", minPrice != null ? minPrice : BigDecimal.ZERO);
                request.setAttribute("maxPrice", maxPrice != null ? maxPrice : BigDecimal.ZERO);

                request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/product-detail.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("manage-product?error=Invalid product ID");
            }

        } else {
            // ⭐ XỬ LÝ LIST (mặc định)
            List<Product> listProduct = pDAO.getAllProducts(0, 50);
            Map<Integer, List<ProductVariant>> productVariantsMap = new HashMap<>();

            for (Product p : listProduct) {
                List<ProductVariant> variants = pvDAO.getByProductId(p.getProductId());
                productVariantsMap.put(p.getProductId(), variants);
            }

            int totalProduct = pDAO.getTotalProducts();
            int totalQuantity = pvDAO.getTotalQuantityAvailable();
            BigDecimal totalPrice = pvDAO.getTotalInventoryValue();

            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int recordsPerPage = 10;
            int startIndex = (currentPage - 1) * recordsPerPage;
            int endIndex = Math.min(startIndex + recordsPerPage, totalProduct);

            List<Product> pageData;
            if (startIndex < totalProduct) {
                pageData = listProduct.subList(startIndex, endIndex);
            } else {
                pageData = new ArrayList<>();
            }

            request.setAttribute("productVariantsMap", productVariantsMap);
            request.setAttribute("totalRecords", totalProduct);
            request.setAttribute("totalQuantity", totalQuantity);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("listProduct", pageData);
            request.setAttribute("baseUrl", request.getRequestURI());
            request.setAttribute("recordsPerPage", recordsPerPage);

            request.getRequestDispatcher("/WEB-INF/views/staff/manage-product/list.jsp")
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
        processRequest(request, response);
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
