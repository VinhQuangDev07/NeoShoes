package DAOs;

import DB.DBContext;
import Models.Brand;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {
    private static final String TBL = "[dbo].[Brand]";
    private DBContext dbContext;

    public BrandDAO() {
        this.dbContext = new DBContext();
    }

    public List<Brand> getAllBrands() throws SQLException {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT BrandId, Name, Logo, ISNULL(IsDeleted,0) AS IsDeleted " +
                     "FROM " + TBL + " WHERE ISNULL(IsDeleted,0) = 0 ORDER BY Name";
        
        try (ResultSet rs = dbContext.execSelectQuery(sql)) {
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
        
        Object[] params = {id};
        try (ResultSet rs = dbContext.execSelectQuery(sql, params)) {
            if (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("BrandId"));
                b.setName(rs.getString("Name"));
                b.setLogo(rs.getString("Logo"));
                b.setDeleted(rs.getBoolean("IsDeleted"));
                return b;
            }
        }
        return null;
    }

    public boolean addBrand(Brand brand) throws SQLException {
        String sql = "INSERT INTO " + TBL + " (Name, Logo, IsDeleted) VALUES (?, ?, 0)";
        Object[] params = {brand.getName(), brand.getLogo()};
        
        return dbContext.execQuery(sql, params) > 0;
    }

    public int addBrandReturnId(Brand brand) throws SQLException {
        String sql = "INSERT INTO " + TBL + " (Name, Logo, IsDeleted) VALUES (?, ?, 0)";
        Object[] params = {brand.getName(), brand.getLogo()};
        
        return dbContext.execQueryReturnId(sql, params);
    }

    public boolean updateBrand(Brand brand) throws SQLException {
        String sql = "UPDATE " + TBL + " SET Name = ?, Logo = ? WHERE BrandId = ? AND ISNULL(IsDeleted,0) = 0";
        Object[] params = {brand.getName(), brand.getLogo(), brand.getBrandId()};
        
        return dbContext.execQuery(sql, params) > 0;
    }

    // Soft delete
    public boolean deleteBrand(int id) throws SQLException {
        String sql = "UPDATE " + TBL + " SET IsDeleted = 1 WHERE BrandId = ?";
        Object[] params = {id};
        
        return dbContext.execQuery(sql, params) > 0;
    }
}