/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;

/**
 * StaffReply model class
 * Represents a staff reply to a customer review
 * 
 * @author System
 */
public class StaffReply {
    private int staffReplyId;
    private int reviewId;
    private String content;
    private LocalDateTime createdAt;
    private String staffName;
    
    // Constructors
    public StaffReply() {}
    
    public StaffReply(int reviewId, String content) {
        this.reviewId = reviewId;
        this.content = content;
    }
    
    // Getters and Setters
    public int getStaffReplyId() {
        return staffReplyId;
    }
    
    public void setStaffReplyId(int staffReplyId) {
        this.staffReplyId = staffReplyId;
    }
    
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getStaffName() {
        return staffName;
    }
    
    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    
    @Override
    public String toString() {
        return "StaffReply{" +
                "staffReplyId=" + staffReplyId +
                ", reviewId=" + reviewId +
                ", content='" + content + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
