<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Your Orders - NeoShoes" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle != null ? pageTitle : 'NeoShoes'}</title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <style>
            /* Orders-specific sidebar adjustments */
            .customer-sidebar {
                min-height: 350px !important;
            }

            .orders-container {
                background: #f8f9fa;
                min-height: 100vh;
                padding: 20px 0;
            }
            .orders-header {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .orders-title {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 0;
            }
            .orders-icon {
                width: 40px;
                height: 40px;
                background: #007bff;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 18px;
            }
            .order-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .order-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            }
            .order-header {
                padding: 20px;
                border-bottom: 1px solid #f0f0f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .order-info {
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
            }
            .order-number {
                font-weight: 600;
                color: #007bff;
                font-size: 16px;
            }
            .order-date {
                color: #666;
                font-size: 14px;
            }
            .order-status {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: capitalize;
            }
            .status-APPROVED, .status-delivered {
                background: #d4edda;
                color: #155724;
            }
            .status-PENDING {
                background: #fff3cd;
                color: #856404;
            }
            .status-processing {
                background: #d1ecf1;
                color: #0c5460;
            }
            .status-shipped, .status-shipping {
                background: #cce7ff;
                color: #004085;
            }
            .status-canceled, .status-cancelled {
            
                background: #f8d7da;
                color: #721c24;
            }
            .order-actions {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .order-total {
                font-weight: 600;
                color: #007bff;
                font-size: 16px;
            }
            .details-btn {
                background: #007bff;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.3s ease;
                display: flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
            }
            .details-btn:hover {
                background: #0056b3;
                color: white;
            }
            
            .action-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
            }
            
            .action-buttons .btn {
                font-size: 12px;
                padding: 6px 12px;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .order-items {
                padding: 20px;
            }
            .order-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .order-item:last-child {
                border-bottom: none;
            }
            .item-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 15px;
                border: 1px solid #e0e0e0;
            }
            .item-details {
                flex: 1;
            }
            .item-name {
                font-weight: 600;
                margin-bottom: 4px;
                color: #333;
            }
            .item-variant {
                color: #999;
                font-size: 13px;
                margin-bottom: 2px;
            }
            .item-quantity {
                color: #666;
                font-size: 14px;
            }
            .item-price {
                font-weight: 600;
                color: #333;
                margin-right: 15px;
            }
            .delivery-info {
                background: #f8f9fa;
                padding: 15px 20px;
                border-top: 1px solid #f0f0f0;
                font-size: 14px;
                color: #666;
                display: flex;
                align-items: flex-start;
                gap: 8px;
            }
            .delivery-info i {
                margin-top: 2px;
            }
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .empty-state i {
                font-size: 4rem;
                color: #ccc;
                margin-bottom: 20px;
            }
            .empty-state h4 {
                color: #666;
                margin-bottom: 10px;
            }
            .empty-state p {
                color: #999;
                margin-bottom: 20px;
            }
            .start-shopping-btn {
                background: #007bff;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .start-shopping-btn:hover {
                background: #0056b3;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/header.jsp"/>
        
        <div class="orders-container">
            <div class="container">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-lg-3">

                        <jsp:include page="common/customer-sidebar.jsp"/>
                    </div>

                    <!-- Main Content -->
                    <div class="col-lg-9">

                        <!-- Page Header -->
                        <div class="orders-header">
                            <h1 class="orders-title">
                                <div class="orders-icon">
                                    <i class="fas fa-shopping-bag"></i>
                                </div>
                                Your Orders
                            </h1>
                            <!-- Debug Info (remove in production) -->
                            <c:if test="${not empty orders}">
                                <small class="text-muted">Found ${orders.size()} orders</small>
                            </c:if>
                        </div>

                        <!-- Success/Error Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i>
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Flash Messages from Session -->
                        <c:if test="${not empty sessionScope.flash}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i>
                                ${sessionScope.flash}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="flash" scope="session"/>
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.flash_error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i>
                                ${sessionScope.flash_error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                            <c:remove var="flash_error" scope="session"/>
                        </c:if>


                        <c:if test="${empty orders}">
                            <div class="empty-state">
                                <i class="fas fa-shopping-bag"></i>
                                <h4>No orders yet</h4>
                                <p>You haven't placed any orders yet.</p>
                                <button class="start-shopping-btn" onclick="window.location.href = '${pageContext.request.contextPath}/products'">
                                    <i class="fas fa-shopping-cart"></i>
                                    Start Shopping
                                </button>
                            </div>
                        </c:if>

                        <c:if test="${not empty orders}">
                            <c:forEach items="${orders}" var="order">
                                <div class="order-card" data-status="${order.status}">
                                    <!-- Order Header -->
                                    <div class="order-header">
                                        <div class="order-info">
                                            <span class="order-number">Order: #${order.orderId}</span>
                                            <span class="order-date">${order.placedAt}</span>
                                            <span class="order-status status-${order.status}">${order.status}
                                            </span>
                                        </div>
                                        <div class="order-actions">
                                            <span class="order-total">$${order.totalAmount}</span>
                                            <div class="action-buttons">
                                                <c:choose>
                                                    <c:when test="${order.paymentStatusId == completeStatusId}">
                                                        <!-- Order is completed/delivered - check if review exists -->
                                                        <c:choose>
                                                            <c:when test="${order.items[0].review != null}">
                                                                <!-- Review exists - show edit/delete buttons -->
                                                                <button type="button" class="btn btn-sm btn-warning" 
                                                                        onclick="openEditReviewModal(${order.items[0].review.reviewId}, ${order.items[0].review.star}, '${order.items[0].review.reviewContent}', ${order.items[0].productVariantId}, '${order.items[0].productName}')">
                                                                    <i class="fas fa-edit"></i> Edit Review
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-danger" 
                                                                        onclick="deleteReview(${order.items[0].review.reviewId})">
                                                                    <i class="fas fa-trash"></i> Delete
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- No review - show write review button -->
                                                                <button type="button" class="btn btn-sm btn-primary" 
                                                                        onclick="openReviewModal(${order.items[0].productVariantId}, '${order.items[0].productName}')">
                                                                    <i class="fas fa-star"></i> Write Review
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- Order not completed - disable review -->
                                                        <button type="button" class="btn btn-sm btn-secondary" disabled 
                                                                title="You can only review products after delivery">
                                                            <i class="fas fa-star"></i> Review
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" 
                                               class="details-btn">
                                                <i class="fas fa-eye"></i>
                                                Details
                                            </a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Order Items -->
                                    <div class="order-items">
                                        <c:choose>
                                            <c:when test="${not empty order.items}">
                                        <c:forEach items="${order.items}" var="item">
                                            <div class="order-item">
                                                <c:choose>
                                                    <c:when test="${item.productName.contains('Vans')}">
                                                        <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Nike')}">
                                                        <img src="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Adidas')}">
                                                        <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Converse')}">
                                                        <img src="https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Jordan')}">
                                                        <img src="https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Puma')}">
                                                        <img src="https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('Reebok')}">
                                                        <img src="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:when test="${item.productName.contains('New Balance')}">
                                                        <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center" 
                                                             alt="${item.productName}" class="item-image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-details">
                                                    <div class="item-name">${item.productName}</div>
                                                    <div class="item-quantity">x${item.detailQuantity}</div>
                                                </div>
                                                <div class="item-price">$${item.detailPrice}</div>
                                            </div>
                                        </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="order-item">
                                                    <div class="item-details">
                                                        <div class="item-name">No items found</div>
                                                        <div class="item-quantity">Please check order details</div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Delivery Information -->
                                    <div class="delivery-info">
                                        <i class="fas fa-truck"></i>
                                        <c:choose>
                                            <c:when test="${not empty order.recipientName}">
                                                Delivery to: ${order.recipientName}, ${order.addressDetails} | ${order.recipientPhone}
                                            </c:when>
                                            <c:otherwise>
                                                Delivery to: Default Address
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    // Filter orders by status
                                    function filterOrders(status) {
                                        // Update active tab
                                        document.querySelectorAll('.filter-tab').forEach(tab => {
                                            tab.classList.remove('active');
                                        });
                                        event.target.classList.add('active');

                                        // Show/hide orders based on status
                                        const orderCards = document.querySelectorAll('.order-card');
                                        orderCards.forEach(card => {
                                            const orderStatus = card.getAttribute('data-status');
                                            console.log('Filtering:', status, 'Order status:', orderStatus); // Debug log

                                            if (status === 'all' || orderStatus === status) {
                                                card.style.display = 'block';
                                            } else {
                                                card.style.display = 'none';
                                            }
                                        });
                                    }

                                    // Review product function
                                    function reviewProduct(productName, productId) {
                                        // Create review modal
                                        const modal = document.createElement('div');
                                        modal.className = 'modal fade';
                                        modal.innerHTML = `
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Review Product</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <h6>${productName}</h6>
                                <div class="mb-3">
                                    <label class="form-label">Rating</label>
                                    <div class="rating">
                                        <i class="fas fa-star" data-rating="1"></i>
                                        <i class="fas fa-star" data-rating="2"></i>
                                        <i class="fas fa-star" data-rating="3"></i>
                                        <i class="fas fa-star" data-rating="4"></i>
                                        <i class="fas fa-star" data-rating="5"></i>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="reviewText" class="form-label">Your Review</label>
                                    <textarea class="form-control" id="reviewText" rows="4" placeholder="Share your experience with this product..."></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-warning" onclick="submitReview('${productName}')">Submit Review</button>
                </div>
            </div>
        </div>
                `;

                                        document.body.appendChild(modal);
                                        const bsModal = new bootstrap.Modal(modal);
                                        bsModal.show();

                                        // Rating functionality
                                        const stars = modal.querySelectorAll('.rating i');
                                        let selectedRating = 0;

                                        stars.forEach((star, index) => {
                                            star.addEventListener('click', () => {
                                                selectedRating = index + 1;
                                                stars.forEach((s, i) => {
                                                    s.style.color = i < selectedRating ? '#ffc107' : '#ddd';
                                                });
                                            });
                                        });

                                        // Clean up modal when hidden
                                        modal.addEventListener('hidden.bs.modal', () => {
                                            document.body.removeChild(modal);
                                        });
                                    }

                                    // Submit review function
                                    function submitReview(productName) {
                                        const reviewText = document.getElementById('reviewText').value;
                                        if (reviewText.trim() === '') {
                                            alert('Please write a review before submitting.');
                                            return;
                                        }

                                        // Simulate API call
                                        setTimeout(() => {
                                            alert('Thank you for your review of ' + productName + '!');
                                            // Close modal
                                            const modal = document.querySelector('.modal.show');
                                            if (modal) {
                                                const bsModal = bootstrap.Modal.getInstance(modal);
                                                bsModal.hide();
                                            }
                                        }, 500);
                                    }
                                                    // Review modal functions
                                                    let currentReviewId = null;
                                                    let currentProductVariantId = null;
                                                    let currentAction = 'create';

                                                    function openReviewModal(productVariantId, productName) {
                                                        currentProductVariantId = productVariantId;
                                                        currentAction = 'create';
                                                        currentReviewId = null;
                                                        
                                                        document.getElementById('reviewModalLabel').textContent = 'Write Review - ' + productName;
                                                        document.getElementById('reviewText').value = '';
                                                        document.getElementById('starRating').value = 5;
                                                        updateStarDisplay(5);
                                                        
                                                        const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
                                                        modal.show();
                                                    }

                                                    function openEditReviewModal(reviewId, star, content, productVariantId, productName) {
                                                        currentReviewId = reviewId;
                                                        currentProductVariantId = productVariantId;
                                                        currentAction = 'update';
                                                        
                                                        document.getElementById('reviewModalLabel').textContent = 'Edit Review - ' + productName;
                                                        document.getElementById('reviewText').value = content;
                                                        document.getElementById('starRating').value = star;
                                                        updateStarDisplay(star);
                                                        
                                                        const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
                                                        modal.show();
                                                    }

                                                    function deleteReview(reviewId) {
                                                        if (confirm('Are you sure you want to delete this review?')) {
                                                            const form = document.createElement('form');
                                                            form.method = 'POST';
                                                            form.action = '<%= request.getContextPath()%>/orders';
                                                            
                                                            const actionInput = document.createElement('input');
                                                            actionInput.type = 'hidden';
                                                            actionInput.name = 'action';
                                                            actionInput.value = 'deleteReview';
                                                            
                                                            const reviewIdInput = document.createElement('input');
                                                            reviewIdInput.type = 'hidden';
                                                            reviewIdInput.name = 'reviewId';
                                                            reviewIdInput.value = reviewId;
                                                            
                                                            form.appendChild(actionInput);
                                                            form.appendChild(reviewIdInput);
                                                            document.body.appendChild(form);
                                                            form.submit();
                                                        }
                                                    }

                                                    function updateStarDisplay(rating) {
                                                        const stars = document.querySelectorAll('.star-rating .star');
                                                        stars.forEach((star, index) => {
                                                            if (index < rating) {
                                                                star.classList.add('active');
                                                            } else {
                                                                star.classList.remove('active');
                                                            }
                                                        });
                                                    }

                                                    function setRating(rating) {
                                                        document.getElementById('starRating').value = rating;
                                                        updateStarDisplay(rating);
                                                    }

                                                    function submitReview() {
                                                        const star = document.getElementById('starRating').value;
                                                        const content = document.getElementById('reviewText').value.trim();
                                                        
                                                        if (!star || star < 1 || star > 5) {
                                                            alert('Please select a rating.');
                                                            return;
                                                        }
                                                        
                                                        if (!content) {
                                                            alert('Please write a review.');
                                                            return;
                                                        }

                                                        const form = document.createElement('form');
                                                        form.method = 'POST';
                                                        form.action = '<%= request.getContextPath()%>/orders';
                                                        
                                                        const actionInput = document.createElement('input');
                                                        actionInput.type = 'hidden';
                                                        actionInput.name = 'action';
                                                        actionInput.value = currentAction + 'Review';
                                                        
                                                        const productVariantInput = document.createElement('input');
                                                        productVariantInput.type = 'hidden';
                                                        productVariantInput.name = 'productVariantId';
                                                        productVariantInput.value = currentProductVariantId;
                                                        
                                                        const starInput = document.createElement('input');
                                                        starInput.type = 'hidden';
                                                        starInput.name = 'star';
                                                        starInput.value = star;
                                                        
                                                        const contentInput = document.createElement('input');
                                                        contentInput.type = 'hidden';
                                                        contentInput.name = 'reviewContent';
                                                        contentInput.value = content;
                                                        
                                                        if (currentAction === 'update') {
                                                            const reviewIdInput = document.createElement('input');
                                                            reviewIdInput.type = 'hidden';
                                                            reviewIdInput.name = 'reviewId';
                                                            reviewIdInput.value = currentReviewId;
                                                            form.appendChild(reviewIdInput);
                                                        }
                                                        
                                                        form.appendChild(actionInput);
                                                        form.appendChild(productVariantInput);
                                                        form.appendChild(starInput);
                                                        form.appendChild(contentInput);
                                                        
                                                        document.body.appendChild(form);
                                                        form.submit();
                                                    }

                                    // Initialize page
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Set active menu based on current page
                                        const currentPath = window.location.pathname;
                                        const menuLinks = document.querySelectorAll('.nav-link-item');

                                        menuLinks.forEach(link => {
                                            const linkHref = link.getAttribute('href');
                                            link.classList.remove('active');

                                            if (currentPath.includes(linkHref.split('/').pop())) {
                                                link.classList.add('active');
                                            }
                                        });

                                        // Default to orders if no match
                                        const hasActive = document.querySelector('.nav-link-item.active');
                                        if (!hasActive) {
                                            const ordersLink = document.getElementById('order');
                                            if (ordersLink) {
                                                ordersLink.classList.add('active');
                                            }
                                        }
                                    });

                                    // Initialize Lucide icons
                                    lucide.createIcons();

                                    // Set active menu based on current page
                                    document.addEventListener("DOMContentLoaded", () => {
                                        const currentPath = window.location.pathname;
                                        const menuLinks = document.querySelectorAll('.nav-link-item');

                                        menuLinks.forEach(link => {
                                            const linkHref = link.getAttribute('href');

                                            // Remove active from all
                                            link.classList.remove('active');

                                            // Check if current path matches link href
                                            if (currentPath.includes(linkHref.split('/').pop())) {
                                                link.classList.add('active');
                                            }
                                        });

                                        // Default to profile if no match
                                        const hasActive = document.querySelector('.nav-link-item.active');
                                        if (!hasActive) {
                                            document.getElementById('profile').classList.add('active');
                                        }
                                    });
        </script>

        <!-- Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel">Write Review</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Rating:</label>
                            <div class="star-rating">
                                <input type="hidden" id="starRating" value="5">
                                <span class="star" onclick="setRating(1)">★</span>
                                <span class="star" onclick="setRating(2)">★</span>
                                <span class="star" onclick="setRating(3)">★</span>
                                <span class="star" onclick="setRating(4)">★</span>
                                <span class="star active" onclick="setRating(5)">★</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewText" class="form-label">Your Review:</label>
                            <textarea class="form-control" id="reviewText" rows="5" placeholder="Share your experience with this product..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="submitReview()">Submit Review</button>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .star-rating {
                display: flex;
                gap: 5px;
                margin-bottom: 10px;
            }
            
            .star {
                font-size: 30px;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
            }
            
            .star:hover,
            .star.active {
                color: #ffc107;
            }
            
            .star:hover ~ .star {
                color: #ddd;
            }
        </style>

        <!-- Footer -->
        <jsp:include page="common/footer.jsp"/>

    </body>
</html>

