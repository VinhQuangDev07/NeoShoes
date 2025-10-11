package DAOs;

import DB.DBContext;
import Models.Product;
import Models.ProductVariant;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
// Thêm vào phần import
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.ArrayList;

public class ProductDAO {

    private final DBContext dbContext;

    public ProductDAO() {
        this.dbContext = new DBContext();
    }

    /* ---------- Helper: map 1 row -> Product ---------- */
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product(
                rs.getInt("ProductId"),
                rs.getInt("BrandId"),
                rs.getInt("CategoryId"),
                rs.getString("Name"),
                rs.getString("Description"),
                rs.getString("DefaultImageUrl"),
                rs.getString("Material")
        );
        product.setMinPrice(rs.getDouble("MinPrice"));
        product.setMaxPrice(rs.getDouble("MaxPrice"));
        product.setTotalQuantity(rs.getInt("TotalQuantity"));
        product.setAvailableColors(rs.getString("AvailableColors"));
        product.setAvailableSizes(rs.getString("AvailableSizes"));
        product.setBrandName(rs.getString("BrandName"));
        product.setCategoryName(rs.getString("CategoryName"));
        return product;
    }

    /* ---------- 1) Featured products (limit) ---------- */
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> products = new ArrayList<>();

        String query =
            "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "       p.Description, p.DefaultImageUrl, p.Material, " +
            "       b.Name AS BrandName, c.Name AS CategoryName, " +
            "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
            "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
            "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
            "       Colors.AvailableColors, Sizes.AvailableSizes " +
            "FROM Product p " +
            "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
            "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
            "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
            "                 FROM ProductVariant pv2 " +
            "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
            ") Colors " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
            "                 FROM ProductVariant pv3 " +
            "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
            ") Sizes " +
            "WHERE p.IsActive = 1 AND p.IsDeleted = 0 " +
            "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
            "         Colors.AvailableColors, Sizes.AvailableSizes " +
            "ORDER BY p.ProductId DESC " +
            "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error in getFeaturedProducts: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /* ---------- 2) All products with pagination ---------- */
    public List<Product> getAllProductsWithPagination(int offset, int pageSize) {
        List<Product> products = new ArrayList<>();

        String query =
            "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "       p.Description, p.DefaultImageUrl, p.Material, " +
            "       b.Name AS BrandName, c.Name AS CategoryName, " +
            "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
            "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
            "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
            "       Colors.AvailableColors, Sizes.AvailableSizes " +
            "FROM Product p " +
            "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
            "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
            "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
            "                 FROM ProductVariant pv2 " +
            "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
            ") Colors " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
            "                 FROM ProductVariant pv3 " +
            "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
            ") Sizes " +
            "WHERE p.IsActive = 1 AND p.IsDeleted = 0 " +
            "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
            "         Colors.AvailableColors, Sizes.AvailableSizes " +
            "ORDER BY p.ProductId DESC " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, Math.max(0, offset));
            ps.setInt(2, Math.max(1, pageSize));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error in getAllProductsWithPagination: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /* ---------- 3) Total count (đếm theo sản phẩm active, có ít nhất 1 variant hợp lệ) ---------- */
    public int getTotalProductsCount() {
        String query =
            "SELECT COUNT(*) AS Total " +
            "FROM Product p " +
            "WHERE p.IsActive = 1 AND p.IsDeleted = 0 " +
            "  AND EXISTS (SELECT 1 FROM ProductVariant pv " +
            "              WHERE pv.ProductId = p.ProductId AND pv.IsDeleted = 0)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("Total");
        } catch (SQLException e) {
            System.out.println("❌ Error in getTotalProductsCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /* ---------- 4) Products by category ---------- */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();

        String query =
            "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "       p.Description, p.DefaultImageUrl, p.Material, " +
            "       b.Name AS BrandName, c.Name AS CategoryName, " +
            "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
            "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
            "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
            "       Colors.AvailableColors, Sizes.AvailableSizes " +
            "FROM Product p " +
            "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
            "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
            "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
            "                 FROM ProductVariant pv2 " +
            "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
            ") Colors " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
            "                 FROM ProductVariant pv3 " +
            "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
            ") Sizes " +
            "WHERE p.CategoryId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 " +
            "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
            "         Colors.AvailableColors, Sizes.AvailableSizes " +
            "ORDER BY p.ProductId DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error in getProductsByCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    /* ---------- 5) Search products ---------- */
    public List<Product> searchProducts(String searchTerm) {
        List<Product> products = new ArrayList<>();

        String query =
            "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "       p.Description, p.DefaultImageUrl, p.Material, " +
            "       b.Name AS BrandName, c.Name AS CategoryName, " +
            "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
            "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
            "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
            "       Colors.AvailableColors, Sizes.AvailableSizes " +
            "FROM Product p " +
            "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
            "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
            "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
            "                 FROM ProductVariant pv2 " +
            "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
            ") Colors " +
            "OUTER APPLY ( " +
            "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
            "                 FROM ProductVariant pv3 " +
            "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
            "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
            ") Sizes " +
            "WHERE (p.Name LIKE ? OR p.Description LIKE ? OR b.Name LIKE ?) " +
            "  AND p.IsActive = 1 AND p.IsDeleted = 0 " +
            "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
            "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
            "         Colors.AvailableColors, Sizes.AvailableSizes " +
            "ORDER BY p.ProductId DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            String like = "%" + (searchTerm == null ? "" : searchTerm.trim()) + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error in searchProducts: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    // Thêm vào ProductDAO

/* ---------- 6) Get product by ID with variants ---------- */
public Product getProductById(int productId) {
    Product product = null;
    
    String query =
        "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "       p.Description, p.DefaultImageUrl, p.Material, " +
        "       b.Name AS BrandName, c.Name AS CategoryName, " +
        "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
        "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
        "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
        "       Colors.AvailableColors, Sizes.AvailableSizes " +
        "FROM Product p " +
        "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
        "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
        "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
        "                 FROM ProductVariant pv2 " +
        "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
        ") Colors " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
        "                 FROM ProductVariant pv3 " +
        "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
        ") Sizes " +
        "WHERE p.ProductId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 " +
        "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
        "         Colors.AvailableColors, Sizes.AvailableSizes";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                product = mapProduct(rs);
                
                // Lấy danh sách variants
                List<ProductVariant> variants = getProductVariants(productId);
                product.setVariants(variants);
                
                // Thiết lập gallery ảnh - THÊM DÒNG NÀY
                setProductImageGallery(product, variants);
            }
        }
    } catch (SQLException e) {
        System.out.println("❌ Error in getProductById: " + e.getMessage());
        e.printStackTrace();
    }
    return product;
}

