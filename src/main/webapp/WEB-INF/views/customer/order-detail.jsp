<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Order Detail - NeoShoes" scope="request"/>

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
            .order-detail-modal {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                max-width: 800px;
                margin: 20px auto;
                overflow: hidden;
            }
            .order-header {
                background: #f8f9fa;
                padding: 20px;
                border-bottom: 1px solid #e0e0e0;
            }
            .order-title {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 8px;
            }
            .order-icon {
                width: 40px;
                height: 40px;
                background: #007bff;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 18px;
            }
            .order-meta {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-top: 10px;
            }
            .order-date {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #666;
                font-size: 14px;
            }
            .status-badge {
                padding: 6px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 600;
            }
            .status-delivered {
                background: #28a745;
                color: white;
            }
            .status-shipped {
                background: #17a2b8;
                color: white;
            }
            .status-pending {
                background: #ffc107;
                color: #000;
            }
            .progress-section {
                padding: 20px;
                border-bottom: 1px solid #e0e0e0;
            }
            .progress-timeline {
                position: relative;
                padding-left: 30px;
            }
            .progress-step {
                position: relative;
                margin-bottom: 20px;
            }
            .progress-step:last-child {
                margin-bottom: 0;
            }
            .progress-step::before {
                content: '';
                position: absolute;
                left: -20px;
                top: 20px;
                width: 2px;
                height: 40px;
                background: #007bff;
            }
            .progress-step:last-child::before {
                display: none;
            }
            .step-circle {
                position: absolute;
                left: -30px;
                top: 0;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #e9ecef;
                color: #6c757d;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: bold;
                border: 2px solid #e9ecef;
            }
            .step-circle.completed {
                background: #28a745;
                color: white;
                border-color: #28a745;
            }
            .step-circle.current {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }
            .step-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .step-text {
                flex: 1;
            }
            .step-date {
                color: #666;
                font-size: 14px;
            }
            .order-summary {
                padding: 20px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                border-bottom: 1px solid #e0e0e0;
            }
            .summary-section h6 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
            }
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }
            .summary-total {
                font-weight: bold;
                color: #007bff;
                font-size: 16px;
            }
            .payment-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .payment-cod {
                background: #28a745;
                color: white;
            }
            .payment-completed {
                background: #17a2b8;
                color: white;
            }
            .shipping-section {
                padding: 20px;
                border-bottom: 1px solid #e0e0e0;
            }
            .products-section {
                padding: 20px;
            }
            .product-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .product-item:last-child {
                border-bottom: none;
            }
            .product-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #e0e0e0;
            }
            .product-info {
                flex: 1;
            }
            .product-name {
                font-weight: 600;
                margin-bottom: 4px;
            }
            .product-quantity {
                color: #666;
                font-size: 14px;
            }
            .product-price {
                font-weight: 600;
                color: #333;
            }
            .modal-footer {
                padding: 20px;
                text-align: right;
                background: #f8f9fa;
            }
            .close-btn {
                background: #007bff;
                color: white;
                border: none;
                padding: 10px 24px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
            }
            .close-btn:hover {
                background: #0056b3;
            }
            .cancel-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 10px 24px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                margin-right: 10px;
            }
            .cancel-btn:hover {
                background: #c82333;
            }
            .cancel-btn:disabled {
                background: #6c757d;
                cursor: not-allowed;
            }
            .cancel-modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
            }
            .cancel-modal-content {
                background-color: white;
                margin: 15% auto;
                padding: 20px;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            }
            .cancel-modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e0e0e0;
            }
            .cancel-modal-title {
                font-size: 18px;
                font-weight: 600;
                color: #dc3545;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .cancel-modal-close {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #666;
            }
            .cancel-modal-body {
                margin-bottom: 20px;
            }
            .cancel-order-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 15px;
            }
            .cancel-info-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }
            .cancel-info-item:last-child {
                margin-bottom: 0;
            }
            .cancel-info-label {
                color: #666;
                font-weight: 500;
            }
            .cancel-info-value {
                color: #333;
                font-weight: 600;
            }
            .cancel-warning {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .cancel-modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }
            .cancel-confirm-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
            }
            .cancel-confirm-btn:hover {
                background: #c82333;
            }
            .cancel-cancel-btn {
                background: #6c757d;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
            }
            .cancel-cancel-btn:hover {
                background: #5a6268;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="row justify-content-center">
                <!-- Main Content -->
                <div class="col-lg-10 col-xl-8">
                    <div class="order-detail-modal">
                        <!-- Order Header -->
                        <div class="order-header">
                            <div class="order-title">
                                <div class="order-icon">
                                    <i class="fas fa-dollar-sign"></i>
                                </div>
                                <h4 class="mb-0">Order Detail #${order.orderId}</h4>
                            </div>
                            <div class="order-meta">
                                <div class="order-date">
                                    <i class="fas fa-calendar"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${order.placedAt != null}">
                                                ${order.placedAt}
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <span class="status-badge ${order.paymentStatusId == 1 ? 'status-pending' : order.paymentStatusId == 2 ? 'status-pending' : order.paymentStatusId == 3 ? 'status-shipped' : 'status-delivered'}">
                                    ${order.paymentStatusId == 1 ? 'Pending' : order.paymentStatusId == 2 ? 'Processing' : order.paymentStatusId == 3 ? 'Shipped' : 'Delivered'}
                                </span>
                            </div>
                        </div>

                        <!-- Order Progress -->
                        <div class="progress-section">
                            <h6>Order Progress</h6>
                            <div class="progress-timeline">
                                <div class="progress-step">
                                    <div class="step-circle completed">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Order Placed</div>
                                            <div class="step-date">${order.placedAt}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="progress-step">
                                    <div class="step-circle ${order.paymentStatusId >= 2 ? 'completed' : ''}">
                                        <i class="fas fa-truck"></i>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Shipping</div>
                                            <div class="step-date">
                                                ${order.paymentStatusId >= 2 ? 'Completed' : 'Pending'}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="progress-step">
                                    <div class="step-circle ${order.paymentStatusId >= 3 ? 'completed' : ''}">
                                        <i class="fas fa-home"></i>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Delivered</div>
                                            <div class="step-date">
                                                ${order.paymentStatusId >= 3 ? 'Completed' : 'Not yet'}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Order Summary -->
<div class="order-summary">
    <div class="summary-section">
        <h6>Order Amount Details</h6>

        <!-- ✅ Subtotal -->
        <div class="summary-item">
            <span>Subtotal:</span>
            <span>$${order.subtotal}</span>
        </div>
        
        <!-- Shipping fee -->
        <div class="summary-item">
            <span>Shipping fee:</span>
            <span>$${order.shippingFee}</span>
        </div>
        
        <!-- ✅ Discount (chỉ hiển thị nếu có voucher) -->
        <c:if test="${order.voucherId != null && order.discount > 0}">
            <div class="summary-item" style="color: #dc2626; font-weight: 600; background: #fef2f2; padding: 8px; margin: 4px -8px; border-radius: 6px;">
                <span>
                    Discount
                    <c:if test="${not empty order.voucher}">
                        (${order.voucher.voucherCode})
                    </c:if>
                    :
                </span>
                <span>-$${order.discount}</span>
            </div>
        </c:if>
        
        <!-- Total -->
        <div class="summary-item summary-total">
            <span>Total to pay:</span>
            <span>$${order.totalAmount}</span>
        </div>
        
        <!-- ✅ Voucher info box -->
        <c:if test="${not empty order.voucher}">
            <div style="margin-top: 12px; padding: 12px; background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); border-left: 4px solid #166534; border-radius: 8px; font-size: 13px; box-shadow: 0 2px 4px rgba(22, 101, 52, 0.1);">
                <strong style="color: #166534; display: flex; align-items: center; gap: 6px;">
                    <i class="fas fa-check-circle"></i>
                    Voucher applied
                </strong>
                <div style="margin-top: 6px;">
                    <span style="display: inline-block; padding: 4px 10px; background: #166534; color: white; border-radius: 6px; font-weight: 700; font-size: 12px; letter-spacing: 0.5px;">
                        ${order.voucher.voucherCode}
                    </span>
                    <c:choose>
                        <c:when test="${order.voucher.type eq 'PERCENTAGE'}">
                            <span style="color: #166534; font-weight: 600;"> - ${order.voucher.value}% discount</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #166534; font-weight: 600;"> - $${order.voucher.value} off</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
    
    <div class="summary-section">
        <h6>Payment Method</h6>
        <div class="mb-3">
            <span class="payment-badge payment-cod">Cash on Delivery</span>
        </div>
        <div>
            <span class="payment-badge payment-completed">Completed</span>
        </div>
    </div>
</div>

<!-- Shipping Info -->
<div class="shipping-section">
    <h6>Ship to</h6>
    <p class="mb-0">
        <c:choose>
            <c:when test="${not empty order.recipientName}">
                ${order.recipientName}<br>
                ${order.addressDetails}<br>
                Phone: ${order.recipientPhone}
            </c:when>
            <c:otherwise>
                Default Address
            </c:otherwise>
        </c:choose>
    </p>
</div>

                        <!-- Products -->
                        <div class="products-section">
                            <h6>Products</h6>
                            <c:choose>
                                <c:when test="${not empty order.items}">
                                    <c:forEach items="${order.items}" var="item">
                                        <div class="product-item">
                                            <c:choose>
                                                <c:when test="${item.productName.contains('Vans')}">
                                                    <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Nike')}">
                                                    <img src="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Adidas')}">
                                                    <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Converse')}">
                                                    <img src="https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Jordan')}">
                                                    <img src="https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Puma')}">
                                                    <img src="https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('Reebok')}">
                                                    <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:when test="${item.productName.contains('New Balance')}">
                                                    <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                         alt="${item.productName}" class="product-image">
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="product-info">
                                                <div class="product-name">${item.productName}</div>
                                                <div class="product-quantity">x${item.detailQuantity}</div>
                                            </div>
                                            <div class="product-price">$${item.detailPrice}</div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="product-item">
                                        <div class="product-info">
                                            <div class="product-name">No items found</div>
                                            <div class="product-quantity">Please check order details</div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Footer -->
                        <div class="modal-footer">
                            <c:choose>
                                <c:when test="${order.paymentStatusId <= 2}">
                                    <button class="cancel-btn" onclick="showCancelModal()">
                                        <i class="fas fa-times"></i>
                                        Cancel Order
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="cancel-btn" disabled>
                                        <i class="fas fa-times"></i>
                                        Cancel Order
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <button class="close-btn" onclick="window.history.back()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cancel Order Modal -->
        <div id="cancelModal" class="cancel-modal">
            <div class="cancel-modal-content">
                <div class="cancel-modal-header">
                    <div class="cancel-modal-title">
                        <i class="fas fa-exclamation-triangle"></i>
                        Cancel Order
                    </div>
                    <button class="cancel-modal-close" onclick="hideCancelModal()">&times;</button>
                </div>
                <div class="cancel-modal-body">
                    <div class="cancel-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>Are you sure you want to cancel this order? This action cannot be undone.</span>
                    </div>
                    <div class="cancel-order-info">
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Order ID:</span>
                            <span class="cancel-info-value">#${order.orderId}</span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Order Status:</span>
                            <span class="cancel-info-value">
                                ${order.paymentStatusId == 1 ? 'Pending' : order.paymentStatusId == 2 ? 'Processing' : order.paymentStatusId == 3 ? 'Shipped' : 'Delivered'}
                            </span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Total Amount:</span>
                            <span class="cancel-info-value">$${order.totalAmount}</span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Payment Status:</span>
                            <span class="cancel-info-value">Completed</span>
                        </div>
                    </div>
                </div>
                <div class="cancel-modal-footer">
                    <button class="cancel-cancel-btn" onclick="hideCancelModal()">Keep Order</button>
                    <button class="cancel-confirm-btn" onclick="confirmCancelOrder()">Confirm Cancel</button>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>
        
        <script>
            function showCancelModal() {
                document.getElementById('cancelModal').style.display = 'block';
            }
            
            function hideCancelModal() {
                document.getElementById('cancelModal').style.display = 'none';
            }
            
            function confirmCancelOrder() {
                // Create a form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/orders/detail';
                
                // Add action parameter
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'cancel';
                form.appendChild(actionInput);
                
                // Add orderId parameter
                const orderIdInput = document.createElement('input');
                orderIdInput.type = 'hidden';
                orderIdInput.name = 'orderId';
                orderIdInput.value = '${order.orderId}';
                form.appendChild(orderIdInput);
                
                // Submit the form
                document.body.appendChild(form);
                form.submit();
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                const modal = document.getElementById('cancelModal');
                if (event.target == modal) {
                    hideCancelModal();
                }
            }
        </script>
    </body>
    </html>

