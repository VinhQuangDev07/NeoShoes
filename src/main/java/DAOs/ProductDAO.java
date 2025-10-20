package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DB.DBContext;
import Models.Product;

public class ProductDAO extends DBContext {

    // ========== COMMON QUERY PARTS ==========
    private static final String PRODUCT_COLUMNS
            = "p.ProductId, p.BrandId, p.CategoryId, p.Name, "
            + "p.Description, p.DefaultImageUrl, p.Material, "
            + "b.Name AS BrandName, c.Name AS CategoryName";

    private static final String PRICE_AGGREGATION
            = "MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, "
            + "MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, "
            + "SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity";

    private static final String COLOR_SUBQUERY
            = "OUTER APPLY ( "
            + "  SELECT STUFF((SELECT DISTINCT ',' + pv2.Color "
            + "    FROM ProductVariant pv2 "
            + "    WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 "
            + "    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors "
            + ") Colors";

    private static final String SIZE_SUBQUERY
            = "OUTER APPLY ( "
            + "  SELECT STUFF((SELECT DISTINCT ',' + pv3.Size "
            + "    FROM ProductVariant pv3 "
            + "    WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 "
            + "    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes "
            + ") Sizes";

    private static final String COMMON_JOINS
            = "FROM Product p "
            + "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId "
            + "INNER JOIN Brand b ON p.BrandId = b.BrandId "
            + "INNER JOIN Category c ON p.CategoryId = c.CategoryId";

    private static final String GROUP_BY
            = "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, "
            + "p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, "
            + "Colors.AvailableColors, Sizes.AvailableSizes";

    public ProductDAO() {
        super();
    }

    // ========== HELPER: BUILD BASE QUERY ==========
    private String buildBaseQuery() {
        return "SELECT " + PRODUCT_COLUMNS + ", " + PRICE_AGGREGATION + ", "
                + "Colors.AvailableColors, Sizes.AvailableSizes "
                + COMMON_JOINS + " "
                + COLOR_SUBQUERY + " "
                + SIZE_SUBQUERY + " ";
    }

    // ========== HELPER: MAP RESULTSET TO PRODUCT ==========
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("ProductId"));
        product.setBrandId(rs.getInt("BrandId"));
        product.setCategoryId(rs.getInt("CategoryId"));
        product.setName(rs.getString("Name"));
        product.setDescription(rs.getString("Description"));
        product.setDefaultImageUrl(rs.getString("DefaultImageUrl"));
        product.setMaterial(rs.getString("Material"));

        // Xử lý giá
        double minPrice = rs.getDouble("MinPrice");
        double maxPrice = rs.getDouble("MaxPrice");
        if (!rs.wasNull()) {
            product.setMinPrice(minPrice);
            product.setMaxPrice(maxPrice);
        } else {
            product.setMinPrice(0.0);
            product.setMaxPrice(0.0);
        }

        // Brand và Category name
        product.setBrandName(rs.getString("BrandName"));
        product.setCategoryName(rs.getString("CategoryName"));

        // Available colors và sizes
        product.setAvailableColors(rs.getString("AvailableColors"));
        product.setAvailableSizes(rs.getString("AvailableSizes"));

        // Total quantity
        int totalQty = rs.getInt("TotalQuantity");
        product.setTotalQuantity(rs.wasNull() ? 0 : totalQty);

        return product;
    }

    // ========== GET LATEST PRODUCTS ==========
    public List<Product> getLatestProducts(int limit) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " "
                + "ORDER BY p.ProductId DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getLatestProducts: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Retrieved " + products.size() + " latest products");
        return products;
    }

    // ========== GET PRODUCTS BY CATEGORY ==========
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.CategoryId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " ORDER BY p.ProductId ASC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getProductsByCategory: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Found " + products.size() + " products for category " + categoryId);
        return products;
    }

    // ========== GET PRODUCTS BY CATEGORY AND BRAND ==========
    public List<Product> getProductsByCategoryAndBrand(int categoryId, int brandId) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.CategoryId = ? AND p.BrandId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " ORDER BY p.ProductId ASC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, brandId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getProductsByCategoryAndBrand: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Found " + products.size() + " products for category " + categoryId + " and brand " + brandId);
        return products;
    }

    // ========== GET PRODUCTS BY BRAND ==========
    public List<Product> getProductsByBrand(int brandId) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.BrandId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " ORDER BY p.ProductId ASC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, brandId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getProductsByBrand: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Found " + products.size() + " products for brand " + brandId);
        return products;
    }

    // ========== SEARCH PRODUCTS ==========
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.Name LIKE ? AND p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " ORDER BY p.ProductId ASC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in searchProducts: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Found " + products.size() + " products matching '" + keyword + "'");
        return products;
    }

    // ========== GET PRODUCT BY ID ==========
    public Product getById(int productId) {
        if (productId <= 0) {
            System.err.println("Invalid productId: " + productId);
            return null;
        }

        String query = "SELECT * FROM Product WHERE ProductId = ? AND IsDeleted = 0";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setProductId(rs.getInt("ProductId"));
                    product.setName(rs.getString("Name"));
                    product.setDescription(rs.getString("Description"));
                    product.setCategoryId(rs.getInt("CategoryId"));
                    product.setBrandId(rs.getInt("BrandId"));
                    product.setDefaultImageUrl(rs.getString("DefaultImageUrl"));
                    product.setMaterial(rs.getString("Material"));
                    return product;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // ========== COUNT TOTAL PRODUCTS ==========
    public int getTotalProducts() {
        String query = "SELECT COUNT(*) AS Total FROM Product WHERE IsActive = 1 AND IsDeleted = 0";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (SQLException e) {
            System.err.println("Error in getTotalProducts: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // ========== GET ALL PRODUCTS WITH PAGINATION ==========
    public List<Product> getAllProducts(int offset, int limit) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.IsActive = 1 AND p.IsDeleted = 0 "
                + GROUP_BY + " "
                + "ORDER BY p.ProductId ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllProducts: " + e.getMessage());
            e.printStackTrace();
        }

        return products;
    }
}
