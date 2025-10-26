/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class Customer {
    
    private int id;
    private String email;
    private String passwordHash;
    private String name;
    private String phoneNumber;
    private String avatar;
    private String gender;
    private boolean isVerified;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isBlock;
    private boolean isDeleted;

    public Customer() {
    }

        public Customer(int id, String email, String passwordHash, String name, String phoneNumber, String avatar, String gender, LocalDateTime createdAt, LocalDateTime updatedAt, boolean isBlock, boolean isDeleted) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.avatar = avatar;
        this.gender = gender;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isBlock = isBlock;
        this.isDeleted = isDeleted;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
    
    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isBlock() {
        return isBlock;
    }

    public void setIsBlock(boolean isBlock) {
        this.isBlock = isBlock;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    public String getFormattedCreatedAt() {
    if (createdAt != null) {
        return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
    return "N/A";
}

    @Override
    public String toString() {
        return "Customer{" + "id=" + id + ", email=" + email + ", passwordHash=" + passwordHash + ", name=" + name + ", phoneNumber=" + phoneNumber + ", avatar=" + avatar + ", gender=" + gender + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", isBlock=" + isBlock + ", isDeleted=" + isDeleted + '}';
    }  
    
}
