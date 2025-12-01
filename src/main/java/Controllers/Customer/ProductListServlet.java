package Controllers.Customer;

import java.io.IOException;
import java.util.List;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductListServlet", urlPatterns = {"/products"})
public class ProductListServlet extends HttpServlet {
    
    private static final int PAGE_SIZE = 12;
    
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.isEmpty()) {
                listAllProducts(request, response);
            } else {
                switch (action) {
                    case "search":
                        searchProducts(request, response);
                        break;
                    case "category":
                        listProductsByCategory(request, response);
                        break;
                    case "brand":
                        listProductsByBrand(request, response);
                        break;
                    default:
                        listAllProducts(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            System.err.println("❌ Error in ProductListServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
    
    // ========== LIST ALL PRODUCTS WITH PAGINATION ==========
    private void listAllProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get page number from parameter
            int page = getPageNumber(request);
            int offset = (page - 1) * PAGE_SIZE;

            // Load categories and brands for filters
            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Load products with pagination
            List<Product> products = productDAO.getAllProducts(offset, PAGE_SIZE);
            
            // Get total products and calculate total pages
            int totalProducts = productDAO.getTotalProducts();
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

            // Debug log
            System.out.println("✅ ProductList - Page " + page + "/" + totalPages + 
                             " - Loaded " + products.size() + "/" + totalProducts + " products");

            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);

            // Forward to JSP
            forwardToProductList(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in listAllProducts: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    // ========== SEARCH PRODUCTS ==========
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("searchTerm");
            
            if (keyword == null || keyword.trim().isEmpty()) {
                listAllProducts(request, response);
                return;
            }
            
            // Load categories and brands
            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Search products
            List<Product> products = productDAO.searchProducts(keyword.trim());
            
            System.out.println("✅ Search '" + keyword + "': Found " + products.size() + " products");
            
            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("searchTerm", keyword);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalProducts", products.size());
            
            // Forward to JSP
            forwardToProductList(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in searchProducts: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    // ========== FILTER BY CATEGORY (AND OPTIONAL BRAND) ==========
    private void listProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String categoryIdParam = request.getParameter("categoryId");
            String brandIdParam = request.getParameter("brandId");
            
            if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
                listAllProducts(request, response);
                return;
            }
            
            int categoryId = Integer.parseInt(categoryIdParam);
            
            System.out.println("🔍 Filter by category: " + categoryId + 
                             (brandIdParam != null ? ", brand: " + brandIdParam : ""));
            
            // Load categories and brands
            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Load products
            List<Product> products;
            
            if (brandIdParam != null && !brandIdParam.trim().isEmpty()) {
                // Filter by both category and brand
                int brandId = Integer.parseInt(brandIdParam);
                products = productDAO.getProductsByCategoryAndBrand(categoryId, brandId);
                request.setAttribute("selectedBrand", brandId);
                System.out.println("✅ Filtered by category " + categoryId + " and brand " + brandId + 
                                 ": " + products.size() + " products");
            } else {
                // Filter by category only
                products = productDAO.getProductsByCategory(categoryId);
                System.out.println("✅ Filtered by category " + categoryId + ": " + products.size() + " products");
            }
            
            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalProducts", products.size());
            
            // Forward to JSP
            forwardToProductList(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid category/brand ID format");
            listAllProducts(request, response);
        } catch (Exception e) {
            System.err.println("❌ Error in listProductsByCategory: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    // ========== FILTER BY BRAND ==========
    private void listProductsByBrand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String brandIdParam = request.getParameter("brandId");
            
            if (brandIdParam == null || brandIdParam.trim().isEmpty()) {
                listAllProducts(request, response);
                return;
            }
            
            int brandId = Integer.parseInt(brandIdParam);
            
            System.out.println("🔍 Filter by brand: " + brandId);
            
            // Load categories and brands
            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            
            // Load products by brand
            List<Product> products = productDAO.getProductsByBrand(brandId);
            
            System.out.println("✅ Filtered by brand " + brandId + ": " + products.size() + " products");
            
            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("selectedBrand", brandId);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalProducts", products.size());
            
            // Forward to JSP
            forwardToProductList(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid brand ID format");
            listAllProducts(request, response);
        } catch (Exception e) {
            System.err.println("❌ Error in listProductsByBrand: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    // ========== HELPER METHODS ==========
    private int getPageNumber(HttpServletRequest request) {
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        return page;
    }
    
    private void setCommonAttributes(HttpServletRequest request, List<Category> categories, 
                                     List<Brand> brands, List<Product> products) {
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("products", products);
    }
    
    private void forwardToProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}