/* ---------- Helper: Get product variants ---------- */
private List<ProductVariant> getProductVariants(int productId) {
    List<ProductVariant> variants = new ArrayList<>();
    
    String query = 
        "SELECT ProductVariantId, ProductId, Image, Color, Size, Price, " +
        "       QuantityAvailable, CreatedAt, UpdatedAt, IsDeleted " +
        "FROM ProductVariant " +
        "WHERE ProductId = ? AND IsDeleted = 0 " +
        "ORDER BY Color, Size";
    
    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductVariant variant = new ProductVariant();
                variant.setProductVariantId(rs.getInt("ProductVariantId"));
                variant.setProductId(rs.getInt("ProductId"));
                variant.setImage(rs.getString("Image"));
                variant.setColor(rs.getString("Color"));
                variant.setSize(rs.getString("Size"));
                variant.setPrice(rs.getDouble("Price"));
                variant.setQuantityAvailable(rs.getInt("QuantityAvailable"));
                variant.setCreatedAt(rs.getObject("CreatedAt", LocalDateTime.class));
                variant.setUpdatedAt(rs.getObject("UpdatedAt", LocalDateTime.class));
                variant.setDeleted(rs.getBoolean("IsDeleted"));
                
                variants.add(variant);
            }
        }
    } catch (SQLException e) {
        System.out.println("❌ Error in getProductVariants: " + e.getMessage());
        e.printStackTrace();
    }
    return variants;
}

/* ---------- Helper: Set product image gallery ---------- */
private void setProductImageGallery(Product product, List<ProductVariant> variants) {
    Set<String> imageSet = new LinkedHashSet<>();
    
    // Thêm ảnh mặc định đầu tiên
    if (product.getDefaultImageUrl() != null && !product.getDefaultImageUrl().trim().isEmpty()) {
        String optimizedUrl = optimizeCloudinaryUrl(product.getDefaultImageUrl(), 600, 600);
        imageSet.add(optimizedUrl);
    }
    
    // Thêm ảnh từ các variants
    for (ProductVariant variant : variants) {
        if (variant.getImage() != null && !variant.getImage().trim().isEmpty()) {
            String optimizedUrl = optimizeCloudinaryUrl(variant.getImage(), 600, 600);
            imageSet.add(optimizedUrl);
        }
    }
    
    // Nếu không có ảnh nào, thêm ảnh placeholder
    if (imageSet.isEmpty()) {
        imageSet.add("https://via.placeholder.com/600x600?text=No+Image");
    }
    
    product.setImageGallery(new ArrayList<>(imageSet));
}

