package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import DB.DBContext;
import Models.Product;

public class ProductDAO extends DBContext {

    // ========== COMMON QUERY PARTS ==========
    private static final String PRODUCT_COLUMNS
            = "p.ProductId, p.BrandId, p.CategoryId, p.Name, "
            + "p.Description, p.DefaultImageUrl, p.Material, "
            + "p.CreatedAt, p.UpdatedAt, "
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
            + "p.Description, p.DefaultImageUrl, p.Material, "
            + "p.CreatedAt, p.UpdatedAt, "
            + "b.Name, c.Name, "
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
        Timestamp cr = rs.getTimestamp("CreatedAt");
        product.setCreatedAt(cr.toLocalDateTime());
        Timestamp up = rs.getTimestamp("UpdatedAt");
        product.setUpdatedAt(up.toLocalDateTime());
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

    public Product getById(int productId) {
        if (productId <= 0) {
            System.err.println("Invalid productId: " + productId);
            return null;
        }

        String query = "SELECT p.*, "
                + "b.Name AS BrandName, "
                + "c.Name AS CategoryName "
                + "FROM Product p "
                + "INNER JOIN Brand b ON p.BrandId = b.BrandId "
                + "INNER JOIN Category c ON p.CategoryId = c.CategoryId "
                + "WHERE p.ProductId = ? AND p.IsDeleted = 0";

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

                    // ⭐ Thêm BrandName và CategoryName
                    product.setBrandName(rs.getString("BrandName"));
                    product.setCategoryName(rs.getString("CategoryName"));

                    Timestamp cr = rs.getTimestamp("CreatedAt");
                    if (cr != null) {
                        product.setCreatedAt(cr.toLocalDateTime());
                    }

                    Timestamp up = rs.getTimestamp("UpdatedAt");
                    if (up != null) {
                        product.setUpdatedAt(up.toLocalDateTime());
                    }

                    return product;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // ========== COUNT TOTAL PRODUCTS FOR CUSTOMER ==========
    public int getTotalProductForCustomer() {
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
    // ========== COUNT TOTAL PRODUCTS FOR STAFF ==========

    public int getTotalProductStaff() {
        String query = "SELECT COUNT(*) AS Total FROM Product WHERE IsDeleted = 0";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (SQLException e) {
            System.err.println("Error in getTotalProducts: " + e.getMessage());

        }

        return 0;
    }

    // ========== GET ALL PRODUCTS WITH PAGINATION FOR CUSTOMER ==========
    public List<Product> getAllProductsCustomer(int offset, int limit) {
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

    // ========== GET ALL PRODUCTS WITH PAGINATION STAFF ==========
    public List<Product> getAllProductsForStaff(int offset, int limit) {
        List<Product> products = new ArrayList<>();

        String query = buildBaseQuery()
                + "WHERE p.IsDeleted = 0 "
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
// ========== TOGGLE PRODUCT ACTIVE STATUS (ADMIN) ==========

    public boolean toggleProductStatus(int productId) {
        String query = "UPDATE Product SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END, "
                + "UpdatedAt = GETDATE() "
                + "WHERE ProductId = ? AND IsDeleted = 0";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                System.out.println("Product status toggled: ID " + productId);
                return true;
            } else {
                System.err.println(" No product found with ID: " + productId);
            }
        } catch (SQLException e) {
            System.err.println("Error in toggleProductStatus: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean createProduct(Product product) {
        String query = "INSERT INTO Product (BrandId, CategoryId, Name, Description, "
                + "DefaultImageUrl, Material, IsActive, IsDeleted, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE())";
        Object[] params = {
            product.getBrandId(),
            product.getCategoryId(),
            product.getName(),
            product.getDescription(),
            product.getDefaultImageUrl(),
            product.getMaterial(),
            "active".equalsIgnoreCase(product.getIsActive()) ? 1 : 0,};
        try {
            int generatedId = execQueryReturnId(query, params);
            if (generatedId > 0) {
                product.setProductId(generatedId);
                System.out.println("Product created successfully with ID: " + generatedId);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in createProduct: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    // ========== UPDATE PRODUCT STATUS (ADMIN) - Tắt/Bật sản phẩm ==========

    public boolean updateProductStatus(int productId, boolean isActive) {
        String query = "UPDATE Product SET IsActive = ?, UpdatedAt = GETDATE() "
                + "WHERE ProductId = ? AND IsDeleted = 0";

        Object[] params = {isActive ? 1 : 0, productId};

        try {
            int affectedRows = execQuery(query, params);

            if (affectedRows > 0) {
                System.out.println("Product status updated: ID " + productId + " -> " + (isActive ? "Active" : "Inactive"));
                return true;
            } else {
                System.err.println(" No product found with ID: " + productId);
            }
        } catch (SQLException e) {
            System.err.println("Error in updateProductStatus: " + e.getMessage());

        }

        return false;
    }
    // ========== UPDATE PRODUCT (ADMIN) - Sử dụng execQuery ==========

    public boolean updateProduct(Product product) {
        String query = "UPDATE Product SET "
                + "BrandId = ?, "
                + "CategoryId = ?, "
                + "Name = ?, "
                + "Description = ?, "
                + "DefaultImageUrl = ?, "
                + "Material = ?, "
                + "IsActive = ?, "
                + "UpdatedAt = GETDATE() "
                + "WHERE ProductId = ? AND IsDeleted = 0";

        Object[] params = {
            product.getBrandId(),
            product.getCategoryId(),
            product.getName(),
            product.getDescription(),
            product.getDefaultImageUrl(),
            product.getMaterial(),
            "active".equalsIgnoreCase(product.getIsActive()) ? 1 : 0, // Convert String ("active"/"inactive") to int
            product.getProductId()
        };

        try {
            int affectedRows = execQuery(query, params);

            if (affectedRows > 0) {
                System.out.println("Product updated successfully: ID " + product.getProductId());
                return true;
            } else {
                System.err.println("No product found with ID: " + product.getProductId());
            }
        } catch (SQLException e) {
            System.err.println("Error in updateProduct: " + e.getMessage());

        }

        return false;
    }

    // ========== SOFT DELETE PRODUCT (ADMIN) ==========
    public boolean deleteProduct(int productId) {
        String query = "UPDATE Product SET IsDeleted = 1, UpdatedAt = GETDATE() "
                + "WHERE ProductId = ? AND IsDeleted = 0";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                System.out.println("Product soft-deleted successfully: ID " + productId);
                return true;
            } else {
                System.err.println(" No product found or already deleted: ID " + productId);
            }
        } catch (SQLException e) {
            System.err.println("Error in deleteProduct: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

}
