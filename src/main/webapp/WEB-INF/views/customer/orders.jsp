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
            .filter-tabs {
                display: flex;
                gap: 8px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .filter-tab {
                padding: 8px 16px;
                border: 1px solid #e0e0e0;
                background: white;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
                color: #666;
            }
            .filter-tab:hover {
                border-color: #007bff;
                color: #007bff;
            }
            .filter-tab.active {
                background: #007bff;
                color: white;
                border-color: #007bff;
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
            }
            .status-delivered {
                background: #d4edda;
                color: #155724;
            }
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            .status-shipped {
                background: #cce7ff;
                color: #004085;
            }
            .status-canceled {
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
            }
            .details-btn:hover {
                background: #0056b3;
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
            .item-quantity {
                color: #666;
                font-size: 14px;
            }
            .item-price {
                font-weight: 600;
                color: #333;
                margin-right: 15px;
            }
            .review-btn {
                background: #ffc107;
                border: 1px solid #ffc107;
                color: #000;
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .review-btn:hover {
                background: #e0a800;
                border-color: #d39e00;
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3);
            }
            .review-btn i {
                font-size: 14px;
            }
            .delivery-info {
                background: #f8f9fa;
                padding: 15px 20px;
                border-top: 1px solid #f0f0f0;
                font-size: 14px;
                color: #666;
                display: flex;
                align-items: center;
                gap: 8px;
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
            .user-profile-section {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 12px;
            }
            .user-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                object-fit: cover;
                border: 3px solid #007bff;
                box-shadow: 0 2px 8px rgba(0,123,255,0.3);
            }
            .user-info h5 {
                margin: 0;
                color: #333;
                font-weight: 600;
                font-size: 16px;
            }
            .user-info p {
                margin: 0;
                color: #666;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
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

                        <!-- Filter Tabs -->
                        <div class="filter-tabs">
                            <div class="filter-tab active" onclick="filterOrders('all')">All</div>
                            <div class="filter-tab" onclick="filterOrders('pending')">Pending</div>
                            <div class="filter-tab" onclick="filterOrders('processing')">Processing</div>
                            <div class="filter-tab" onclick="filterOrders('shipped')">Shipped</div>
                            <div class="filter-tab" onclick="filterOrders('completed')">Delivered</div>
                        </div>

                            <c:if test="${empty orders}">
                            <div class="empty-state">
                                <i class="fas fa-shopping-bag"></i>
                                <h4>No orders yet</h4>
                                <p>You haven't placed any orders yet.</p>
                                <button class="start-shopping-btn" onclick="window.location.href='${pageContext.request.contextPath}/products'">
                                    <i class="fas fa-shopping-cart"></i>
                                    Start Shopping
                                </button>
                            </div>
                            </c:if>

                            <c:if test="${not empty orders}">
                            <c:forEach items="${orders}" var="order">
                                <div class="order-card" data-status="${order.paymentStatusId == 1 ? 'pending' : order.paymentStatusId == 2 ? 'processing' : order.paymentStatusId == 3 ? 'shipped' : 'completed'}">
                                    <!-- Order Header -->
                                    <div class="order-header">
                                        <div class="order-info">
                                            <span class="order-number">Order: #${order.orderId}</span>
                                            <span class="order-date">
                                                <c:choose>
                                                    <c:when test="${order.placedAt != null}">
                                                        ${order.placedAt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="order-status ${order.paymentStatusId == 1 ? 'status-pending' : order.paymentStatusId == 2 ? 'status-pending' : order.paymentStatusId == 3 ? 'status-shipped' : 'status-delivered'}">
                                                ${order.paymentStatusId == 1 ? 'Pending' : order.paymentStatusId == 2 ? 'Processing' : order.paymentStatusId == 3 ? 'Shipped' : 'Delivered'}
                                            </span>
                                        </div>
                                        <div class="order-actions">
                                            <span class="order-total">$${order.totalAmount}</span>
                                            <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" 
                                               class="details-btn">
                                                <i class="fas fa-eye"></i>
                                                Details
                                            </a>
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
                                                        <!-- Review button temporarily disabled -->
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
        <script src="https://unpkg.com/lucide@latest"></script>
        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>
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

    </body>
</html>

