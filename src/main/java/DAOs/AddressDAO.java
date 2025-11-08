package DAOs;

import Models.Address;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ✅ Version sử dụng DBContext hiện tại của bạn
 * ⚠️ LƯU Ý: Vẫn có vấn đề connection leak và race condition
 */
public class AddressDAO extends DB.DBContext {

    /**
     * Thêm địa chỉ mới
     * NOTE: Nên gọi clearDefaultAddress trước nếu isDefault = true
     */
    public void addAddress(int customerId, String addressName, String addressDetails, 
            String recipientName, String recipientPhone, boolean isDefault, boolean isDeleted) throws SQLException {
        String sql = "INSERT INTO Address (CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {customerId, addressName, addressDetails, recipientName, recipientPhone, isDefault, isDeleted};
        execQuery(sql, params);
    }

    /**
     * ✅ Lấy địa chỉ theo ID với ownership validation
     */
    public Address getAddressById(int addressId) throws SQLException {
        Address address = null;
        String sql = "SELECT AddressId, CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted "
                + "FROM Address "
                + "WHERE AddressId = ? AND IsDeleted = 0";

        Object[] params = {addressId};

        try (ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                address = new Address();
                address.setAddressId(rs.getInt("AddressId"));
                address.setCustomerId(rs.getInt("CustomerId"));
                address.setAddressName(rs.getString("AddressName"));
                address.setAddressDetails(rs.getString("AddressDetails"));
                address.setRecipientName(rs.getString("RecipientName"));
                address.setRecipientPhone(rs.getString("RecipientPhone"));
                address.setIsDefault(rs.getBoolean("IsDefault"));
                address.setIsDeleted(rs.getBoolean("IsDeleted"));
            }
        }
        return address;
    }

    /**
     * ✅ Lấy tất cả địa chỉ của customer
     */
    public List<Address> getAllAddressByCustomerId(int customerId){
        List<Address> list = new ArrayList<>();
        String sql = "SELECT AddressId, CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted "
                + "FROM Address "
                + "WHERE CustomerId = ? AND IsDeleted = 0 "
                + "ORDER BY IsDefault DESC, AddressId ASC";

        Object[] params = {customerId};

        try (ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Address addr = new Address();
                addr.setAddressId(rs.getInt("AddressId"));
                addr.setCustomerId(rs.getInt("CustomerId"));
                addr.setAddressName(rs.getString("AddressName"));
                addr.setAddressDetails(rs.getString("AddressDetails"));
                addr.setRecipientName(rs.getString("RecipientName"));
                addr.setRecipientPhone(rs.getString("RecipientPhone"));
                addr.setIsDefault(rs.getBoolean("IsDefault"));
                addr.setIsDeleted(rs.getBoolean("IsDeleted"));
                list.add(addr);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AddressDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * ✅ Update địa chỉ với ownership validation
     * @param customerId - để verify ownership
     */
    public void updateAddress(int addressId, int customerId, String addressName, 
            String addressDetails, String recipientName, String recipientPhone, boolean isDefault) throws SQLException {
        
        // ✅ Verify ownership trước khi update
        Address existing = getAddressById(addressId);
        if (existing == null || existing.getCustomerId() != customerId) {
            throw new SQLException("Address not found or access denied");
        }
        
        // Update địa chỉ với CustomerId trong WHERE clause
        String sql = "UPDATE Address "
                + "SET AddressName = ?, AddressDetails = ?, RecipientName = ?, RecipientPhone = ?, IsDefault = ? "
                + "WHERE AddressId = ? AND CustomerId = ?"; // ✅ Thêm CustomerId vào WHERE

        Object[] params = {addressName, addressDetails, recipientName, recipientPhone, isDefault, addressId, customerId};
        
        int rowsAffected = execQuery(sql, params);
        if (rowsAffected == 0) {
            throw new SQLException("Update failed - address not found or access denied");
        }
    }

    /**
     * ✅ Soft delete với ownership validation
     * @param customerId - để verify ownership
     */
    public void delete(int addressId, int customerId) throws SQLException {
        // ✅ Verify ownership
        Address address = getAddressById(addressId);
        if (address == null || address.getCustomerId() != customerId) {
            throw new SQLException("Address not found or access denied");
        }
        
        // Soft delete
        String sql = "UPDATE Address SET IsDeleted = 1 WHERE AddressId = ? AND CustomerId = ?";
        Object[] params = {addressId, customerId};
        
        int rowsAffected = execQuery(sql, params);
        if (rowsAffected == 0) {
            throw new SQLException("Delete failed - address not found");
        }
        
        // ✅ Nếu xóa địa chỉ default, tự động set địa chỉ khác làm default
        if (address.isIsDefault()) {
            autoSetNewDefaultAddress(customerId);
        }
    }

    /**
     * ✅ Tự động set địa chỉ đầu tiên còn lại làm default
     * Helper method cho delete operation
     */
    private void autoSetNewDefaultAddress(int customerId) throws SQLException {
        String sql = "UPDATE Address SET IsDefault = 1 "
                + "WHERE CustomerId = ? AND IsDeleted = 0 "
                + "AND AddressId = (SELECT TOP 1 AddressId FROM Address "
                + "                 WHERE CustomerId = ? AND IsDeleted = 0 "
                + "                 ORDER BY AddressId ASC)";
        Object[] params = {customerId, customerId};
        execQuery(sql, params);
    }

    /**
     * ✅ Set địa chỉ làm default với ownership validation
     * @param customerId - để verify ownership
     */
    public void setDefaultAddress(int addressId, int customerId) throws SQLException {
        // ✅ Verify ownership
        Address address = getAddressById(addressId);
        if (address == null || address.getCustomerId() != customerId) {
            throw new SQLException("Address not found or access denied");
        }
        
        // Clear all defaults cho customer này
        clearDefaultAddress(customerId);
        
        // Set new default
        String sqlSet = "UPDATE Address SET IsDefault = 1 "
                + "WHERE AddressId = ? AND CustomerId = ? AND IsDeleted = 0";
        Object[] params = {addressId, customerId};
        
        int rowsAffected = execQuery(sqlSet, params);
        if (rowsAffected == 0) {
            throw new SQLException("Failed to set default address");
        }
    }

    /**
     * ✅ Clear tất cả default addresses của 1 customer
     */
    public void clearDefaultAddress(int customerId) throws SQLException {
        String sql = "UPDATE Address SET IsDefault = 0 WHERE CustomerId = ? AND IsDeleted = 0";
        execQuery(sql, new Object[]{customerId});
    }
    
    /**
     * ✅ BONUS: Check xem địa chỉ có thuộc về customer không
     * Dùng cho validation trong Servlet
     */
    public boolean isAddressBelongToCustomer(int addressId, int customerId) throws SQLException {
        String sql = "SELECT COUNT(*) as cnt FROM Address "
                + "WHERE AddressId = ? AND CustomerId = ? AND IsDeleted = 0";
        Object[] params = {addressId, customerId};
        
        try (ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        }
        return false;
    }
}