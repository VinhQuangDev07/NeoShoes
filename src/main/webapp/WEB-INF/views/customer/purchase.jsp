<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Purchase History - NeoShoes" scope="request"/>

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
        <div class="purchase-container">
            <div class="container">
                <!-- Page Header -->
                <div class="purchase-header">
                    <h1 class="purchase-title">
                        <i class="fas fa-shopping-cart"></i>
                        Purchase Confirmation
                    </h1>
                    <p class="purchase-subtitle">Complete your order information</p>
                </div>

                <!-- Main Content -->
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
                                <i class="fas fa-chevron-down" style="color: #666;"></i>
                            </div>

                            <div class="customer-info">
                                <div class="info-item">
                                    <div class="info-label">Full Name</div>
                                    <div class="info-value">Demo Customer</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">demo@neoshoes.com</div>
                                </div>
                            </div>

                            <div class="delivery-address">
                                <div class="address-title">123 Main Street</div>
                                <div class="address-detail">
                                    <i class="fas fa-phone address-icon" style="color: #007bff;"></i>
                                    0123456789
                                </div>
                                <div class="address-detail">
                                    <i class="fas fa-user address-icon" style="color: #6f42c1;"></i>
                                    Demo Customer
                                </div>
                                <div class="address-detail">
                                    <i class="fas fa-map-marker-alt address-icon" style="color: #6f42c1;"></i>
                                    123 Main Street, Ho Chi Minh City, Vietnam
                                </div>
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
                                    <p class="section-subtitle">${totalItems} items</p>
                                </div>
                            </div>

                            <div class="order-items">
                                <c:if test="${empty recentOrders}">
                                    <div class="empty-state">
                                        <i class="fas fa-shopping-bag"></i>
                                        <h4>No items in cart</h4>
                                        <p>Add some items to your cart first.</p>
                                    </div>
                                </c:if>

                                <c:if test="${not empty recentOrders}">
                                    <c:forEach items="${recentOrders}" var="order">
                                        <c:forEach items="${order.items}" var="item">
                                            <div class="order-item">
                                                <c:choose>
                                                    <c:when test="${item.productName.contains('Vans')}">
                                                        <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Nike')}">
                                                        <img src="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Adidas')}">
                                                        <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-details">
                                                    <div class="item-name">${item.productName}</div>
                                                    <div class="item-price">$${item.unitPrice}</div>
                                                    <div class="item-quantity">Quantity ${item.quantity}</div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:forEach>
                                </c:if>
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
                                    <input type="text" id="voucherCode" class="voucher-field" placeholder="Enter voucher code">
                                    <button class="clear-btn" onclick="clearVoucher()">×</button>
                                </div>
                                <button class="apply-btn" onclick="applyVoucher()">Apply</button>
                            </div>

                            <div class="available-vouchers">
                                <h6>Available vouchers:</h6>
                                <div class="voucher-suggestions">
                                    <span class="voucher-tag" onclick="selectVoucher('FIXED15')">FIXED15 (15.000 off)</span>
                                    <span class="voucher-tag" onclick="selectVoucher('SUMMER20')">FPTUCT (20.000 off)</span>
                                    <span class="voucher-tag" onclick="selectVoucher('NEOSHOE25')">NEOSHOE25 (25.000 off)</span>
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
                                <span class="summary-label">Items (${totalItems}):</span>
                                <span class="summary-value">$${totalSpent}</span>
                            </div>
                            <div class="summary-item">
                                <span class="summary-label">Shipping:</span>
                                <span class="summary-value">$10.00</span>
                            </div>
                            <div class="summary-item" id="discountRow" style="display: none;">
                                <span class="summary-label">Discount:</span>
                                <span class="summary-value" style="color: #28a745;">-$<span id="discountAmount">0</span></span>
                            </div>
                            <div class="summary-item">
                                <span class="summary-label">Total Amount:</span>
                                <span class="summary-value summary-total">$<span id="totalAmount">${totalSpent + 10}</span></span>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button class="place-order-btn">
                                <i class="fas fa-equals"></i>
                                Place Order
                            </button>
                            <button class="back-cart-btn">
                                <i class="fas fa-arrow-left"></i>
                                Back to Cart
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

        <script>
                                        let appliedDiscount = 0;
                                        let originalTotal = ${totalSpent + 10};

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

                                            // Voucher validation and discount calculation
                                            let discount = 0;
                                            let message = '';

                                            switch (voucherCode) {
                                                case 'FIXED15':
                                                    discount = 15;
                                                    message = 'FIXED15 applied! You saved $15.00';
                                                    break;
                                                case 'FPTUCT':
                                                    discount = 20;
                                                    message = 'FPTUCT applied! You saved $20.00';
                                                    break;
                                                case 'NEOSHOE25':
                                                    discount = 25;
                                                    message = 'NEOSHOE25 applied! You saved $25.00';
                                                    break;
                                                default:
                                                    alert('Invalid voucher code');
                                                    return;
                                            }

                                            appliedDiscount = discount;
                                            updateTotal();
                                            showDiscountMessage(message);
                                        }

                                        function removeDiscount() {
                                            appliedDiscount = 0;
                                            updateTotal();
                                            hideDiscountMessage();
                                        }

                                        function updateTotal() {
                                            const newTotal = originalTotal - appliedDiscount;
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
        </script>
    </body>
</html>
