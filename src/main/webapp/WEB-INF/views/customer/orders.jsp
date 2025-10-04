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
            .order-card {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                margin-bottom: 20px;
                background: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .order-header {
                background: #f8f9fa;
                padding: 15px 20px;
                border-bottom: 1px solid #e0e0e0;
                border-radius: 8px 8px 0 0;
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
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                margin-right: 15px;
                border: 1px solid #e0e0e0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .item-details {
                flex: 1;
            }
            .item-name {
                font-weight: 600;
                margin-bottom: 5px;
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
                padding: 10px 20px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .review-btn:hover {
                background: #e0a800;
                border-color: #d39e00;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(255, 193, 7, 0.3);
            }
            .review-btn i {
                font-size: 16px;
            }
            .status-badge {
                padding: 4px 12px;
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
            .filter-tabs {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
                padding: 0 20px;
            }
            .filter-tab {
                padding: 10px 20px;
                border: 1px solid #ddd;
                background: white;
                border-radius: 4px;
                cursor: pointer;
                transition: all 0.3s;
            }
            .filter-tab.active {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }
            .delivery-info {
                background: #f8f9fa;
                padding: 15px 20px;
                border-top: 1px solid #e0e0e0;
                font-size: 14px;
                color: #666;
            }
            .rating {
                display: flex;
                gap: 5px;
                margin-top: 5px;
            }
            .rating i {
                font-size: 20px;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
            }
            .rating i:hover {
                color: #ffc107;
            }
        </style>
    </head>
    <body>


        <div class="container">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <jsp:include page="common/customer-sidebar.jsp"/>
                </div>

                <!-- Main Content -->
                <div class="col-lg-9">
                    <!-- Page Header -->
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex align-items-center mb-4">
                                    <i class="fas fa-folder-open me-3" style="font-size: 2rem; color: #007bff;"></i>
                                    <h1 class="display-6 fw-bold mb-0">Your Orders</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Filter Tabs -->
                    <div class="filter-tabs">
                        <div class="filter-tab active" onclick="filterOrders('all')">All</div>
                        <div class="filter-tab" onclick="filterOrders('pending')">Pending</div>
                        <div class="filter-tab" onclick="filterOrders('shipped')">Shipping</div>
                        <div class="filter-tab" onclick="filterOrders('completed')">Delivered</div>
                    </div>

                    <c:if test="${empty orders}">
                        <div class="text-center py-5">
                            <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">No orders yet</h4>
                            <p class="text-muted">You haven't placed any orders yet.</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>Start Shopping
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${not empty orders}">
                        <c:forEach items="${orders}" var="order">
                            <div class="order-card" data-status="${order.status.toLowerCase()}">
                                <!-- Order Header -->
                                <div class="order-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="fw-bold text-primary">Order: #${order.id}</span>
                                            <span class="text-muted ms-2">
                                                ${order.createdAt}
                                            </span>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:choose>
                                                <c:when test="${order.status == 'COMPLETED'}">
                                                    <span class="status-badge status-delivered">Delivered</span>
                                                </c:when>
                                                <c:when test="${order.status == 'SHIPPED'}">
                                                    <span class="status-badge status-shipped">Shipping</span>
                                                </c:when>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${order.status == 'CANCELED'}">
                                                    <span class="status-badge status-canceled">Canceled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-pending">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="fw-bold text-primary">$${order.totalAmount}</span>
                                            <a href="${pageContext.request.contextPath}/orders/detail?id=${order.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>Details
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Order Items -->
                                <div class="order-items">
                                    <c:forEach items="${order.items}" var="item">
                                        <div class="order-item">
                                            <img src="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=80&h=80&fit=crop&crop=center" 
                                                 alt="${item.productName}" class="item-image">
                                            <div class="item-details">
                                                <div class="item-name">${item.productName}</div>
                                                <div class="item-quantity">x${item.quantity}</div>
                                            </div>
                                            <div class="item-price">$${item.unitPrice}</div>
                                            <c:if test="${order.status == 'COMPLETED'}">
                                                <button class="review-btn" onclick="reviewProduct('${item.productName}', '${item.productName}')">
                                                    <i class="fas fa-star"></i>
                                                    <span>Review</span>
                                                </button>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Delivery Information -->
                                <div class="delivery-info">
                                    <i class="fas fa-truck me-2"></i>
                                    Delivery to: Demo Customer, 123 Main Street, Ho Chi Minh City | 0123456789
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
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

