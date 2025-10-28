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

    /**
     * Get role name for display
     * @return "Admin" or "Staff"
     */
    public String getRoleName() {
        return role ? "Admin" : "Staff";
    }
    
    /**
     * Get display avatar with fallback
     * @return Avatar URL or default image
     */
    public String getDisplayAvatar() {
        if (avatar == null || avatar.trim().isEmpty()) {
            return "https://ui-avatars.com/api/?name=Staff&background=667eea&color=fff&size=200";
        }
        return avatar;
    }
    
    /**
     * Check if user is admin
     * @return true if admin
     */
    public boolean isAdmin() {
        return role;
    }
    
    /**
     * Format created date for display
     * @return Formatted date string
     */
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "N/A";
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdAt.format(formatter);
    }
    
    /**
     * Format date of birth for display
     * @return Formatted date string
     */
    public String getFormattedDob() {
        if (dateOfBirth == null) return "N/A";
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return dateOfBirth.format(formatter);
    }
    
    /**
     * Get age from date of birth
     * @return Age in years or "N/A"
     */
    public String getAge() {
        if (dateOfBirth == null) return "N/A";
        return String.valueOf(LocalDate.now().getYear() - dateOfBirth.getYear());
    }

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
