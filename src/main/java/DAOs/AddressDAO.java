/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Address;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class AddressDAO extends DB.DBContext {

    public void addAddress(int customerId, String addressName, String addressDetails, String recipientName, String recipientPhone, boolean isDefault, boolean isDeleted) throws SQLException {
        String sql = "INSERT INTO Address (CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {customerId, addressName, addressDetails, recipientName, recipientPhone, isDefault, isDeleted};
        execQuery(sql, params);
    }

    public Address getAddressById(int addressId) throws SQLException {
        Address address = null;
        String sql = "SELECT AddressId, CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted "
                + "FROM Address "
                + "WHERE AddressId = ? AND IsDeleted = 0";

        Object[] params = {addressId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
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

    public List<Address> getAllAddressByCustomerId(int customerId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT AddressId, CustomerId, AddressName, AddressDetails, RecipientName, RecipientPhone, IsDefault, IsDeleted "
                + "FROM Address "
                + "WHERE CustomerId = ? AND IsDeleted = 0 "
                + "ORDER BY IsDefault DESC, AddressId ASC";

        Object[] params = {customerId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
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
        }
        return list;
    }

    public void updateAddress(int addressId, String addressName, String addressDetails, String recipientName, String recipientPhone, boolean isDefault) throws SQLException {
        String sql = "UPDATE Address "
                + "SET AddressName = ?, AddressDetails = ?, RecipientName = ?, RecipientPhone = ?, "
                + "IsDefault = ? "
                + "WHERE AddressId = ?";

        Object[] params = {addressName, addressDetails, recipientName, recipientPhone, isDefault, addressId};
        execQuery(sql, params);
    }

    public void delete(int id) throws SQLException {
        String sql = "UPDATE Address SET IsDeleted = 1 WHERE AddressId = ?";
        Object[] params = {id};
        execQuery(sql, params);
    }

    public void setDefaultAddress(int addressId, int customerId) throws SQLException {
        String sqlUnSet = "UPDATE Address SET IsDefault = 0 WHERE CustomerId = ? ";
        Object[] UnSet = {customerId};
        execQuery(sqlUnSet, UnSet);

        String sqlSet = "UPDATE Address SET IsDefault = 1 WHERE AddressId = ? AND CustomerId = ?";
        Object[] Set = {addressId, customerId};
        execQuery(sqlSet, Set);
    }

    public void clearDefaultAddress(int customerId) throws SQLException {
        String sql = "UPDATE Address SET IsDefault = 0 WHERE CustomerId = ?";
        execQuery(sql, new Object[]{customerId});
    }

}