/* ---------- Helper: Optimize Cloudinary URL ---------- */
private String optimizeCloudinaryUrl(String originalUrl, int width, int height) {
    if (originalUrl == null || originalUrl.trim().isEmpty()) {
        return "https://via.placeholder.com/" + width + "x" + height + "?text=No+Image";
    }
    
    // Nếu ảnh đã là từ Cloudinary, thêm parameters để tối ưu
    if (originalUrl.contains("cloudinary.com")) {
        String[] parts = originalUrl.split("/upload/");
        if (parts.length == 2) {
            return parts[0] + "/upload/w_" + width + ",h_" + height + ",c_fill,q_auto,f_auto/" + parts[1];
        }
    }
    
    // Nếu không phải Cloudinary, trả về URL gốc
    return originalUrl;
}

/* ---------- Helper: Get thumbnail URLs ---------- */
public List<String> getThumbnailUrls(List<String> imageUrls) {
    List<String> thumbnails = new ArrayList<>();
    if (imageUrls == null || imageUrls.isEmpty()) {
        thumbnails.add("https://via.placeholder.com/100x100?text=No+Image");
        return thumbnails;
    }
    
    for (String url : imageUrls) {
        thumbnails.add(optimizeCloudinaryUrl(url, 100, 100));
    }
    return thumbnails;
}


/* ---------- 7) Products by brand ---------- */
public List<Product> getProductsByBrand(int brandId) {
    List<Product> products = new ArrayList<>();

    String query =
        "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "       p.Description, p.DefaultImageUrl, p.Material, " +
        "       b.Name AS BrandName, c.Name AS CategoryName, " +
        "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
        "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
        "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
        "       Colors.AvailableColors, Sizes.AvailableSizes " +
        "FROM Product p " +
        "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
        "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
        "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
        "                 FROM ProductVariant pv2 " +
        "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
        ") Colors " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
        "                 FROM ProductVariant pv3 " +
        "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
        ") Sizes " +
        "WHERE p.BrandId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 " +
        "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
        "         Colors.AvailableColors, Sizes.AvailableSizes " +
        "ORDER BY p.ProductId DESC";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, brandId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }
    } catch (SQLException e) {
        System.out.println("❌ Error in getProductsByBrand: " + e.getMessage());
        e.printStackTrace();
    }
    return products;
}

/* ---------- 8) Products by category and brand ---------- */
public List<Product> getProductsByCategoryAndBrand(int categoryId, int brandId) {
    List<Product> products = new ArrayList<>();

    String query =
        "SELECT p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "       p.Description, p.DefaultImageUrl, p.Material, " +
        "       b.Name AS BrandName, c.Name AS CategoryName, " +
        "       MIN(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MinPrice, " +
        "       MAX(CASE WHEN pv.IsDeleted = 0 THEN pv.Price END) AS MaxPrice, " +
        "       SUM(CASE WHEN pv.IsDeleted = 0 THEN pv.QuantityAvailable ELSE 0 END) AS TotalQuantity, " +
        "       Colors.AvailableColors, Sizes.AvailableSizes " +
        "FROM Product p " +
        "LEFT JOIN ProductVariant pv ON p.ProductId = pv.ProductId " +
        "INNER JOIN Brand b ON p.BrandId = b.BrandId " +
        "INNER JOIN Category c ON p.CategoryId = c.CategoryId " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv2.Color " +
        "                 FROM ProductVariant pv2 " +
        "                 WHERE pv2.ProductId = p.ProductId AND pv2.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableColors " +
        ") Colors " +
        "OUTER APPLY ( " +
        "   SELECT STUFF((SELECT DISTINCT ',' + pv3.Size " +
        "                 FROM ProductVariant pv3 " +
        "                 WHERE pv3.ProductId = p.ProductId AND pv3.IsDeleted = 0 " +
        "                 FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AvailableSizes " +
        ") Sizes " +
        "WHERE p.CategoryId = ? AND p.BrandId = ? AND p.IsActive = 1 AND p.IsDeleted = 0 " +
        "GROUP BY p.ProductId, p.BrandId, p.CategoryId, p.Name, " +
        "         p.Description, p.DefaultImageUrl, p.Material, b.Name, c.Name, " +
        "         Colors.AvailableColors, Sizes.AvailableSizes " +
        "ORDER BY p.ProductId DESC";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, categoryId);
        ps.setInt(2, brandId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }
    } catch (SQLException e) {
        System.out.println("❌ Error in getProductsByCategoryAndBrand: " + e.getMessage());
        e.printStackTrace();
    }
    return products;
}
}
