<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <title>NeoShoes - Tất Cả Sản Phẩm</title>
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
            }
            .search-button {
                background: #ff6b6b;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 25px;
                cursor: pointer;
                font-size: 1rem;
                transition: background 0.3s;
            }
            .search-button:hover {
                background: #ff5252;
            }

            /* Layout */
            .main-container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 20px;
                display: grid;
                grid-template-columns: 250px 1fr;
                gap: 2rem;
            }

            /* Sidebar with categories */
            .sidebar {
                background: white;
                padding: 1.5rem;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
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

            /* Updated: Grid with 3 columns */
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

            /* Ảnh sản phẩm */
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

            /* Responsive adjustments */
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

            /* Optional: Add some spacing for brand section */
            .sidebar-title {
                font-size: 1.2rem;
                margin-bottom: 1rem;
                color: #333;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #667eea;
            }

            /* Brand thumbnails can be slightly different if needed */
            .brand-thumb {
                width: 26px;
                height: 26px;
                border-radius: 50%;
                object-fit: cover;
                background: #f0f0f0;
                border: 1px solid rgba(0,0,0,.06);
            }
            .clear-filters-btn {
                transition: all 0.3s ease;
            }

            .clear-filters-btn:hover {
                background: #ff5252 !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(255, 107, 107, 0.3);
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <a href="${pageContext.request.contextPath}/home" class="logo">NeoShoes</a>
                <!-- Route đúng: /products -->
                <form action="${pageContext.request.contextPath}/products" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="searchTerm" placeholder="Tìm kiếm sản phẩm..." value="${param.searchTerm}" class="search-input">
                    <button type="submit" class="search-button">Tìm kiếm</button>
                </form>
            </div>
        </header>

        <!-- Main Content -->
        <div class="main-container">

            <!-- Sidebar -->
            <aside class="sidebar">
                <h3 class="sidebar-title">Danh Mục</h3>
                <ul class="categories-list">
                    <li class="category-item">
                        <a href="${pageContext.request.contextPath}/products"
                           class="category-link ${empty param.selectedCategory and empty param.selectedBrand ? 'active' : ''}">
                            <img class="category-thumb" src="https://via.placeholder.com/52?text=All" alt="All">
                            <span>Tất Cả Sản Phẩm</span>
                        </a>
                    </li>
                    <c:forEach var="category" items="${categories}">
                        <li class="category-item">
                            <c:choose>
                                <c:when test="${not empty param.selectedBrand}">
                                    <!-- Nếu đã chọn brand, tạo link kết hợp với category -->
                                    <a href="${pageContext.request.contextPath}/products?action=category-brand&categoryId=${category.categoryId}&brandId=${param.selectedBrand}"
                                       class="category-link ${param.selectedCategory == category.categoryId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty category.image ? 'https://via.placeholder.com/52?text=Cat' : category.image}"
                                             alt="${category.name}"
                                             onerror="this.src='https://via.placeholder.com/52?text=Cat'">
                                        <span>${category.name}</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <!-- Nếu chưa chọn brand, tạo link category bình thường -->
                                    <a href="${pageContext.request.contextPath}/products?action=category&categoryId=${category.categoryId}"
                                       class="category-link ${param.selectedCategory == category.categoryId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty category.image ? 'https://via.placeholder.com/52?text=Cat' : category.image}"
                                             alt="${category.name}"
                                             onerror="this.src='https://via.placeholder.com/52?text=Cat'">
                                        <span>${category.name}</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>

                <!-- Thêm phần lọc theo brand -->
                <h3 class="sidebar-title" style="margin-top: 2rem;">Thương Hiệu</h3>
                <ul class="categories-list">
                    <c:forEach var="brand" items="${brands}">
                        <li class="category-item">
                            <c:choose>
                                <c:when test="${not empty param.selectedCategory}">
                                    <!-- Nếu đã chọn category, tạo link kết hợp với brand -->
                                    <a href="${pageContext.request.contextPath}/products?action=category-brand&categoryId=${param.selectedCategory}&brandId=${brand.brandId}"
                                       class="category-link ${param.selectedBrand == brand.brandId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty brand.logo ? 'https://via.placeholder.com/52?text=Brand' : brand.logo}"
                                             alt="${brand.name}"
                                             onerror="this.src='https://via.placeholder.com/52?text=Brand'">
                                        <span>${brand.name}</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <!-- Nếu chưa chọn category, tạo link brand bình thường -->
                                    <a href="${pageContext.request.contextPath}/products?action=brand&brandId=${brand.brandId}"
                                       class="category-link ${param.selectedBrand == brand.brandId ? 'active' : ''}">
                                        <img class="category-thumb"
                                             src="${empty brand.logo ? 'https://via.placeholder.com/52?text=Brand' : brand.logo}"
                                             alt="${brand.name}"
                                             onerror="this.src='https://via.placeholder.com/52?text=Brand'">
                                        <span>${brand.name}</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>

                <!-- Nút xóa bộ lọc khi có cả category và brand -->
                <c:if test="${not empty param.selectedCategory and not empty param.selectedBrand}">
                    <div style="margin-top: 1.5rem; text-align: center;">
                        <a href="${pageContext.request.contextPath}/products" 
                           class="clear-filters-btn"
                           style="display: inline-block; padding: 10px 16px; background: #ff6b6b; color: white;
                           text-decoration: none; border-radius: 5px; font-size: 0.9rem; font-weight: 500;">
                            ✕ Xóa Bộ Lọc
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
                                    Kết quả tìm kiếm cho "${param.searchTerm}"
                                </c:when>
                                <c:when test="${not empty param.selectedCategory and not empty param.selectedBrand}">
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.categoryId == param.selectedCategory}">
                                            <c:forEach var="brand" items="${brands}">
                                                <c:if test="${brand.brandId == param.selectedBrand}">
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
                                <c:when test="${not empty param.selectedBrand}">
                                    <c:forEach var="brand" items="${brands}">
                                        <c:if test="${brand.brandId == param.selectedBrand}">
                                            ${brand.name}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>Tất Cả Sản Phẩm</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="products-count">
                            <c:choose>
                                <c:when test="${not empty products}">
                                    ${fn:length(products)} sản phẩm
                                </c:when>
                                <c:otherwise>0 sản phẩm</c:otherwise>
                            </c:choose>
                            <c:if test="${not empty param.selectedCategory and not empty param.selectedBrand}">
                                <span style="color: #667eea; margin-left: 10px;">(Đang lọc kết hợp)</span>
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
                                             onerror="this.src='https://via.placeholder.com/360x270?text=No+Image'">
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

                                        <a href="product-detail?id=${product.productId}" class="view-details-btn">Xem Chi Tiết</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${not empty totalPages && totalPages > 1}">
                            <div class="pagination">
                                <div class="page-info">Trang ${currentPage} / ${totalPages}</div>
                                <div class="page-numbers">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                           class="page-link">← Trước</a>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="page-number active">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${i}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                                   class="page-number">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}<c:if test='${not empty param.action}'>&action=${param.action}</c:if><c:if test='${not empty param.categoryId}'>&categoryId=${param.categoryId}</c:if><c:if test='${not empty param.searchTerm}'>&searchTerm=${param.searchTerm}</c:if>"
                                           class="page-link">Sau →</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="no-products">
                            <c:choose>
                                <c:when test="${not empty param.searchTerm}">
                                    <p>Không tìm thấy sản phẩm nào phù hợp với "${param.searchTerm}"</p>
                                </c:when>
                                <c:otherwise>
                                    <p>Không có sản phẩm nào</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </body>
</html>