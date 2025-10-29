/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.ImportProduct;
import Models.ImportProductDetail;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ImportProductDAO extends DB.DBContext {

    /**
     * Insert import product header - returns generated ID
     */
    public int insertImportProduct(ImportProduct importRecord) {
        String sql = "INSERT INTO dbo.ImportProduct (StaffId, ImportDate, SupplierName, Note, IsDeleted) "
                + "VALUES (?, ?, ?, ?, ?)";
        Object[] params = {
            importRecord.getStaffId(),
            Timestamp.valueOf(importRecord.getImportDate()),
            importRecord.getSupplierName(),
            importRecord.getNote(),
            importRecord.isDeleted() ? 1 : 0
        };
        try {
            return execQueryReturnId(sql, params);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Insert import product detail
     */
    public int insertImportProductDetail(ImportProductDetail detail) {
        String sql = "INSERT INTO dbo.ImportProductDetail (ImportProductId, ProductVariantId, Quantity, CostPrice, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        Object[] params = {
            detail.getImportProductId(),
            detail.getProductVariantId(),
            detail.getQuantity(),
            detail.getCostPrice(),
            LocalDateTime.now(),
            LocalDateTime.now()
        };
        try {
            return execQueryReturnId(sql, params);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Update import product header
     */
    public boolean updateImportProduct(ImportProduct importRecord) {
        String sql = "UPDATE dbo.ImportProduct "
                + "SET SupplierName = ?, ImportDate = ?, Note = ? "
                + "WHERE ImportProductId = ? AND IsDeleted = 0";

        Object[] params = {
            importRecord.getSupplierName(),
            Timestamp.valueOf(importRecord.getImportDate()),
            importRecord.getNote(),
            importRecord.getImportProductId()
        };

        try {
            int rowsAffected = execQuery(sql, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update import product detail
     */
    public boolean updateImportProductDetail(ImportProductDetail detail) {
        String sql = "UPDATE dbo.ImportProductDetail "
                + "SET ProductVariantId = ?, Quantity = ?, CostPrice = ?, UpdatedAt = GETDATE() "
                + "WHERE ImportProductDetailId = ?";

        Object[] params = {
            detail.getProductVariantId(),
            detail.getQuantity(),
            detail.getCostPrice(),
            detail.getImportProductDetailId()
        };

        try {
            int rowsAffected = execQuery(sql, params); // ✅ dùng hàm từ DBContext
            return rowsAffected > 0; // trả về true nếu có dòng bị ảnh hưởng
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // false nếu lỗi hoặc không update được
        }
    }

    /**
     * Delete import details by import ID
     */
    public boolean deleteImportDetails(int importProductId) {
        String sql = "DELETE FROM dbo.ImportProductDetail WHERE ImportProductId = ?";
        try {
            int rowsAffected = execQuery(sql, new Object[]{importProductId});
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete import product detail (hard delete)
     */
    public boolean deleteImportProductDetail(int detailId) {
        String sql = "DELETE FROM dbo.ImportProductDetail WHERE ImportProductDetailId = ?";

        Object[] params = {detailId};

        try {
            int rowsAffected = execQuery(sql, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hard delete import product (permanently remove record)
     */
    public boolean deleteImportProduct(int importProductId) {
        String sql = "DELETE FROM dbo.ImportProduct WHERE ImportProductId = ?";

        Object[] params = {importProductId};

        try {
            int rowsAffected = execQuery(sql, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Soft delete import product (set IsDeleted = 1)
     */
    public boolean softDeleteImportProduct(int importProductId) {
        String sql = "UPDATE dbo.ImportProduct "
                + "SET IsDeleted = 1, UpdatedAt = GETDATE() "
                + "WHERE ImportProductId = ? AND IsDeleted = 0";

        Object[] params = {importProductId};

        try {
            int rowsAffected = execQuery(sql, params); 
            return rowsAffected > 0; 
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get import product by ID with staff name
     */
    public ImportProduct getImportById(int importId) {
        String sql = "SELECT ip.ImportProductId, ip.ImportDate, ip.SupplierName, ip.Note, ip.StaffId, s.Name AS StaffName "
                + "FROM dbo.ImportProduct ip "
                + "JOIN dbo.Staff s ON s.StaffId = ip.StaffId AND s.IsDeleted = 0 "
                + "WHERE ip.ImportProductId = ? AND ip.IsDeleted = 0";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{importId})) {
            if (rs.next()) {
                ImportProduct record = new ImportProduct();
                record.setImportProductId(rs.getInt("ImportProductId"));
                record.setImportDate(rs.getTimestamp("ImportDate").toLocalDateTime());
                record.setSupplierName(rs.getString("SupplierName"));
                record.setNote(rs.getString("Note"));
                record.setStaffId(rs.getInt("StaffId"));
                record.setStaffName(rs.getString("StaffName"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get import details with variant info
     */
    public List<ImportProductDetail> getImportDetails(int importProductId) {
        List<ImportProductDetail> details = new ArrayList<>();
        String sql = "SELECT ipd.ImportProductDetailId, ipd.ProductVariantId, pv.Image, pv.Color, pv.Size, "
                + "        ipd.Quantity, ipd.CostPrice, ipd.CreatedAt, ipd.UpdatedAt, p.ProductId, p.Name AS ProductName "
                + "FROM dbo.ImportProductDetail ipd "
                + "JOIN dbo.ProductVariant pv ON pv.ProductVariantId = ipd.ProductVariantId AND pv.IsDeleted = 0 "
                + "JOIN dbo.Product p ON p.ProductId = pv.ProductId AND p.IsDeleted = 0 "
                + "WHERE ipd.ImportProductId = ? "
                + "ORDER BY ipd.ImportProductDetailId";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{importProductId})) {
            while (rs.next()) {
                ImportProductDetail detail = new ImportProductDetail();
                detail.setImportProductDetailId(rs.getInt("ImportProductDetailId"));
                detail.setProductVariantId(rs.getInt("ProductVariantId"));
                detail.setVariantImage(rs.getString("Image"));
                detail.setColor(rs.getString("Color"));
                detail.setSize(rs.getString("Size"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setCostPrice(rs.getBigDecimal("CostPrice"));
                detail.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                detail.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                detail.setProductId(rs.getInt("ProductId"));
                detail.setProductName(rs.getString("ProductName"));
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    /**
     * Get import detail objects for delta calculation
     */
    public List<ImportProductDetail> getImportDetailObjects(int importProductId) {
        List<ImportProductDetail> details = new ArrayList<>();
        String sql = "SELECT ImportProductDetailId, ImportProductId, ProductVariantId, Quantity, CostPrice, CreatedAt, UpdatedAt "
                + "FROM dbo.ImportProductDetail "
                + "WHERE ImportProductId = ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{importProductId})) {
            while (rs.next()) {
                ImportProductDetail detail = new ImportProductDetail();
                detail.setImportProductDetailId(rs.getInt("ImportProductDetailId"));
                detail.setImportProductId(rs.getInt("ImportProductId"));
                detail.setProductVariantId(rs.getInt("ProductVariantId"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setCostPrice(rs.getBigDecimal("CostPrice"));
                detail.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                detail.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                details.add(detail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    /**
     * Search imports with filters
     */
    public List<ImportProduct> searchImports(String phrase, LocalDateTime fromDate,
            LocalDateTime toDate, int offset, int pageSize) {
        List<ImportProduct> records = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ip.ImportProductId, ip.ImportDate, ip.SupplierName, ip.Note, s.StaffId, s.Name AS StaffName "
                + "FROM dbo.ImportProduct ip "
                + "JOIN dbo.Staff s ON s.StaffId = ip.StaffId AND s.IsDeleted = 0 "
                + "WHERE ip.IsDeleted = 0"
        );

        List<Object> paramsList = new ArrayList<>();

        if (phrase != null && !phrase.isEmpty()) {
            sql.append(" AND (ip.SupplierName LIKE ? OR ip.Note LIKE ? OR s.Name LIKE ?)");
            String searchPattern = "%" + phrase + "%";
            paramsList.add(searchPattern);
            paramsList.add(searchPattern);
            paramsList.add(searchPattern);
        }

        if (fromDate != null) {
            sql.append(" AND ip.ImportDate >= ?");
            paramsList.add(Timestamp.valueOf(fromDate));
        }

        if (toDate != null) {
            sql.append(" AND ip.ImportDate < ?");
            paramsList.add(Timestamp.valueOf(toDate));
        }

        sql.append(" ORDER BY ip.ImportDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        paramsList.add(offset);
        paramsList.add(pageSize);

        Object[] params = paramsList.toArray();
        try ( ResultSet rs = execSelectQuery(sql.toString(), params)) {
            while (rs.next()) {
                ImportProduct record = new ImportProduct();
                record.setImportProductId(rs.getInt("ImportProductId"));
                record.setImportDate(rs.getTimestamp("ImportDate").toLocalDateTime());
                record.setSupplierName(rs.getString("SupplierName"));
                record.setNote(rs.getString("Note"));
                record.setStaffId(rs.getInt("StaffId"));
                record.setStaffName(rs.getString("StaffName"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    /**
     * Count imports with filters
     */
    public int countImports(String phrase, LocalDateTime fromDate, LocalDateTime toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) as cnt FROM dbo.ImportProduct ip "
                + "JOIN dbo.Staff s ON s.StaffId = ip.StaffId AND s.IsDeleted = 0 "
                + "WHERE ip.IsDeleted = 0"
        );

        List<Object> paramsList = new ArrayList<>();

        if (phrase != null && !phrase.isEmpty()) {
            sql.append(" AND (ip.SupplierName LIKE ? OR ip.Note LIKE ? OR s.Name LIKE ?)");
            String searchPattern = "%" + phrase + "%";
            paramsList.add(searchPattern);
            paramsList.add(searchPattern);
            paramsList.add(searchPattern);
        }

        if (fromDate != null) {
            sql.append(" AND ip.ImportDate >= ?");
            paramsList.add(Timestamp.valueOf(fromDate));
        }

        if (toDate != null) {
            sql.append(" AND ip.ImportDate < ?");
            paramsList.add(Timestamp.valueOf(toDate));
        }

        Object[] params = paramsList.toArray();
        try ( ResultSet rs = execSelectQuery(sql.toString(), params)) {
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
