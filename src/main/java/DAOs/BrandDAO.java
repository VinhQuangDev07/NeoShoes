package DAOs;

import DB.DBContext;
import Models.Brand;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {
    private DBContext dbContext;

    public BrandDAO() {
        this.dbContext = new DBContext();
    }

    // Lấy tất cả brands active
    public List<Brand> getAllActiveBrands() {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT BrandId, Name, Logo, IsDeleted FROM Brand WHERE IsDeleted = 0 ORDER BY Name";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandId(rs.getInt("BrandId"));
                brand.setName(rs.getString("Name"));
                brand.setLogo(rs.getString("Logo"));
                brand.setDeleted(rs.getBoolean("IsDeleted"));
                brands.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }
}