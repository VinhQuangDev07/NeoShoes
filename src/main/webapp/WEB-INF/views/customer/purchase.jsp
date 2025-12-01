<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Purchase - NeoShoes" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle != null ? pageTitle : 'NeoShoes'}</title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <style>
            .purchase-container {
                background: #f8f9fa;
                min-height: 100vh;
                padding: 20px 0;
            }
            .purchase-header {
                text-align: center;
                margin-bottom: 30px;
            }
            .purchase-title {
                font-size: 28px;
                font-weight: 700;
                color: #333;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
            }
            .purchase-subtitle {
                color: #666;
                font-size: 16px;
            }
            .purchase-content {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                max-width: 1200px;
                margin: 0 auto;
            }
            .purchase-section {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .section-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
            }
            .section-title {
                font-size: 18px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 1.5rem;
                position: relative;
                padding-bottom: 0.5rem;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 50px;
                height: 3px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
            }

            .section-subtitle {
                color: #666;
                font-size: 14px;
                margin-top: 4px;
            }
            .section-icon {
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .customer-info {
                background: white;
                border-radius: 8px;
                padding: 15px;
                margin-top: 15px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            }
            .info-item {
                margin-bottom: 12px;
            }
            .info-item:last-child {
                margin-bottom: 0;
            }
            .info-label {
                font-size: 12px;
                color: #666;
                margin-bottom: 4px;
            }
            .info-value {
                font-weight: 500;
                color: #333;
            }
            .delivery-address {
                background: white;
                border-radius: 8px;
                padding: 15px;
                margin-top: 15px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            }
            .address-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 10px;
            }
            .address-detail {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 6px;
                font-size: 14px;
                color: #666;
            }
            .address-detail:last-child {
                margin-bottom: 0;
            }
            .address-icon {
                width: 16px;
                height: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .order-items {
                max-height: 400px;
                overflow-y: auto;
            }
            .order-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .order-item:last-child {
                border-bottom: none;
            }
            .item-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 15px;
                border: 1px solid #e0e0e0;
            }
            .item-details {
                flex: 1;
            }
            .item-name {
                font-weight: 600;
                margin-bottom: 4px;
                color: #333;
            }
            .item-price {
                color: #6f42c1;
                font-weight: 600;
            }
            .item-quantity {
                color: #007bff;
                font-size: 14px;
            }
            .voucher-section {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .voucher-input {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }
            .voucher-field {
                flex: 1;
                padding: 12px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                position: relative;
            }
            .voucher-field:focus {
                border-color: #007bff;
                outline: none;
            }
            .clear-btn {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #999;
                cursor: pointer;
                font-size: 16px;
            }
            .apply-btn {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s ease;
            }
            .apply-btn:hover {
                transform: translateY(-1px);
            }
            .available-vouchers {
                margin-top: 20px;
            }
            .available-vouchers h6 {
                color: #666;
                font-size: 14px;
                margin-bottom: 10px;
            }
            .voucher-suggestions {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }
            .voucher-tag {
                background: #f8f9ff;
                color: #6f42c1;
                border: 1px solid #e0e0ff;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .voucher-tag:hover {
                background: #6f42c1;
                color: white;
            }
            .discount-applied {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
                padding: 10px;
                border-radius: 8px;
                margin-top: 10px;
                font-size: 14px;
                display: none;
            }
            .order-summary {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
            }
            .summary-item:last-child {
                margin-bottom: 0;
                padding-top: 12px;
                border-top: 1px solid #f0f0f0;
            }
            .summary-label {
                color: #666;
            }
            .summary-value {
                font-weight: 600;
                color: #333;
            }
            .summary-total {
                font-weight: 700;
                color: #6f42c1;
            }
            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }
            .place-order-btn {
                background: #0b5ed7;
                color: white;
                border: none;
                padding: 15px 20px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 16px;
                cursor: pointer;
                transition: transform 0.2s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                box-shadow: 0 2px 8px rgba(111, 66, 193, 0.3);
            }
            .place-order-btn:hover {
                transform: translateY(-1px);
            }
            .back-cart-btn {
                background: white;
                color: #666;
                border: 1px solid #e0e0e0;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }
            .back-cart-btn:hover {
                background: #f8f9fa;
                border-color: #007bff;
                color: #007bff;
            }
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }
            .empty-state i {
                font-size: 4rem;
                color: #ccc;
                margin-bottom: 20px;
            }
            @media (max-width: 768px) {
                .purchase-content {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        
        <div class="purchase-container">
            <div class="container">
                <!-- Page Header -->
                <div class="purchase-header">
                    <c:choose>
                        <c:when test="${not empty cartItems}">
                            <h1 class="purchase-title">
                                <i class="fas fa-shopping-cart"></i>
                                Purchase Confirmation
                            </h1>
                            <p class="purchase-subtitle">Complete your order information</p>
                        </c:when>
                        <c:otherwise>
                            <h1 class="purchase-title">
                                <i class="fas fa-history"></i>
                                Purchase History
                            </h1>
                            <p class="purchase-subtitle">Your order history and statistics</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Main Content -->
                <c:choose>
                    <c:when test="${not empty cartItems}">
                        <!-- Checkout Mode -->
                        <form id="checkoutForm" method="post" action="${pageContext.request.contextPath}/purchase">
                            <input type="hidden" name="action" value="placeOrder">
                            
                            <div class="purchase-content">
                                <!-- Left Column -->
                                <div class="left-column">
                                    <!-- Customer Information -->
                                    <div class="purchase-section">
                                        <div class="section-header">
                                            <div>
                                                <h3 class="section-title">
                                                    <i class="fas fa-user" style="color: #6f42c1;"></i>
                                                    Customer Information
                                                </h3>
                                                <p class="section-subtitle">Your personal and delivery details</p>
                                            </div>
                                        </div>

                                        <div class="customer-info">
                                            <div class="info-item">
                                                <div class="info-label">Full Name</div>
                                                <div class="info-value">${customer.name}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Email</div>
                                                <div class="info-value">${customer.email}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Phone</div>
                                                <div class="info-value">${customer.phoneNumber}</div>
                                            </div>
                                        </div>

                                        <!-- Delivery Address Selection -->
                                        <div class="delivery-address">
                                            <div class="address-title mb-3">Select Delivery Address</div>
                                            <c:choose>
                                                <c:when test="${empty addresses}">
                                                    <div class="alert alert-warning">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        No delivery address found. Please add an address first.
                                                        <a href="${pageContext.request.contextPath}/address" class="btn btn-sm btn-primary ms-2">Add Address</a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${addresses}" var="address">
                                                        <div class="form-check mb-3">
                                                            <input class="form-check-input" type="radio" name="addressId" 
                                                                   id="address_${address.addressId}" value="${address.addressId}"
                                                                   ${address.isDefault ? 'checked' : ''}>
                                                            <label class="form-check-label" for="address_${address.addressId}">
                                                                <div class="address-card p-3 border rounded">
                                                                    <div class="fw-bold">${address.addressName}</div>
                                                                    <div class="text-muted">${address.addressDetails}</div>
                                                                    <div class="text-muted">Recipient: ${address.recipientName} - ${address.recipientPhone}</div>
                                                                </div>
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Order Items -->
                                    <div class="purchase-section">
                                        <div class="section-header">
                                            <div>
                                                <h3 class="section-title">
                                                    <i class="fas fa-shopping-bag" style="color: #28a745;"></i>
                                                    Order Items
                                                </h3>
                                                <p class="section-subtitle">${cartItems.size()} items</p>
                                            </div>
                                        </div>

                                        <div class="order-items">
                                            <c:forEach items="${cartItems}" var="item">
                                                <div class="order-item">
                                                    <img src="${item.variant.image}" alt="${item.variant.product.name}" class="item-image">
                                                    <div class="item-details">
                                                        <div class="item-name">${item.variant.product.name}</div>
                                                        <div class="item-variant">Size: ${item.variant.size} | Color: ${item.variant.color}</div>
                                                        <div class="item-price">$${item.variant.price}</div>
                                                        <div class="item-quantity">Quantity: ${item.quantity}</div>
                                                    </div>
                                                    <input type="hidden" name="cartItemIds" value="${item.cartItemId}">
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column -->
                                <div class="right-column">
                                    <!-- Voucher Codes -->
                                    <div class="voucher-section">
                                        <div class="section-header">
                                            <div>
                                                <h3 class="section-title">
                                                    <i class="fas fa-tag" style="color: #6f42c1;"></i>
                                                    Voucher Codes
                                                </h3>
                                            </div>
                                        </div>

                                        <div class="voucher-input">
                                            <div style="position: relative; flex: 1;">
                                                <input type="text" id="voucherCode" name="voucherCode" class="voucher-field" placeholder="Enter voucher code">
                                                <button type="button" class="clear-btn" onclick="clearVoucher()">×</button>
                                            </div>
                                            <button type="button" class="apply-btn" onclick="applyVoucher()">Apply</button>
                                        </div>

                                        <div class="available-vouchers">
                                            <h6>Available vouchers:</h6>
                                            <div class="voucher-suggestions">
                                                <c:forEach items="${availableVouchers}" var="voucher">
                                                    <span class="voucher-tag" onclick="selectVoucher('${voucher.voucherCode}')">
                                                        ${voucher.voucherCode} (${voucher.displayValue})
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div id="discountApplied" class="discount-applied">
                                            <i class="fas fa-check-circle"></i>
                                            <span id="discountMessage"></span>
                                        </div>
                                    </div>

                                    <!-- Order Summary -->
                                    <div class="order-summary">
                                        <div class="section-header">
                                            <div>
                                                <h3 class="section-title">
                                                    <i class="fas fa-file-alt" style="color: #007bff;"></i>
                                                    Order Summary
                                                </h3>
                                            </div>
                                        </div>

                                        <div class="summary-item">
                                            <span class="summary-label">Subtotal:</span>
                                            <span class="summary-value">$${subtotal}</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="summary-label">Shipping:</span>
                                            <span class="summary-value">$${shippingFee}</span>
                                        </div>
                                        <div class="summary-item" id="discountRow" style="display: none;">
                                            <span class="summary-label">Discount:</span>
                                            <span class="summary-value" style="color: #28a745;">-$<span id="discountAmount">0</span></span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="summary-label">Total Amount:</span>
                                            <span class="summary-value summary-total">$<span id="totalAmount">${total}</span></span>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="action-buttons">
                                        <button type="submit" class="place-order-btn">
                                            <i class="fas fa-credit-card"></i>
                                            Place Order
                                        </button>
                                        <a href="${pageContext.request.contextPath}/cart" class="back-cart-btn text-decoration-none">
                                            <i class="fas fa-arrow-left"></i>
                                            Back to Cart
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Purchase History Mode -->
                        <div class="purchase-content">
                            <!-- Statistics -->
                            <div class="row mb-4">
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-primary">${totalOrders}</h5>
                                            <p class="card-text">Total Orders</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-success">$${totalSpent}</h5>
                                            <p class="card-text">Total Spent</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card text-center">
                                        <div class="card-body">
                                            <h5 class="card-title text-info">${totalItems}</h5>
                                            <p class="card-text">Total Items</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Order History -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Order History</h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty allOrders}">
                                            <div class="text-center py-5">
                                                <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                                                <h4>No orders yet</h4>
                                                <p class="text-muted">Start shopping to see your orders here.</p>
                                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Start Shopping</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Order ID</th>
                                                            <th>Date</th>
                                                            <th>Items</th>
                                                            <th>Total</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${allOrders}" var="order">
                                                            <tr>
                                                                <td>#${order.orderId}</td>
                                                                <td>${order.placedAt}</td>
                                                                <td>${order.items.size()} items</td>
                                                                <td>$${order.totalAmount}</td>
                                                                <td>
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </td>
                                                                <td>
                                                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}" 
                                                                       class="btn btn-sm btn-outline-primary">View Details</a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

        <script>
            <c:if test="${not empty cartItems}">
                let appliedDiscount = 0;
                // Parse total from server, ensure it's a number
                let originalTotal = parseFloat('${total}') || 0;

                function selectVoucher(code) {
                    document.getElementById('voucherCode').value = code;
                }

                function clearVoucher() {
                    document.getElementById('voucherCode').value = '';
                    removeDiscount();
                }

                function applyVoucher() {
                    const voucherCode = document.getElementById('voucherCode').value.trim().toUpperCase();

                    if (!voucherCode) {
                        alert('Please enter a voucher code');
                        return;
                    }

                    // Get current total (may already have discount applied)
                    const currentTotal = parseFloat(document.getElementById('totalAmount').textContent) || originalTotal;

                    // ✅ GỌI SERVER ĐỂ VALIDATE (always use originalTotal for voucher calculation)
                    console.log('=== APPLY VOUCHER REQUEST ===');
                    console.log('Voucher Code:', voucherCode);
                    console.log('Original Total (for voucher calc):', originalTotal);
                    console.log('Current Display Total:', currentTotal);
                    
                    fetch('${pageContext.request.contextPath}/voucher?action=apply', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: new URLSearchParams({
                            'voucherCode': voucherCode,
                            'orderTotal': originalTotal
                        })
                    })
                    .then(response => {
                        console.log('Response status:', response.status);
                        console.log('Content-Type:', response.headers.get('content-type'));
                        return response.text();
                    })
                    .then(text => {
                        console.log('Raw response:', text);
                        
                        try {
                            const data = JSON.parse(text);
                            console.log('Parsed JSON:', data);
                            
                            if (data.success) {
                                console.log('SUCCESS!');
                                console.log('Discount from server:', data.discount);
                                
                                // Update discount (ensure it's a number)
                                appliedDiscount = parseFloat(data.discount) || 0;
                                console.log('Applied discount:', appliedDiscount);
                                
                                // Update total display
                                updateTotal();
                                showDiscountMessage(data.message);
                                
                                // Set hidden input để submit form
                                let hiddenInput = document.getElementById('hiddenVoucherCode');
                                if (!hiddenInput) {
                                    hiddenInput = document.createElement('input');
                                    hiddenInput.type = 'hidden';
                                    hiddenInput.id = 'hiddenVoucherCode';
                                    hiddenInput.name = 'voucherCode';
                                    document.getElementById('checkoutForm').appendChild(hiddenInput);
                                }
                                hiddenInput.value = data.voucherCode;
                                
                                // Disable input và button
                                document.getElementById('voucherCode').disabled = true;
                                document.querySelector('.apply-btn').disabled = true;
                                
                            } else {
                                console.error('FAILED:', data.message);
                                alert(data.message || 'Invalid voucher code');
                                removeDiscount();
                            }
                        } catch (e) {
                            console.error('NOT JSON! Response:', text);
                            alert('Error applying voucher. Please try again.');
                        }
                    })
                    .catch(error => {
                        console.error('FETCH ERROR:', error);
                        alert('Failed to apply voucher. Please check your connection.');
                    });
                }

                function removeDiscount() {
                    appliedDiscount = 0;
                    updateTotal();
                    hideDiscountMessage();
                    // Re-enable input and button
                    document.getElementById('voucherCode').disabled = false;
                    if (document.querySelector('.apply-btn')) {
                        document.querySelector('.apply-btn').disabled = false;
                    }
                }

                function updateTotal() {
                    // Calculate new total: originalTotal - appliedDiscount
                    const newTotal = Math.max(0, originalTotal - appliedDiscount);
                    console.log('Updating total: ' + originalTotal + ' - ' + appliedDiscount + ' = ' + newTotal);
                    
                    // Update display
                    document.getElementById('totalAmount').textContent = newTotal.toFixed(2);

                    if (appliedDiscount > 0) {
                        document.getElementById('discountRow').style.display = 'flex';
                        document.getElementById('discountAmount').textContent = appliedDiscount.toFixed(2);
                    } else {
                        document.getElementById('discountRow').style.display = 'none';
                    }
                }

                function showDiscountMessage(message) {
                    document.getElementById('discountMessage').textContent = message;
                    document.getElementById('discountApplied').style.display = 'block';
                }

                function hideDiscountMessage() {
                    document.getElementById('discountApplied').style.display = 'none';
                }

                // Form validation before submission
                document.getElementById('checkoutForm').addEventListener('submit', function(e) {
                    const addressSelected = document.querySelector('input[name="addressId"]:checked');
                    if (!addressSelected) {
                        e.preventDefault();
                        alert('Please select a delivery address');
                        return false;
                    }
                });
            </c:if>
        </script>
        
        <jsp:include page="common/footer.jsp"/>
    </body>
</html>
