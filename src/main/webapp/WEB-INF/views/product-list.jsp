<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <title>NeoShoes - All Products</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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


            /* Layout */
            .main-container {
                max-width: 1200px;
                margin: 28px auto;
                padding: 0 20px;
                display: grid;
                grid-template-columns: 280px 1fr;
                gap: 24px;
                align-items: start;
            }

            /* Sidebar with categories */
            .sidebar {
                background: white;
                padding: 1.5rem;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
                position: sticky;
                top: 20px;
                display: flex;
                flex-direction: column;
            }
            .sidebar-title {
                font-size: 1.2rem;
                margin-bottom: 1rem;
                color: #333;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #667eea;
            }
            .categories-list {
                list-style: none;
            }
            .category-item {
                margin-bottom: 0.5rem;
            }
            .category-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 12px;
                color: #333;
                text-decoration: none;
                border-radius: 8px;
                transition: all 0.2s;
            }
            .category-link:hover, .category-link.active {
                background: #667eea;
                color: #fff;
            }
            .category-thumb {
                width: 26px;
                height: 26px;
                border-radius: 50%;
                object-fit: cover;
                background: #f0f0f0;
                border: 1px solid rgba(0,0,0,.06);
            }

            /* Products Section */
            .products-section {
                flex: 1;
            }
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                background: white;
                padding: 1.5rem;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .products-title {
                font-size: 1.8rem;
                color: #333;
                font-weight: 600;
            }
            .products-count {
                color: #666;
                font-size: 1rem;
            }

            /* Grid */
            .products-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1.5rem;
                margin-bottom: 2rem;
            }
            .product-card {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 18px rgba(0,0,0,0.08);
                transition: transform .25s, box-shadow .25s;
            }
            .product-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            }

            .product-media {
                width: 100%;
                aspect-ratio: 4 / 3;
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 15px;
                border-bottom: 1px solid rgba(0,0,0,.05);
            }
            .product-image {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
                display: block;
            }

            .product-info {
                padding: 1.25rem;
            }
            .product-name {
                font-size: 1rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
                color: #333;
                line-height: 1.3;
                height: 2.6rem;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }
            .product-brand {
                color: #667eea;
                font-weight: 600;
                font-size: 0.85rem;
                margin-bottom: 0.5rem;
            }
            .color-previews {
                display: flex;
                gap: 5px;
                margin: 8px 0;
                flex-wrap: wrap;
            }
            .color-dot {
                width: 18px;
                height: 18px;
                border-radius: 50%;
                border: 2px solid #fff;
                box-shadow: 0 0 2px rgba(0,0,0,0.3);
                display: inline-block;
            }
            .color-more {
                font-size: 0.75rem;
                color: #666;
                margin-left: 5px;
                align-self: center;
            }
            .price-range, .price {
                font-size: 1.2rem;
                font-weight: bold;
                color: #28a745;
                margin: 8px 0;
            }

            .view-details-btn {
                display: block;
                background: #f8f9fa;
                color: #333;
                text-align: center;
                padding: 8px 12px;
                border-radius: 8px;
                text-decoration: none;
                margin-top: 10px;
                transition: all 0.3s;
                font-weight: 500;
                font-size: 0.9rem;
            }
            .view-details-btn:hover {
                background: #667eea;
                color: white;
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 1rem;
                margin: 2rem 0;
                padding: 1.5rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .page-info {
                color: #666;
                font-size: 0.9rem;
            }
            .page-link {
                padding: 8px 16px;
                background: #667eea;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background 0.3s;
            }
            .page-link:hover {
                background: #5a6fd8;
            }
            .page-link.disabled {
                background: #ccc;
                cursor: not-allowed;
            }
            .page-numbers {
                display: flex;
                gap: 0.5rem;
            }
            .page-number {
                padding: 8px 12px;
                background: #f8f9fa;
                color: #333;
                text-decoration: none;
                border-radius: 5px;
                transition: all 0.3s;
            }
            .page-number:hover, .page-number.active {
                background: #667eea;
                color: white;
            }

            .no-products {
                text-align: center;
                color: #666;
                font-size: 1.1rem;
                margin: 3rem 0;
                padding: 2rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            /* Responsive */
            @media (max-width: 1100px) {
                .products-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 968px) {
                .main-container {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                }
                .sidebar {
                    order: 2;
                }
                .products-section {
                    order: 1;
                }
                .products-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 768px) {
                .header-container {
                    flex-direction: column;
                    gap: 1rem;
                }
                .search-form {
                    width: 100%;
                }
                .section-header {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }
                .products-grid {
                    gap: 1rem;
                }
                .pagination {
                    flex-direction: column;
                    gap: 1rem;
                }
            }
            @media (max-width: 580px) {
                .products-grid {
                    grid-template-columns: 1fr;
                }
                .product-card {
                    max-width: 320px;
                    margin: 0 auto;
                }
            }

            /* Brand thumbnails */
            .brand-thumb {
                width: 26px;
                height: 26px;
                border-radius: 50%;
                object-fit: cover;
                background: #f0f0f0;
                border: 1px solid rgba(0,0,0,.06);
            }

            /* --- Buttons (base) --- */
            .btn{
                
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:10px 14px;
                border-radius:12px;
                border:1px solid var(--btn-bd);
                color:var(--btn-fg);
                background:var(--btn-bg);
                text-decoration:none;
                font-weight:700;
                letter-spacing:.2px;
                transition:transform .18s ease, box-shadow .18s ease, background .18s ease, color .18s ease, border-color .18s ease;
                box-shadow:0 4px 14px rgba(0,0,0,.06);
            }
            .btn:hover{
                transform:translateY(-1px);
                box-shadow:0 10px 22px rgba(0,0,0,.10);
            }
            .btn:active{
                transform:translateY(0);
                box-shadow:0 6px 14px rgba(0,0,0,.08);
            }
            .btn:focus-visible{
                outline:3px solid rgba(59,130,246,.35);
                outline-offset:2px;
            }

            /* size + block */
            .btn-lg{
                padding:12px 16px;
                border-radius:14px;
                font-size:15px;
            }
            .btn-block{
                display:flex;
                width:100%;
            }
            .btn-ic{
                flex:0 0 auto;
            }

            /* Variant A: Soft Danger (khuyến nghị) */
            .btn-danger-soft{
                --btn-bg:#fff1f2;   /* rất nhẹ */
                --btn-fg:#be123c;   /* đỏ hoa hồng */
                --btn-bd:#fecdd3;   /* viền nhạt */
            }
            .btn-danger-soft:hover{
                --btn-bg:#ffe4e6;
            }

            /* (Tuỳ chọn) Variant B: Gradient nổi bật
            .btn-danger-grad{
              --btn-bg:linear-gradient(135deg, #ff6b6b 0%, #f43f5e 100%);
              --btn-fg:#fff; --btn-bd:transparent;
              color:#fff; border:0; box-shadow:0 10px 22px rgba(244,63,94,.25);
            }
            .btn-danger-grad:hover{ box-shadow:0 14px 26px rgba(244,63,94,.32); }
            */

            /* (Tuỳ chọn) Variant C: Outline tối giản
            .btn-danger-outline{ --btn-bg:#fff; --btn-fg:#dc2626; --btn-bd:#fca5a5; }
            .btn-danger-outline:hover{ --btn-bg:#fff5f5; border-color:#f87171; }
            */

            /* Push footer button to the bottom of the sidebar card */
            .sidebar-footer {
                margin-top: auto;
            }

        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/customer/common/header.jsp"/>
        <!--        <header class="header">
                    <div class="header-container">
                        <a href="${pageContext.request.contextPath}/home" class="logo">NeoShoes</a>
                        <form action="${pageContext.request.contextPath}/products" method="get" class="search-form">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="searchTerm" placeholder="Search products..." value="${param.searchTerm}" class="search-input">
                            <button type="submit" class="search-button">Search</button>
                        </form>
                    </div>
                </header>-->

        <!-- Main Content -->
        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <h3 class="sidebar-title">Categories</h3>
                <ul class="categories-list">
                    <li class="category-item">
                        <c:choose>
                            <c:when test="${not empty param.brandId}">
                                <!-- When a brand is selected, 'All' goes back to the brand page -->
                                <a href="${pageContext.request.contextPath}/products?action=brand&brandId=${param.brandId}"
                                   class="category-link ${empty param.selectedCategory ? 'active' : ''}">
                                    <img class="category-thumb" src="https://media.gq.com/photos/6813a873625bf4cbda4cb50c/16:9/w_1280,c_limit/sneaker%20lede%20v1.png" alt="All">
                                    <span>All Categories</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <!-- When no brand is selected, 'All' goes to all products -->
                                <a href="${pageContext.request.contextPath}/products"
                                   class="category-link ${empty param.selectedCategory ? 'active' : ''}">
                                    <img class="category-thumb" src="https://media.gq.com/photos/6813a873625bf4cbda4cb50c/16:9/w_1280,c_limit/sneaker%20lede%20v1.png" alt="All">
                                    <span>All Products</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </li>

                    <c:forEach var="category" items="${categories}">
                        <li class="category-item">
                            <c:choose>
                                <c:when test="${not empty param.brandId}">
                                    <!-- Always pass brandId when clicking category on a brand page -->
                                    <a href="${pageContext.request.contextPath}/products?action=category&categoryId=${category.categoryId}&brandId=${param.brandId}"
                                       class="category-link ${param.selectedCategory == category.categoryId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty category.image ? 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png' : category.image}"
                                             alt="${category.name}"
                                             onerror="this.src='https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png'">
                                        <span>${category.name}</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <!-- Normal category link when no brand is selected -->
                                    <a href="${pageContext.request.contextPath}/products?action=category&categoryId=${category.categoryId}"
                                       class="category-link ${param.selectedCategory == category.categoryId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty category.image ? 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png' : category.image}"
                                             alt="${category.name}"
                                             onerror="this.src='https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png'">
                                        <span>${category.name}</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>

                <!-- Clear brand filter -->
                <c:if test="${not empty param.brandId}">
                    <div class="sidebar-footer">
                        <a href="${pageContext.request.contextPath}/products"
                           class="btn btn-success-soft btn-lg btn-block no-ic">
                            Clear Brand Filter
                        </a>

                    </div>
                </c:if>

            </aside>

            <!-- Products Section -->
            <main class="products-section">
                <div class="section-header">
                    <div>
                        <h2 class="products-title">
                            <c:choose>
                                <c:when test="${not empty param.searchTerm}">
                                    Search results for "${param.searchTerm}"
                                </c:when>
                                <c:when test="${not empty param.selectedCategory and not empty param.brandId}">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == param.selectedCategory}">
                                            <c:forEach var="brand" items="${brands}">
                                                <c:if test="${brand.brandId == param.brandId}">
                                                    ${category.name} - ${brand.name}
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${not empty param.selectedCategory}">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == param.selectedCategory}">
                                            ${category.name}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${not empty param.brandId}">
                                    <c:forEach var="brand" items="${brands}">
                                        <c:if test="${brand.brandId == param.brandId}">
                                            ${brand.name}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>All Products</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="products-count">
                            <c:choose>
                                <c:when test="${not empty products}">
                                    ${fn:length(products)} products
                                </c:when>
                                <c:otherwise>0 products</c:otherwise>
                            </c:choose>
                            <c:if test="${not empty param.selectedCategory and not empty param.brandId}">
                                <span style="color: #667eea; margin-left: 10px;">(Combined filter)</span>
                            </c:if>
                        </p>
                    </div>
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
                                        <p class="product-brand">${product.brandName} • ${product.categoryName}</p>

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

                        <!-- Pagination -->
                        <c:if test="${not empty totalPages && totalPages > 1}">
                            <div class="pagination">
                                <div class="page-info">Page ${currentPage} / ${totalPages}</div>
                                <div class="page-numbers">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.brandId}'>&brandId=${param.brandId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                           class="page-link">← Prev</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="page-number active">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${i}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.brandId}'>&brandId=${param.brandId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                                   class="page-number">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.brandId}'>&brandId=${param.brandId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                           class="page-link">Next →</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="no-products">
                            <c:choose>
                                <c:when test="${not empty param.searchTerm}">
                                    <p>No products found matching "${param.searchTerm}"</p>
                                </c:when>
                                <c:when test="${not empty param.selectedCategory and not empty param.brandId}">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == param.selectedCategory}">
                                            <c:forEach var="brand" items="${brands}">
                                                <c:if test="${brand.brandId == param.brandId}">
                                                    <p>No products for brand <strong>${brand.name}</strong> in category <strong>${category.name}</strong></p>
                                                    <p style="margin-top: 10px; font-size: 0.9rem; color: #666;">
                                                        Please choose another category or <a href="${pageContext.request.contextPath}/products?action=brand&brandId=${param.brandId}" style="color: #667eea;">see all products of ${brand.name}</a>
                                                    </p>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${not empty param.selectedCategory}">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == param.selectedCategory}">
                                            <p>No products in category "${category.name}"</p>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${not empty param.brandId}">
                                    <c:forEach var="brand" items="${brands}">
                                        <c:if test="${brand.brandId == param.brandId}">
                                            <p>No products for brand "${brand.name}"</p>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>No products available</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
        <jsp:include page="/WEB-INF/views/customer/common/footer.jsp"/>
    </body>
</html>
