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

        <style>
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
                position: fixed;
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
                position: fixed;
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
                        <div class="card shadow-sm mb-3">
                            <div class="row g-0 align-items-center p-1">
                                <!-- Checkbox -->
                                <div class="col-md-1 text-center">
                                    <input type="checkbox" class="form-check-input checkbox-black" checked>
                                </div>

                                <!-- Image -->
                                <div class="col-md-3 text-center">
                                    <img src="${item.variant.image}"
                                         alt="${item.variant.product.productName}"
                                         class="img-fluid rounded"
                                         style="width:180px; height:180px; object-fit:cover;">
                                </div>

                                <!-- Info -->
                                <div class="col-md-8">
                                    <div class="card-body">
                                        <h5 class="card-title fw-bold">${item.variant.product.productName}</h5>

                                        <div class="row align-items-start mb-3">
                                            <!-- Left -->
                                            <div class="col-md-6">
                                                <div class="variant-btn-wrapper">
                                                    <button class="btn btn-outline-secondary btn-sm selectVariantBtn"
                                                            data-cartitemid="${item.cartItemId}"
                                                            data-productid="${item.variant.productId}">
                                                        Select Variant
                                                    </button>

                                                    <!-- Include modal selector -->
                                                    <jsp:include page="common/variant-selector.jsp">
                                                        <jsp:param name="variants" value="${variantsByProduct[item.product.productId]}"/>
                                                        <jsp:param name="colors" value="${colorsByProduct[item.product.productId]}"/>
                                                        <jsp:param name="sizes" value="${sizesByProduct[item.product.productId]}"/>
                                                    </jsp:include>
                                                </div>

                                                <div class="mt-2">
                                                    <span class="badge bg-success" id="selectedVariant_${item.cartItemId}">
                                                        Size: ${item.variant.size} / Color: ${item.variant.color}
                                                    </span>
                                                    <p class="text-muted small mb-0">${item.variant.stock} available</p>
                                                </div>
                                            </div>

                                            <!-- Right -->
                                            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                                                <p class="mb-1">
                                                    Price: <span class="fw-bold text-primary">${item.variant.price}₫</span>
                                                </p>
                                                <p class="mb-0">
                                                    Total: <span class="fw-bold fs-5 text-danger">
                                                        ${item.variant.price * item.quantity}₫
                                                    </span>
                                                </p>
                                            </div>
                                        </div>

                                        <!-- Quantity -->
                                        <div class="d-flex align-items-center">
                                            <label class="me-2 fw-semibold">Quantity:</label>
                                            <div class="input-group" style="width:120px;">
                                                <button class="btn btn-outline-secondary"
                                                        onclick="changeQty(${item.cartItemId}, -1)">
                                                    −
                                                </button>
                                                <input type="number"
                                                       class="form-control text-center qty-input"
                                                       id="qty_${item.cartItemId}"
                                                       value="${item.quantity}" min="1">
                                                <button class="btn btn-outline-secondary"
                                                        onclick="changeQty(${item.cartItemId}, 1)">
                                                    +
                                                </button>
                                            </div>
                                            <button class="btn btn-danger btn-sm ms-auto"
                                                    onclick="removeItem(${item.cartItemId})">
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
                                                        function changeQty(cartItemId, delta) {
                                                            const input = document.getElementById('qty_' + cartItemId);
                                                            let qty = parseInt(input.value || '1');
                                                            qty += delta;
                                                            if (qty < 1)
                                                                qty = 1;
                                                            input.value = qty;

                                                            fetch('${pageContext.request.contextPath}/cart', {
                                                                method: 'POST',
                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                body: `action=updateQuantity&cartItemId=${cartItemId}&quantity=${qty}`
                                                            }).then(r => r.json()).then(d => {
                                                                if (d.success)
                                                                    showNotification("Quantity updated", "success");
                                                                else
                                                                    showNotification("Failed to update", "error");
                                                            });
                                                        }

                                                        function removeItem(cartItemId) {
                                                            if (!confirm('Remove this item?'))
                                                                return;
                                                            fetch('${pageContext.request.contextPath}/cart', {
                                                                method: 'POST',
                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                body: `action=remove&cartItemId=${cartItemId}`
                                                            }).then(r => r.json()).then(d => {
                                                                if (d.success)
                                                                    location.reload();
                                                                else
                                                                    showNotification("Failed to remove", "error");
                                                            });
                                                        }

        // variant change (called from modal confirm)
                                                        function updateVariant(cartItemId, variantId, displayText) {
                                                            fetch('${pageContext.request.contextPath}/cart', {
                                                                method: 'POST',
                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                body: `action=updateVariant&cartItemId=${cartItemId}&variantId=${variantId}`
                                                            }).then(r => r.json()).then(d => {
                                                                if (d.success) {
                                                                    document.getElementById('selectedVariant_' + cartItemId).textContent = displayText;
                                                                    showNotification("Variant updated", "success");
                                                                } else
                                                                    showNotification("Failed to update variant", "error");
                                                            });
                                                        }

        // Example placeholder (replace by your global script)
                                                        function showNotification(msg, type) {
                                                            console.log(`[${type}] ${msg}`);
                                                        }
        </script>

    </body>
</html>
