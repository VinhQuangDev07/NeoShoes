<%-- 
    Document   : manage-product
    Created on : Oct 18, 2025, 10:27:47 PM
    Author     : Nguyen Huynh Thien An - CE190979
    FIXED VERSION - Validation & Logic
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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
                padding: 0;
                margin: 0;
            }

            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
            }

            @media (max-width: 768px) {
                .main-wrapper {
                    margin-left: 0;
                }
                #sidebar {
                    transform: translateX(-100%);
                }
                #sidebar.show {
                    transform: translateX(0);
                }
            }

            .page-header {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .stat-content h3 {
                color: #64748b;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 8px;
            }

            .stat-content .number {
                color: #1e293b;
                font-size: 32px;
                font-weight: 700;
            }

            .stat-icon {
                width: 56px;
                height: 56px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }

            .stat-icon.blue { background-color: #dbeafe; color: #3b82f6; }
            .stat-icon.green { background-color: #d1fae5; color: #10b981; }
            .stat-icon.yellow { background-color: #fef3c7; color: #f59e0b; }
            .stat-icon.purple { background-color: #e9d5ff; color: #a855f7; }

            .product-section {
                background: white;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .section-header {
                padding: 24px;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .section-header h2 {
                font-size: 20px;
                font-weight: 600;
                color: #1e293b;
            }

            .btn-create {
                padding: 10px 20px;
                background-color: #3b82f6;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s;
            }

            .btn-create:hover {
                background-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .product-table {
                width: 100%;
                border-collapse: collapse;
            }

            .product-table thead {
                background-color: #f8fafc;
                border-bottom: 1px solid #e2e8f0;
            }

            .product-table th {
                padding: 16px 24px;
                text-align: left;
                font-size: 12px;
                font-weight: 600;
                color: #64748b;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .product-table td {
                padding: 16px 24px;
                border-bottom: 1px solid #f1f5f9;
                color: #1e293b;
                font-size: 14px;
            }

            .product-table tbody tr:hover {
                background-color: #f8fafc;
            }

            .product-cell {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .product-image {
                width: 56px;
                height: 56px;
                border-radius: 8px;
                object-fit: cover;
                border: 1px solid #e2e8f0;
            }

            .product-info {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .product-name {
                font-weight: 600;
                color: #1e293b;
                font-size: 14px;
            }

            .product-tags {
                display: flex;
                gap: 6px;
                flex-wrap: wrap;
            }

            .tag {
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 11px;
                font-weight: 500;
            }

            .tag.blue { background-color: #dbeafe; color: #1e40af; }
            .variant-count { color: #3b82f6; font-size: 12px; font-weight: 500; }

            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-badge.out-of-stock {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .action-btn {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                border: none;
                background-color: #dbeafe;
                color: #3b82f6;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
            }

            .action-btn:hover {
                background-color: #bfdbfe;
                transform: scale(1.05);
            }

            .action-btn.edit { background-color: #fef3c7; color: #f59e0b; }
            .action-btn.edit:hover { background-color: #fde68a; }
            .action-btn.delete { background-color: #fee2e2; color: #ef4444; }
            .action-btn.delete:hover { background-color: #fecaca; }

            .info-text {
                color: #64748b;
                font-size: 13px;
                line-height: 1.6;
            }

            .info-text strong {
                color: #1e293b;
            }

            .price-range {
                font-size: 13px;
                color: #1e293b;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #64748b;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 16px;
                opacity: 0.5;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>

        <div class="main-wrapper">
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Manage Product</h2>
                    </div>
                </div>
            </div>

            <!-- ✅ FIX: Success/Error Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <c:out value="${sessionScope.successMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <c:out value="${sessionScope.errorMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="container">
                <!-- ✅ FIX 1: Calculate out of stock count -->
                <c:set var="outOfStockCount" value="0"/>
                <c:if test="${not empty listProduct}">
                    <c:forEach var="product" items="${listProduct}">
                        <c:set var="variants" value="${productVariantsMap[product.productId]}"/>
                        <c:set var="hasStock" value="false"/>
                        <c:if test="${not empty variants}">
                            <c:forEach var="v" items="${variants}">
                                <c:if test="${v.quantityAvailable > 0}">
                                    <c:set var="hasStock" value="true"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:if test="${!hasStock}">
                            <c:set var="outOfStockCount" value="${outOfStockCount + 1}"/>
                        </c:if>
                    </c:forEach>
                </c:if>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Total products</h3>
                            <div class="number">
                                <c:out value="${totalRecords}" default="0"/>
                            </div>
                        </div>
                        <div class="stat-icon blue">
                            <i class="fas fa-box"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Total Inventory</h3>
                            <div class="number">
                                <c:out value="${totalQuantity}" default="0"/>
                            </div>
                        </div>
                        <div class="stat-icon green">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Inventory Value</h3>
                            <div class="number">
                                <!-- ✅ FIX 2: Handle null totalPrice -->
                                <c:choose>
                                    <c:when test="${not empty totalPrice}">
                                        <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                                    </c:when>
                                    <c:otherwise>
                                        $0.00
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="stat-icon yellow">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Out of stocks</h3>
                            <div class="number">${outOfStockCount}</div>
                        </div>
                        <div class="stat-icon purple">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                </div>

                <!-- Product List -->
                <div class="product-section">
                    <div class="section-header">
                        <h2>Product List</h2>
                        <button class="btn-create" onclick="createProduct()">
                            <span>➕</span>
                            Create Product
                        </button>
                    </div>

                    <!-- ✅ FIX 3: Check if listProduct is empty -->
                    <c:choose>
                        <c:when test="${empty listProduct}">
                            <div class="empty-state">
                                <i class="fas fa-box-open"></i>
                                <h5>No Products Found</h5>
                                <p>Get started by creating your first product</p>
                                <button class="btn-create mt-3" onclick="createProduct()">
                                    <span>➕</span>
                                    Create Product
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>PRODUCT</th>
                                        <th>INFORMATION</th>
                                        <th>PRICE RANGE</th>
                                        <th>TOTAL INVENTORY</th>
                                        <th>STATUS</th>
                                        <th>ACTIONS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${listProduct}" varStatus="status">
                                        <!-- ✅ FIX 4: Safe null check for variants -->
                                        <c:set var="variants" value="${productVariantsMap[product.productId]}"/>
                                        <c:set var="hasVariants" value="${not empty variants}"/>

                                        <tr>
                                            <td>${product.productId}</td>
                                            <td>
                                                <div class="product-cell">
                                                    <!-- ✅ FIX 5: Handle null image -->
                                                    <c:choose>
                                                        <c:when test="${not empty product.defaultImageUrl}">
                                                            <img src="<c:out value='${product.defaultImageUrl}'/>" 
                                                                 alt="<c:out value='${product.name}'/>" 
                                                                 class="product-image"
                                                                 onerror="this.src='${pageContext.request.contextPath}/images/placeholder.png'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/images/placeholder.png" 
                                                                 alt="No image" class="product-image">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="product-info">
                                                        <!-- ✅ FIX 6: Escape XSS -->
                                                        <div class="product-name">
                                                            <c:out value="${product.name}" default="Unnamed Product"/>
                                                        </div>
                                                        <div class="product-tags">
                                                            <span class="tag blue">
                                                                <c:out value="${product.material}" default="N/A"/>
                                                            </span>
                                                            <c:if test="${hasVariants and fn:length(variants) > 1}">
                                                                <span class="variant-count">${fn:length(variants)} variants</span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="info-text">
                                                    <strong>Variants:</strong> ${hasVariants ? fn:length(variants) : 0}<br>
                                                    <strong>Material:</strong> <c:out value="${product.material}" default="N/A"/>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${hasVariants}">
                                                        <!-- ✅ FIX 7: Safe price calculation with BigDecimal -->
                                                        <c:set var="minPrice" value="${variants[0].price}"/>
                                                        <c:set var="maxPrice" value="${variants[0].price}"/>
                                                        <c:forEach var="v" items="${variants}">
                                                            <c:if test="${v.price != null}">
                                                                <!-- Compare using compareTo for BigDecimal -->
                                                                <c:if test="${v.price.compareTo(minPrice) < 0}">
                                                                    <c:set var="minPrice" value="${v.price}"/>
                                                                </c:if>
                                                                <c:if test="${v.price.compareTo(maxPrice) > 0}">
                                                                    <c:set var="maxPrice" value="${v.price}"/>
                                                                </c:if>
                                                            </c:if>
                                                        </c:forEach>

                                                        <div class="price-range">
                                                            <c:choose>
                                                                <c:when test="${minPrice.compareTo(maxPrice) == 0}">
                                                                    <fmt:formatNumber value="${minPrice}" type="currency" currencySymbol="$"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <fmt:formatNumber value="${minPrice}" type="currency" currencySymbol="$"/> - 
                                                                    <fmt:formatNumber value="${maxPrice}" type="currency" currencySymbol="$"/>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <!-- ✅ FIX 8: Optimize - calculate once -->
                                                <c:choose>
                                                    <c:when test="${hasVariants}">
                                                        <c:set var="totalQty" value="0"/>
                                                        <c:forEach var="v" items="${variants}">
                                                            <c:set var="totalQty" value="${totalQty + v.quantityAvailable}"/>
                                                        </c:forEach>
                                                        <strong>${totalQty}</strong>
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <!-- ✅ FIX 9: Optimize - calculate once -->
                                                <c:choose>
                                                    <c:when test="${hasVariants}">
                                                        <c:set var="hasStock" value="false"/>
                                                        <c:forEach var="v" items="${variants}">
                                                            <c:if test="${v.quantityAvailable > 0}">
                                                                <c:set var="hasStock" value="true"/>
                                                            </c:if>
                                                        </c:forEach>

                                                        <c:choose>
                                                            <c:when test="${hasStock}">
                                                                <span class="status-badge">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge out-of-stock">Out of Stock</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge out-of-stock">Out of Stock</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <!-- ✅ FIX 10: Validate productId before use -->
                                                    <c:if test="${product.productId > 0}">
                                                        <button class="action-btn" 
                                                                onclick="viewProduct(${product.productId})" 
                                                                title="View Details">
                                                            👁️
                                                        </button>
                                                        <button class="action-btn edit" 
                                                                onclick="editProduct(${product.productId})" 
                                                                title="Edit Product">
                                                            ✏️
                                                        </button>
                                                        <button class="action-btn delete" 
                                                                onclick="deleteProduct(${product.productId}, '<c:out value="${fn:escapeXml(product.name)}"/>', ${hasVariants ? fn:length(variants) : 0})" 
                                                                title="Delete Product">
                                                            🗑️
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <jsp:include page="/WEB-INF/views/common/pagination.jsp"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script>
            function createProduct() {
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=create';
            }

            // ✅ FIX 11: Validate productId
            function viewProduct(productId) {
                if (!productId || productId <= 0) {
                    alert('Invalid product ID');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=detail&productId=' + encodeURIComponent(productId);
            }

            function editProduct(productId) {
                if (!productId || productId <= 0) {
                    alert('Invalid product ID');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=edit&productId=' + encodeURIComponent(productId);
            }

            // ✅ FIX 12: Enhanced delete with variant warning
            function deleteProduct(productId, productName, variantCount) {
                if (!productId || productId <= 0) {
                    alert('Invalid product ID');
                    return;
                }

                let message = 'Are you sure you want to delete "' + productName + '"?';
                
                if (variantCount > 0) {
                    message += '\n\nThis product has ' + variantCount + ' variant(s) that will also be deleted.';
                }
                
                message += '\n\nThis action cannot be undone!';

                if (!confirm(message)) {
                    return;
                }

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/staff/product';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);

                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = productId;
                form.appendChild(productIdInput);

                document.body.appendChild(form);
                form.submit();
            }
        </script>
    </body>
</html>