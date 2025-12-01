<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="approvedTime" value="" />
<c:set var="shippedTime" value="" />
<c:set var="deliveredTime" value="" />
<c:set var="returnedTime" value="" />
<c:set var="cancelledTime" value="" />

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
        <c:when test="${history.orderStatus == 'RETURNED'}">
            <c:set var="returnedTime" value="${history.changedAt}" />
        </c:when>
        <c:when test="${history.orderStatus == 'CANCELLED'}">
            <c:set var="cancelledTime" value="${history.changedAt}" />
        </c:when>
    </c:choose>
</c:forEach>

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
            .orders-container {
                background: #f8f9fa;
                min-height: 100vh;
                padding: 20px 0;
            }

            .order-detail-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .order-header {
                padding: 20px;
                border-bottom: 1px solid #f0f0f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 15px;
            }

            .order-info {
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
            }

            .order-number {
                font-weight: 600;
                color: #007bff;
                font-size: 18px;
            }

            .order-date {
                color: #666;
                font-size: 14px;
            }

            .status-badge {
                font-size: 0.8rem;
                padding: 0.25rem 0.5rem;
            }

            .badge.bg-secondary {
                background-color: #6c757d !important;
                color: white;
            }

            .progress-section {
                padding: 20px;
                border-bottom: 1px solid #f0f0f0;
            }

            .progress-timeline {
                position: relative;
                padding-left: 50px;
            }

            .progress-timeline::before {
                content: '';
                position: absolute;
                left: 20px;
                top: 10px;
                bottom: 10px;
                width: 2px;
                background: #dee2e6;
                z-index: 1;
            }

            .timeline-item {
                position: relative;
                margin-bottom: 20px;
                padding-left: 0;
            }

            .timeline-item:last-child {
                margin-bottom: 0;
            }

            .timeline-dot {
                position: absolute;
                left: -40px;
                top: 2px;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #e9ecef;
                border: 3px solid white;
                box-shadow: 0 0 0 2px #dee2e6;
                z-index: 3;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }

            .timeline-dot::after {
                content: '';
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #6c757d;
                transition: all 0.3s ease;
            }

            .timeline-dot.completed {
                background: #28a745;
                border-color: white;
                box-shadow: 0 0 0 2px #28a745;
            }

            .timeline-dot.completed::after {
                background: white;
            }

            .timeline-dot.current {
                background: #007bff;
                border-color: white;
                box-shadow: 0 0 0 2px #007bff;
                animation: pulse-dot 2s infinite;
            }

            .timeline-dot.current::after {
                background: white;
            }

            @keyframes pulse-dot {
                0%, 100% {
                    box-shadow: 0 0 0 2px #007bff, 0 0 0 4px rgba(0,123,255,0.3);
                }
                50% {
                    box-shadow: 0 0 0 2px #007bff, 0 0 0 8px rgba(0,123,255,0);
                }
            }

            .timeline-content {
                background: #fff;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 14px 16px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                margin-left: 0;
            }

            .timeline-status {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 600;
                color: #212529;
                font-size: 15px;
                margin-bottom: 6px;
            }

            .timeline-status i {
                font-size: 16px;
            }

            .timeline-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
                font-size: 13px;
                color: #6c757d;
                align-items: center;
            }

            .timeline-meta span {
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .timeline-meta i {
                font-size: 12px;
            }

            .order-summary {
                padding: 20px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                border-bottom: 1px solid #f0f0f0;
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

            .delivery-info {
                background: #f8f9fa;
                padding: 15px 20px;
                border-bottom: 1px solid #f0f0f0;
                font-size: 14px;
                color: #666;
                display: flex;
                align-items: flex-start;
                gap: 8px;
            }

            .delivery-info i {
                margin-top: 2px;
            }

            .order-items {
                padding: 20px;
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

            .item-variant {
                color: #999;
                font-size: 13px;
                margin-bottom: 2px;
            }

            .item-quantity {
                color: #666;
                font-size: 14px;
            }

            .item-price {
                font-weight: 600;
                color: #333;
                margin-right: 15px;
            }

            .order-actions {
                padding: 20px;
                background: #f8f9fa;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                flex-wrap: wrap;
            }

            .action-buttons .btn {
                font-size: 14px;
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                white-space: nowrap;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: #007bff;
                border-color: #007bff;
            }

            .btn-primary:hover {
                background: #0056b3;
                border-color: #0056b3;
            }

            .btn-danger {
                background: #dc3545;
                border-color: #dc3545;
            }

            .btn-danger:hover {
                background: #c82333;
                border-color: #c82333;
            }

            .btn-secondary {
                background: #6c757d;
                border-color: #6c757d;
            }

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
                to {
                    transform: rotate(360deg);
                }
            }

            /* Cancel Modal - matching order list style */
            .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            }

            .modal-header {
                background: #f8f9fa;
                border-bottom: 1px solid #e0e0e0;
                padding: 20px;
            }

            .modal-title {
                font-size: 18px;
                font-weight: 600;
                color: #dc3545;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .modal-body {
                padding: 20px;
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

            @media (max-width: 768px) {
                .order-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .order-summary {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .order-actions {
                    flex-direction: column;
                }

                .action-buttons .btn {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />

        <div class="orders-container">
            <div class="container">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-lg-3">
                        <jsp:include page="common/customer-sidebar.jsp"/>
                    </div>

                    <!-- Main Content -->
                    <div class="col-lg-9">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i>
                                <c:out value="${successMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i>
                                <c:out value="${errorMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Order Detail Card -->
                        <div class="order-detail-card">
                            <!-- Order Header -->
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-number">Order: #<c:out value="${order.orderId}"/></span>
                                    <span class="order-date" data-date="${order.placedAt}"></span>
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
                                                <span class="badge bg-primary status-badge">Shipping</span>
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
                            <div class="progress-section">
                                <h6>Order Progress</h6>
                                <div class="progress-timeline">
                                    <!-- Step 1: Pending -->
                                    <c:set var="pendingDotClass" value="${order.status == 'PENDING' ? 'current' : 'completed'}"/>
                                    <div class="timeline-item">
                                        <div class="timeline-dot ${pendingDotClass}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-status">
                                                <i class="fas fa-clock ${order.status == 'PENDING' ? 'text-warning' : 'text-muted'}"></i>
                                                <span>Pending</span>
                                            </div>
                                            <div class="timeline-meta">
                                                <span class="timeline-date" data-date="${order.placedAt}"></span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Step 2: Approved -->
                                    <c:choose>
                                        <c:when test="${not empty approvedTime}">
                                            <c:set var="approvedDotClass" value="completed"/>
                                            <c:set var="approvedIconClass" value="text-info"/>
                                        </c:when>
                                        <c:when test="${order.status == 'APPROVED' || order.status == 'SHIPPED' || order.status == 'COMPLETED' || order.status == 'RETURNED'}">
                                            <c:set var="approvedDotClass" value="completed"/>
                                            <c:set var="approvedIconClass" value="text-info"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="approvedDotClass" value=""/>
                                            <c:set var="approvedIconClass" value="text-muted"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="timeline-item">
                                        <div class="timeline-dot ${approvedDotClass}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-status">
                                                <i class="fas fa-check-circle ${approvedIconClass}"></i>
                                                <span>Approved</span>
                                            </div>
                                            <div class="timeline-meta">
                                                <c:choose>
                                                    <c:when test="${not empty approvedTime}">
                                                        <span class="timeline-date" data-date="${approvedTime}"></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Step 3: Shipping -->
                                    <c:choose>
                                        <c:when test="${not empty shippedTime}">
                                            <c:set var="shippingDotClass" value="completed"/>
                                            <c:set var="shippingIconClass" value="text-primary"/>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPED' || order.status == 'COMPLETED' || order.status == 'RETURNED'}">
                                            <c:set var="shippingDotClass" value="completed"/>
                                            <c:set var="shippingIconClass" value="text-primary"/>
                                        </c:when>
                                        <c:when test="${order.status == 'APPROVED'}">
                                            <c:set var="shippingDotClass" value="current"/>
                                            <c:set var="shippingIconClass" value="text-primary"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="shippingDotClass" value=""/>
                                            <c:set var="shippingIconClass" value="text-muted"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="timeline-item">
                                        <div class="timeline-dot ${shippingDotClass}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-status">
                                                <i class="fas fa-shipping-fast ${shippingIconClass}"></i>
                                                <span>Shipping</span>
                                            </div>
                                            <div class="timeline-meta">
                                                <c:choose>
                                                    <c:when test="${not empty shippedTime}">
                                                        <span class="timeline-date" data-date="${shippedTime}"></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Step 4: Delivered -->
                                    <c:choose>
                                        <c:when test="${not empty deliveredTime}">
                                            <c:set var="deliveredDotClass" value="completed"/>
                                            <c:set var="deliveredIconClass" value="text-success"/>
                                        </c:when>
                                        <c:when test="${order.status == 'COMPLETED' || order.status == 'RETURNED'}">
                                            <c:set var="deliveredDotClass" value="completed"/>
                                            <c:set var="deliveredIconClass" value="text-success"/>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPED'}">
                                            <c:set var="deliveredDotClass" value="current"/>
                                            <c:set var="deliveredIconClass" value="text-success"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="deliveredDotClass" value=""/>
                                            <c:set var="deliveredIconClass" value="text-muted"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="timeline-item">
                                        <div class="timeline-dot ${deliveredDotClass}"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-status">
                                                <i class="fas fa-home ${deliveredIconClass}"></i>
                                                <span>Delivered</span>
                                            </div>
                                            <div class="timeline-meta">
                                                <c:choose>
                                                    <c:when test="${not empty deliveredTime}">
                                                        <span class="timeline-date" data-date="${deliveredTime}"></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Optional: Returned -->
                                    <c:if test="${not empty returnedTime || order.status == 'RETURNED'}">
                                        <div class="timeline-item">
                                            <div class="timeline-dot ${not empty returnedTime ? 'completed' : 'current'}"></div>
                                            <div class="timeline-content">
                                                <div class="timeline-status">
                                                    <i class="fas fa-undo-alt ${not empty returnedTime ? 'text-secondary' : 'text-secondary'}"></i>
                                                    <span>Returned</span>
                                                </div>
                                                <div class="timeline-meta">
                                                    <c:choose>
                                                        <c:when test="${not empty returnedTime}">
                                                            <span class="timeline-date" data-date="${returnedTime}"></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Processing</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Optional: Cancelled -->
                                    <c:if test="${order.status == 'CANCELLED' || not empty cancelledTime}">
                                        <div class="timeline-item">
                                            <div class="timeline-dot ${not empty cancelledTime ? 'completed' : 'current'}"></div>
                                            <div class="timeline-content">
                                                <div class="timeline-status">
                                                    <i class="fas fa-times-circle text-danger"></i>
                                                    <span>Cancelled</span>
                                                </div>
                                                <div class="timeline-meta">
                                                    <c:choose>
                                                        <c:when test="${not empty cancelledTime}">
                                                            <span class="timeline-date" data-date="${cancelledTime}"></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Processing</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="order-summary">
                                <div class="summary-section">
                                    <h6>Payment Summary</h6>
                                    <div class="summary-item">
                                        <span>Items Subtotal:</span>
                                        <span>$<fmt:formatNumber value="${totalOrder}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="summary-item">
                                        <span>Shipping Fee:</span>
                                        <span>$<fmt:formatNumber value="${order.shippingFee}" pattern="#,##0.00"/></span>
                                    </div>
                                    <c:if test="${not empty discount}">
                                        <div class="summary-item">
                                            <span>Discount:</span>
                                            <span>$<fmt:formatNumber value="${discount}" pattern="#,##0.00"/></span>
                                        </div>
                                    </c:if>
                                    <div class="summary-item summary-total">
                                        <span>Total Amount:</span>
                                        <span>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                    </div>
                                </div>
                                <div class="summary-section">
                                    <h6>Payment</h6>
                                    <c:choose>
                                        <c:when test="${order.paymentStatusName == 'Cancelled'}">
                                            <div class="mb-3">
                                                <span class="payment-badge payment-cancelled">
                                                    <i class="fas fa-times-circle"></i>
                                                    Cancelled
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:when test="${order.paymentStatusName == 'Failed'}">
                                            <div class="mb-3">
                                                <span class="payment-badge payment-cancelled">
                                                    <i class="fas fa-times-circle"></i>
                                                    Failed
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
                                                    <c:out value="${order.paymentStatusName}" default="Pending"/>
                                                </span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Delivery Information -->
                            <div class="delivery-info">
                                <i class="fas fa-truck"></i>
                                <c:choose>
                                    <c:when test="${not empty order.recipientName}">
                                        Delivery to: <c:out value="${order.recipientName}"/>, 
                                        <c:out value="${order.addressDetails}"/> | 
                                        <c:out value="${order.recipientPhone}"/>
                                    </c:when>
                                    <c:when test="${not empty order.addressDetails}">
                                        Delivery to: <c:out value="${order.addressDetails}"/>
                                    </c:when>
                                    <c:otherwise>
                                        Delivery to: Default Address
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Order Items -->
                            <div class="order-items">
                                <c:choose>
                                    <c:when test="${not empty order.items}">
                                        <c:forEach items="${order.items}" var="item">
                                            <div class="order-item">
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
                                                     class="item-image"
                                                     loading="lazy">
                                                <div class="item-details">
                                                    <div class="item-name"><c:out value="${item.productName}"/></div>
                                                    <div class="item-variant">
                                                        <c:if test="${not empty item.color}">Color: ${item.color}</c:if>
                                                        <c:if test="${not empty item.size}"> • Size: ${item.size}</c:if>
                                                        </div>
                                                        <div class="item-quantity">x<c:out value="${item.detailQuantity}"/></div>
                                                </div>
                                                <div class="item-price">$<c:out value="${item.detailPrice}"/></div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="order-item">
                                            <div class="item-details">
                                                <div class="item-name">No items found</div>
                                                <div class="item-quantity">Please check order details</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Footer Actions -->
                            <div class="order-actions">
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}">
                                        <button class="btn btn-danger" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#cancelModal">
                                            <i class="fas fa-times"></i>
                                            Cancel Order
                                        </button>
                                    </c:when>
                                    <c:when test="${order.status == 'COMPLETED'}">
                                        <c:choose>
                                            <c:when test="${hasRequest}">
                                                <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${requestId}" 
                                                   class="btn btn-info">
                                                    <i class="fas fa-eye"></i>
                                                    View Return Request
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/return-request?orderId=${order.orderId}" 
                                                   class="btn btn-warning">
                                                    <i class="fas fa-undo"></i>
                                                    Create Return Request
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:when test="${order.status == 'RETURNED'}">
                                        <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${requestId}" 
                                           class="btn btn-info">
                                            <i class="fas fa-eye"></i>
                                            View Return Request
                                        </a>
                                    </c:when>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/orders" 
                                   class="btn btn-primary">
                                    <i class="fas fa-arrow-left"></i>
                                    Back to Orders
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cancel Order Modal -->
        <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelModalLabel">
                            <i class="fas fa-exclamation-triangle"></i>
                            Cancel Order
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="cancel-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Are you sure you want to cancel this order? This action cannot be undone.</span>
                        </div>
                        <div class="cancel-order-info">
                            <div class="cancel-info-item">
                                <span class="cancel-info-label">Order Number:</span>
                                <span class="cancel-info-value">#<c:out value="${order.orderId}"/></span>
                            </div>
                            <div class="cancel-info-item">
                                <span class="cancel-info-label">Order Status:</span>
                                <span class="cancel-info-value"><c:out value="${order.status}"/></span>
                            </div>
                            <div class="cancel-info-item">
                                <span class="cancel-info-label">Total Amount:</span>
                                <span class="cancel-info-value">$<c:out value="${order.totalAmount}"/></span>
                            </div>
                            <div class="cancel-info-item">
                                <span class="cancel-info-label">Payment Status:</span>
                                <span class="cancel-info-value">${order.paymentStatusName}</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Keep Order
                        </button>
                        <button type="button" class="btn btn-danger" id="confirmCancelBtn">
                            Confirm Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="common/footer.jsp"/>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Order Detail Manager
            const OrderDetailManager = {
                orderId: '${order.orderId}',
                contextPath: '${pageContext.request.contextPath}',

                init() {
                    this.attachEventListeners();
                },

                attachEventListeners() {
                    // Confirm cancel button
                    const confirmBtn = document.getElementById('confirmCancelBtn');
                    if (confirmBtn) {
                        confirmBtn.addEventListener('click', () => {
                            this.confirmCancelOrder(confirmBtn);
                        });
                    }
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
                }
            };

            // Initialize when DOM is ready
            document.addEventListener('DOMContentLoaded', function () {
                // Initialize order detail manager
                OrderDetailManager.init();

                // Set active menu based on current page
                const currentPath = window.location.pathname;
                const menuLinks = document.querySelectorAll('.nav-link-item');

                menuLinks.forEach(link => {
                    const linkHref = link.getAttribute('href');
                    link.classList.remove('active');

                    if (currentPath.includes(linkHref.split('/').pop())) {
                        link.classList.add('active');
                    }
                });

                // Default to orders if no match
                const hasActive = document.querySelector('.nav-link-item.active');
                if (!hasActive) {
                    const ordersLink = document.getElementById('order');
                    if (ordersLink) {
                        ordersLink.classList.add('active');
                    }
                }

                // Format datetime like in order list
                document.querySelectorAll('.order-date[data-date]').forEach(element => {
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
                                second: '2-digit'
                            });
                        } catch (e) {
                            element.textContent = dateStr;
                        }
                    }
                });

                // Format timeline dates
                document.querySelectorAll('.timeline-date[data-date]').forEach(element => {
                    const dateStr = element.getAttribute('data-date');
                    if (dateStr) {
                        try {
                            const date = new Date(dateStr);
                            const formattedDate = date.toLocaleString('vi-VN', {
                                year: 'numeric',
                                month: '2-digit',
                                day: '2-digit',
                                hour: '2-digit',
                                minute: '2-digit'
                            });
                            element.textContent = formattedDate;
                        } catch (e) {
                            element.textContent = dateStr;
                        }
                    }
                });

                // Auto-hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });

            // Export to window
            window.OrderDetailManager = OrderDetailManager;
        </script>
    </body>
</html>