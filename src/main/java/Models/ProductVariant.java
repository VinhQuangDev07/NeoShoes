
package Models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author Le Huu Nghia - CE181052
 */
public class ProductVariant {

    private int productVariantId;
    private Product product;
    private int productId;
    private String image;
    private String size;
    private String color;
    private BigDecimal price;
    private int quantityAvailable;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int isDeleted;

    public ProductVariant() {
    }

    public ProductVariant(int productVariantId, Product product, int productId, String image, String size, String color, BigDecimal price, int quantityAvailable, LocalDateTime createdAt, LocalDateTime updatedAt, int isDeleted) {
        this.productVariantId = productVariantId;
        this.product = product;
        this.productId = productId;
        this.image = image;
        this.size = size;
        this.color = color;
        this.price = price;
        this.quantityAvailable = quantityAvailable;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isDeleted = isDeleted;
    }

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantityAvailable() {
        return quantityAvailable;
    }

    public void setQuantityAvailable(int quantityAvailable) {
        this.quantityAvailable = quantityAvailable;
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

    public int getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(int isDeleted) {
        this.isDeleted = isDeleted;
    }

}
