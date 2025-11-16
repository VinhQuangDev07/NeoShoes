<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>NeoShoes - Home</title>
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


        <style>
            /* Reset & base */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f8f9fa;
                line-height: 1.6;
                color: #333;
            }

            /* Header: solid black */
            .header {
                background: #0A437F;
                color: #fff;
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
                color: #fff;
            }
            .search-form {
                display: flex;
                gap: 10px;
                flex: 0 1 400px;
            }
            .search-input {
                flex: 1;
                padding: 10px 15px;
                border: none;
                border-radius: 25px;
                font-size: 1rem;
                outline: none;
                background: #fff;
                color: #333;
            }
            .search-button {
                background: #28a745;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 25px;
                cursor: pointer;
                font-size: 1rem;
                transition: background .3s;
            }
            .search-button:hover {
                background: #111;
            }

            /* Categories */
            .categories {
                background: #fff;
                padding: 1rem 0;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .categories-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }
            .categories-title {
                font-size: 1.2rem;
                margin-bottom: 1rem;
                color: #333;
            }
            .categories-list {
                display: flex;
                flex-wrap: wrap;
                justify-content: center; /* căn giữa toàn bộ brand */
                align-items: center; /* căn giữa theo chiều dọc */
                gap: 20px 30px; /* khoảng cách đều nhau giữa các dòng và cột */
                padding: 10px 0;
                overflow: visible;
            }


            .category-chip {
                flex: 0 1 180px; /* chiều rộng đồng đều */
                justify-content: center;
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 16px;
                border: 2px solid #000;
                border-radius: 999px;
                text-decoration: none;
                background: #fff;
                color: #333;
                transition: all 0.2s ease-in-out;
                white-space: nowrap;
            }

            .category-chip:hover {
                background: #000;
                color: #fff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .category-thumb {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                object-fit: cover;
            }


            /* Products */
            .products {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 20px;
            }
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }
            .products-title {
                font-size: 1.8rem;
                color: #333;
                font-weight: 600;
            }

            /* View all: black */
            .view-all-btn {
                background: #000;
                color: #fff;
                padding: 12px 24px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 500;
                transition: all .3s ease;
                box-shadow: 0 4px 15px rgba(0,0,0,.3);
            }
            .view-all-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,.4);
                color: #fff;
            }

            /* Grid: 4 columns on desktop */
            .products-grid {
                display: grid;
                grid-template-columns: repeat(4, minmax(0, 1fr));
                gap: 2rem;
            }

            .product-card {
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 18px rgba(0,0,0,0.08);
                transition: transform .25s, box-shadow .25s;
            }
            .product-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            }

            /* Product image fits (no crop) */
            .product-media {
                width: 100%;
                aspect-ratio: 4 / 3;
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 10px;
                border-bottom: 1px solid rgba(0,0,0,.05);
            }
            .product-image {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
                display: block;
            }

            .product-info {
                padding: 1.5rem;
            }
            .product-name {
                font-size: 1.1rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
                color: #333;
                line-height: 1.3;
            }
            .product-brand {
                color: #000;
                font-weight: 600;
                font-size: 0.9rem;
                margin-bottom: 0.5rem;
            }

            /* Color swatches: keep original color; only border & shadow styles */
            .color-previews {
                display: flex;
                gap: 5px;
                margin: 10px 0;
                flex-wrap: wrap;
            }
            .color-dot {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                border: 2px solid #fff;
                box-shadow: 0 0 2px rgba(0,0,0,0.3);
                display: inline-block; /* background comes from inline style from server */
            }
            .color-more {
                font-size: 0.8rem;
                color: #666;
                margin-left: 5px;
                align-self: center;
            }

            .price-range, .price {
                font-size: 1.3rem;
                font-weight: bold;
                color: #28a745;
                margin: 10px 0;
            }

            .view-details-btn {
                display: block;
                background: #f8f9fa;
                color: #333;
                text-align: center;
                padding: 10px;
                border-radius: 8px;
                text-decoration: none;
                margin-top: 10px;
                transition: all 0.3s;
                font-weight: 500;
            }
            .view-details-btn:hover {
                background: #000;
                color: #fff;
            }

            /* Mobile view-all button: black */
            .view-all-mobile {
                display: none;
                text-align: center;
                margin-top: 2rem;
            }
            .view-all-btn-mobile {
                background: #000;
                color: #fff;
                padding: 12px 30px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 500;
                display: inline-block;
                box-shadow: 0 4px 15px rgba(0,0,0,.3);
            }

            .no-products {
                text-align: center;
                color: #666;
                font-size: 1.1rem;
                margin: 3rem 0;
                padding: 2rem;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            /* Responsive: fewer columns on small screens; keep 4 on desktop */
            @media (max-width: 1024px) {
                .products-grid {
                    grid-template-columns: repeat(3, minmax(0, 1fr));
                }
            }
            @media (max-width: 768px) {
                .header-container {
                    flex-direction: column;
                    gap: 1rem;
                }
                .search-form {
                    flex: 1;
                    width: 100%;
                }
                .section-header {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }
                .view-all-btn {
                    display: none;
                }
                .view-all-mobile {
                    display: block;
                }
                .products-grid {
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                    gap: 1.5rem;
                }
                .categories-list {
                    gap: 10px;
                }
            }
            @media (max-width: 480px) {
                .products-grid {
                    grid-template-columns: 1fr;
                }
                .product-card {
                    margin: 0 10px;
                }
            }


            /* Video Banner */
            .video-banner {
                position: relative;
                width: 100%;
                height: 500px;
                overflow: hidden;
                margin-bottom: 40px;
            }

            .video-container {
                position: relative;
                width: 100%;
                height: 100%;
            }

            .banner-video {
                position: absolute;
                top: 50%;
                left: 50%;
                min-width: 100%;
                min-height: 100%;
                width: auto;
                height: auto;
                transform: translate(-50%, -50%);
                object-fit: cover;
            }

            .video-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.4);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .banner-content {
                text-align: center;
                color: white;
                z-index: 2;
                padding: 20px;
            }

            .banner-title {
                font-size: 56px;
                font-weight: bold;
                margin-bottom: 16px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
                animation: fadeInUp 1s ease-out;
            }

            .banner-subtitle {
                font-size: 24px;
                margin-bottom: 32px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
                animation: fadeInUp 1.2s ease-out;
            }

            .banner-btn {
                display: inline-block;
                padding: 14px 40px;
                background: #ff6b6b;
                color: white;
                text-decoration: none;
                border-radius: 30px;
                font-weight: 600;
                font-size: 18px;
                transition: all 0.3s ease;
                animation: fadeInUp 1.4s ease-out;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
            }

            .banner-btn:hover {
                background: #ff5252;
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 107, 107, 0.6);
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive */
            @media (max-width: 768px) {
                .video-banner {
                    height: 350px;
                }

                .banner-title {
                    font-size: 32px;
                }

                .banner-subtitle {
                    font-size: 16px;
                }

                .banner-btn {
                    padding: 10px 28px;
                    font-size: 16px;
                }
            }

            @media (max-width: 480px) {
                .video-banner {
                    height: 280px;
                }

                .banner-title {
                    font-size: 24px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/customer/common/header.jsp"/>
        <!-- Notifications -->
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <!-- Video Banner Section -->
        <section class="video-banner">
            <div class="video-container">
                <video class="banner-video" autoplay muted loop playsinline>
                    <source src="${pageContext.request.contextPath}/assets/videos/banner.mp4" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
                <div class="video-overlay">
                    <div class="banner-content">
                        <h1 class="banner-title">NeoShoes Collection</h1>
                        <p class="banner-subtitle">Step into Style, Walk with Confidence</p>
                        <a href="${pageContext.request.contextPath}/products" class="banner-btn">Shop Now</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Brands -->
        <section class="categories">
            <div class="categories-container">
                <h3 class="categories-title">Brands</h3>
                <div class="categories-list">
                    <c:forEach var="brand" items="${brands}">
                        <a href="${pageContext.request.contextPath}/products?action=filter&type=brand&brandId=${brand.brandId}"
                           class="category-chip ${param.selectedBrand == brand.brandId ? 'active' : ''}">
                            <img class="category-thumb"
                                 src="${empty brand.logo ? 'https://via.placeholder.com/56?text=Brand' : brand.logo}"
                                 alt="${brand.name}"
                                 onerror="this.src='https://nftcalendar.io/storage/uploads/2022/02/21/image-not-found_0221202211372462137974b6c1a.png'">
                            <span>${brand.name}</span>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>


        <!-- Featured Products -->
        <section class="products">
            <div class="section-header">
                <h2 class="products-title">
                    <c:choose>
                        <c:when test="${not empty param.searchTerm}">
                            Search results for "${param.searchTerm}"
                        </c:when>
                        <c:when test="${not empty param.selectedCategory}">
                            <c:forEach var="category" items="${categories}">
                                <c:if test="${category.categoryId == param.selectedCategory}">
                                    ${category.name}
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>Newest Products</c:otherwise> 
                    </c:choose>
                </h2>

            </div>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="products-grid">
                        <c:forEach var="product" items="${products}">
                            <div class="product-card">
                                <div class="product-media">
                                    <img src="${product.defaultImageUrl}" alt="${product.name}" class="product-image"
                                         onerror="this.src='https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png'">
                                </div>
                                <div class="product-info">
                                    <h3 class="product-name">${product.name}</h3>
                                    <p class="product-brand">${product.brandName}</p>

                                    <c:choose>
                                        <c:when test="${empty product.minPrice or empty product.maxPrice}">
                                            <div id="priceText" class="price">Discontinue</div>
                                        </c:when>
                                        <c:when test="${product.minPrice != product.maxPrice}">
                                            <div class="price-range">$${product.minPrice} - $${product.maxPrice}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="price">$${product.minPrice}</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="product-detail?id=${product.productId}" class="view-details-btn">View Details</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${empty param.searchTerm && empty param.selectedCategory}">
                        <div class="view-all-mobile">
                            <a href="${pageContext.request.contextPath}/products" class="view-all-btn-mobile">View All Products</a>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <c:choose>
                            <c:when test="${not empty param.searchTerm}">
                                <p>No products matched "${param.searchTerm}"</p>
                            </c:when>
                            <c:otherwise>
                                <p>There are no featured products yet</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
        <jsp:include page="/WEB-INF/views/customer/common/footer.jsp"/>

        <!-- JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
