<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Cart | NeoShoes</title>

        <!-- Bootstrap & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body.modal-open {
                overflow: hidden;
                width: 100%;
            }
            .checkbox-black:checked {
                background-color: #000 !important;
                border-color: #000 !important;
            }
            .variant-btn-wrapper {
                position: relative;
                display: inline-block;
            }
            .variant-modal.show {
                display: block;
            }
            .variant-modal {
                display: none;
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 1050;
            }
            .variant-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.3);
            }
            .variant-content {
                position: absolute;
                background: white;
                border-radius: 8px;
                padding: 20px;
                width: 320px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
                animation: slideDown 0.2s ease;
                z-index: 1051;
            }
            @keyframes slideDown {
                from {
                    opacity:0;
                    transform:translateY(-10px);
                }
                to {
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .option-btn {
                border: 1px solid #dee2e6;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.2s ease;
                background: white;
                font-size: 14px;
            }

            .option-btn:hover {
                border-color: #000;
                background: #f8f9fa;
            }

            .option-btn.selected {
                border-color: #000;
                background: #000;
                color: white;
                position: relative;
            }
            .btn-confirm {
                background:#000;
                border:none;
                color:white;
                padding:8px 24px;
                border-radius:4px;
            }
            .btn-confirm:hover {
                background:#333;
                color:white;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />

        <main class="container my-5">
            <!-- Header -->
            <div class="text-center mb-5">
                <h1 class="fw-bold display-5">
                    <i class="bi bi-cart-check me-2"></i>Your Shopping Cart
                </h1>
                <p class="text-muted">Shoe Sales Website – NeoShoes</p>
            </div>

            <!-- Cart info -->
            <div class="alert alert-light border-start border-3 border-1 shadow-sm mb-4" role="alert">
                <i class="bi bi-bell-fill me-2"></i>
                You have <strong><c:out value="${itemCount}" default="0"/> item(s)</strong> in your cart.
            </div>

            <div class="row g-4">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <c:forEach var="item" items="${cartItems}">
                        <c:set var="productId" value="${item.variant.product.productId}" />
                        <!-- Cart item -->
                        <div class="card shadow-sm mb-3">
                            <div class="row g-0 align-items-center p-1">
                                <!-- Checkbox -->
                                <div class="col-md-1 text-center">
                                    <input type="checkbox"
                                           class="form-check-input checkbox-black"
                                           id="checkbox-${item.cartItemId}">
                                </div>

                                <!-- Image -->
                                <div class="col-md-3 text-center">
                                    <img src="${item.variant.image}"
                                         alt="${item.variant.product.name}"
                                         class="img-fluid rounded"
                                         style="width:200px; height:200px; object-fit:cover;">
                                </div>

                                <!-- Info -->
                                <div class="col-md-8">
                                    <div class="card-body">
                                        <h5 class="card-title fw-bold">${item.variant.product.name}</h5>

                                        <div class="row align-items-start mb-3">
                                            <!-- Left -->
                                            <div class="col-md-6">
                                                <div class="variant-btn-wrapper">
                                                    <button class="btn btn-outline-secondary btn-sm selectVariantBtn"
                                                            data-product-id="${productId}">
                                                        Select Variant
                                                    </button>

                                                    <!-- Modal select variant -->
                                                    <div class="variant-modal" id="variantModal-${productId}">
                                                        <div class="variant-backdrop"></div>
                                                        <div class="variant-content">
                                                            <h6 class="mb-3 fw-bold">Select variant</h6>

                                                            <!-- Color -->
                                                            <div class="mb-3">
                                                                <div class="section-title">Color:</div>
                                                                <div class="d-flex flex-wrap gap-2">
                                                                    <c:forEach var="color" items="${colorsByProduct[productId]}">
                                                                        <button class="option-btn color-option"
                                                                                data-value="${color}">
                                                                            ${color}
                                                                        </button>
                                                                    </c:forEach>
                                                                    <c:if test="${empty colorsByProduct[productId]}">
                                                                        <p style="color:red;">No colors for product ${productId}</p>
                                                                    </c:if>
                                                                </div>
                                                            </div>

                                                            <!-- Size -->
                                                            <div class="mb-3">
                                                                <div class="section-title">Size:</div>
                                                                <div class="d-flex flex-wrap gap-2">
                                                                    <c:forEach var="size" items="${sizesByProduct[productId]}">
                                                                        <button class="option-btn size-option"
                                                                                data-value="${size}">
                                                                            ${size}
                                                                        </button>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>

                                                            <!-- Buttons -->
                                                            <div class="text-end mt-3">
                                                                <button class="btn btn-confirm confirmBtn" data-product-id="${productId}">
                                                                    Confirm
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="mt-2">
                                                    <span class="badge bg-success" id="selectedVariant-${productId}">
                                                        Size: ${item.variant.size} / Color: ${item.variant.color}
                                                    </span>
                                                    <p class="text-muted small mb-0"
                                                       id="quantityAvailableText-${item.cartItemId}">
                                                        ${item.variant.quantityAvailable} available
                                                    </p>
                                                </div>
                                            </div>

                                            <!-- Right -->
                                            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                                                <p class="mb-1">
                                                    Price: <span class="fw-bold text-primary">$${item.variant.price}</span>
                                                </p>
                                                <p class="mb-0">
                                                    Total: <span class="fw-bold fs-5 text-danger">
                                                        $${item.variant.price * item.quantity}
                                                    </span>
                                                </p>
                                            </div>
                                        </div>

                                        <!-- Quantity -->
                                        <div class="d-flex align-items-center">
                                            <label class="me-2 fw-semibold">Quantity:</label>
                                            <div class="input-group" style="width:120px;">
                                                <button type="button"
                                                        class="btn btn-outline-secondary decreaseQuantityBtn"
                                                        data-cartitem-id="${item.cartItemId}"
                                                        onclick="changeQuantity(${item.cartItemId}, -1)">
                                                    −
                                                </button>
                                                <input type="number"
                                                       class="form-control text-center qty-input"
                                                       id="quantityInput-${item.cartItemId}"
                                                       value="${item.quantity}"
                                                       max="${item.variant.quantityAvailable}"
                                                       min="1"
                                                       data-product-id="${productId}"
                                                       data-variant-id="${item.variant.productVariantId}">
                                                <button type="button"
                                                        class="btn btn-outline-secondary increaseQuantityBtn"
                                                        data-cartitem-id="${item.cartItemId}"
                                                        onclick="changeQuantity(${item.cartItemId}, 1)">
                                                    +
                                                </button>
                                            </div>
                                            <button type="button"
                                                    class="btn btn-danger btn-sm ms-auto"
                                                    onclick="openDeleteModal(${item.cartItemId})">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Order summary -->
                <div class="col-lg-4">
                    <div class="card shadow-sm sticky-top" style="top: 90px;">
                        <div class="card-body">
                            <h5 class="card-title text-center text-uppercase fw-bold mb-4">Order Summary</h5>

                            <div class="d-flex justify-content-between mb-2">
                                <span>Items:</span>
                                <span class="fw-bold" id="selectedItemCount">0</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <span class="fw-bold">Total:</span>
                                <span class="fw-bold fs-4 text-danger" id="selectedTotalPrice">$0.00</span>
                            </div>
                            <button class="btn btn-lg w-100 text-white" style="background:#000;">
                                Purchase
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script>

                                                        function changeQuantity(cartItemId, delta) {
                                                            const input = document.getElementById('quantityInput-' + cartItemId);
                                                            const availableText = document.getElementById('quantityAvailableText-' + cartItemId);
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
                                                        }

                                                        function openDeleteModal(cartItemId) {
                                                            const deleteModal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
                                                            const hiddenInput = document.getElementById('deleteCartItemId');
                                                            hiddenInput.value = cartItemId;
                                                            deleteModal.show();
                                                        }
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const checkboxes = document.querySelectorAll('.checkbox-black');
                const countEl = document.getElementById('selectedItemCount');
                const totalEl = document.getElementById('selectedTotalPrice');

                // Hàm cập nhật tổng
                function updateSummary() {
                    let totalItems = 0;
                    let totalPrice = 0;

                    checkboxes.forEach(chk => {
                        if (chk.checked) {
                            // tìm cart item container
                            const card = chk.closest('.card');
                            const qtyInput = card.querySelector('.qty-input');
                            const priceEl = card.querySelector('.text-primary'); // $${item.variant.price}

                            if (!qtyInput || !priceEl)
                                return;

                            const price = parseFloat(priceEl.textContent.replace('$', '').trim()) || 0;
                            const quantity = parseInt(qtyInput.value) || 0;

                            totalItems += quantity;
                            totalPrice += price * quantity;
                        }
                    });

                    countEl.textContent = totalItems;
                    totalEl.textContent = '$' + totalPrice.toFixed(2);
                }

                // Khi checkbox thay đổi
                checkboxes.forEach(chk => {
                    chk.addEventListener('change', updateSummary);
                });

                // Khi số lượng thay đổi, cập nhật lại nếu item đang được chọn
                const qtyInputs = document.querySelectorAll('.qty-input');
                qtyInputs.forEach(inp => {
                    inp.addEventListener('input', updateSummary);
                });

                // Khởi tạo ban đầu
                updateSummary();

                // Lấy tất cả các nút "Select Variant" trên trang
                const selectVariantBtns = document.querySelectorAll('.selectVariantBtn');

                selectVariantBtns.forEach(btn => {
                    const productId = btn.dataset.productId; // lấy id sản phẩm
                    const modal = document.getElementById(`variantModal-${productId}`);
                    const backdrop = modal.querySelector('.variant-backdrop');
                    const variantContent = modal.querySelector('.variant-content');
                    const confirmBtn = modal.querySelector('.confirmBtn');
                    const colorOptions = modal.querySelectorAll('.color-option');
                    const sizeOptions = modal.querySelectorAll('.size-option');
                    const selectedBadge = document.getElementById(`selectedVariant-${productId}`); // nếu bạn có badge hiển thị variant đã chọn

                    let selectedColor = null;
                    let selectedSize = null;

                    // Hàm định vị modal (nếu bạn muốn đặt modal gần nút)
                    function positionModal() {
                        const btnRect = btn.getBoundingClientRect();
                        variantContent.style.top = (btnRect.bottom + 8) + 'px';
                        variantContent.style.left = btnRect.left + 'px';

                        variantContent.style.position = 'fixed';
                    }

                    // Mở modal
                    btn.addEventListener('click', (e) => {
                        e.stopPropagation();

                        colorOptions.forEach(c => c.classList.remove('selected'));
                        sizeOptions.forEach(s => s.classList.remove('selected'));
                        selectedColor = null;
                        selectedSize = null;

                        positionModal();
                        modal.classList.add('show');
                        document.body.classList.add('modal-open');
                    });

                    // Đóng modal khi click backdrop
                    backdrop.addEventListener('click', () => {
                        modal.classList.remove('show');
                        document.body.classList.remove('modal-open');
                    });

                    // Ngăn modal đóng khi click bên trong
                    variantContent.addEventListener('click', (e) => e.stopPropagation());

                    // Chọn color
                    colorOptions.forEach(cBtn => {
                        cBtn.addEventListener('click', () => {
                            colorOptions.forEach(b => b.classList.remove('selected'));
                            cBtn.classList.add('selected');
                            selectedColor = cBtn.dataset.value;
                        });
                    });

                    // Chọn size
                    sizeOptions.forEach(sBtn => {
                        sBtn.addEventListener('click', () => {
                            sizeOptions.forEach(b => b.classList.remove('selected'));
                            sBtn.classList.add('selected');
                            selectedSize = sBtn.dataset.value;
                        });
                    });

                    // Xác nhận chọn variant
                    confirmBtn.addEventListener('click', () => {
                        if (!selectedColor || !selectedSize) {
                            alert("Please select both color and size!");
                            return;
                        }

                        // Nếu có badge hiển thị variant đã chọn
                        if (selectedBadge) {
                            selectedBadge.textContent = `Color: ${selectedColor}, Size: ${selectedSize}`;
                        }

                        // Sau này có thể gọi AJAX update CartItem ở đây
                        console.log(`Product ${productId}: ${selectedColor} - ${selectedSize}`);

                        modal.classList.remove('show');
                        document.body.classList.remove('modal-open');
                    });

                    // Đóng modal khi nhấn ESC
                    document.addEventListener('keydown', (e) => {
                        if (e.key === 'Escape' && modal.classList.contains('show')) {
                            modal.classList.remove('show');
                            document.body.classList.remove('modal-open');
                        }
                    });
                });
            });

        </script>
        <!-- Confirm Delete Modal -->
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-sm">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Remove Item</h5>
                    </div>
                    <div class="modal-body text-center">
                        <p>Are you sure you want to remove this item from your cart?</p>
                    </div>
                    <div class="modal-footer border-0 d-flex justify-content-center">
                        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/cart">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="cartItemId" id="deleteCartItemId">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
