<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Detail - NeoShoes Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .order-status-badge {
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
        }
        .info-card {
            border-left: 4px solid #0A437F;
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
        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }
        .summary-card {
            background: #f8f9fa;
            color: #333;
            border: 2px solid #0A437F;
        }
    </style>
</head>
<body>
    <!-- Include Staff Header -->
    <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp" />
    
    <div class="container-fluid" style="margin-top: 80px; max-width: 1400px;">
        <div class="row">
            <!-- Main content -->
            <main class="col-12">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-1">
                            <i class="fas fa-receipt me-2"></i>Order Details
                        </h1>
                        <p class="text-muted mb-0">
                            Order #${order.orderId} • 
                            <script>
                                document.write(new Date('${order.placedAt}').toLocaleString('vi-VN', {
                                    year: 'numeric',
                                    month: '2-digit',
                                    day: '2-digit',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                }));
                            </script>
                        </p>
                    </div>
                    <a href="<c:url value='/staff/orders'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Orders
                    </a>
                </div>

                <!-- Order Summary Card -->
                <div class="card summary-card mb-4 shadow-lg">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="mb-1">Order #${order.orderId}</h2>
                                <p class="mb-0 text-muted">
                                    <i class="fas fa-calendar me-2" style="color: #0A437F;"></i>
                                    <script>
                                        document.write(new Date('${order.placedAt}').toLocaleString('vi-VN', {
                                            year: 'numeric',
                                            month: 'long',
                                            day: 'numeric',
                                            hour: '2-digit',
                                            minute: '2-digit'
                                        }));
                                    </script>
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${empty order.status}">
                                            <span class="badge bg-light text-dark order-status-badge">
                                                <i class="fas fa-question-circle me-1"></i>No Status
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'PENDING'}">
                                            <span class="badge bg-warning order-status-badge">
                                                <i class="fas fa-clock me-1"></i>${order.status}
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'CONFIRMED'}">
                                            <span class="badge bg-info order-status-badge">
                                                <i class="fas fa-check-circle me-1"></i>${order.status}
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'APPROVED'}">
                                            <span class="badge bg-info order-status-badge">
                                                <i class="fas fa-check-circle me-1"></i>${order.status}
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPED'}">
                                            <span class="badge bg-primary order-status-badge">
                                                <i class="fas fa-shipping-fast me-1"></i>Shipping
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'DELIVERED'}">
                                            <span class="badge bg-success order-status-badge">
                                                <i class="fas fa-check-double me-1"></i>${order.status}
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge bg-danger order-status-badge">
                                                <i class="fas fa-times-circle me-1"></i>${order.status}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary order-status-badge">
                                                <i class="fas fa-info-circle me-1"></i>${order.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h3 class="mb-0" style="color: #0A437F;">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/>
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column -->
                    <div class="col-lg-8">
                        <!-- Customer Information -->
                        <div class="card mb-4 shadow-sm info-card">
                    <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-user me-2"></i>Customer Information
                                </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Customer Name</label>
                                            <p class="mb-0 fs-6">${order.customerName}</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Email Address</label>
                                            <p class="mb-0">
                                                <a href="mailto:${order.customerEmail}" class="text-decoration-none">
                                                    <i class="fas fa-envelope me-1" style="color: #0A437F;"></i>${order.customerEmail}
                                                </a>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Phone Number</label>
                                            <p class="mb-0">
                                                <a href="tel:${order.customerPhone}" class="text-decoration-none">
                                                    <i class="fas fa-phone me-1" style="color: #0A437F;"></i>${order.customerPhone}
                                                </a>
                                            </p>
                                </div>
                                <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Customer ID</label>
                                            <p class="mb-0">#${order.customerId}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Delivery Address -->
                        <div class="card mb-4 shadow-sm info-card">
                            <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-map-marker-alt me-2"></i>Delivery Address
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Recipient Name</label>
                                            <p class="mb-0 fs-6">
                                                <c:choose>
                                                    <c:when test="${not empty order.recipientName}">
                                                        ${order.recipientName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Contact Phone</label>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${not empty order.recipientPhone}">
                                                        <a href="tel:${order.recipientPhone}" class="text-decoration-none">
                                                            <i class="fas fa-phone me-1" style="color: #0A437F;"></i>${order.recipientPhone}
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Address Name</label>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${not empty order.addressName}">
                                                        ${order.addressName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                </div>
                                <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">Full Address</label>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${not empty order.addressDetails}">
                                                        ${order.addressDetails}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                        </div>

                        <!-- Order Items -->
                        <div class="card mb-4 shadow-sm">
                            <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-shopping-bag me-2"></i>Order Items (${order.items.size()} items)
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 40%;">Product</th>
                                                <th style="width: 20%;">Variant</th>
                                                <th style="width: 10%;" class="text-center">Qty</th>
                                                <th style="width: 15%;" class="text-end">Unit Price</th>
                                                <th style="width: 15%;" class="text-end">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://via.placeholder.com/50x50/0A437F/ffffff?text=IMG" 
                                                                 alt="Product" class="product-image me-3" style="width: 50px; height: 50px;">
                                                            <div class="flex-grow-1">
                                                                <h6 class="mb-1 fw-bold text-dark">${item.productName}</h6>
                                                                <div class="d-flex flex-wrap gap-1">
                                                                    <c:if test="${not empty item.brandName}">
                                                                        <span class="badge bg-primary bg-opacity-10 text-primary" style="font-size: 0.7rem;">
                                                                            ${item.brandName}
                                                                        </span>
                                                                    </c:if>
                                                                    <c:if test="${not empty item.categoryName}">
                                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary" style="font-size: 0.7rem;">
                                                                            ${item.categoryName}
                                                                        </span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex flex-wrap gap-1">
                                                            <span class="badge bg-light text-dark border">${item.color}</span>
                                                            <c:if test="${not empty item.size}">
                                                                <span class="badge bg-dark text-white">${item.size}</span>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-info text-white fw-bold" style="font-size: 0.9rem;">
                                                            ${item.detailQuantity}
                                                        </span>
                                                    </td>
                                                    <td class="text-end">
                                                        <span class="fw-semibold text-dark">
                                                            <fmt:formatNumber value="${item.detailPrice}" type="currency" currencySymbol="$"/>
                                                        </span>
                                                    </td>
                                                    <td class="text-end">
                                                        <span class="fw-bold text-success fs-6">
                                                            <fmt:formatNumber value="${item.detailPrice * item.detailQuantity}" type="currency" currencySymbol="$"/>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="col-lg-4">
                        <!-- Payment Information -->
                        <div class="card mb-4 shadow-sm">
                            <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-credit-card me-2"></i>Payment Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label text-muted small fw-bold">Payment Method</label>
                                    <p class="mb-0">
                                        <i class="fas fa-money-bill-wave me-2" style="color: #0A437F;"></i>Cash on Delivery
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted small fw-bold">Payment Status</label>
                                    <p class="mb-0">
                                        <c:choose>
                                        <c:when test="${order.paymentStatusName == 'Complete'}">
                                            <span class="badge bg-success">
                                                <i class="fas fa-check-circle me-1"></i>${order.paymentStatusName}
                                            </span>
                                        </c:when>
                                        <c:when test="${order.paymentStatusName == 'Pending'}">
                                            <span class="badge bg-warning">
                                                <i class="fas fa-clock me-1"></i>${order.paymentStatusName}
                                            </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    <i class="fas fa-info-circle me-1"></i>${order.paymentStatusName}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:if test="${not empty order.voucher}">
                                <div class="mb-3">
                                        <label class="form-label text-muted small fw-bold">Voucher Applied</label>
                                    <p class="mb-0">
                                            <span class="badge bg-info">
                                                <i class="fas fa-tag me-1"></i>${order.voucher.voucherCode}
                                            </span>
                                    </p>
                                </div>
                                </c:if>
                    </div>
                </div>

                        <!-- Order Summary -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-calculator me-2"></i>Order Summary
                                </h5>
                    </div>
                    <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal:</span>
                                    <span>
                                        <fmt:formatNumber value="${order.totalAmount - order.shippingFee}" type="currency" currencySymbol="$"/>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping Fee:</span>
                                    <span>
                                        <fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="$"/>
                                    </span>
                                </div>
                                <c:if test="${not empty order.voucher}">
                                    <div class="d-flex justify-content-between mb-2 text-success">
                                        <span>Voucher Discount:</span>
                                        <span>-<fmt:formatNumber value="${order.voucher.value}" type="currency" currencySymbol="$"/></span>
                                    </div>
                                </c:if>
                                <hr>
                                <div class="d-flex justify-content-between fw-bold fs-5">
                                    <span>Total:</span>
                                    <span style="color: #0A437F;">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/>
                                    </span>
                            </div>
                    </div>
                </div>


                <!-- Status History -->
                <div class="card shadow-sm">
                    <div class="card-header bg-light">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-history me-2"></i>Status History
                                </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty statusHistory}">
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
                                                                    <c:when test="${history.orderStatus == 'CONFIRMED'}">
                                                                        <i class="fas fa-check-circle me-2 text-info"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'APPROVED'}">
                                                                        <i class="fas fa-check-circle me-2 text-info"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'SHIPPED'}">
                                                                        <i class="fas fa-shipping-fast me-2 text-primary"></i>
                                                                    </c:when>
                                                                    <c:when test="${history.orderStatus == 'DELIVERED'}">
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
                                                            <script>
                                                                document.write(new Date('${history.changedAt}').toLocaleString('vi-VN', {
                                                                    year: 'numeric',
                                                                    month: '2-digit',
                                                                    day: '2-digit',
                                                                    hour: '2-digit',
                                                                    minute: '2-digit'
                                                                }));
                                                            </script>
                                                        </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-history text-muted mb-3" style="font-size: 3rem;"></i>
                                <p class="text-muted">No status history available.</p>
                                        </div>
                            </c:otherwise>
                        </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>