/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ImportProductDAO;
import DAOs.ProductDAO;
import DAOs.ProductVariantDAO;
import Models.ImportProduct;
import Models.ImportProductDetail;
import Models.Product;
import Models.ProductVariant;
import Models.Staff;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
@WebServlet(name = "ImportProductServlet", urlPatterns = {
    "/staff/import-records",
    "/staff/import-product",
    "/staff/import-record-details",
    "/staff/update-import-record"
})
public class ImportProductServlet extends HttpServlet {

    private ImportProductDAO importDAO;
    private ProductVariantDAO variantDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        importDAO = new ImportProductDAO();
        variantDAO = new ProductVariantDAO();
        productDAO = new ProductDAO();
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
        if (!staff.isAdmin()) {
            session.setAttribute("flash_info", "Access Denied - Admin only");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }
        
        String path = request.getRequestURI();

        try {
            if (path.endsWith("/staff/import-records")) {
                viewImportRecords(request, response);
            } else if (path.endsWith("/staff/import-product")) {
                showImportForm(request, response);
            } else if (path.endsWith("/staff/import-record-details")) {
                viewImportDetails(request, response);
            } else if (path.endsWith("/staff/update-import-record")) {
                showUpdateForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            request.getSession().setAttribute("flash_error", "Internal server error!");
            response.sendRedirect(request.getContextPath() + "/staff/import-records");
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

        try {
            if ("create".equals(action)) {
                createImport(request, response);
            } else if ("update".equals(action)) {
                updateImport(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            request.getSession().setAttribute("flash_error", "Internal server error!");
            response.sendRedirect(request.getContextPath() + "/staff/import-records");
        }
    }

    // ============ GET Methods ============
    private void viewImportRecords(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String phrase = request.getParameter("phrase");
            String from = request.getParameter("from");
            String to = request.getParameter("to");
            int page = request.getParameter("page") != null
                    ? Integer.parseInt(request.getParameter("page")) : 1;

            LocalDateTime fromDate = null, toDate = null;
            if (from != null && !from.isEmpty()) {
                fromDate = LocalDateTime.parse(from + "T00:00:00");
            }
            if (to != null && !to.isEmpty()) {
                toDate = LocalDateTime.parse(to + "T23:59:59");
            }

            List<ImportProduct> records = importDAO.searchImports(phrase, fromDate, toDate, (page - 1) * 10, 10);
            int totalRecords = importDAO.countImports(phrase, fromDate, toDate);
            int totalPages = (totalRecords + 9) / 10;

            request.setAttribute("importRecords", records);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/views/staff/import-record-list.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showImportForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy tất cả variants
            List<ProductVariant> allVariants = variantDAO.getAllActiveVariants();

            // 2. Tạo Map để group
            Map<Integer, Product> productMap = new HashMap<>();

            // 3. Loop và build map
            for (ProductVariant variant : allVariants) {
                int productId = variant.getProductId();

                Product product = productMap.computeIfAbsent(productId, k -> {
                    Product p = new Product();
                    p.setProductId(productId);
                    p.setName(variant.getProductName());
                    p.setDefaultImageUrl(variant.getImage());
                    return p;
                });

                product.addVariant(variant);
            }

            // 4. Chuyển Map thành List
            List<Product> products = new ArrayList<>(productMap.values());

            // 5. Gửi sang JSP
            request.setAttribute("products", products);

            request.getRequestDispatcher("/WEB-INF/views/staff/import-product.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void viewImportDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ImportProduct importRecord = importDAO.getImportById(id);
            List<ImportProductDetail> details = importDAO.getImportDetails(id);

            if (importRecord == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                request.getSession().setAttribute("flash_error", "Import record not found!");
                response.sendRedirect(request.getContextPath() + "/staff/import-records");
                return;
            }

            request.setAttribute("importRecord", importRecord);
            request.setAttribute("importDetails", details);

            request.getRequestDispatcher("/WEB-INF/views/staff/import-record-details.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy importId từ URL parameter
            String importIdStr = request.getParameter("id");
            if (importIdStr == null || importIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/import-records");
                return;
            }

            int importId = Integer.parseInt(importIdStr);

            // 2. Lấy import record từ database
            ImportProduct importRecord = importDAO.getImportById(importId);
            if (importRecord == null) {
                response.sendRedirect(request.getContextPath() + "/staff/import-records");
                return;
            }

            // 3. Lấy danh sách import details cho import này
            List<ImportProductDetail> importLines = importDAO.getImportDetails(importId);
            importRecord.setImportProductDetails(importLines);

            // 6. Lấy tất cả variants để load vào modal
            List<ProductVariant> allVariants = variantDAO.getAllActiveVariants();

            // 2. Tạo Map để group
            Map<Integer, Product> productMap = new HashMap<>();

            // 3. Loop và build map
            for (ProductVariant variant : allVariants) {
                int productId = variant.getProductId();

                Product product = productMap.computeIfAbsent(productId, k -> {
                    Product p = new Product();
                    p.setProductId(productId);
                    p.setName(variant.getProductName());
                    p.setDefaultImageUrl(variant.getImage());
                    return p;
                });

                product.addVariant(variant);
            }

            // 4. Chuyển Map thành List
            List<Product> products = new ArrayList<>(productMap.values());

            // 9. Gửi data sang JSP
            request.setAttribute("importRecord", importRecord);
            request.setAttribute("importLines", importLines);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/WEB-INF/views/staff/update-import-record.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/import-records");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ============ POST Methods ============
    private void createImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get header data
            String supplierName = request.getParameter("supplierName");
            String importDateStr = request.getParameter("importDate");
            String note = request.getParameter("note");

//            // Get staff from session
//            Staff staff = (Staff) request.getSession().getAttribute("staff");
//            if (staff == null) {
//                response.sendRedirect(request.getContextPath() + "/login");
//                return;
//            }
            LocalDateTime importDate = LocalDateTime.parse(importDateStr);

            // Get line data
            String[] variantIds = request.getParameterValues("variantIds[]");
            String[] quantities = request.getParameterValues("quantities[]");
            String[] costPrices = request.getParameterValues("costPrices[]");

            if (variantIds == null || variantIds.length == 0) {
                request.getSession().setAttribute("flash_error", "Please add at least one product variant");
                response.sendRedirect(request.getContextPath() + "/staff/import-product");
                return;
            }

            // Create import record
            ImportProduct importRecord = new ImportProduct();
//            importRecord.setStaffId(staff.getStaffId());
            importRecord.setStaffId(1);
            importRecord.setImportDate(importDate);
            importRecord.setSupplierName(supplierName);
            importRecord.setNote(note);

            // Insert header and get ID
            int importId = importDAO.insertImportProduct(importRecord);

            // Process each line
            for (int i = 0; i < variantIds.length; i++) {
                int variantId = Integer.parseInt(variantIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                BigDecimal costPrice = BigDecimal.valueOf(Double.parseDouble(costPrices[i]));

                ProductVariant variant = variantDAO.findById(variantId);
                if (variant == null) {
                    request.getSession().setAttribute("flash_error", "Variant " + variantId + " not found");
                    response.sendRedirect(request.getContextPath() + "/staff/import-product");
                }

                // Create and insert import detail
                ImportProductDetail detail = new ImportProductDetail();
                detail.setImportProductId(importId);
                detail.setProductVariantId(variantId);
                detail.setQuantity(quantity);
                detail.setCostPrice(costPrice);
                importDAO.insertImportProductDetail(detail);

                // Increase inventory
                variantDAO.increaseQuantityAvailable(variantId, quantity);
            }

            request.getSession().setAttribute("flash", "Import record created successfully!");
            response.sendRedirect(request.getContextPath() + "/staff/import-records");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Invalid number format");
            response.sendRedirect(request.getContextPath() + "/staff/import-product");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flash_error", "Error creating import record: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/import-product");
        }
    }

    private void updateImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy thông tin import cơ bản
            int importProductId = Integer.parseInt(request.getParameter("importProductId"));
            String supplierName = request.getParameter("supplierName");
            String note = request.getParameter("note");

            // 2. Lấy staff ID từ session
            HttpSession session = request.getSession();
//            User currentUser = (User) session.getAttribute("user");
//            if (currentUser == null) {
//                response.sendRedirect(request.getContextPath() + "/login");
//                return;
//            }
            int staffId = 1;

            // 3. Kiểm tra import record có tồn tại không
            ImportProduct existingImport = importDAO.getImportById(importProductId);
            if (existingImport == null) {
                session.setAttribute("flash_error", "Import record not found");
                response.sendRedirect(request.getContextPath() + "/staff/import-records");
                return;
            }

            // 4. Update import header
            ImportProduct importProduct = new ImportProduct();
            importProduct.setImportProductId(importProductId);
            importProduct.setStaffId(staffId);
            importProduct.setImportDate(existingImport.getImportDate()); // Keep original import date
            importProduct.setSupplierName(supplierName);
            importProduct.setNote(note);

            boolean headerUpdated = importDAO.updateImportProduct(importProduct);
            if (!headerUpdated) {
                session.setAttribute("flash_error", "Failed to update import record");
                response.sendRedirect(request.getContextPath() + "/staff/update-import-record?id=" + importProductId);
                return;
            }

            // 5. Xử lý import details
            String[] lineIds = request.getParameterValues("lineIds[]");
            String[] productIds = request.getParameterValues("productIds[]");
            String[] variantIds = request.getParameterValues("variantIds[]");
            String[] quantities = request.getParameterValues("quantities[]");
            String[] costPrices = request.getParameterValues("costPrices[]");

            if (productIds == null || productIds.length == 0) {
                session.setAttribute("flash_error", "Please add at least one product line");
                response.sendRedirect(request.getContextPath() + "/staff/update-import-record?id=" + importProductId);
                return;
            }

            // 6. Lấy danh sách line IDs hiện tại từ database
            List<ImportProductDetail> existingDetails = importDAO.getImportDetails(importProductId);
            Set<Integer> existingLineIds = new HashSet<>();
            for (ImportProductDetail detail : existingDetails) {
                existingLineIds.add(detail.getImportProductDetailId());
            }

            // 7. Track các line IDs được submit
            Set<Integer> submittedLineIds = new HashSet<>();

            // 8. Process từng line
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] == null || productIds[i].isEmpty()) {
                    continue; // Skip empty lines
                }

                int variantId = Integer.parseInt(variantIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                BigDecimal costPrice = new BigDecimal(costPrices[i]);

                ImportProductDetail detail = new ImportProductDetail();
                detail.setImportProductId(importProductId);
                detail.setProductVariantId(variantId);
                detail.setQuantity(quantity);
                detail.setCostPrice(costPrice);

                // Kiểm tra xem đây là line mới hay line cũ
                if (lineIds != null && i < lineIds.length && lineIds[i] != null && !lineIds[i].isEmpty()) {
                    // Line cũ - update
                    int lineId = Integer.parseInt(lineIds[i]);
                    detail.setImportProductDetailId(lineId);
                    importDAO.updateImportProductDetail(detail);
                    submittedLineIds.add(lineId);
                } else {
                    // Line mới - insert
                    importDAO.insertImportProductDetail(detail);
                }
            }

            // 9. Xóa các lines không còn trong form (đã bị remove)
            for (Integer existingLineId : existingLineIds) {
                if (!submittedLineIds.contains(existingLineId)) {
                    importDAO.deleteImportProductDetail(existingLineId);
                }
            }

            // 10. Update quantity available cho tất cả variants trong import này
            List<ImportProductDetail> updatedDetails = importDAO.getImportDetails(importProductId);
            for (ImportProductDetail detail : updatedDetails) {
                int variantId = detail.getProductVariantId();

                // Tìm quantity cũ (nếu có)
                int oldQuantity = 0;
                for (ImportProductDetail existing : existingDetails) {
                    if (existing.getProductVariantId() == variantId) {
                        oldQuantity = existing.getQuantity();
                        break;
                    }
                }

                // Tính delta = new - old
                int delta = detail.getQuantity() - oldQuantity;

                // Nếu delta = 0, không cần update
                if (delta == 0) {
                    continue;
                }

                // Update stock
                variantDAO.adjustQuantityAvailable(variantId, delta);
            }

            // 11. Success message và redirect
            session.setAttribute("flash", "Import record updated successfully");
            response.sendRedirect(request.getContextPath() + "/staff/import-records");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("flash_error", "Invalid number format");
            response.sendRedirect(request.getContextPath() + "/staff/import-records");
        } catch (Exception e) {
            request.getSession().setAttribute("flash_error", "Error updating import: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/import-records");
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
