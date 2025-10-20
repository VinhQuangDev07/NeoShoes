package Controllers.Customer;

import DAOs.BrandDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import java.sql.SQLException;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
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
                    listProducts(request, response);
                    break;
                case "category":
                    listProductsByCategory(request, response);
                    break;
                case "search":
                    searchProducts(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách brands thay vì categories
            BrandDAO brandDAO = new BrandDAO();
            List<Brand> brands = brandDAO.getAllBrands();
            request.setAttribute("brands", brands);

            // Lấy danh sách sản phẩm mới nhất (8 sản phẩm) dựa trên thời gian update
            List<Product> latestProducts = productDAO.getLatestProducts(8);
            request.setAttribute("products", latestProducts);

            System.out.println("Latest products loaded: " + latestProducts.size());

            // Forward đến trang home
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println(" Error in listProducts: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void listProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        // Lấy danh sách categories
        List<Category> categories = categoryDAO.getAllActiveCategories();
        request.setAttribute("categories", categories);

        // Lấy danh sách sản phẩm theo category
        List<Product> products = productDAO.getProductsByCategory(categoryId);
        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", categoryId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        dispatcher.forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String searchTerm = request.getParameter("searchTerm");

        // Lấy danh sách brands thay vì categories
        BrandDAO brandDAO = new BrandDAO();
        List<Brand> brands = brandDAO.getAllBrands();
        request.setAttribute("brands", brands);
        
        // Lấy danh sách categories
        List<Category> categories = categoryDAO.getAllActiveCategories();
        request.setAttribute("categories", categories);

        // Tìm kiếm sản phẩm
        List<Product> products = productDAO.searchProducts(searchTerm);
        request.setAttribute("products", products);
        request.setAttribute("searchTerm", searchTerm);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
