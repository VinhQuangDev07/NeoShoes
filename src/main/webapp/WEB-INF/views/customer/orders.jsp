<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Your Orders - NeoShoes" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title><c:out value="${pageTitle != null ? pageTitle : 'NeoShoes'}"/></title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

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
                flex-wrap: wrap;
                gap: 15px;
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
            
            
            .status-badge {
                font-size: 0.8rem;
                padding: 0.25rem 0.5rem;
            }
            
            .badge.bg-secondary {
                background-color: #6c757d !important;
                color: white;
            }
            
            .order-actions {
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
            }
            
            .order-total {
                font-weight: 600;
                color: #007bff;
                font-size: 16px;
            }
            
            .action-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }
            
            .action-buttons .btn {
                font-size: 12px;
                padding: 6px 12px;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 4px;
                white-space: nowrap;
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
                display: inline-flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
            }
            
            .details-btn:hover {
                background: #0056b3;
                color: white;
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
            
            .item-review-actions {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-left: auto;
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
            
            /* Star Rating Styles */
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
                user-select: none;
            }
            
            .star:hover,
            .star.active {
                color: #ffc107;
            }
            
            .star:hover ~ .star {
                color: #ddd;
            }
            
            /* Loading Spinner */
            .btn-loading {
                position: relative;
                pointer-events: none;
            }
            
            .btn-loading::after {
                content: "";
                position: absolute;
                width: 16px;
                height: 16px;
                top: 50%;
                left: 50%;
                margin-left: -8px;
                margin-top: -8px;
                border: 2px solid #ffffff;
                border-radius: 50%;
                border-top-color: transparent;
                animation: spinner 0.6s linear infinite;
            }
            
            @keyframes spinner {
                to { transform: rotate(360deg); }
            }
            
            /* Responsive adjustments */
            @media (max-width: 768px) {
                .order-header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                
                .order-actions {
                    width: 100%;
                    justify-content: space-between;
                }
                
                .action-buttons {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        
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
                                Your Orders
                            </h1>
                            <c:if test="${not empty orders}">
                                <small class="text-muted">Found ${fn:length(orders)} orders</small>
                            </c:if>
                        </div>

                        <!-- Empty State -->
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

                        <!-- Orders List -->
                        <c:if test="${not empty orders}">
                            <c:forEach items="${orders}" var="order">
                                <div class="order-card" data-status="${order.status}">
                                    <!-- Order Header -->
                                    <div class="order-header">
                                        <div class="order-info">
                                            <span class="order-number">Order: #<c:out value="${order.orderId}"/></span>
                                            <span class="order-date" data-date="${order.placedAt}"></span>
                                            <span class="order-status">
                                                <c:choose>
                                                    <c:when test="${empty order.status}">
                                                        <span class="badge bg-secondary status-badge">No Status</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <span class="badge bg-warning status-badge">Pending</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'APPROVED'}">
                                                        <span class="badge bg-info status-badge">Approved</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'SHIPPED'}">
                                                        <span class="badge bg-primary status-badge">Shipped</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'COMPLETED'}">
                                                        <span class="badge bg-success status-badge">Completed</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger status-badge">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary status-badge">${order.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="order-actions">
                                            <span class="order-total">$<c:out value="${order.totalAmount}"/></span>
                                            <div class="action-buttons">
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
                                                        <c:set var="productName" value="${fn:toLowerCase(item.productName)}"/>
                                                        <c:choose>
                                                            <c:when test="${fn:contains(productName, 'vans')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:when test="${fn:contains(productName, 'nike')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:when test="${fn:contains(productName, 'adidas')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:when test="${fn:contains(productName, 'converse')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:when test="${fn:contains(productName, 'jordan')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:when test="${fn:contains(productName, 'puma')}">
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="imageUrl" value="https://images.unsplash.com/photo-1549298916-b41d501d3772?w=60&h=60&fit=crop&crop=center"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <img src="${imageUrl}" 
                                                             alt="<c:out value='${item.productName}'/>" 
                                                             class="item-image"
                                                             loading="lazy">
                                                        <div class="item-details">
                                                            <div class="item-name"><c:out value="${item.productName}"/></div>
                                                            <div class="item-quantity">x<c:out value="${item.detailQuantity}"/></div>
                                                        </div>
                                                        
                                                        <!-- Review Buttons for each item (on the right) -->
                                                        <div class="item-review-actions">
                                                            <c:choose>
                                                                <c:when test="${(order.paymentStatusId == completeStatusId || order.status == 'COMPLETED') && order.status != null && order.status != ''}">
                                                                    <!-- Order is completed/delivered - show review button for this item -->
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.review}">
                                                                            <!-- Review exists -->
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-warning"
                                                                                    data-action="edit"
                                                                                    data-review-id="${item.review.reviewId}"
                                                                                    data-star="${item.review.star}"
                                                                                    data-content="${fn:escapeXml(item.review.reviewContent)}"
                                                                                    data-variant-id="${item.productVariantId}"
                                                                                    data-product-name="${fn:escapeXml(item.productName)}">
                                                                                <i class="fas fa-edit"></i> Edit Review
                                                                            </button>
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-danger"
                                                                                    data-action="delete"
                                                                                    data-review-id="${item.review.reviewId}">
                                                                                <i class="fas fa-trash"></i> Delete
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- No review -->
                                                                            <button type="button" 
                                                                                    class="btn btn-sm btn-primary"
                                                                                    data-action="create"
                                                                                    data-variant-id="${item.productVariantId}"
                                                                                    data-product-name="${fn:escapeXml(item.productName)}">
                                                                                <i class="fas fa-star"></i> Write Review
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:when test="${order.status == 'CANCELLED'}">
                                                                    <!-- Order is cancelled -->
                                                                    <button type="button" class="btn btn-sm btn-secondary" disabled 
                                                                            title="Cannot review cancelled orders">
                                                                        <i class="fas fa-ban"></i> Cancelled
                                                                    </button>
                                                                </c:when>
                                                                <c:when test="${order.paymentStatusId == 4}">
                                                                    <!-- Payment is cancelled -->
                                                                    <button type="button" class="btn btn-sm btn-secondary" disabled 
                                                                            title="Payment cancelled - cannot review">
                                                                        <i class="fas fa-ban"></i> Payment Cancelled
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <!-- Order not completed -->
                                                                    <button type="button" class="btn btn-sm btn-secondary" disabled 
                                                                            title="You can only review products after delivery">
                                                                        <i class="fas fa-star"></i> Review
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        
                                                        <div class="item-price">$<c:out value="${item.detailPrice}"/></div>
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
                                                Delivery to: <c:out value="${order.recipientName}"/>, 
                                                <c:out value="${order.addressDetails}"/> | 
                                                <c:out value="${order.recipientPhone}"/>
                                            </c:when>
                                            <c:when test="${not empty order.addressDetails}">
                                                Delivery to: <c:out value="${order.addressDetails}"/>
                                            </c:when>
                                            <c:otherwise>
                                                Delivery to: Default Address
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        
                        <!-- Pagination -->
                        <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                    </div>
                </div>
            </div>
        </div>

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
                            <div class="star-rating" id="starRatingDisplay">
                                <input type="hidden" id="starRating" value="5">
                                <span class="star active" data-rating="1">★</span>
                                <span class="star active" data-rating="2">★</span>
                                <span class="star active" data-rating="3">★</span>
                                <span class="star active" data-rating="4">★</span>
                                <span class="star active" data-rating="5">★</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewText" class="form-label">Your Review:</label>
                            <textarea class="form-control" 
                                      id="reviewText" 
                                      rows="5" 
                                      maxlength="1000"
                                      placeholder="Share your experience with this product..."></textarea>
                            <small class="text-muted">Maximum 1000 characters</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="submitReviewBtn">Submit Review</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="common/footer.jsp"/>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Review management
            const ReviewManager = {
                currentReviewId: null,
                currentProductVariantId: null,
                currentAction: 'create',
                modal: null,
                
                init() {
                    this.modal = new bootstrap.Modal(document.getElementById('reviewModal'));
                    this.attachEventListeners();
                },
                
                attachEventListeners() {
                    // Star rating clicks
                    document.querySelectorAll('#starRatingDisplay .star').forEach(star => {
                        star.addEventListener('click', (e) => {
                            const rating = parseInt(e.target.dataset.rating);
                            this.setRating(rating);
                        });
                    });
                    
                    // Submit button
                    document.getElementById('submitReviewBtn').addEventListener('click', () => {
                        this.submitReview();
                    });
                    
                    // Action buttons (using event delegation)
                    document.addEventListener('click', (e) => {
                        const btn = e.target.closest('[data-action]');
                        if (!btn) return;
                        
                        const action = btn.dataset.action;
                        
                        if (action === 'create') {
                            this.openCreateModal(
                                btn.dataset.variantId,
                                btn.dataset.productName
                            );
                        } else if (action === 'edit') {
                            this.openEditModal(
                                btn.dataset.reviewId,
                                btn.dataset.star,
                                btn.dataset.content,
                                btn.dataset.variantId,
                                btn.dataset.productName
                            );
                        } else if (action === 'delete') {
                            this.deleteReview(btn.dataset.reviewId);
                        }
                    });
                },
                
                openCreateModal(variantId, productName) {
                    this.currentAction = 'create';
                    this.currentProductVariantId = variantId;
                    this.currentReviewId = null;
                    
                    document.getElementById('reviewModalLabel').textContent = 'Write Review - ' + productName;
                    document.getElementById('reviewText').value = '';
                    this.setRating(5);
                    
                    this.modal.show();
                },
                
                openEditModal(reviewId, star, content, variantId, productName) {
                    this.currentAction = 'update';
                    this.currentReviewId = reviewId;
                    this.currentProductVariantId = variantId;
                    
                    document.getElementById('reviewModalLabel').textContent = 'Edit Review - ' + productName;
                    document.getElementById('reviewText').value = content;
                    this.setRating(parseInt(star));
                    
                    this.modal.show();
                },
                
                setRating(rating) {
                    document.getElementById('starRating').value = rating;
                    
                    const stars = document.querySelectorAll('#starRatingDisplay .star');
                    stars.forEach((star, index) => {
                        if (index < rating) {
                            star.classList.add('active');
                        } else {
                            star.classList.remove('active');
                        }
                    });
                },
                
                submitReview() {
                    const star = document.getElementById('starRating').value;
                    const content = document.getElementById('reviewText').value.trim();
                    const submitBtn = document.getElementById('submitReviewBtn');
                    
                    // Validation
                    if (!star || star < 1 || star > 5) {
                        this.showAlert('Please select a rating.', 'warning');
                        return;
                    }
                    
                    if (!content) {
                        this.showAlert('Please write a review.', 'warning');
                        return;
                    }
                    
                    if (content.length > 1000) {
                        this.showAlert('Review is too long. Maximum 1000 characters.', 'warning');
                        return;
                    }
                    
                    // Show loading state
                    submitBtn.disabled = true;
                    submitBtn.classList.add('btn-loading');
                    const originalText = submitBtn.textContent;
                    submitBtn.textContent = 'Submitting...';
                    
                    // Create and submit form
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/reviews';
                    
                    const fields = {
                        action: this.currentAction + 'Review',
                        productVariantId: this.currentProductVariantId,
                        star: star,
                        reviewContent: content
                    };
                    
                    if (this.currentAction === 'update') {
                        fields.reviewId = this.currentReviewId;
                    }
                    
                    Object.entries(fields).forEach(([name, value]) => {
                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = name;
                        input.value = value;
                        form.appendChild(input);
                    });
                    
                    document.body.appendChild(form);
                    form.submit();
                },
                
                deleteReview(reviewId) {
                    if (!confirm('Are you sure you want to delete this review? This action cannot be undone.')) {
                        return;
                    }
                    
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/reviews';
                    
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
                },
                
                showAlert(message, type = 'info') {
                    const alertDiv = document.createElement('div');
                    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
                    alertDiv.role = 'alert';
                    alertDiv.innerHTML = `
                        <i class="fas fa-info-circle"></i>
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    `;
                    
                    const container = document.querySelector('.col-lg-9');
                    const firstChild = container.firstElementChild.nextElementSibling;
                    container.insertBefore(alertDiv, firstChild);
                    
                    // Auto dismiss after 5 seconds
                    setTimeout(() => {
                        alertDiv.remove();
                    }, 5000);
                }
            };
            
            // Initialize when DOM is ready
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize review manager
                ReviewManager.init();
                
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
                
                // Format datetime like in staff orders
                document.querySelectorAll('.order-date[data-date]').forEach(element => {
                    const dateStr = element.getAttribute('data-date');
                    if (dateStr) {
                        try {
                            const date = new Date(dateStr);
                            element.textContent = date.toLocaleString('vi-VN', {
                                year: 'numeric',
                                month: '2-digit',
                                day: '2-digit',
                                hour: '2-digit',
                                minute: '2-digit',
                                second: '2-digit'
                            });
                        } catch (e) {
                            element.textContent = dateStr;
                        }
                    }
                });
                
                // Auto-hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
            
            // Filter orders by status (if you add filter tabs later)
            function filterOrders(status) {
                const orderCards = document.querySelectorAll('.order-card');
                orderCards.forEach(card => {
                    const orderStatus = card.getAttribute('data-status');
                    
                    if (status === 'all' || orderStatus === status) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
            
            // Export to window for inline usage if needed
            window.ReviewManager = ReviewManager;
            window.filterOrders = filterOrders;
        </script>
    </body>
</html>