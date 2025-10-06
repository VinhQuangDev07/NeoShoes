/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Nguyen Huynh Thien An - CE190979
 */
public class Address {
    private int addressId;
    private int customerId;
    private String addressName;
    private String addressDetails;
    private String recipientName;
    private String recipientPhone;
    private boolean isDefault;
    private boolean isDeleted;

    public Address() {
    }

    public Address(int addressId, int customerId, String addressName, String addressDetails, String recipientName, String recipientPhone, boolean isDefault, boolean isDeleted) {
        this.addressId = addressId;
        this.customerId = customerId;
        this.addressName = addressName;
        this.addressDetails = addressDetails;
        this.recipientName = recipientName;
        this.recipientPhone = recipientPhone;
        this.isDefault = isDefault;
        this.isDeleted = isDeleted;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getAddressName() {
        return addressName;
    }

    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }

    public String getAddressDetails() {
        return addressDetails;
    }

    public void setAddressDetails(String addressDetails) {
        this.addressDetails = addressDetails;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

   
  
}
