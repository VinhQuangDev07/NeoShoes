<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Order Detail - NeoShoes" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title><c:out value="${pageTitle != null ? pageTitle : 'NeoShoes'}"/></title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        
        <style>
            body {
                background: #f8f9fa;
                padding: 20px 0;
            }
            
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
                flex-wrap: wrap;
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
                text-transform: capitalize;
            }
            
            .status-PENDING {
                background: #ffc107;
                color: #000;
            }
            
            .status-APPROVED {
                background: #007bff;
                color: white;
            }
            
            .status-SHIPPING {
                background: #17a2b8;
                color: white;
            }
            
            .status-DELIVERED {
                background: #28a745;
                color: white;
            }
            
            .status-CANCELED {
                background: #dc3545;
                color: white;
            }
            
            .status-RETURNED {
                background: #6c757d;
                color: white;
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
                background: #e9ecef;
            }
            
            .progress-step.completed::before {
                background: #28a745;
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
                animation: pulse 2s infinite;
            }
            
            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0.7);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(0, 123, 255, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0);
                }
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
                padding-top: 8px;
                border-top: 1px solid #e0e0e0;
                margin-top: 8px;
            }
            
            .payment-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
                margin-right: 8px;
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
            
            .shipping-section h6 {
                font-weight: 600;
                margin-bottom: 10px;
                color: #333;
            }
            
            .products-section {
                padding: 20px;
            }
            
            .products-section h6 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
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
                color: #333;
            }
            
            .product-variant {
                color: #999;
                font-size: 13px;
                margin-bottom: 2px;
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
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                flex-wrap: wrap;
            }
            
            .btn-action {
                border: none;
                padding: 10px 24px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            
            .close-btn {
                background: #007bff;
                color: white;
            }
            
            .close-btn:hover {
                background: #0056b3;
                color: white;
            }
            
            .cancel-btn {
                background: #dc3545;
                color: white;
            }
            
            .cancel-btn:hover {
                background: #c82333;
                color: white;
            }
            
            .cancel-btn:disabled {
                background: #6c757d;
                cursor: not-allowed;
            }
            
            /* Cancel Modal Styles */
            .cancel-modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                animation: fadeIn 0.3s ease;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            
            .cancel-modal-content {
                background-color: white;
                margin: 10% auto;
                padding: 0;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.3);
                animation: slideDown 0.3s ease;
            }
            
            @keyframes slideDown {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            .cancel-modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
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
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 4px;
                transition: background 0.3s ease;
            }
            
            .cancel-modal-close:hover {
                background: #f0f0f0;
            }
            
            .cancel-modal-body {
                padding: 20px;
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
                align-items: flex-start;
                gap: 10px;
            }
            
            .cancel-warning i {
                margin-top: 2px;
            }
            
            .cancel-modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                padding: 20px;
                border-top: 1px solid #e0e0e0;
            }
            
            .cancel-confirm-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.3s ease;
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
                transition: background 0.3s ease;
            }
            
            .cancel-cancel-btn:hover {
                background: #5a6268;
            }
            
            /* Loading state */
            .btn-loading {
                position: relative;
                pointer-events: none;
                opacity: 0.7;
            }
            
            .btn-loading::after {
                content: "";
                position: absolute;
                width: 16px;
                height: 16px;
                top: 50%;
                left: 50%;
                margin-left: -8px;
                margin-top: -8px;
                border: 2px solid #ffffff;
                border-radius: 50%;
                border-top-color: transparent;
                animation: spinner 0.6s linear infinite;
            }
            
            @keyframes spinner {
                to { transform: rotate(360deg); }
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .order-summary {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
                
                .modal-footer {
                    flex-direction: column;
                }
                
                .btn-action {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10 col-xl-8">
                    <div class="order-detail-modal">
                        <!-- Order Header -->
                        <div class="order-header">
                            <div class="order-title">
                                <div class="order-icon">
                                    <i class="fas fa-receipt"></i>
                                </div>
                                <h4 class="mb-0">Order Detail #<c:out value="${order.orderId}"/></h4>
                            </div>
                            <div class="order-meta">
                                <div class="order-date">
                                    <i class="fas fa-calendar"></i>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty order.placedAt}">
                                                <c:out value="${order.placedAt}"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <span class="status-badge status-${order.status}">
                                    <c:out value="${order.status}"/>
                                </span>
                            </div>
                        </div>

                        <!-- Order Progress Timeline -->
                        <div class="progress-section">
                            <h6>Order Progress</h6>
                            <div class="progress-timeline">
                                <!-- Step 1: Order Placed -->
                                <div class="progress-step completed">
                                    <div class="step-circle completed">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Order Placed</div>
                                            <div class="step-date">
                                                <c:out value="${order.placedAt}"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Step 2: Approved -->
                                <div class="progress-step ${order.status == 'APPROVED' || order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'APPROVED' || order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'completed' : (order.status == 'PENDING' ? '' : 'current')}">
                                        <c:choose>
                                            <c:when test="${order.status == 'APPROVED' || order.status == 'SHIPPING' || order.status == 'DELIVERED'}">
                                                <i class="fas fa-check"></i>
                                            </c:when>
                                            <c:when test="${order.status == 'PENDING'}">
                                                <i class="fas fa-clock"></i>
                                            </c:when>
                                            <c:when test="${order.status == 'CANCELED'}">
                                                <i class="fas fa-times"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-check-circle"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Approved</div>
                                            <div class="step-date">
                                                <c:choose>
                                                    <c:when test="${order.status == 'APPROVED' || order.status == 'SHIPPING' || order.status == 'DELIVERED'}">
                                                        <c:out value="${order.placedAt}"/>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CANCELED'}">
                                                        Canceled
                                                    </c:when>
                                                    <c:otherwise>
                                                        Pending
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Step 3: Shipping -->
                                <div class="progress-step ${order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'completed' : (order.status == 'APPROVED' ? 'current' : '')}">
                                        <c:choose>
                                            <c:when test="${order.status == 'SHIPPING' || order.status == 'DELIVERED'}">
                                                <i class="fas fa-check"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-truck"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Shipping</div>
                                            <div class="step-date">
                                                <c:choose>
                                                    <c:when test="${order.status == 'SHIPPING' || order.status == 'DELIVERED'}">
                                                        In Transit
                                                    </c:when>
                                                    <c:otherwise>
                                                        Pending
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Step 4: Delivered -->
                                <div class="progress-step ${order.status == 'DELIVERED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'DELIVERED' ? 'completed' : (order.status == 'SHIPPING' ? 'current' : '')}">
                                        <c:choose>
                                            <c:when test="${order.status == 'DELIVERED'}">
                                                <i class="fas fa-check"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-home"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Delivered</div>
                                            <div class="step-date">
                                                <c:choose>
                                                    <c:when test="${order.status == 'DELIVERED'}">
                                                        Completed
                                                    </c:when>
                                                    <c:otherwise>
                                                        Not yet
                                                    </c:otherwise>
                                                </c:choose>
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
                                <div class="summary-item">
                                    <span>Subtotal:</span>
                                    <span>$<c:out value="${order.totalAmount - order.shippingFee}"/></span>
                                </div>
                                <div class="summary-item">
                                    <span>Shipping fee:</span>
                                    <span>$<c:out value="${order.shippingFee}"/></span>
                                </div>
                                <div class="summary-item summary-total">
                                    <span>Total to pay:</span>
                                    <span>$<c:out value="${order.totalAmount}"/></span>
                                </div>
                            </div>
                            <div class="summary-section">
                                <h6>Payment Method</h6>
                                <div class="mb-3">
                                    <span class="payment-badge payment-cod">
                                        <i class="fas fa-money-bill-wave"></i>
                                        Cash on Delivery
                                    </span>
                                </div>
                                <div>
                                    <span class="payment-badge payment-completed">
                                        <i class="fas fa-check-circle"></i>
                                        Completed
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Info -->
                        <div class="shipping-section">
                            <h6><i class="fas fa-shipping-fast"></i> Delivery Address</h6>
                            <p class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty order.recipientName}">
                                        <strong><c:out value="${order.recipientName}"/></strong><br>
                                        <c:out value="${order.addressDetails}"/><br>
                                        <i class="fas fa-phone"></i> Phone: <c:out value="${order.recipientPhone}"/>
                                    </c:when>
                                    <c:otherwise>
                                        Default Address
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Products --> 
                        <div class="products-section">
                            <h6><i class="fas fa-box"></i> Products</h6>
                            <c:choose>
                                <c:when test="${not empty order.items}">
                                    <c:forEach items="${order.items}" var="item">
                                        <div class="product-item">
                                            <c:set var="productName" value="${fn:toLowerCase(item.productName)}"/>
                                            <c:choose>
                                                <c:when test="${fn:contains(productName, 'vans')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:when test="${fn:contains(productName, 'nike')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:when test="${fn:contains(productName, 'adidas')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:when test="${fn:contains(productName, 'converse')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:when test="${fn:contains(productName, 'jordan')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:when test="${fn:contains(productName, 'puma')}">
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=60&h=60&fit=crop&crop=center"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="imageUrl" value="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="${imageUrl}" 
                                                 alt="<c:out value='${item.productName}'/>" 
                                                 class="product-image"
                                                 loading="lazy">
                                            <div class="product-info">
                                                <div class="product-name">
                                                    <c:out value="${item.productName}"/>
                                                </div>
                                                <div class="product-quantity">
                                                    Quantity: x<c:out value="${item.detailQuantity}"/>
                                                </div>
                                            </div>
                                            <div class="product-price">
                                                $<c:out value="${item.detailPrice}"/>
                                            </div>
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

                        <!-- Footer Actions -->
                        <div class="modal-footer">
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">
                                    <!-- Only PENDING orders can be cancelled -->
                                    <button class="btn-action cancel-btn" 
                                            data-action="show-cancel"
                                            aria-label="Cancel Order">
                                        <i class="fas fa-times"></i>
                                        Cancel Order
                                    </button>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <!-- Only DELIVERED orders can create return request -->
                                    <c:choose>
                                        <c:when test="${hasRequest}">
                                            <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${requestId}" 
                                               class="btn-action cancel-btn"
                                               aria-label="View Return Request">
                                                <i class="fas fa-eye"></i>
                                                View Return Request
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/return-request?orderId=${order.orderId}" 
                                               class="btn-action cancel-btn"
                                               aria-label="Create Return Request">
                                                <i class="fas fa-undo"></i>
                                                Create Return Request
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${order.status == 'RETURNED'}">
                                    <!-- Show view return request for RETURNED orders -->
                                    <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${requestId}" 
                                       class="btn-action cancel-btn"
                                       aria-label="View Return Request">
                                        <i class="fas fa-eye"></i>
                                        View Return Request
                                    </a>
                                </c:when>
                            </c:choose>
                            <button class="btn-action close-btn" 
                                    onclick="window.history.back()"
                                    aria-label="Close">
                                <i class="fas fa-arrow-left"></i>
                                Back to Orders
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cancel Order Modal -->
        <div id="cancelModal" 
             class="cancel-modal" 
             role="dialog" 
             aria-labelledby="cancelModalTitle"
             aria-hidden="true">
            <div class="cancel-modal-content">
                <div class="cancel-modal-header">
                    <div class="cancel-modal-title" id="cancelModalTitle">
                        <i class="fas fa-exclamation-triangle"></i>
                        Cancel Order
                    </div>
                    <button class="cancel-modal-close" 
                            data-action="hide-cancel"
                            aria-label="Close">&times;</button>
                </div>
                <div class="cancel-modal-body">
                    <div class="cancel-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>Are you sure you want to cancel this order? This action cannot be undone.</span>
                    </div>
                    <div class="cancel-order-info">
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Order Status:</span>
                            <span class="cancel-info-value">
                                <c:out value="${order.status}"/>
                            </span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Total Amount:</span>
                            <span class="cancel-info-value">$<c:out value="${order.totalAmount}"/></span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Payment Status:</span>
                            <span class="cancel-info-value">Completed</span>
                        </div>
                    </div>
                </div>
                <div class="cancel-modal-footer">
                    <button class="cancel-cancel-btn" 
                            data-action="hide-cancel"
                            aria-label="Keep Order">
                        Keep Order
                    </button>
                    <button class="cancel-confirm-btn" 
                            data-action="confirm-cancel"
                            aria-label="Confirm Cancel">
                        Confirm Cancel
                    </button>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Order Detail Manager
            const OrderDetailManager = {
                modal: null,
                orderId: '${order.orderId}',
                contextPath: '${pageContext.request.contextPath}',
                
                init() {
                    this.modal = document.getElementById('cancelModal');
                    this.attachEventListeners();
                },
                
                attachEventListeners() {
                    // Event delegation for all action buttons
                    document.addEventListener('click', (e) => {
                        const btn = e.target.closest('[data-action]');
                        if (!btn) return;
                        
                        const action = btn.dataset.action;
                        
                        switch(action) {
                            case 'show-cancel':
                                this.showCancelModal();
                                break;
                            case 'hide-cancel':
                                this.hideCancelModal();
                                break;
                            case 'confirm-cancel':
                                this.confirmCancelOrder(btn);
                                break;
                        }
                    });
                    
                    // Close modal when clicking outside
                    window.addEventListener('click', (e) => {
                        if (e.target === this.modal) {
                            this.hideCancelModal();
                        }
                    });
                    
                    // Close modal on ESC key
                    document.addEventListener('keydown', (e) => {
                        if (e.key === 'Escape' && this.modal.style.display === 'block') {
                            this.hideCancelModal();
                        }
                    });
                },
                
                showCancelModal() {
                    this.modal.style.display = 'block';
                    this.modal.setAttribute('aria-hidden', 'false');
                    document.body.style.overflow = 'hidden'; // Prevent background scroll
                },
                
                hideCancelModal() {
                    this.modal.style.display = 'none';
                    this.modal.setAttribute('aria-hidden', 'true');
                    document.body.style.overflow = ''; // Restore scroll
                },
                
                confirmCancelOrder(button) {
                    // Prevent double submission
                    if (button.classList.contains('btn-loading')) {
                        return;
                    }
                    
                    // Show loading state
                    button.classList.add('btn-loading');
                    const originalText = button.textContent;
                    button.textContent = 'Processing...';
                    
                    // Create and submit form
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = this.contextPath + '/orders/detail';
                    
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
                    orderIdInput.value = this.orderId;
                    form.appendChild(orderIdInput);
                    
                    // Submit the form
                    document.body.appendChild(form);
                    form.submit();
                },
                
               
            
            // Initialize when DOM is ready
            document.addEventListener('DOMContentLoaded', function() {
                OrderDetailManager.init();
                
                // Add smooth scroll behavior
                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                    anchor.addEventListener('click', function (e) {
                        e.preventDefault();
                        const target = document.querySelector(this.getAttribute('href'));
                        if (target) {
                            target.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                        }
                    });
                });
                
                // Auto-hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        alert.style.transition = 'opacity 0.3s ease';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 300);
                    }, 5000);
                });
            });
            
            // Export to window for backward compatibility
            window.OrderDetailManager = OrderDetailManager;
            window.showCancelModal = () => OrderDetailManager.showCancelModal();
            window.hideCancelModal = () => OrderDetailManager.hideCancelModal();
        </script>
    </body>
</html> ID:</span>
                            <span class="cancel-info-value">#<c:out value="${order.orderId}"/></span>
                        </div>
                        <div class="cancel-info-item">
                            <span class="cancel-info-label">Order