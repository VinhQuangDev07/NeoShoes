<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${product.name} - NeoShoes</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>
    </head>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            line-height: 1.6;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .logo {
            font-size: 2rem;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }
        .nav-links {
            display: flex;
            gap: 2rem;
        }
        .nav-link {
            color: white;
            text-decoration: none;
            transition: opacity 0.3s;
        }
        .nav-link:hover {
            opacity: 0.8;
        }

        /* Breadcrumb */
        .breadcrumb {
            max-width: 1200px;
            margin: 1rem auto;
            padding: 0 20px;
        }
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Product Detail */
        .product-detail {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 20px;
        }
        .product-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        /* Product Images */
        .product-images {
            position: sticky;
            top: 2rem;
        }
        .main-image {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .main-image img {
            width: 100%;
            height: 400px;
            object-fit: contain;
            border-radius: 10px;
        }
        .thumbnail-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.5rem;
        }
        .thumbnail {
            width: 100%;
            aspect-ratio: 1;
            object-fit: cover;
            border-radius: 5px;
            cursor: pointer;
            border: 2px solid transparent;
        }
        .thumbnail:hover, .thumbnail.active {
            border-color: #667eea;
        }

        /* Product Info */
        .product-info h1 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 1rem;
        }
        .product-meta {
            color: #666;
            margin-bottom: 1.5rem;
        }
        .product-brand {
            color: #667eea;
            font-weight: 600;
        }
        .product-description {
            margin-bottom: 2rem;
            line-height: 1.6;
            color: #555;
        }

        /* Price */
        .price-section {
            margin-bottom: 2rem;
        }
        .price {
            font-size: 2rem;
            font-weight: bold;
            color: #28a745;
        }
        .price-range {
            font-size: 1.5rem;
            color: #28a745;
            font-weight: 600;
        }

        /* Variants */
        .variants-section {
            margin-bottom: 2rem;
        }
        .variant-option {
            margin-bottom: 1rem;
        }
        .variant-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }
        .variant-options {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        .variant-chip {
            padding: 8px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }
        .variant-chip:hover {
            border-color: #667eea;
        }
        .variant-chip.selected {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        .variant-chip.out-of-stock {
            background: #f8f9fa;
            color: #999;
            cursor: not-allowed;
            text-decoration: line-through;
        }

        /* Quantity */
        .quantity-section {
            margin-bottom: 2rem;
        }
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.2rem;
        }
        .quantity-input {
            width: 60px;
            height: 40px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: #f8f9fa;
            color: #333;
            border: 2px solid #e0e0e0;
        }
        .btn-secondary:hover {
            background: #e9ecef;
        }
        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        /* Product Details */
        .product-details {
            margin-top: 2rem;
        }
        .details-section {
            margin-bottom: 2rem;
        }
        .details-title {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 0.5rem;
        }
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        .detail-value {
            color: #333;
        }

        /* Variants Table */
        .variants-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .variants-table th, .variants-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .variants-table th {
            background: #f8f9fa;
            font-weight: 600;
        }
        .variants-table tr:nth-child(even) {
            background: #f8f9fa;
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #667eea;
            text-decoration: none;
            margin-bottom: 1rem;
        }
        .back-button:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .product-container {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            .action-buttons {
                flex-direction: column;
            }
            .thumbnail-grid {
                grid-template-columns: repeat(3, 1fr);
            }
            .header-container {
                flex-direction: column;
                gap: 1rem;
            }
            .nav-links {
                gap: 1rem;
            }
        }
    </style>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/home" class="logo">NeoShoes</a>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/home" class="nav-link">Home Page</a>
                    <a href="${pageContext.request.contextPath}/products" class="nav-link">Product</a>
                </div>
            </div>
        </header>

        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home Page</a> &gt;
            <a href="${pageContext.request.contextPath}/products">Product</a> &gt;
            <span>${product.name}</span>
        </div>
        <c:if test="${not empty sessionScope.flash}">
            <script>
                showNotification("${sessionScope.flash}", "success");
            </script>
            <c:remove var="flash" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_info}">
            <script>
                showNotification("${sessionScope.flash_info}", "info");
            </script>
            <c:remove var="flash_info" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_error}">
            <script>
                showNotification("${sessionScope.flash_error}", "error");
            </script>
            <c:remove var="flash_error" scope="session"/>
        </c:if>
        <!-- Product Detail -->
        <main class="product-detail">
            <a href="javascript:history.back()" class="back-button">← Quay lại</a>

            <div class="product-container">
                <!-- Product Images -->
                <div class="product-images">
                    <div class="main-image">
                        <img src="${product.defaultImageUrl}" alt="${product.name}" 
                             id="mainImage" >
                    </div>
                    <c:if test="${not empty variants}">
                        <div class="thumbnail-grid">
                            <c:forEach var="variant" items="${variants}" varStatus="status" end="7">
                                <c:if test="${not empty variant.image}">
                                    <img src="${variant.image}" alt="${product.name} - ${variant.color}" 
                                         class="thumbnail ${status.first ? 'active' : ''}"
                                         onclick="changeMainImage('${variant.image}')">
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- Product Info -->
                <div class="product-info">
                    <h1>${product.name}</h1>
                    <div class="product-meta">
                        <span class="product-brand">${product.brandName}</span> • 
                        <span>${product.categoryName}</span>
                    </div>

                    <div class="product-description">
                        ${product.description}
                    </div>

                    <!-- Price -->
                    <div class="price-section">
                        <c:choose>
                            <c:when test="${product.minPrice != product.maxPrice}">
                                <div class="price-range">$${product.minPrice} - $${product.maxPrice}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="price">$${product.minPrice}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Include Variant Selector -->
                    <jsp:include page="common/variant-selector.jsp"/>

                    <!-- Product Details -->
                    <div class="product-details">
                        <div class="details-section">
                            <h3 class="details-title">Thông tin sản phẩm</h3>
                            <div class="details-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Thương hiệu:</span>
                                    <span class="detail-value">${product.brandName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Danh mục:</span>
                                    <span class="detail-value">${product.categoryName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Chất liệu:</span>
                                    <span class="detail-value">${product.material}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Tổng số lượng:</span>
                                    <span class="detail-value">${product.totalQuantity} sản phẩm</span>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
        </main>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
                                             // Change main image when thumbnail is clicked
                                             function changeMainImage(imageUrl) {
                                                 document.getElementById('mainImage').src = imageUrl;
                                                 // Update active thumbnail
                                                 document.querySelectorAll('.thumbnail').forEach(thumb => {
                                                     thumb.classList.remove('active');
                                                 });
                                                 event.target.classList.add('active');
                                             }

                                             // Quantity controls
                                             function changeQuantity(change) {
                                                 const quantityInput = document.getElementById('quantity');
                                                 let quantity = parseInt(quantityInput.value);
                                                 quantity += change;
                                                 if (quantity < 1)
                                                     quantity = 1;
                                                 if (quantity > 10)
                                                     quantity = 10;
                                                 quantityInput.value = quantity;
                                             }

                                             // Variant selection
                                             document.querySelectorAll('.variant-chip').forEach(chip => {
                                                 chip.addEventListener('click', function () {
                                                     if (this.classList.contains('out-of-stock'))
                                                         return;

                                                     const parent = this.parentElement;
                                                     parent.querySelectorAll('.variant-chip').forEach(c => {
                                                         c.classList.remove('selected');
                                                     });
                                                     this.classList.add('selected');
                                                 });
                                             });

                                             // Add to cart function (placeholder)
                                             function addToCart() {
                                                 alert('Tính năng thêm vào giỏ hàng đang được phát triển!');
                                             }

                                             // Buy now function (placeholder)
                                             function buyNow() {
                                                 alert('Tính năng mua ngay đang được phát triển!');
                                             }

                                             // Initialize first variant as selected
                                             document.addEventListener('DOMContentLoaded', function () {
                                                 const firstColor = document.querySelector('#colorOptions .variant-chip');
                                                 const firstSize = document.querySelector('#sizeOptions .variant-chip');

                                                 if (firstColor)
                                                     firstColor.classList.add('selected');
                                                 if (firstSize)
                                                     firstSize.classList.add('selected');
                                             });
        </script>
    </body>
</html>