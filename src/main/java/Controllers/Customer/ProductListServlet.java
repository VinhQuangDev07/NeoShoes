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

    // ✅ Khai báo biến instance
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;
    private List<Category> categories;
    private List<Brand> brands;

    // ✅ Constructor - khởi tạo DAO và load data
    public ProductListServlet() {
        super();
        System.out.println("Initializing ProductListServlet...");
        
        try {
            this.productDAO = new ProductDAO();
            this.categoryDAO = new CategoryDAO();
            this.brandDAO = new BrandDAO();
            
            System.out.println("Loading categories and brands...");
            this.categories = categoryDAO.getAllActiveCategories();
            this.brands = brandDAO.getAllBrands();
            System.out.println("Loaded " + categories.size() + " categories, " + brands.size() + " brands");
            
        } catch (Exception e) {
            System.err.println("Error initializing ProductListServlet: " + e.getMessage());
            e.printStackTrace();
        }
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
                    case "filter":
                        String type = request.getParameter("type"); 
                        if ("category".equals(type)) {
                            listProductsByCategory(request, response);
                        } else if ("brand".equals(type)) {
                            listProductsByBrand(request, response);
                        }
                        break;
                    default:
                        listAllProducts(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in ProductListServlet: " + e.getMessage());
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

            // Load products with pagination
            List<Product> products = productDAO.getAllProductsCustomer(offset, PAGE_SIZE);

            // Get total products and calculate total pages
            int totalProducts = productDAO.getTotalProductForCustomer();
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

            // Debug log
            System.out.println(" ProductList - Page " + page + "/" + totalPages
                    + " - Loaded " + products.size() + "/" + totalProducts + " products");

            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);

            // Forward to JSP
            forwardToProductList(request, response);

        } catch (Exception e) {
            System.err.println(" Error in listAllProducts: " + e.getMessage());
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
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Search products
            List<Product> products = productDAO.searchProducts(keyword.trim());

            System.out.println("Search '" + keyword + "': Found " + products.size() + " products");

            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("searchTerm", keyword);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalProducts", products.size());

            // Forward to JSP
            forwardToProductList(request, response);

        } catch (Exception e) {
            System.err.println("Error in searchProducts: " + e.getMessage());
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
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            int categoryId = Integer.parseInt(categoryIdParam);

            System.out.println("Filter by category: " + categoryId
                    + (brandIdParam != null ? ", brand: " + brandIdParam : ""));

            // Load products
            List<Product> products;

            if (brandIdParam != null && !brandIdParam.trim().isEmpty()) {
                // Filter by both category and brand
                int brandId = Integer.parseInt(brandIdParam);
                products = productDAO.getProductsByCategoryAndBrand(categoryId, brandId);
                request.setAttribute("selectedBrand", brandId);
                System.out.println("Filtered by category " + categoryId + " and brand " + brandId
                        + ": " + products.size() + " products");
            } else {
                // Filter by category only
                products = productDAO.getProductsByCategory(categoryId);
                System.out.println("Filtered by category " + categoryId + ": " + products.size() + " products");
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
            System.err.println("Invalid category/brand ID format");
            response.sendRedirect(request.getContextPath() + "/products");
        } catch (Exception e) {
            System.err.println("Error in listProductsByCategory: " + e.getMessage());
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
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            int brandId = Integer.parseInt(brandIdParam);

            System.out.println("Filter by brand: " + brandId);

            // Load products by brand
            List<Product> products = productDAO.getProductsByBrand(brandId);

            System.out.println("Filtered by brand " + brandId + ": " + products.size() + " products");

            // Set attributes
            setCommonAttributes(request, categories, brands, products);
            request.setAttribute("selectedBrand", brandId);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalProducts", products.size());

            // Forward to JSP
            forwardToProductList(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid brand ID format");
            response.sendRedirect(request.getContextPath() + "/products");
        } catch (Exception e) {
            System.err.println("Error in listProductsByBrand: " + e.getMessage());
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
