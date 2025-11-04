<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="approvedTime" value="" />
<c:set var="shippedTime" value="" />
<c:set var="deliveredTime" value="" />

<c:forEach items="${statusHistory}" var="history">
    <c:choose>
        <c:when test="${history.orderStatus == 'APPROVED'}">
            <c:set var="approvedTime" value="${history.changedAt}" />
        </c:when>
        <c:when test="${history.orderStatus == 'SHIPPED'}">
            <c:set var="shippedTime" value="${history.changedAt}" />
        </c:when>
        <c:when test="${history.orderStatus == 'COMPLETED'}">
            <c:set var="deliveredTime" value="${history.changedAt}" />
        </c:when>
    </c:choose>
</c:forEach>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Detail - NeoShoes Staff</title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
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
            
            .container {
                margin-top: 100px;
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
                background: #0A437F;
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
                font-size: 0.8rem;
                padding: 0.25rem 0.5rem;
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
            
            .payment-cancelled {
                background: #dc3545;
                color: white;
            }
            
            .shipping-section {
                padding: 15px 20px;
                border-bottom: 1px solid #e0e0e0;
            }
            
            .shipping-section h6 {
                font-weight: 600;
                margin-bottom: 8px;
                color: #333;
                font-size: 16px;
            }
            
            .address-info {
                line-height: 1.4;
            }
            
            .address-horizontal {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 12px;
            }
            
            .address-item {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                color: #555;
                font-size: 14px;
            }
            
            .address-item a {
                color: #0A437F;
                text-decoration: none;
            }
            
            .address-item a:hover {
                color: #083063;
                text-decoration: underline;
            }
            
            .address-separator {
                color: #999;
                font-size: 12px;
            }
            
            .address-line {
                margin-bottom: 4px;
                color: #555;
                font-size: 14px;
            }
            
            .address-line:last-child {
                margin-bottom: 0;
            }
            
            @media (max-width: 576px) {
                .address-horizontal {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 8px;
                }
                .address-separator {
                    display: none;
                }
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
            
            /* Status History Section */
            .status-history-section {
                padding: 20px;
                border-top: 1px solid #e0e0e0;
                background: #f8f9fa;
            }
            
            .status-history-section h6 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #333;
            }
            
        .timeline {
            position: relative;
            padding-left: 30px;
        }
            
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
            
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
            padding-left: 20px;
        }
            
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -22px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #0A437F;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #dee2e6;
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
    <!-- Include Staff Header -->
        <jsp:include page="/WEB-INF/views/Staff/common/staff-header.jsp" />
        
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
                                    <span class="order-date" data-date="${order.placedAt}"></span>
                                </div>
                                <span class="order-status">
                                    <c:choose>
                                        <c:when test="${empty order.status}">
                                            <span class="badge bg-secondary status-badge">No Status</span>
                                        </c:when>
                                        <c:when test="${order.status == 'PENDING'}">
                                            <span class="badge bg-warning status-badge">Pending</span>
                                        </c:when>
                                        <c:when test="${order.status == 'APPROVED'}">
                                            <span class="badge bg-info status-badge">Approved</span>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPED'}">
                                            <span class="badge bg-primary status-badge">Shipped</span>
                                        </c:when>
                                        <c:when test="${order.status == 'COMPLETED'}">
                                            <span class="badge bg-success status-badge">Completed</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge bg-danger status-badge">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary status-badge">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                    </div>
                </div>

                        <!-- Order Progress Timeline -->
                        <c:if test="${order.status != 'CANCELLED'}">
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
                                            <div>Pending</div>
                                </div>
                            </div>
                        </div>

                                <!-- Step 2: Approved -->
                                <div class="progress-step ${order.status == 'APPROVED' || order.status == 'SHIPPED' || order.status == 'COMPLETED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'APPROVED' || order.status == 'SHIPPED' || order.status == 'COMPLETED' ? 'completed' : (order.status == 'PENDING' ? '' : 'current')}">
                                                <c:choose>
                                            <c:when test="${order.status == 'APPROVED' || order.status == 'SHIPPED' || order.status == 'COMPLETED'}">
                                                <i class="fas fa-check"></i>
                                            </c:when>
                                            <c:when test="${order.status == 'PENDING'}">
                                                <i class="fas fa-clock"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                <i class="fas fa-check-circle"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                        </div>
                                    <div class="step-info">
                                        <div class="step-text">
                                            <div>Approved</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Step 3: Shipping -->
                                <div class="progress-step ${order.status == 'SHIPPED' || order.status == 'COMPLETED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'SHIPPED' || order.status == 'COMPLETED' ? 'completed' : (order.status == 'APPROVED' ? 'current' : '')}">
                                                <c:choose>
                                            <c:when test="${order.status == 'SHIPPED' || order.status == 'COMPLETED'}">
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
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Step 4: Delivered -->
                                <div class="progress-step ${order.status == 'COMPLETED' ? 'completed' : ''}">
                                    <div class="step-circle ${order.status == 'COMPLETED' ? 'completed' : (order.status == 'SHIPPED' ? 'current' : '')}">
                                        <c:choose>
                                            <c:when test="${order.status == 'COMPLETED'}">
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
                                        </div>
                                </div>
                                </div>
                    </div>
                </div>
                        </c:if>

                        <!-- Order Summary -->
                        <div class="order-summary">
                            <div class="summary-section">
                                <h6>Payment Summary</h6>
                                <div class="summary-item">
                                    <span>Items Subtotal:</span>
                                    <span>$<fmt:formatNumber value="${order.totalAmount - order.shippingFee}" pattern="#,##0.00"/></span>
                                </div>
                                <div class="summary-item">
                                    <span>Shipping Fee:</span>
                                    <span>$<fmt:formatNumber value="${order.shippingFee}" pattern="#,##0.00"/></span>
                                </div>
                                <div class="summary-item summary-total">
                                    <span>Total Amount:</span>
                                    <span>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                    </div>
                            </div>
                            <div class="summary-section">
                                <h6>Payment Method</h6>
                                <c:choose>
                                    <c:when test="${order.status == 'CANCELLED'}">
                                        <div class="mb-3">
                                            <span class="payment-badge payment-cancelled">
                                                <i class="fas fa-times-circle"></i>
                                                Cancelled
                                            </span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mb-3">
                                            <span class="payment-badge payment-cod">
                                                <i class="fas fa-money-bill-wave"></i>
                                                <c:out value="${order.paymentMethodName}" default="Cash on Delivery"/>
                                            </span>
                                        </div>
                                        <div>
                                            <span class="payment-badge payment-completed">
                                                <i class="fas fa-check-circle"></i>
                                                <c:out value="${order.paymentStatusName}" default="Completed"/>
                                            </span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                    </div>
                </div>

                        <!-- Customer Information -->
                        <div class="shipping-section">
                            <h6><i class="fas fa-user-circle"></i> Customer Information</h6>
                            <div class="address-info">
                                <c:set var="hasCustomerName" value="${not empty order.customerName}" />
                                <c:set var="hasCustomerEmail" value="${not empty order.customerEmail}" />
                                <c:set var="hasCustomerPhone" value="${not empty order.customerPhone}" />
                                <c:set var="hasAnyCustomerData" value="${hasCustomerName || hasCustomerEmail || hasCustomerPhone}" />
                                
                                <c:choose>
                                    <c:when test="${hasAnyCustomerData}">
                                        <div class="address-horizontal">
                                            <c:if test="${hasCustomerName}">
                                                <span class="address-item"><i class="fas fa-user"></i> <strong><c:out value="${order.customerName}"/></strong></span>
                                            </c:if>
                                            
                                            <c:if test="${hasCustomerName && (hasCustomerEmail || hasCustomerPhone)}">
                                                <span class="address-separator">•</span>
                                            </c:if>
                                            
                                            <c:if test="${hasCustomerEmail}">
                                                <span class="address-item"><i class="fas fa-envelope"></i> <c:out value="${order.customerEmail}"/></span>
                                            </c:if>
                                            
                                            <c:if test="${hasCustomerEmail && hasCustomerPhone}">
                                                <span class="address-separator">•</span>
                                            </c:if>
                                            
                                            <c:if test="${hasCustomerPhone}">
                                                <span class="address-item"><i class="fas fa-phone"></i> <c:out value="${order.customerPhone}"/></span>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="address-horizontal">
                                            <span class="address-item text-muted">
                                                <i class="fas fa-info-circle"></i> 
                                                Customer information not available
                                            </span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Shipping Info -->
                        <div class="shipping-section">
                            <h6><i class="fas fa-shipping-fast"></i> Delivery Address</h6>
                            <div class="address-info">
                                <c:set var="hasRecipientName" value="${not empty order.recipientName}" />
                                <c:set var="hasAddressDetails" value="${not empty order.addressDetails}" />
                                <c:set var="hasRecipientPhone" value="${not empty order.recipientPhone}" />
                                <c:set var="hasAnyAddressData" value="${hasRecipientName || hasAddressDetails || hasRecipientPhone}" />
                                
                                <c:choose>
                                    <c:when test="${hasAnyAddressData}">
                                        <div class="address-horizontal">
                                            <c:if test="${hasRecipientName}">
                                                <span class="address-item"><i class="fas fa-user"></i> <strong><c:out value="${order.recipientName}"/></strong></span>
                                            </c:if>
                                            
                                            <c:if test="${hasRecipientName && (hasAddressDetails || hasRecipientPhone)}">
                                                <span class="address-separator">•</span>
                                            </c:if>
                                            
                                            <c:if test="${hasAddressDetails}">
                                                <span class="address-item"><i class="fas fa-map-marker-alt"></i> <c:out value="${order.addressDetails}"/></span>
                                            </c:if>
                                            
                                            <c:if test="${hasAddressDetails && hasRecipientPhone}">
                                                <span class="address-separator">•</span>
                                            </c:if>
                                            
                                            <c:if test="${hasRecipientPhone}">
                                                <span class="address-item"><i class="fas fa-phone"></i> <c:out value="${order.recipientPhone}"/></span>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="address-horizontal">
                                            <span class="address-item text-muted">
                                                <i class="fas fa-info-circle"></i> 
                                                Address information not available
                                            </span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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
                                                <div class="product-variant">
                                                    <c:if test="${not empty item.color}">Color: ${item.color}</c:if>
                                                    <c:if test="${not empty item.size}"> • Size: ${item.size}</c:if>
                                                </div>
                                                <div class="product-quantity">
                                                    Quantity: x<c:out value="${item.detailQuantity}"/>
                                                </div>
                                            </div>
                                            <div class="product-price">
                                                $<fmt:formatNumber value="${item.detailPrice}" pattern="#,##0.00"/>
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

                        <!-- Status History Section -->
                        <c:if test="${not empty statusHistory}">
                            <div class="status-history-section">
                                <h6><i class="fas fa-history"></i> Status History</h6>
                                <div class="timeline">
                                    <c:forEach var="history" items="${statusHistory}">
                                        <div class="timeline-item">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                            <div class="d-flex align-items-center mb-1">
                                                                <c:choose>
                                                                    <c:when test="${history.orderStatus == 'PENDING'}">
                                                                        <i class="fas fa-clock me-2 text-warning"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'APPROVED'}">
                                                                        <i class="fas fa-check-circle me-2 text-info"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'SHIPPED'}">
                                                                        <i class="fas fa-shipping-fast me-2 text-primary"></i>
                                                                    </c:when>
                                                            <c:when test="${history.orderStatus == 'COMPLETED'}">
                                                                        <i class="fas fa-check-double me-2 text-success"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'CANCELLED'}">
                                                                        <i class="fas fa-times-circle me-2 text-danger"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="fas fa-info-circle me-2 text-secondary"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <strong class="me-2">
                                                                    <c:choose>
                                                                        <c:when test="${history.orderStatus == 'SHIPPED'}">Shipping</c:when>
                                                                        <c:otherwise>${history.orderStatus}</c:otherwise>
                                                                    </c:choose>
                                                                </strong>
                                                            </div>
                                                            <p class="text-muted mb-1 small">
                                                                <i class="fas fa-user me-1" style="color: #0A437F;"></i>Changed by: ${history.changedByName}
                                                            </p>
                                                </div>
                                                        <small class="text-muted">
                                                    <span class="status-date" data-date="${history.changedAt}"></span>
                                                        </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Footer Actions -->
                        <div class="modal-footer">
                            <a href="${pageContext.request.contextPath}/staff/orders" class="btn-action close-btn">
                                <i class="fas fa-arrow-left"></i>
                                Back to Orders
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Format datetime
            document.querySelectorAll('.order-date[data-date], .status-date[data-date]').forEach(element => {
                const dateStr = element.getAttribute('data-date');
                if (dateStr) {
                    try {
                        const date = new Date(dateStr);
                        element.textContent = date.toLocaleString('vi-VN', {
                            year: 'numeric',
                            month: '2-digit',
                            day: '2-digit',
                            hour: '2-digit',
                            minute: '2-digit',
                            second: dateStr.includes('T') && dateStr.split('T')[1] ? '2-digit' : undefined
                        });
                    } catch (e) {
                        element.textContent = dateStr;
                    }
                }
            });
            
        </script>
</body>
</html>
