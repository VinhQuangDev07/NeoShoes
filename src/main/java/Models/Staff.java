/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class Staff {
    private int staffId;
    private boolean role;
    private String email;
    private String passwordHash;
    private String name;
    private String phoneNumber;
    private String avatar;
    private String gender;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;

    public Staff() {
    }

    public Staff(int staffId, boolean role, String email, String passwordHash, String name, String phoneNumber, String avatar, String gender, LocalDateTime createdAt, LocalDateTime updatedAt, boolean isDeleted) {
        this.staffId = staffId;
        this.role = role;
        this.email = email;
        this.passwordHash = passwordHash;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.avatar = avatar;
        this.gender = gender;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public boolean isRole() {
        return role;
    }

    public void setRole(boolean role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    // Helper method to get role name
    public String getRoleName() {
        return role ? "Admin" : "Staff";
    }
    
    // Helper method to format createdAt
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "N/A";
    }

    // Helper method to format updatedAt
    public String getFormattedUpdatedAt() {
        if (updatedAt != null) {
            return updatedAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "N/A";
    }

    // Check if staff is admin
    public boolean isAdmin() {
        return role;
    }

    // Check if staff is regular staff
    public boolean isStaff() {
        return !role;
    }

    @Override
    public String toString() {
        return "Staff{" + "staffId=" + staffId 
                + ", role=" + role 
                + ", email=" + email 
                + ", passwordHash=" + passwordHash 
                + ", name=" + name 
                + ", phoneNumber=" + phoneNumber 
                + ", avatar=" + avatar 
                + ", gender=" + gender 
                + ", createdAt=" + createdAt 
                + ", updatedAt=" + updatedAt 
                + ", isDeleted=" + isDeleted + '}';
    }
    
    
}
