<%-- 
    Document   : variant-selector
    Created on : Oct 10, 2025, 7:04:25 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Price -->
<div class="price-section">
    <c:choose>
        <c:when test="${empty product.minPrice or empty product.maxPrice}">
            <div id="priceText" class="price">Discontinue</div>
        </c:when>
        <c:when test="${product.minPrice != product.maxPrice}">
            <div id="priceText" class="price-range">$${product.minPrice} - $${product.maxPrice}</div>
        </c:when>
        <c:otherwise>
            <div id="priceText" class="price">$${product.minPrice}</div>
        </c:otherwise>
    </c:choose>
</div>
<div class="variant-content" id="variantContent">
    <h6 class="mb-3 fw-bold">Select variant</h6>

    <c:if test="${not empty variants}">
        <form id="addToCartForm" action="${pageContext.request.contextPath}/cart" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="variantId" id="variantIdField" value="">
            <input type="hidden" name="quantity" id="quantityField" value="1">
            <input type="hidden" name="productId" value="${product.productId}">

            <!-- Color options -->
            <div class="mb-3">
                <div class="section-title">Color: 
                    <span id="selectedColorText" class="text-muted"></span>
                </div>
                <div class="d-flex flex-wrap gap-2" id="colorOptions">
                    <c:forEach items="${colors}" var="color">
                        <button type="button" class="option-btn color-option" 
                                data-value="${color}"
                                onclick="selectOption('color', '${color}', this)">
                            ${color}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- Size options -->
            <div class="mb-3">
                <div class="section-title">Size: 
                    <span id="selectedSizeText" class="text-muted"></span>
                </div>
                <div class="d-flex flex-wrap gap-2" id="sizeOptions">
                    <c:forEach items="${sizes}" var="size">
                        <button type="button" class="option-btn size-option"
                                data-value="${size}"
                                onclick="selectOption('size', '${size}', this)">
                            ${size}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- Quantity + available -->
            <!-- Quantity Selector -->
            <div class="mb-3 d-flex align-items-center gap-4">
                <label class="fw-medium text-secondary mb-0">Quantity:</label>

                <div class="d-flex align-items-center bg-quantity">
                    <button type="button" id="decreaseQuantityBtn"
                            class="btn btn-sm px-3 py-2 border-end-0"
                            onclick="changeQuantity(-1)">
                        <i class="bi bi-dash text-secondary"></i>
                    </button>

                    <input type="number" id="quantityInput"
                           class="text-center border-0 fw-medium"
                           value="1" min="1" style="width: 50px;" disabled>

                    <button type="button" id="increaseQuantityBtn"
                            class="btn btn-sm px-3 py-2 border-start-0"
                            onclick="changeQuantity(1)">
                        <i class="bi bi-plus text-secondary"></i>
                    </button>
                </div>

                <span id="quantityAvailableText" class="text-muted small"></span>
            </div>

            <!-- Add to Cart -->
            <div class="text-end mt-3">
                <button type="submit" class="btn btn-dark" id="addToCartBtn" disabled>Add to Cart</button>
            </div>

        </form>

        <!-- JSON danh sách variant -->
        <script>
            var allVariants = [
            <c:forEach items="${variants}" var="variant" varStatus="status">
            {
            variantId: ${variant.productVariantId},
                    color: '${variant.color}',
                    size: '${variant.size}',
                    quantityAvailable: ${variant.quantityAvailable},
                    price: ${variant.price},
                    image: '${variant.image}'
            }${!status.last ? ',' : ''}
            </c:forEach>
            ];
        </script>
    </c:if>

    <c:if test="${empty variants}">
        <div class="alert alert-warning">No variants available for this product.</div>
    </c:if>
</div>


<style>
    .option-btn {
        border: 2px solid #dee2e6;
        padding: 8px 16px;
        border-radius: 4px;
        cursor: pointer;
        background: white;
        font-size: 14px;
        transition: all 0.2s;
    }
    .option-btn.selected {
        border-color: #000;
        background: #000;
        color: #fff;
    }
    .option-btn:disabled {
        opacity: 0.4;
        cursor: not-allowed;
        text-decoration: line-through;
    }
    #quantityAvailableText {
        font-size: 14px;
    }

    .bg-quantity {
        border: 1px solid #dee2e6 !important;
        border-radius: 4px;
    }

    #decreaseQuantityBtn,
    #increaseQuantityBtn {
        background-color: #fff !important;
        transition: none !important;
    }

    #decreaseQuantityBtn {
        border-top-right-radius: 4px;
        border-bottom-right-radius: 4px;
    }

    #increaseQuantityBtn {
        border-top-left-radius: 4px;
        border-bottom-left-radius: 4px;
    }

    #decreaseQuantityBtn:hover,
    #increaseQuantityBtn:hover {
        background-color: #f8f9fa !important;
    }

    #quantityInput {
        height: 43px;
    }

    #quantityInput:disabled {
        background-color: #f8f9fa;
    }
    #quantityInput {
        background-color: #f8fafb;
    }

