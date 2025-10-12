package Controllers.Customer;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import DAOs.BrandDAO;
import Models.Category;
import Models.Product;
import Models.Brand;
import jakarta.servlet.RequestDispatcher;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name="ProductListServlet", urlPatterns={"/products"})
public class ProductListServlet extends HttpServlet {
    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;
    private BrandDAO brandDAO;
    private final int PAGE_SIZE = 12;
    
    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listAllProducts(request, response);
                    break;
                case "category":
                    listProductsByCategory(request, response);
                    break;
                case "brand":
                    listProductsByBrand(request, response);
                    break;
                case "category-brand":
                    listProductsByCategoryAndBrand(request, response);
                    break;
                case "search":
                    searchProducts(request, response);
                    break;
                default:
                    listAllProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    private void listAllProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy page number từ parameter
            int page = 1;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Tính offset
            int offset = (page - 1) * PAGE_SIZE;
            
            // Lấy danh sách categories và brands
            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<Brand> brands = brandDAO.getAllBrands();
            request.setAttribute("categories", categories);
            request.setAttribute("brands", brands);
            
            // Lấy danh sách sản phẩm với phân trang
            List<Product> products = productDAO.getAllProductsWithPagination(offset, PAGE_SIZE);
            request.setAttribute("products", products);
            
            // Lấy tổng số sản phẩm và tính tổng số trang
            int totalProducts = productDAO.getTotalProductsCount();
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
            
            // Set attributes cho phân trang
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("pageSize", PAGE_SIZE);
            
            System.out.println("✅ Product list loaded: " + products.size() + " products, page " + page);
            
            // Forward đến trang product list
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error in listAllProducts: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    private void listProductsByCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Lấy danh sách categories và brands
        List<Category> categories = categoryDAO.getAllActiveCategories();
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        
        // Lấy danh sách sản phẩm theo category
        List<Product> products = productDAO.getProductsByCategory(categoryId);
        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", categoryId);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    private void listProductsByBrand(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        
        // Lấy danh sách categories và brands
        List<Category> categories = categoryDAO.getAllActiveCategories();
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        
        // Lấy danh sách sản phẩm theo brand
        List<Product> products = productDAO.getProductsByBrand(brandId);
        request.setAttribute("products", products);
        request.setAttribute("selectedBrand", brandId);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    private void listProductsByCategoryAndBrand(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        
        // Lấy danh sách categories và brands
        List<Category> categories = categoryDAO.getAllActiveCategories();
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        
        // Lấy danh sách sản phẩm theo category và brand
        List<Product> products = productDAO.getProductsByCategoryAndBrand(categoryId, brandId);
        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedBrand", brandId);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String searchTerm = request.getParameter("searchTerm");
        
        // Lấy danh sách categories và brands
        List<Category> categories = categoryDAO.getAllActiveCategories();
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        
        // Tìm kiếm sản phẩm
        List<Product> products = productDAO.searchProducts(searchTerm);
        request.setAttribute("products", products);
        request.setAttribute("searchTerm", searchTerm);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product-list.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       doGet(request, response);
    }
}