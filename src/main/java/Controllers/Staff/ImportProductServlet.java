/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.Staff;

import DAOs.ImportProductDAO;
import DAOs.ProductVariantDAO;
import Models.ImportProduct;
import Models.ImportProductDetail;
import Models.Product;
import Models.ProductVariant;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
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

    @Override
    public void init() throws ServletException {
        super.init();
        importDAO = new ImportProductDAO();
        variantDAO = new ProductVariantDAO();
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

        try {
            if ("create".equals(action)) {
                createImport(request, response);
            } else if ("update".equals(action)) {
//                updateImport(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
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

            // 2. Group variants theo productId
            Map<Integer, List<ProductVariant>> productVariantsMap = new LinkedHashMap<>();
            List<Product> products = new ArrayList<>();
            Set<Integer> processedProducts = new HashSet<>();

            for (ProductVariant variant : allVariants) {
                int productId = variant.getProductId();

                // Add variant vào map
                productVariantsMap.computeIfAbsent(productId, k -> new ArrayList<>()).add(variant);

                // Tạo ProductInfo cho product (chỉ tạo 1 lần)
                if (!processedProducts.contains(productId)) {
                    Product productInfo = new Product();
                    productInfo.setProductId(productId);
                    productInfo.setName(variant.getProductName());
                    productInfo.setDefaultImageUrl(variant.getImage());

                    products.add(productInfo);
                    processedProducts.add(productId);
                }
            }

            // 3. Đếm số lượng variants cho mỗi product
            for (Product product : products) {
                int variantCount = productVariantsMap.get(product.getProductId()).size();
                product.setVariantCount(variantCount);
            }

            // 5. Gửi data sang JSP
            request.setAttribute("products", products);
            request.setAttribute("productVariantsMap", productVariantsMap);

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
            int id = Integer.parseInt(request.getParameter("id"));

            ImportProduct importRecord = importDAO.getImportById(id);
            List<ImportProductDetail> details = importDAO.getImportDetails(id);
            List<ProductVariant> variants = variantDAO.getAllActiveVariants();

            if (importRecord == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            request.setAttribute("importRecord", importRecord);
            request.setAttribute("importDetails", details);
            request.setAttribute("productVariants", variants);

            request.getRequestDispatcher("/WEB-INF/views/staff/update-import-record.jsp")
                    .forward(request, response);
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
                ImportProductDetail detail = new ImportProductDetail(importId, variantId, quantity, costPrice);
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

//    private void updateImport(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//            int importId = Integer.parseInt(request.getParameter("importProductId"));
//            String supplierName = request.getParameter("supplierName");
//            String importDateStr = request.getParameter("importDate");
//            String note = request.getParameter("note");
//            
//            LocalDateTime importDate = LocalDateTime.parse(importDateStr);
//            
//            // Get line data
//            String[] variantIds = request.getParameterValues("variantIds[]");
//            String[] oldQuantities = request.getParameterValues("oldQuantities[]");
//            String[] quantities = request.getParameterValues("quantities[]");
//            String[] costPrices = request.getParameterValues("costPrices[]");
//            
//            if (variantIds == null || variantIds.length == 0) {
//                request.getSession().setAttribute("flash_error", "Please keep at least one product variant");
//                response.sendRedirect(request.getContextPath() + "/staff/update-import-record?id=" + importId);
//                return;
//            }
//            
//            // Get old details for delta calculation
//            List<ImportProductDetail> oldDetails = importDAO.getImportDetailObjects(importId);
//            Map<Integer, Integer> oldQtyMap = new HashMap<>();
//            for (ImportProductDetail detail : oldDetails) {
//                oldQtyMap.put(detail.getProductVariantId(), detail.getQuantity());
//            }
//            
//            // Update header
//            ImportProduct importRecord = importDAO.getImportById(importId);
//            importRecord.setSupplierName(supplierName);
//            importRecord.setImportDate(importDate);
//            importRecord.setNote(note);
//            importDAO.updateImportProduct(importRecord);
//            
//            // Delete old details
//            importDAO.deleteImportDetails(importId);
//            
//            // Map for new quantities
//            Map<Integer, Integer> newQtyMap = new HashMap<>();
//            
//            // Process each line
//            for (int i = 0; i < variantIds.length; i++) {
//                int variantId = Integer.parseInt(variantIds[i]);
//                int quantity = Integer.parseInt(quantities[i]);
//                double costPrice = Double.parseDouble(costPrices[i]);
//                
//                // Check if variant exists, if not create new one
//                ProductVariant variant = variantDAO.getVariantById(variantId);
//                if (variant == null) {
//                    variant = new ProductVariant();
//                    variant.setProductId(1);
//                    variant.setColor("Unknown");
//                    variant.setSize("Unknown");
//                    variant.setPrice(costPrice);
//                    variant.setQuantityAvailable(0);
//                    variantId = variantDAO.createVariant(variant);
//                }
//                
//                // Insert new detail
//                ImportProductDetail detail = new ImportProductDetail(importId, variantId, quantity, costPrice);
//                importDAO.insertImportProductDetail(detail);
//                
//                newQtyMap.put(variantId, quantity);
//            }
//            
//            // Calculate and apply inventory deltas
//            Set<Integer> allVariantIds = new HashSet<>();
//            allVariantIds.addAll(oldQtyMap.keySet());
//            allVariantIds.addAll(newQtyMap.keySet());
//            
//            for (Integer variantId : allVariantIds) {
//                int oldQty = oldQtyMap.getOrDefault(variantId, 0);
//                int newQty = newQtyMap.getOrDefault(variantId, 0);
//                int delta = newQty - oldQty;
//                
//                if (delta > 0) {
//                    variantDAO.increaseQuantityAvailable(variantId, delta);
//                } else if (delta < 0) {
//                    variantDAO.decreaseQuantityAvailable(variantId, Math.abs(delta));
//                }
//            }
//            
//            request.getSession().setAttribute("flash", "Import record updated successfully!");
//            response.sendRedirect(request.getContextPath() + "/staff/import-record-details?id=" + importId);
//            
//        } catch (NumberFormatException e) {
//            e.printStackTrace();
//            request.getSession().setAttribute("flash_error", "Invalid number format");
//            response.sendRedirect(request.getContextPath() + "/staff/import-records");
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.getSession().setAttribute("flash_error", "Error updating import record: " + e.getMessage());
//            response.sendRedirect(request.getContextPath() + "/staff/import-records");
//        }
//    }
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