</style>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        disableUnavailableOptions();
    });

    function disableUnavailableOptions() {
        const colorBtns = document.querySelectorAll('.color-option');
        const sizeBtns = document.querySelectorAll('.size-option');

        colorBtns.forEach(btn => {
            const color = btn.dataset.value;
            const available = allVariants.some(v => v.color === color && v.quantityAvailable > 0);
            if (!available)
                btn.disabled = true;
        });

        sizeBtns.forEach(btn => {
            const size = btn.dataset.value;
            const available = allVariants.some(v => v.size === size && v.quantityAvailable > 0);
            if (!available)
                btn.disabled = true;
        });
    }

    let selectedColor = '';
    let selectedSize = '';

    function selectOption(type, value, element) {
        // chọn / bỏ chọn
        document.querySelectorAll('.' + type + '-option').forEach(btn => btn.classList.remove('selected'));
        element.classList.add('selected');

        // cập nhật biến tạm
        if (type === 'color')
            selectedColor = value;
        if (type === 'size')
            selectedSize = value;

        document.getElementById('selected' + capitalize(type) + 'Text').textContent = '(' + value + ')';

        // Lọc các lựa chọn còn khả dụng
        filterOptions();
        // Cập nhật trạng thái
        updateQuantityInfo();
    }

    function filterOptions() {
        const sizeBtns = document.querySelectorAll('.size-option');
        const colorBtns = document.querySelectorAll('.color-option');

        if (selectedColor) {
            sizeBtns.forEach(btn => {
                const hasVariant = allVariants.some(v =>
                    v.color === selectedColor && v.size === btn.dataset.value && v.quantityAvailable > 0
                );
                btn.disabled = !hasVariant;
            });
        }

        if (selectedSize) {
            colorBtns.forEach(btn => {
                const hasVariant = allVariants.some(v =>
                    v.size === selectedSize && v.color === btn.dataset.value && v.quantityAvailable > 0
                );
                btn.disabled = !hasVariant;
            });
        }
    }

    function updateQuantityInfo() {
        const quantityText = document.getElementById('quantityAvailableText');
        const addToCartBtn = document.getElementById('addToCartBtn');
        const qtyInput = document.getElementById('quantityInput');
        const variantField = document.getElementById('variantIdField');
        const priceText = document.getElementById('priceText');

        quantityText.textContent = '';
        addToCartBtn.disabled = true;
        qtyInput.disabled = true;
        variantField.value = '';

        if (!selectedColor || !selectedSize)
            return;

        const variant = allVariants.find(v => v.color === selectedColor && v.size === selectedSize);

        if (variant) {
            variantField.value = variant.variantId;
            const available = variant.quantityAvailable;

            if (priceText) {
                priceText.textContent = '$' + variant.price.toFixed(2);
            }

            const mainImage = document.getElementById('mainImage');
            if (mainImage && variant.image) {
                mainImage.src = variant.image;
            }

            if (available > 0) {
                qtyInput.max = available;
                qtyInput.disabled = false;
                addToCartBtn.disabled = false;
                quantityText.textContent = 'Quantity Available: ' + available;
            } else {
                quantityText.textContent = 'Out of stock';
            }
        }
    }

// đồng bộ số lượng input vào hidden field
    document.getElementById('quantityInput').addEventListener('input', e => {
        document.getElementById('quantityField').value = e.target.value;
    });

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    function changeQuantity(delta) {
        const input = document.getElementById('quantityInput');
        const availableText = document.getElementById('quantityAvailableText');
        const maxQty = parseInt(input.max || '1');
        let value = parseInt(input.value || '1');

        if (isNaN(value))
            value = 1;
        value += delta;

        if (value < 1)
            value = 1;
        if (value > maxQty)
            value = maxQty;

        input.value = value;
        document.getElementById('quantityField').value = value; // cập nhật hidden field
    }
</script>

