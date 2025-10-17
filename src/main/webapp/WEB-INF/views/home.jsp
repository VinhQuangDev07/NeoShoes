<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>NeoShoes - Home</title>
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
                background: #000;
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
                background: #000;
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
                gap: 15px;
                overflow-x: auto;
                padding-bottom: 10px;
            }
            .category-chip {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                padding: 8px 12px;
                border: 2px solid #000;
                border-radius: 999px;
                text-decoration: none;
                background: #fff;
                color: #333;
                transition: all .2s;
                white-space: nowrap;
            }
            .category-chip.active, .category-chip:hover {
                background: #000;
                color: #fff;
                border-color: #000;
            }
            .category-thumb {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                object-fit: cover;
                background: #f0f0f0;
                border: 1px solid rgba(0,0,0,.06);
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
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/home" class="logo">NeoShoes</a>
                <form action="${pageContext.request.contextPath}/home" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="searchTerm" placeholder="Search products..." value="${param.searchTerm}" class="search-input">
                    <button type="submit" class="search-button">Search</button>
                </form>
            </div>
        </header>

        <!-- Brands -->
        <section class="categories">
            <div class="categories-container">
                <h3 class="categories-title">Brands</h3>
                <div class="categories-list">
                    <c:forEach var="brand" items="${brands}">
                        <a href="${pageContext.request.contextPath}/products?action=brand&brandId=${brand.brandId}"
                           class="category-chip ${param.selectedBrand == brand.brandId ? 'active' : ''}">
                            <img class="category-thumb"
                                 src="${empty brand.logo ? 'https://via.placeholder.com/56?text=Brand' : brand.logo}"
                                 alt="${brand.name}"
                                 onerror="this.src='https://via.placeholder.com/56?text=Brand'">
                            <span>${brand.name}</span>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>
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
            <c:if test="${empty param.searchTerm && empty param.selectedCategory}">
                <!-- Correct route: /products -->
                <a href="${pageContext.request.contextPath}/products" class="view-all-btn">View All →</a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty products}">
                <div class="products-grid">
                    <c:forEach var="product" items="${products}">
                        <div class="product-card">
                            <div class="product-media">
                                <img src="${product.defaultImageUrl}" alt="${product.name}" class="product-image"
                                     onerror="this.src='https://via.placeholder.com/360x270?text=No+Image'">
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${product.name}</h3>
                                <p class="product-brand">${product.brandName}</p>

                                <c:if test="${product.availableColors != null}">
                                    <div class="color-previews">
                                        <c:forTokens items="${product.availableColors}" delims="," var="color" end="3">
                                            <span class="color-dot" style="background-color: ${color}" title="${color}"></span>
                                        </c:forTokens>
                                        <c:if test="${fn:length(fn:split(product.availableColors, ',')) > 3}">
                                            <span class="color-more">+${fn:length(fn:split(product.availableColors, ',')) - 3}</span>
                                        </c:if>
                                    </div>
                                </c:if>

                                <c:choose>
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
</body>
</html>
