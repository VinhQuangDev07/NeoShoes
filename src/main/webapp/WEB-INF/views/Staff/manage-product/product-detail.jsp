
<%-- 
    Document   : product-detail
    Created on : Oct 20, 2025
    Author     : Nguyen Huynh Thien An - CE190979
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                background-color: #f5f7fa;
                padding: 20px;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
            }

            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            /* Header */
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
            }

            .back-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 16px;
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                color: #475569;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s;
            }

            .back-btn:hover {
                background-color: #f8fafc;
                border-color: #cbd5e1;
            }

            .page-title {
                font-size: 28px;
                font-weight: 700;
                color: #1e293b;
            }

            .action-buttons {
                display: flex;
                gap: 12px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background-color: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background-color: #2563eb;
            }

            .btn-secondary {
                background-color: white;
                color: #475569;
                border: 1px solid #e2e8f0;
            }

            .btn-secondary:hover {
                background-color: #f8fafc;
            }

            .btn-danger {
                background-color: #ef4444;
                color: white;
            }

            .btn-danger:hover {
                background-color: #dc2626;
            }

            /* Main Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
                margin-bottom: 24px;
            }

            /* Card */
            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .card-header {
                padding: 20px 24px;
                border-bottom: 1px solid #e2e8f0;
            }

            .card-title {
                font-size: 18px;
                font-weight: 600;
                color: #1e293b;
            }

            .card-body {
                padding: 24px;
            }

            /* Image Gallery */
            .image-gallery {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            .main-image {
                width: 100%;
                height: 400px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .thumbnail-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
                gap: 12px;
            }

            .thumbnail {
                width: 100%;
                height: 100px;
                object-fit: cover;
                border-radius: 6px;
                border: 2px solid #e2e8f0;
                cursor: pointer;
                transition: all 0.2s;
            }

            .thumbnail:hover,
            .thumbnail.active {
                border-color: #3b82f6;
            }

            /* Product Info */
            .info-row {
                display: flex;
                padding: 16px 0;
                border-bottom: 1px solid #f1f5f9;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                width: 140px;
                color: #64748b;
                font-size: 14px;
                font-weight: 500;
            }

            .info-value {
                flex: 1;
                color: #1e293b;
                font-size: 14px;
            }

            .info-value strong {
                font-weight: 600;
            }

            /* Tags */
            .tag {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                margin-right: 8px;
            }

            .tag.blue {
                background-color: #dbeafe;
                color: #1e40af;
            }

            .tag.green {
                background-color: #d1fae5;
                color: #065f46;
            }

            .tag.purple {
                background-color: #e9d5ff;
                color: #7c3aed;
            }

            /* Stats Cards */
            .stats-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 16px;
            }

            .stat-box {
                background-color: #f8fafc;
                padding: 16px;
                border-radius: 8px;
                text-align: center;
            }

            .stat-label {
                color: #64748b;
                font-size: 12px;
                font-weight: 500;
                margin-bottom: 8px;
                text-transform: uppercase;
            }

            .stat-value {
                color: #1e293b;
                font-size: 20px;
                font-weight: 700;
            }

            /* Variants Table */
            .variants-section {
                grid-column: 1 / -1;
            }

            .variant-table {
                width: 100%;
                border-collapse: collapse;
            }

            .variant-table thead {
                background-color: #f8fafc;
            }

            .variant-table th {
                padding: 12px 16px;
                text-align: left;
                font-size: 12px;
                font-weight: 600;
                color: #64748b;
                text-transform: uppercase;
                border-bottom: 1px solid #e2e8f0;
            }

            .variant-table td {
                padding: 16px;
                border-bottom: 1px solid #f1f5f9;
                color: #1e293b;
                font-size: 14px;
            }

            .variant-table tbody tr:hover {
                background-color: #f8fafc;
            }

            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
            }

            .status-badge.in-stock {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-badge.out-of-stock {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status-badge.low-stock {
                background-color: #fef3c7;
                color: #92400e;
            }

            .variant-actions {
                display: flex;
                gap: 8px;
            }

            .icon-btn {
                width: 32px;
                height: 32px;
                border-radius: 6px;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.2s;
            }

            .icon-btn.edit {
                background-color: #dbeafe;
                color: #3b82f6;
            }

            .icon-btn.edit:hover {
                background-color: #bfdbfe;
            }

            .icon-btn.delete {
                background-color: #fee2e2;
                color: #ef4444;
            }

            .icon-btn.delete:hover {
                background-color: #fecaca;
            }

            /* Description */
            .description {
                color: #475569;
                font-size: 14px;
                line-height: 1.8;
                white-space: pre-wrap;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 48px 24px;
                color: #94a3b8;
            }

            .empty-state-icon {
                font-size: 48px;
                margin-bottom: 16px;
            }

            .empty-state-text {
                font-size: 16px;
                font-weight: 500;
            }

            /* Alert Styles */
            .alert {
                border-radius: 8px;
                border: none;
                font-weight: 500;
            }

            .alert-success {
                background-color: #d1fae5;
                color: #065f46;
                border-left: 4px solid #10b981;
            }

            .alert-danger {
                background-color: #fee2e2;
                color: #dc2626;
                border-left: 4px solid #ef4444;
            }

            /* Review Styles */
            .review-item {
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                background-color: #ffffff;
            }

            .review-item:hover {
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .customer-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #f1f5f9;
            }

            .rating {
                display: flex;
                align-items: center;
            }

            .rating .fas.fa-star {
                font-size: 14px;
            }

            .staff-reply {
                border-left: 3px solid #3b82f6;
                background-color: #f8fafc;
            }

            .reply-form {
                background-color: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 16px;
            }

            .review-actions .btn {
                font-size: 12px;
                padding: 4px 8px;
            }

            /* Reviews Section */
            .reviews-summary {
                margin-bottom: 20px;
            }

            .review-stats {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #f8fafc;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .review-count {
                text-align: center;
            }

            .count-number {
                font-size: 32px;
                font-weight: 700;
                color: #3b82f6;
                line-height: 1;
            }

            .count-label {
                font-size: 14px;
                color: #64748b;
                font-weight: 500;
                margin-top: 4px;
            }

            .review-actions {
                display: flex;
                gap: 12px;
            }

            .review-actions .btn {
                font-size: 16px;
                padding: 12px 24px;
                font-weight: 600;
                border-radius: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            /* Modal Overlay */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 9998;
                animation: fadeIn 0.2s ease-in-out;
            }

            .modal-overlay.active {
                display: block;
            }

            /* Modal Container */
            .modal-container {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                border-radius: 12px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                z-index: 9999;
                max-width: 600px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                animation: slideUp 0.3s ease-out;
            }

            .modal-container.active {
                display: block;
            }

            /* Modal Header */
            .modal-header {
                padding: 24px;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .modal-title {
                font-size: 20px;
                font-weight: 600;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .modal-close {
                width: 32px;
                height: 32px;
                border: none;
                background: #f1f5f9;
                border-radius: 6px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
                color: #64748b;
                font-size: 18px;
            }

            .modal-close:hover {
                background: #e2e8f0;
                color: #1e293b;
            }

            /* Modal Body */
            .modal-body {
                padding: 24px;
            }

            .modal-form-group {
                margin-bottom: 20px;
            }

            .modal-form-group label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                color: #475569;
                margin-bottom: 8px;
            }

            .modal-form-group .required {
                color: #ef4444;
                margin-left: 4px;
            }

            .modal-form-control {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                color: #1e293b;
                transition: all 0.2s;
            }

            .modal-form-control:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .modal-form-row {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 16px;
            }

            .modal-helper-text {
                font-size: 12px;
                color: #64748b;
                margin-top: 6px;
            }

            /* Image Preview in Modal */
            .modal-image-preview {
                margin-top: 12px;
                border: 2px dashed #e2e8f0;
                border-radius: 8px;
                padding: 12px;
                text-align: center;
                background: #f8fafc;
            }

            .modal-image-preview img {
                max-width: 200px;
                max-height: 200px;
                border-radius: 8px;
                object-fit: cover;
            }

            .modal-image-preview.empty {
                color: #94a3b8;
                padding: 40px 12px;
                font-size: 13px;
            }

            /* Modal Footer */
            .modal-footer {
                padding: 20px 24px;
                border-top: 1px solid #e2e8f0;
                display: flex;
                gap: 12px;
                justify-content: flex-end;
            }

            /* Animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translate(-50%, -45%);
                }
                to {
                    opacity: 1;
                    transform: translate(-50%, -50%);
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>

        <!-- Notification -->
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        <div class="main-wrapper">
            <div class="container">
                <!-- Header -->
                <div class="page-header">
                    <div style="display: flex; align-items: center; gap: 20px;">
                        <a href="${pageContext.request.contextPath}/staff/product" class="back-btn">
                            ← Back
                        </a>
                        <h1 class="page-title">${product.name}</h1>
                    </div>

                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${param.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Main Content -->
                <div class="content-grid">
                    <!-- Left Column: Image Gallery -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Product Image</h2>
                        </div>
                        <div class="card-body">
                            <div class="image-gallery">
                                <img src="${product.defaultImageUrl}" alt="${product.name}" class="main-image" id="mainImage">

                                <c:if test="${not empty productImages}">
                                    <div class="thumbnail-list">
                                        <c:forEach var="image" items="${productImages}" varStatus="status">
                                            <img src="${image.imageUrl}" 
                                                 alt="Ảnh ${status.index + 1}" 
                                                 class="thumbnail ${status.index == 0 ? 'active' : ''}"
                                                 onclick="changeMainImage('${image.imageUrl}', this)">
                                        </c:forEach>
                                    </div>
                                </c:if>


                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Product Info -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Product Information</h2>
                        </div>
                        <div class="card-body">
                            <div class="info-row">
                                <div class="info-label">Product ID:</div>
                                <div class="info-value"><strong>#${product.productId}</strong></div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Product Name:</div>
                                <div class="info-value"><strong>${product.name}</strong></div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Brand:</div>
                                <div class="info-value">
                                    <span class="tag blue">${product.brandName}</span>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Category:</div>
                                <div class="info-value">
                                    <span class="tag green">${product.categoryName}</span>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Material:</div>
                                <div class="info-value">${product.material}</div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Status:</div>
                                <div class="info-value">
                                    <span class="tag green">Active</span>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Created Date:</div>
                                <div class="info-value">
                                    <i class="fas fa-calendar-alt me-1"></i>${product.formattedCreatedAt}
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-label">Last Updated:</div>
                                <div class="info-value">
                                    <i class="fas fa-clock me-1"></i>${product.formattedUpdatedAt}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Product Description</h2>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty product.description}">
                                    <div class="description">${product.description}</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📝</div>
                                        <div class="empty-state-text">No description available</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-star me-2"></i>Product Reviews
                            </h2>
                        </div>
                        <div class="card-body">
                            <div class="reviews-summary">
                                <div class="review-stats">
                                    <div class="review-count">
                                        <div class="count-number">${reviews.size()}</div>
                                        <div class="count-label">Total Reviews</div>
                                    </div>
                                    <div class="review-actions">
                                        <a href="<c:url value='/reviews?productId=${product.productId}&showReplyButton=true'/>" 
                                           class="btn btn-primary btn-lg" target="_blank">
                                            <i class="fas fa-eye me-2"></i>View All Reviews
                                        </a>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="card" style="grid-column: 1 / -1;">
                        <div class="card-header">
                            <h2 class="card-title">
                                <i class="fas fa-chart-bar me-2"></i>Product Statistics
                            </h2>
                        </div>
                        <div class="card-body">
                            <div class="stats-row">
                                <div class="stat-box">
                                    <div class="stat-label">Total Quantity</div>
                                    <div class="stat-value">${totalQuantity}</div>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-label">Variants</div>
                                    <div class="stat-value">${fn:length(productVariants)}</div>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-label">Price Range</div>
                                    <div class="stat-value">
                                        <fmt:formatNumber value="${minPrice}" type="currency" currencySymbol="$"/> - 
                                        <fmt:formatNumber value="${maxPrice}" type="currency" currencySymbol="$"/>
                                    </div>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-label">Reviews</div>
                                    <div class="stat-value">${reviews.size()} reviews</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Variants Table -->
                    <div class="card variants-section">
                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <h2 class="card-title">Variant List</h2>
                            <button class="btn btn-primary" onclick="addVariant()">
                                ➕ Add Variant
                            </button>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <c:choose>
                                <c:when test="${not empty productVariants}">
                                    <table class="variant-table">
                                        <thead>
                                            <tr>
                                                <th>Image</th>
                                                <th>Size/Color</th>
                                                <th>Brand</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="variant" items="${productVariants}">
                                                <tr>
                                                    <!-- Image - SỬA: Dùng variant.image thay vì product.defaultImageUrl -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty variant.image}">
                                                                <img src="${variant.image}" alt="${product.name}" 
                                                                     style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;"
                                                                     onerror="this.src='https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png" 
                                                                     alt="No image" 
                                                                     style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- Size/Color -->
                                                    <td>
                                                        <c:if test="${not empty variant.size}">
                                                            <span class="tag purple">Size: ${variant.size}</span>
                                                        </c:if>
                                                        <c:if test="${not empty variant.color}">
                                                            <span class="tag blue">Color: ${variant.color}</span>
                                                        </c:if>
                                                        <c:if test="${empty variant.size && empty variant.color}">
                                                            <span class="tag">Default</span>
                                                        </c:if>
                                                    </td>

                                                    <!-- Brand -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty product.brandName}">
                                                                <span class="tag purple">${product.brandName}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #94a3b8;">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- Price -->
                                                    <td>
                                                        <strong style="color: #059669;">
                                                            <fmt:formatNumber value="${variant.price}" pattern="#,###" groupingUsed="true"/>$
                                                        </strong>
                                                    </td>

                                                    <!-- Quantity -->
                                                    <td>
                                                        <strong style="font-size: 15px;">
                                                            ${variant.quantityAvailable}
                                                        </strong>
                                                    </td>

                                                    <!-- Status -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${variant.quantityAvailable > 10}">
                                                                <span class="status-badge in-stock">Available</span>
                                                            </c:when>
                                                            <c:when test="${variant.quantityAvailable > 0}">
                                                                <span class="status-badge low-stock">Nearly out of stock</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge out-of-stock">Out of stock</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- Actions - SỬA: Dùng data attribute thay vì truyền string trực tiếp -->
                                                    <td>
                                                        <div class="variant-actions">
                                                            <button class="icon-btn edit" 
                                                                    onclick="editVariant(${variant.productVariantId})" 
                                                                    title="Edit Variant">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button class="icon-btn delete" 
                                                                    data-variant-id="${variant.productVariantId}"
                                                                    data-variant-size="${variant.size}"
                                                                    data-variant-color="${variant.color}"
                                                                    onclick="deleteVariant(this)" 
                                                                    title="Delete Variant">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📦</div>
                                        <div class="empty-state-text">Empty Variant</div>

                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Edit Variant Modal -->
        <div class="modal-overlay" id="editModalOverlay" onclick="closeEditModal()"></div>
        <div class="modal-container" id="editModal">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-edit"></i>
                    Edit Variant
                </h3>
                <button class="modal-close" onclick="closeEditModal()" type="button">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form id="editVariantForm" method="POST" action="${pageContext.request.contextPath}/staff/variant">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="variantId" id="edit_variantId">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="modal-body">
                    <div class="modal-form-row">
                        <div class="modal-form-group">
                            <label for="edit_color">
                                Color
                                <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="edit_color" 
                                   name="color" 
                                   class="modal-form-control" 
                                   placeholder="e.g., Red, Blue"
                                   required>
                        </div>

                        <div class="modal-form-group">
                            <label for="edit_size">
                                Size
                                <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="edit_size" 
                                   name="size" 
                                   class="modal-form-control" 
                                   placeholder="e.g., S, M, L"
                                   required>
                        </div>
                    </div>

                    <div class="modal-form-row">
                        <div class="modal-form-group">
                            <label for="edit_price">
                                Price ($)
                                <span class="required">*</span>
                            </label>
                            <input type="number" 
                                   id="edit_price" 
                                   name="price" 
                                   class="modal-form-control" 
                                   placeholder="0.00"
                                   step="0.01"
                                   min="0"
                                   required>
                        </div>
                    </div>

                    <div class="modal-form-group">
                        <label for="edit_image">
                            Image URL
                            <span class="required">*</span>
                        </label>
                        <input type="url" 
                               id="edit_image" 
                               name="image" 
                               class="modal-form-control" 
                               placeholder="https://example.com/image.jpg"
                               required
                               onchange="previewEditImage()">
                        <div class="modal-helper-text">Enter a valid image URL</div>

                        <div class="modal-image-preview" id="editImagePreview">
                            <div class="empty">📷 Image preview will appear here</div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>
                        Save Changes
                    </button>
                </div>
            </form>
        </div>


        <script>
            function addVariant() {
                const productId = ${product.productId};
                window.location.href = '${pageContext.request.contextPath}/staff/variant?view=create&productId=' + productId;
            }

            // Open Edit Modal with data
            function editVariant(variantId) {
                // Get data from table row
                const row = event.target.closest('tr');
                const colorTag = row.querySelector('.tag.blue');
                const sizeTag = row.querySelector('.tag.purple');
                const price = row.querySelector('td:nth-child(4) strong').textContent.replace(/[^0-9.]/g, '');

                const image = row.querySelector('img').src;
                // Extract color and size from tags
                const color = colorTag ? colorTag.textContent.replace('Color: ', '').trim() : '';
                const size = sizeTag ? sizeTag.textContent.replace('Size: ', '').trim() : '';
                // Fill form
                document.getElementById('edit_variantId').value = variantId;
                document.getElementById('edit_color').value = color;
                document.getElementById('edit_size').value = size;
                document.getElementById('edit_price').value = price;

                document.getElementById('edit_image').value = image;
                // Show preview
                const preview = document.getElementById('editImagePreview');
                preview.innerHTML = '<img src="' + image + '" alt="Variant Image" onerror="imageEditLoadError()">';
                // Show modal
                document.getElementById('editModalOverlay').classList.add('active');
                document.getElementById('editModal').classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            // Close Edit Modal
            function closeEditModal() {
                document.getElementById('editModalOverlay').classList.remove('active');
                document.getElementById('editModal').classList.remove('active');
                document.body.style.overflow = 'auto';
                // Reset form
                document.getElementById('editVariantForm').reset();
                document.getElementById('editImagePreview').innerHTML = '<div class="empty">📷 Image preview will appear here</div>';
            }

            // Preview edit image
            function previewEditImage() {
                const url = document.getElementById('edit_image').value;
                const preview = document.getElementById('editImagePreview');
                if (url) {
                    preview.innerHTML = '<img src="' + url + '" alt="Variant Image" onerror="imageEditLoadError()">';
                } else {
                    preview.innerHTML = '<div class="empty">📷 Image preview will appear here</div>';
                }
            }

            // Handle image load error
            function imageEditLoadError() {
                const preview = document.getElementById('editImagePreview');
                preview.innerHTML = '<div class="empty" style="color: #ef4444;">❌ Failed to load image<br>Please check the URL</div>';
            }

            // Delete variant
            function deleteVariant(button) {
                const variantId = button.getAttribute('data-variant-id');
                const size = button.getAttribute('data-variant-size') || 'N/A';
                const color = button.getAttribute('data-variant-color') || 'N/A';
                const variantInfo = size + ' - ' + color;
                if (!confirm('Are you sure you want to delete variant "' + variantInfo + '"?\n\nThis action cannot be undone!')) {
                    return;
                }

                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/staff/variant';
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                const variantIdInput = document.createElement('input');
                variantIdInput.type = 'hidden';
                variantIdInput.name = 'variantId';
                variantIdInput.value = variantId;
                form.appendChild(variantIdInput);
                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = ${product.productId};
                form.appendChild(productIdInput);
                document.body.appendChild(form);
                form.submit();
            }

            // Change main image
            function changeMainImage(imageUrl, thumbnail) {
                document.getElementById('mainImage').src = imageUrl;
                // Remove active class from all thumbnails
                document.querySelectorAll('.thumbnail').forEach(thumb => {
                    thumb.classList.remove('active');
                });
                // Add active class to clicked thumbnail
                thumbnail.classList.add('active');
            }

            // Close modal when pressing ESC
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeEditModal();
                }
            });
            // Form validation
            document.getElementById('editVariantForm').addEventListener('submit', function (e) {
                const price = parseFloat(document.getElementById('edit_price').value);
                const quantity = parseInt(document.getElementById('edit_quantity').value);
                if (price < 0) {
                    e.preventDefault();
                    alert('Price must be 0 or greater!');
                    return false;
                }

                if (quantity < 0) {
                    e.preventDefault();
                    alert('Quantity must be 0 or greater!');
                    return false;
                }
            });
            // Auto-hide success/error messages after 5 seconds
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    if (alert.classList.contains('alert-success') || alert.classList.contains('alert-danger')) {
                        alert.style.transition = 'opacity 0.5s';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500);
                    }
                });
            }, 5000);</script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>