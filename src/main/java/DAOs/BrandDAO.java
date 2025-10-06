package DAOs;

import DB.DBContext;
import Models.Brand;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO extends DBContext {
    private static final String TBL = "[dbo].[Brand]"; // ⚠️ đúng tên bảng trong SQL
    private Connection connection;

    public BrandDAO(Connection connection) {
        this.connection = (connection != null) ? connection : super.getConnection();
    }

    public BrandDAO() { // cho phép new BrandDAO() không cần truyền conn
        this.connection = super.getConnection();
    }

    // Đảm bảo luôn có Connection hợp lệ
    private Connection getConn() throws SQLException {
        if (this.connection == null || this.connection.isClosed()) {
            this.connection = super.getConnection();
        }
        if (this.connection == null) {
            throw new SQLException("DB connection is null. Check DBContext/AppContextListener.");
        }
        return this.connection;
    }

    public List<Brand> getAllBrands() throws SQLException {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT BrandId, Name, Logo, ISNULL(IsDeleted,0) AS IsDeleted " +
                     "FROM " + TBL + " WHERE ISNULL(IsDeleted,0) = 0 ORDER BY Name";
        try (Statement stmt = getConn().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("BrandId"));
                b.setName(rs.getString("Name"));
                b.setLogo(rs.getString("Logo"));
                b.setDeleted(rs.getBoolean("IsDeleted"));
                brands.add(b);
            }
        }
        return brands;
    }

    public Brand getBrandById(int id) throws SQLException {
        String sql = "SELECT BrandId, Name, Logo, ISNULL(IsDeleted,0) AS IsDeleted " +
                     "FROM " + TBL + " WHERE BrandId = ? AND ISNULL(IsDeleted,0) = 0";
        try (PreparedStatement stmt = getConn().prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Brand b = new Brand();
                    b.setBrandId(rs.getInt("BrandId"));
                    b.setName(rs.getString("Name"));
                    b.setLogo(rs.getString("Logo"));
                    b.setDeleted(rs.getBoolean("IsDeleted"));
                    return b;
                }
            }
        }
        return null;
    }

    public boolean addBrand(Brand brand) throws SQLException {
        String sql = "INSERT INTO " + TBL + " (Name, Logo, IsDeleted) VALUES (?, ?, 0)";
        try (PreparedStatement stmt = getConn().prepareStatement(sql)) {
            stmt.setString(1, brand.getName());
            stmt.setString(2, brand.getLogo());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateBrand(Brand brand) throws SQLException {
        String sql = "UPDATE " + TBL + " SET Name = ?, Logo = ? WHERE BrandId = ? AND ISNULL(IsDeleted,0) = 0";
        try (PreparedStatement stmt = getConn().prepareStatement(sql)) {
            stmt.setString(1, brand.getName());
            stmt.setString(2, brand.getLogo());
            stmt.setInt(3, brand.getBrandId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Soft delete
    public boolean deleteBrand(int id) throws SQLException {
        String sql = "UPDATE " + TBL + " SET IsDeleted = 1 WHERE BrandId = ?";
        try (PreparedStatement stmt = getConn().prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
}
