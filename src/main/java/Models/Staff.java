package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Staff {

    private int staffId;
    private boolean role;            // true=admin, false=staff
    private String email;
    private String passwordHash;
    private String name;
    private String phoneNumber;
    private String avatar;
    private String gender;
    private String address;          // NEW
    private LocalDate dateOfBirth;   // NEW
    private LocalDateTime createdAt, updatedAt;
    private boolean isDeleted;

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int v) {
        staffId = v;
    }

    public boolean isRole() {
        return role;
    }

    public void setRole(boolean v) {
        role = v;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String v) {
        email = v;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String v) {
        passwordHash = v;
    }

    public String getName() {
        return name;
    }

    public void setName(String v) {
        name = v;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String v) {
        phoneNumber = v;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String v) {
        avatar = v;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String v) {
        gender = v;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String v) {
        address = v;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate v) {
        dateOfBirth = v;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime v) {
        createdAt = v;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime v) {
        updatedAt = v;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean v) {
        isDeleted = v;
    }
}
