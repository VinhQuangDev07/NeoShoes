/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import Utils.Utils;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ImportProduct {

    private int importProductId;
    private int staffId;
    private LocalDateTime importDate;
    private String supplierName;
    private String note;
    private boolean isDeleted;

    // Additional fields for display
    private String staffName;
    private List<ImportProductDetail> importProductDetails;

    public ImportProduct() {
    }

    public ImportProduct(int importProductId, int staffId, LocalDateTime importDate, String supplierName, String note, boolean isDeleted, String staffName) {
        this.importProductId = importProductId;
        this.staffId = staffId;
        this.importDate = importDate;
        this.supplierName = supplierName;
        this.note = note;
        this.isDeleted = isDeleted;
        this.staffName = staffName;
    }

    public int getImportProductId() {
        return importProductId;
    }

    public void setImportProductId(int importProductId) {
        this.importProductId = importProductId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public LocalDateTime getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDateTime importDate) {
        this.importDate = importDate;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getFormattedImportDate() {
        if (importDate != null) {
            return importDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "N/A";
    }

    public List<ImportProductDetail> getImportProductDetails() {
        return importProductDetails;
    }

    public void setImportProductDetails(List<ImportProductDetail> importProductDetails) {
        this.importProductDetails = importProductDetails;
    }

    @Override
    public String toString() {
        return "ImportProduct{" + "importProductId=" + importProductId
                + ", staffId=" + staffId
                + ", importDate=" + importDate
                + ", supplierName=" + supplierName
                + ", note=" + note
                + ", isDeleted=" + isDeleted
                + ", staffName=" + staffName + '}';
    }

}
