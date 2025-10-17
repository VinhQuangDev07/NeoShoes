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
public class CartItem {
    private int cartItemId;
    private int customerId;
    private ProductVariant variant;
    private int productVariantId;
    private int quantity;
    private LocalDateTime createdAt;

    public CartItem() {
    }

    public CartItem(int cartItemId, int customerId, ProductVariant variant,int productVariantId, int quantity, LocalDateTime createdAt) {
        this.cartItemId = cartItemId;
        this.customerId = customerId;
        this.variant = variant;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.createdAt = createdAt;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CartItem{" + "cartItemId=" + cartItemId 
                + ", customerId=" + customerId 
                + ", variant=" + variant 
                + ", quantity=" + quantity 
                + ", createdAt=" + createdAt + '}';
    }
    
    
    
}
