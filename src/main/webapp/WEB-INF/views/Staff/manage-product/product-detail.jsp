<%-- 
    Document   : product-detail
    Created on : Oct 20, 2025, 7:59:04 AM
    Author     : Nguyen Huynh Thien An - CE190979
--%>

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
                font-size: 24px;
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
        </style>
    </head>
    <body>
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
                        <h2 class="card-title">Product information</h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">Product Id:</div>
                            <div class="info-value"><strong>#${product.productId}</strong></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Category: </div>
                            <div class="info-value">
                                <span class="tag blue">${product.categoryName}</span>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Material: </div>
                            <div class="info-value">${product.material}</div>
                        </div>

                        <!--                        
                        
                        -->                                                <div class="info-row">
                            <div class="info-label">Status: </div>
                            <div class="info-value">
                                <span class="tag green">Active</span>
                            </div>
                        </div>


                        <div class="info-row">
                            <div class="info-label">Create Date: </div>
                            <div class="info-value">
                                ${product.formattedCreatedAt}
                            </div>
                        </div>


                        <div class="info-row">
                            <div class="info-label">Last Update: </div>
                            <div class="info-value">
                                ${product.formattedUpdatedAt}
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

                <!-- Statistics -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">Statistics</h2>
                    </div>
                    <div class="card-body">
                        <div class="stats-row">
                            <div class="stat-box">
                                <div class="stat-label">Total Quantity</div>
                                <div class="stat-value">${totalQuantity}</div>
                            </div>
                            <div class="stat-box">
                                <div class="stat-label">Number of variants</div>
                                <div class="stat-value">${fn:length(productVariants)}</div>
                            </div>
                            <div class="stat-box">
                                <div class="stat-label">Min price</div>
                                <div class="stat-value">
                                    <fmt:formatNumber value="${minPrice}" type="currency" currencySymbol="$"/>
                                </div>
                            </div>
                            <div class="stat-box">
                                <div class="stat-label">Max price</div>
                                <div class="stat-value">
                                    <fmt:formatNumber value="${maxPrice}" type="currency" currencySymbol="$"/>
                                </div>
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
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="variant" items="${productVariants}">
                                            <tr>
                                                <!-- Image -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty product.defaultImageUrl}">
                                                            <img src="${product.defaultImageUrl}" alt="${product.name}" 
                                                                 style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;"
                                                                 onerror="this.src='https://placehold.co/56x56/94a3b8/white?text=No+Img'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://placehold.co/56x56/94a3b8/white?text=${fn:substring(product.name, 0, 2)}" 
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

                                                <!-- Brand - Lấy từ product -->
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

                                                <!-- Giá bán -->
                                                <td>
                                                    <strong style="color: #059669;">
                                                        <fmt:formatNumber value="${variant.price}" pattern="#,###" groupingUsed="true"/>$
                                                    </strong>
                                                </td>

                                                <!-- Số lượng -->
                                                <td>
                                                    <strong style="font-size: 15px;">
                                                        ${variant.quantityAvailable}
                                                    </strong>
                                                </td>

                                                <!-- Trạng thái -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${variant.quantityAvailable > 10}">
                                                            <span class="status-badge in-stock">Available</span>
                                                        </c:when>
                                                        <c:when test="${variant.quantityAvailable > 0}">
                                                            <span class="status-badge low-stock">Nearly out of stock </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge out-of-stock">Out of stock</span>
                                                        </c:otherwise>
                                                    </c:choose>
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
                                    <button class="btn btn-primary" onclick="addVariant()" style="margin-top: 16px;">
                                        ➕ Add Variant
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>