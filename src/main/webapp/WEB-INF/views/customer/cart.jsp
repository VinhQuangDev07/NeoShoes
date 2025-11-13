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
            input[type=number]::-webkit-inner-spin-button,
            input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }
            body.modal-open {
                /*overflow: hidden;*/
                width: 100%;
            }
            .checkbox-black:checked {
                background-color: #000 !important;
                border-color: #000 !important;
            }
            .checkbox-black {
                transform: scale(1.2);
                margin: 8px;
                cursor: pointer;
            }
            .card.selected {
                border: 2px solid #007bff;
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
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

            .option-btn:disabled {
                opacity: 0.4;
                cursor: not-allowed;
                text-decoration: line-through;
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
            .btn-confirm:disabled {
                background-color: #6c757d !important;
                cursor: not-allowed;
            }
        </style>
    </head>

    <body>
        <jsp:include page="common/header.jsp"/>
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
                                                            <h6 class="mb-3 fw-bold">Select variant for Product ${productId}</h6>

                                                            <!-- Color -->
                                                            <div class="mb-3">
                                                                <div class="section-title">Color:</div>
                                                                <div class="d-flex flex-wrap gap-2">
                                                                    <c:forEach var="color" items="${item.variant.product.colors}">
                                                                        <button class="option-btn color-option"
                                                                                data-value="${color}">
                                                                            ${color}
                                                                        </button>
                                                                    </c:forEach>
                                                                    <c:if test="${empty item.variant.product.colors}">
                                                                        <p style ="color:red;">No colors for product ${productId}</p>
                                                                    </c:if>
                                                                </div>
                                                            </div>

                                                            <!-- Size -->
                                                            <div class="mb-3">
                                                                <div class="section-title">Size:</div>
                                                                <div class="d-flex flex-wrap gap-2">
                                                                    <c:forEach var="size" items="${item.variant.product.sizes}">
                                                                        <button class="option-btn size-option"
                                                                                data-value="${size}">
                                                                            ${size}
                                                                        </button>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>

                                                            <script>
                                                                var variants_${productId} = [
                                                                <c:forEach items="${item.variant.product.variants}" var="v" varStatus="loop">
                                                                {
                                                                variantId: ${v.productVariantId},
                                                                        color: '${v.color}',
                                                                        size: '${v.size}',
                                                                        quantityAvailable: ${v.quantityAvailable}
                                                                }${!loop.last ? ',' : ''}
                                                                </c:forEach>
                                                                ];
                                                            </script>

                                                            <!-- Buttons -->
                                                            <div class="text-end mt-3">
                                                                <button class="btn btn-confirm confirmBtn" 
                                                                        data-product-id="${productId}"
                                                                        data-cartitem-id="${item.cartItemId}">
                                                                    Confirm
                                                                </button>
                                                            </div>
                                                            <form id="updateVariantForm-${item.cartItemId}" method="post" action="${pageContext.request.contextPath}/cart" style="display:none;">
                                                                <input type="hidden" name="action" value="updateVariant">
                                                                <input type="hidden" name="cartItemId" id="hiddenCartItemId-${item.cartItemId}">
                                                                <input type="hidden" name="productVariantId" id="hiddenVariantId-${item.cartItemId}">
                                                            </form>

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
                                                    Price: <span class="fw-bold text-primary" id="itemPrice-${item.cartItemId}">
                                                        $${item.variant.price}</span>
                                                </p>
                                                <p class="mb-0">
                                                    Total: <span class="fw-bold fs-5 text-danger" id="itemTotal-${item.cartItemId}">
                                                        $${item.variant.price * item.quantity}
                                                    </span>
                                                </p>
                                            </div>
                                        </div>

                                        <!-- Quantity -->
                                        <div class="d-flex align-items-center">
                                            <label class="me-2 fw-semibold">Quantity:</label>
                                            <div class="input-group" style="width:150px;">
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
                            <button class="btn btn-lg w-100 text-white" style="background:#000;" onclick="proceedToCheckout()">
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

                                                            input.value = value;

                                                            // Gửi AJAX đến servlet để cập nhật DB mà không reload
                                                            fetch(`${window.location.origin}${pageContext.request.contextPath}/cart`, {
                                                                method: "POST",
                                                                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                                                body: new URLSearchParams({
                                                                    action: "updateQuantity",
                                                                    cartItemId: cartItemId,
                                                                    quantity: value
                                                                })
                                                            })
                                                                    .then(res => {
                                                                        if (!res.ok)
                                                                            return res.text().then(t => {
                                                                                throw new Error(t);
                                                                            });
                                                                        return res.json();
                                                                    })
                                                                    .then(data => {
                                                                        console.log("Quantity updated successfully:", data);
                                                                        showNotification("Quantity updated!", "success");

                                                                        // Cập nhật subtotal cho item
                                                                        const priceEl = document.getElementById('itemPrice-' + cartItemId);
                                                                        const totalEl = document.getElementById('itemTotal-' + cartItemId);

                                                                        if (priceEl && totalEl) {
                                                                            const price = parseFloat(priceEl.textContent.replace('$', '').trim());
                                                                            const newTotal = price * value;
                                                                            totalEl.textContent = '$' + newTotal.toFixed(2);
                                                                        }

                                                                        // Cập nhật tổng tạm tính
                                                                        if (typeof window.updateSummary === "function") {
                                                                            window.updateSummary();
                                                                        }
                                                                    })
                                                                    .catch(err => {
                                                                        console.error(" Update failed:", err);
                                                                        // Nếu lỗi, khôi phục giá trị cũ
                                                                        input.value = parseInt(input.defaultValue || 1);
                                                                    });
                                                        }

                                                        function openDeleteModal(cartItemId) {
                                                            const deleteModal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
                                                            const hiddenInput = document.getElementById('deleteCartItemId');
                                                            hiddenInput.value = cartItemId;
                                                            deleteModal.show();
                                                        }

                                                        function proceedToCheckout() {
                                                            const selectedItems = document.querySelectorAll('.checkbox-black:checked');
                                                            if (selectedItems.length === 0) {
                                                                alert('Please select at least one product to checkout!\n\nInstructions:\n1. Check the box next to the product you want to buy\n2. Check the quantity and price\n3. Click the Buy button to checkout ');
                                                                return;
                                                            }
                                                            
                                                            // Get selected cart item IDs
                                                            const cartItemIds = Array.from(selectedItems).map(checkbox => {
                                                                return checkbox.id.replace('checkbox-', '');
                                                            });
                                                            
                                                            // Redirect to purchase page with selected items
                                                            const params = new URLSearchParams();
                                                            cartItemIds.forEach(id => params.append('cartItemIds', id));
                                                            
                                                            window.location.href = '${pageContext.request.contextPath}/purchase?action=checkout&' + params.toString();
                                                        }
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const checkboxes = document.querySelectorAll('.checkbox-black');
                const countEl = document.getElementById('selectedItemCount');
                const totalEl = document.getElementById('selectedTotalPrice');

                // Cho phép updateSummary được gọi từ bên ngoài
                window.updateSummary = function () {
                    let totalItems = 0;
                    let totalPrice = 0;

                    checkboxes.forEach(chk => {
                        if (chk.checked) {
                            const card = chk.closest('.card');
                            const qtyInput = card.querySelector('.qty-input');
                            const priceEl = card.querySelector('#itemPrice-' + chk.id.replace('checkbox-', ''));

                            if (!qtyInput || !priceEl) {
                                console.log('Missing elements for checkbox:', chk.id);
                                return;
                            }

                            const price = parseFloat(priceEl.textContent.replace('$', '').trim()) || 0;
                            const quantity = parseInt(qtyInput.value) || 0;

                            totalItems += quantity;
                            totalPrice += price * quantity;
                        }
                    });

                    countEl.textContent = totalItems;
                    totalEl.textContent = '$' + totalPrice.toFixed(2);
                }

                checkboxes.forEach(chk => {
                    chk.addEventListener('change', function() {
                        const card = chk.closest('.card');
                        if (chk.checked) {
                            card.classList.add('selected');
                        } else {
                            card.classList.remove('selected');
                        }
                        updateSummary();
                    });
                });

                const qtyInputs = document.querySelectorAll('.qty-input');
                qtyInputs.forEach(inp => {
                    inp.addEventListener('input', updateSummary);
                });

                // Auto-check all items by default
                checkboxes.forEach(chk => {
                    chk.checked = true;
                    const card = chk.closest('.card');
                    card.classList.add('selected');
                });

                // Initial summary update
                updateSummary();

                // ✅ Đóng tất cả modal (helper function)
                function closeAllModals() {
                    document.querySelectorAll('.variant-modal').forEach(m => {
                        m.classList.remove('show');
                    });
                    document.body.classList.remove('modal-open');
                }

                // ✅ ESC key handler - CHỈ ĐĂNG KÝ 1 LẦN
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'Escape') {
                        closeAllModals();
                    }
                });

                // ✅ XỬ LÝ MODAL VARIANT - FIX HOÀN TOÀN
                document.querySelectorAll('.selectVariantBtn').forEach(btn => {
                    let productId = btn.dataset.productId; // ✅ dùng let để tạo scope riêng
                    let modal = document.getElementById('variantModal-' + productId);
                    let backdrop = modal.querySelector('.variant-backdrop');
                    let variantContent = modal.querySelector('.variant-content');
                    let confirmBtn = modal.querySelector('.confirmBtn');
                    let colorOptions = modal.querySelectorAll('.color-option');
                    let sizeOptions = modal.querySelectorAll('.size-option');
                    let variants = window['variants_' + productId] || [];

                    const btnSelectVariant = document.querySelector('.selectVariantBtn[data-product-id="' + productId + '"]');

                    let selectedColor = null;
                    let selectedSize = null;

                    // ✅ MỞ MODAL - Đóng tất cả modal khác trước
                    btn.addEventListener('click', (e) => {
                        e.stopPropagation();

                        // Đóng tất cả modal khác trước
                        closeAllModals();

                        // Reset selections
                        selectedColor = null;
                        selectedSize = null;
                        confirmBtn.disabled = true;
                        colorOptions.forEach(c => c.classList.remove('selected'));
                        sizeOptions.forEach(s => s.classList.remove('selected'));


                        // Cập nhật option khả dụng
                        disableUnavailableOptions();

                        // Mở modal này
                        modal.classList.add('show');
                        document.body.classList.add('modal-open');
                    });

                    // ✅ ĐÓNG MODAL khi click backdrop
                    backdrop.addEventListener('click', () => {
                        modal.classList.remove('show');
                        document.body.classList.remove('modal-open');
                    });

                    // 🧩 Disable các option không khả dụng
                    function disableUnavailableOptions() {
                        colorOptions.forEach(btn => {
                            const color = btn.dataset.value;
                            const available = variants.some(v => v.color === color && v.quantityAvailable > 0);
                            btn.disabled = !available;
                            btn.classList.toggle('text-muted', !available);
                        });

                        sizeOptions.forEach(btn => {
                            const size = btn.dataset.value;
                            const available = variants.some(v => v.size === size && v.quantityAvailable > 0);
                            btn.disabled = !available;
                            btn.classList.toggle('text-muted', !available);
                        });
                    }

                    // 🧩 Khi chọn 1 option (color / size)
                    function selectOption(type, value, element) {
                        if (element.disabled)
                            return;

                        // Bỏ chọn các nút khác cùng nhóm
                        modal.querySelectorAll('.' + type + '-option').forEach(btn => btn.classList.remove('selected'));
                        element.classList.add('selected');

                        if (type === 'color')
                            selectedColor = value;
                        if (type === 'size')
                            selectedSize = value;

                        filterOptions();
                        updateConfirmButtonState();
                    }

                    // 🧩 Lọc các tùy chọn còn khả dụng theo lựa chọn hiện tại
                    function filterOptions() {
                        if (selectedColor) {
                            sizeOptions.forEach(btn => {
                                const hasVariant = variants.some(v =>
                                    v.color === selectedColor && v.size === btn.dataset.value && v.quantityAvailable > 0
                                );
                                btn.disabled = !hasVariant;
                                btn.classList.toggle('text-muted', !hasVariant);
                            });
                        }

                        if (selectedSize) {
                            colorOptions.forEach(btn => {
                                const hasVariant = variants.some(v =>
                                    v.size === selectedSize && v.color === btn.dataset.value && v.quantityAvailable > 0
                                );
                                btn.disabled = !hasVariant;
                                btn.classList.toggle('text-muted', !hasVariant);
                            });
                        }
                    }

                    // Ngăn modal đóng khi click bên trong content
                    variantContent.addEventListener('click', (e) => e.stopPropagation());

                    function updateConfirmButtonState() {
                        confirmBtn.disabled = !(selectedColor && selectedSize);
                    }

                    // ✅ CHỌN COLOR
                    colorOptions.forEach(cBtn => {
                        cBtn.addEventListener('click', () => {
                            selectOption('color', cBtn.dataset.value, cBtn);
                        });
                    });

                    // ✅ CHỌN SIZE
                    sizeOptions.forEach(sBtn => {
                        sBtn.addEventListener('click', () => {
                            selectOption('size', sBtn.dataset.value, sBtn);
                        });
                    });

                    // ✅ XÁC NHẬN VARIANT
                    confirmBtn.addEventListener('click', () => {
                        if (!selectedColor || !selectedSize) {
                            console.warn('Color or size not selected');
                            return;
                        }

                        const matchedVariant = variants.find(v =>
                            v.color === selectedColor && v.size === selectedSize
                        );

                        if (!matchedVariant) {
                            alert("Variant not available!");
                            return;
                        }

                        // Lấy cartItemId từ nút Confirm
                        const cartItemId = confirmBtn.dataset.cartitemId;

                        // Điền vào form ẩn
                        document.getElementById('hiddenCartItemId-' + cartItemId).value = cartItemId;
                        document.getElementById('hiddenVariantId-' + cartItemId).value = matchedVariant.variantId;

                        // Submit form
                        document.getElementById('updateVariantForm-' + cartItemId).submit();
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
        <jsp:include page="common/footer.jsp"/>
    </body>
</html>
