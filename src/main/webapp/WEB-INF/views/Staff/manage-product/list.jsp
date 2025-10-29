<%-- 
    Document   : manage-product
    Created on : Oct 18, 2025, 10:27:47 PM
    Author     : Nguyen Huynh Thien An - CE190979
    Phương án A: Hiển thị biến thể đầu tiên hoặc dữ liệu tổng hợp
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
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Lucide Icons -->
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

            /* Wrapper cho content chính */
            .main-wrapper {
                margin-left: 300px; /* Chiều rộng của sidebar */
                margin-top: 74px;   /* Chiều cao của header */
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
            }

            /* Responsive: ẩn sidebar trên mobile */
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
            
            /* Stats Cards */
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

            .stat-icon.blue {
                background-color: #dbeafe;
                color: #3b82f6;
            }
            .stat-icon.green {
                background-color: #d1fae5;
                color: #10b981;
            }
            .stat-icon.yellow {
                background-color: #fef3c7;
                color: #f59e0b;
            }
            .stat-icon.purple {
                background-color: #e9d5ff;
                color: #a855f7;
            }

            /* Product List Section */
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

            .category-select {
                padding: 8px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                color: #475569;
                background: white;
                cursor: pointer;
                min-width: 200px;
            }

            /* Create Button */
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

            .btn-create:active {
                transform: translateY(0);
            }

            /* Table */
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

            /* Product Cell */
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

            .tag.blue {
                background-color: #dbeafe;
                color: #1e40af;
            }

            .tag.purple {
                background-color: #e9d5ff;
                color: #7c3aed;
            }

            .tag.pink {
                background-color: #fce7f3;
                color: #be185d;
            }

            /* Status Badge */
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

            /* Action Buttons */
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

            .action-btn.edit {
                background-color: #fef3c7;
                color: #f59e0b;
            }

            .action-btn.edit:hover {
                background-color: #fde68a;
            }

            .action-btn.delete {
                background-color: #fee2e2;
                color: #ef4444;
            }

            .action-btn.delete:hover {
                background-color: #fecaca;
            }

            .info-text {
                color: #64748b;
                font-size: 13px;
                line-height: 1.6;
            }

            .info-text strong {
                color: #1e293b;
            }

            .variant-count {
                color: #3b82f6;
                font-size: 12px;
                font-weight: 500;
            }

            .price-range {
                font-size: 13px;
                color: #1e293b;
            }
        </style>

    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>
        <!-- Main Content -->
        <div class="main-wrapper">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Manage Product</h2>
                    </div>
                </div>
            </div>
            <div class="container">        

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Total products</h3>
                            <div class="number">${totalRecords}</div>
                        </div>
                        <div class="stat-icon blue">
                            <i class="fas fa-box"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Total Inventory</h3>
                            <div class="number">${totalQuantity}</div>
                        </div>
                        <div class="stat-icon green">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Inventory Value</h3>
                            <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$" maxFractionDigits="2" var="fmtTotal" />
                            <div class="number">${fmtTotal}</div>
                        </div>
                        <div class="stat-icon yellow">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-content">
                            <h3>Out of stocks</h3>
                            <div class="number">0</div>
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
                                <c:set var="variants" value="${productVariantsMap[product.productId]}" />
                                <c:set var="hasVariants" value="${not empty variants}" />

                                <tr>
                                    <td>${product.productId}</td>
                                    <td>
                                        <div class="product-cell">
                                            <img src="${product.defaultImageUrl}" alt="${product.name}" class="product-image">
                                            <div class="product-info">
                                                <div class="product-name">${product.name}</div>
                                                <div class="product-tags">
                                                    <span class="tag blue">${product.material}</span>
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
                                            <strong>Material:</strong> ${product.material}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${hasVariants}">
                                                <%-- Tính min và max price --%>
                                                <c:set var="minPrice" value="${variants[0].price}" />
                                                <c:set var="maxPrice" value="${variants[0].price}" />
                                                <c:forEach var="v" items="${variants}">
                                                    <c:if test="${v.price < minPrice}">
                                                        <c:set var="minPrice" value="${v.price}" />
                                                    </c:if>
                                                    <c:if test="${v.price > maxPrice}">
                                                        <c:set var="maxPrice" value="${v.price}" />
                                                    </c:if>
                                                </c:forEach>

                                                <%-- Hiển thị price range --%>
                                                <div class="price-range">
                                                    <c:choose>
                                                        <c:when test="${minPrice == maxPrice}">
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
                                        <c:choose>
                                            <c:when test="${hasVariants}">
                                                <%-- Tính tổng số lượng --%>
                                                <c:set var="totalQty" value="0" />
                                                <c:forEach var="v" items="${variants}">
                                                    <c:set var="totalQty" value="${totalQty + v.quantityAvailable}" />
                                                </c:forEach>
                                                <strong>${totalQty}</strong>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${hasVariants}">
                                                <%-- Kiểm tra có variant nào còn hàng không --%>
                                                <c:set var="hasStock" value="false" />
                                                <c:forEach var="v" items="${variants}">
                                                    <c:if test="${v.quantityAvailable > 0}">
                                                        <c:set var="hasStock" value="true" />
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
                                            <button class="action-btn" onclick="viewProduct(${product.productId})" title="View Details">
                                                👁️
                                            </button>
                                            <button class="action-btn edit" onclick="editProduct(${product.productId})" title="Edit Product">
                                                ✏️
                                            </button>
                                            <button class="action-btn delete" onclick="deleteProduct(${product.productId}, '${fn:escapeXml(product.name)}')" title="Delete Product">
                                                🗑️
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                </div>
            </div>
        </div>  

        <script>
            function createProduct() {
                // chuyển trang tới servlet để tạo product mới
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=create';
            }

            function viewProduct(productId) {
                // chuyển trang tới servlet bằng GET
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=detail&productId=' + encodeURIComponent(productId);
            }

            function editProduct(productId) {
                // chuyển trang tới servlet để edit
                window.location.href = '${pageContext.request.contextPath}/staff/product?action=edit&productId=' + encodeURIComponent(productId);
            }

            function deleteProduct(productId, productName) {
                if (!confirm('Are you sure you want to delete "' + productName + '"?\n\nThis action cannot be undone!')) {
                    return;
                }

                // Create form and submit
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