<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${product.name} - NeoShoes</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <style>
        input[type=number]::-webkit-inner-spin-button,
        input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
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
            justify-content: flex-end;
            margin-bottom: 2rem;
        }

        .add-to-cart-btn {
            background-color: #000 !important;
            border-color: #000 !important;
            color: white !important;
            border-radius: 0 !important;
            padding: 0.75rem 2rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .add-to-cart-btn:hover {
            background-color: #333 !important;
            border-color: #333 !important;
            color: white !important;
        }

        .view-reviews-btn {
            background-color: #000 !important;
            border-color: #000 !important;
            color: white !important;
            border-radius: 0 !important;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.875rem;
        }

        .view-reviews-btn:hover {
            background-color: #333 !important;
            border-color: #333 !important;
            color: white !important;
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

        /* Reviews Section */
        .review-summary {
            font-size: 0.9rem;
            color: #666;
            margin-left: 1rem;
        }
        .rating-summary {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .average-rating {
            background: white !important;
            border: 2px solid #e9ecef;
        }
        .stars {
            color: #ffc107;
        }
        .review-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .no-reviews {
            background: #f8f9fa;
            border-radius: 10px;
            border: 2px dashed #dee2e6;
        }
        .progress-bar {
            background-color: #667eea;
        }
        .btn-outline-primary {
            border-color: #667eea;
            color: #667eea;
        }
        .btn-outline-primary:hover {
            background-color: #667eea;
            border-color: #667eea;
        }

        @media (max-width: 768px) {
            .product-container {
                grid-template-columns: 1fr;
                gap: 2rem;
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
        <jsp:include page="common/header.jsp"/>
        
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        <!-- Product Detail -->
        <main class="product-detail">
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

                    <!-- Include Variant Selector -->
                    <jsp:include page="common/variant-selector.jsp"/>

                    <!-- Product Details -->
                    <div class="product-details">
                        <div class="details-section">
                            <h3 class="details-title">Product Information</h3>
                            <div class="details-grid">
                                <div class="detail-item">
                                    <span class="detail-label">Brand:</span>
                                    <span class="detail-value">${product.brandName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Category:</span>
                                    <span class="detail-value">${product.categoryName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Material:</span>
                                    <span class="detail-value">${product.material}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Total Quantity:</span>
                                    <span class="detail-value">${product.totalQuantity} items</span>
                                </div>
                            </div>
                        </div>

                        <!-- Reviews Section -->
                        <div class="details-section">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h3 class="details-title mb-0">
                                    Product Reviews
                                    <c:if test="${totalReviews > 0}">
                                        <span class="review-summary">
                                            <i class="fas fa-star text-warning"></i>
                                            ${formattedRating}/5 (${totalReviews} reviews)
                                        </span>
                                    </c:if>
                                </h3>
                                <a href="${pageContext.request.contextPath}/reviews?productId=${product.productId}" 
                                   class="btn view-reviews-btn">
                                    <i class="fas fa-comments me-2"></i>
                                    <c:choose>
                                        <c:when test="${totalReviews > 0}">
                                            View All (${totalReviews})
                                        </c:when>
                                        <c:otherwise>
                                            View Reviews
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${totalReviews > 0}">
                                    <!-- Rating Summary -->
                                    <div class="rating-summary mb-3">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="average-rating text-center p-3 bg-light rounded">
                                                    <h2 class="text-primary mb-1">${formattedRating}</h2>
                                                    <div class="stars mb-2">
                                                        <c:forEach var="i" begin="1" end="5">
                                                            <i class="fas fa-star ${i <= averageRating ? 'text-warning' : 'text-muted'}"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <small class="text-muted">${totalReviews} reviews</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="rating-breakdown">
                                                    <c:forEach var="i" begin="5" end="1" step="-1">
                                                        <div class="rating-bar d-flex align-items-center mb-1">
                                                            <span class="me-2" style="width: 20px;">${i}★</span>
                                                            <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                                                <div class="progress-bar" role="progressbar" 
                                                                     style="width: ${ratingCounts[i] > 0 ? (ratingCounts[i] * 100.0 / totalReviews) : 0}%"></div>
                                                            </div>
                                                            <span class="text-muted" style="width: 30px; font-size: 0.8rem;">${ratingCounts[i]}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Reviews -->
                                    <div class="recent-reviews">
                                        <h5 class="mb-3">Recent Reviews</h5>
                                        <c:forEach var="review" items="${reviews}" end="2">
                                            <div class="review-item border-bottom pb-3 mb-3">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <strong>${review.customerName}</strong>
                                                        <c:if test="${not empty review.color}">
                                                            <span class="text-muted"> - ${review.color}</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="stars">
                                                        <c:forEach var="i" begin="1" end="5">
                                                            <i class="fas fa-star ${i <= review.star ? 'text-warning' : 'text-muted'}"></i>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                                <c:if test="${not empty review.reviewContent}">
                                                    <p class="mb-2">${review.reviewContent}</p>
                                                </c:if>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- View All Reviews Button -->
                                    <div class="text-center mt-3">
                                        <a href="${pageContext.request.contextPath}/reviews?productId=${product.productId}" 
                                           class="btn btn-outline-primary">
                                            <i class="fas fa-comments me-2"></i>
                                            View All Reviews (${totalReviews})
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-reviews text-center py-4">
                                        <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No Reviews Yet</h5>
                                        <p class="text-muted">Be the first to review this product!</p>
                                        <a href="${pageContext.request.contextPath}/reviews?productId=${product.productId}" 
                                           class="btn btn-outline-primary">
                                            <i class="fas fa-star me-2"></i>
                                            Write Review
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>

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
        <jsp:include page="common/footer.jsp"/>
    </body>
</html>