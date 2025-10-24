<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Only include CSS if not already included in parent page -->
<c:if test="${empty param.skipCSS}">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</c:if>

<style>
            /* Reviews Section - Same as product-detail.jsp */
            .container-fluid .bg-light {
                background-color: #f8f9fa !important;
                margin-top: 40px;
            }
            .review-header {
                background-color: #fff;
                border-radius: 10px;
                padding: 30px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .rating-score {
                font-size: 3rem;
                font-weight: bold;
                color: #333;
            }
            .rating-text {
                color: #666;
                font-size: 0.9rem;
            }
            .filter-section {
                margin-bottom: 15px;
            }
            .filter-label {
                font-weight: 600;
                color: #333;
                margin-right: 10px;
                display: inline-block;
            }
            .filter-btn {
                border: 1px solid #ddd;
                border-radius: 20px;
                padding: 8px 16px;
                margin: 5px;
                background-color: #fff;
                color: #666;
                font-size: 0.9rem;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }
            .filter-btn:hover {
                background-color: #f8f9fa;
                color: #666;
            }
            .filter-btn.active {
                background-color: #ffc107;
                border-color: #ffc107;
                color: #000;
            }
            .review-card {
                background-color: #fff;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 15px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                transform: translateY(0);
            }
            .review-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .reviewer-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                background-color: #e9ecef;
                transition: transform 0.3s ease;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
            }
            .reviewer-name {
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            .review-stars {
                color: #ffc107;
                transition: all 0.3s ease;
            }
            .review-stars .fas.fa-star {
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .review-time {
                color: #999;
                font-size: 0.85rem;
            }
            .review-text {
                color: #666;
                margin-top: 10px;
                line-height: 1.6;
            }
            .star-empty {
                color: #ddd;
            }
            .no-reviews {
                text-align: center;
                padding: 40px;
                color: #999;
            }
            
            
            /* Reviewer Avatar Colors */
            .reviewer-avatar.color-0 { background: linear-gradient(135deg, #007bff, #0056b3); }
            .reviewer-avatar.color-1 { background: linear-gradient(135deg, #6f42c1, #5a2d91); }
            .reviewer-avatar.color-2 { background: linear-gradient(135deg, #28a745, #1e7e34); }
            .reviewer-avatar.color-3 { background: linear-gradient(135deg, #fd7e14, #e55a00); }
            .reviewer-avatar.color-4 { background: linear-gradient(135deg, #e83e8c, #c2185b); }
            
        </style>
    <div class="reviews-container bg-light">
        <!-- Reviews Section - Same as product-detail.jsp -->
        <div class="container-fluid px-0">
            <div class="bg-light py-4">
                <div class="container">
                    <!-- Success/Error Messages -->
                    <c:if test="${param.success == '1'}">
                        <div id="successAlert" class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Success!</strong> Your review has been submitted successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            ${param.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error == '1'}">
                        <div id="errorAlert" class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Error!</strong> Failed to submit your review. Please try again.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    
                    <!-- Review Header -->
                    <div class="review-header">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0">Reviews</h4>
                            <c:if test="${param.showReplyButton == 'true'}">
                                <button onclick="goBack()" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>Back
                                </button>
                            </c:if>
                        </div>
                        <div class="row align-items-center mb-4">
                            <div class="col-md-3 text-center">
                                <div class="rating-score">${formattedRating}</div>
                                <div class="rating-text">Based on ${totalReviews} reviews</div>
                            </div>
                            <div class="col-md-9">
                                <div class="filter-section">
                                    <span class="filter-label">Rating:</span>
                                    <button type="button" onclick="return filterReviews('all', 'all')" class="filter-btn" data-rating="all">
                                        All
                                    </button>
                                    <button type="button" onclick="return filterReviews('5', 'all')" class="filter-btn" data-rating="5">
                                        5 <i class="fas fa-star"></i>
                                    </button>
                                    <button type="button" onclick="return filterReviews('4', 'all')" class="filter-btn" data-rating="4">
                                        4 <i class="fas fa-star"></i>
                                    </button>
                                    <button type="button" onclick="return filterReviews('3', 'all')" class="filter-btn" data-rating="3">
                                        3 <i class="fas fa-star"></i>
                                    </button>
                                    <button type="button" onclick="return filterReviews('2', 'all')" class="filter-btn" data-rating="2">
                                        2 <i class="fas fa-star"></i>
                                    </button>
                                    <button type="button" onclick="return filterReviews('1', 'all')" class="filter-btn" data-rating="1">
                                        1 <i class="fas fa-star"></i>
                                    </button>
                                </div>
                                <div class="filter-section">
                                    <span class="filter-label">Time Posted:</span>
                                    <button type="button" onclick="return filterReviews('all', 'all')" class="filter-btn" data-time="all">
                                        All Time
                                    </button>
                                    <button type="button" onclick="return filterReviews('all', 'today')" class="filter-btn" data-time="today">
                                        Today
                                    </button>
                                    <button type="button" onclick="return filterReviews('all', 'week')" class="filter-btn" data-time="week">
                                        This Week
                                    </button>
                                    <button type="button" onclick="return filterReviews('all', 'month')" class="filter-btn" data-time="month">
                                        This Month
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-muted small">
                            Showing ${fn:length(reviews)} of ${totalReviews} review(s)
                        </div>
                    </div>


                    <!-- Reviews List -->
                    <div id="reviewsList">
                        
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <div class="no-reviews">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <p>No reviews found</p>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <div id="reviews-container">
                                <c:forEach var="review" items="${reviews}" varStatus="status">
                                    <!-- BEAUTIFUL REVIEW CARD -->
                                    <div class="review-card mb-3" style="background-color: #fff; border-radius: 10px; padding: 20px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                        <div style="display: flex; justify-content: space-between; align-items: start;">
                                            <div style="display: flex; gap: 15px;">
                                                <div style="width: 50px; height: 50px; border-radius: 50%; background: linear-gradient(135deg, #007bff, #0056b3); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 18px;">
                                                    ${fn:substring(review.customerName, 0, 1)}
                                                </div>
                                                <div>
                                                    <div style="font-weight: bold; color: #333; margin-bottom: 5px;">${review.customerName}</div>
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <div class="review-rating" data-rating="${review.star}" style="color: gold; font-size: 18px;">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <c:choose>
                                                                    <c:when test="${i <= review.star}">★</c:when>
                                                                    <c:otherwise>☆</c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </div>
                                                        <span style="color: #666; font-size: 14px;">${review.star}/5</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="review-date" style="color: #999; font-size: 14px;" data-date="${review.createdAt}">
                                                ${fn:substring(review.createdAt, 0, 10)}
                                            </div>
                                        </div>
                                        <div style="margin-top: 15px;">
                                            <p style="margin: 0; color: #333; line-height: 1.6;">${review.reviewContent}</p>
                                        </div>
                                        
                                        <!-- Staff Reply Button (only show if showReplyButton is true and no existing reply) -->
                                        <c:if test="${(param.showReplyButton == 'true' || param.showReplyButton == null) && empty review.staffReply}">
                                            <div style="margin-top: 15px;">
                                                <button class="btn btn-outline-primary btn-sm" onclick="replyToReview(${review.reviewId})">
                                                    <i class="fas fa-reply me-1"></i>Reply
                                                </button>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Edit Reply Button (only show if showReplyButton is true and reply exists) -->
                                        <c:if test="${(param.showReplyButton == 'true' || param.showReplyButton == null) && not empty review.staffReply}">
                                            <div style="margin-top: 15px;">
                                                <button class="btn btn-outline-warning btn-sm" onclick="document.getElementById('editReplyForm-${review.reviewId}').style.display = 'block';">
                                                    <i class="fas fa-edit me-1"></i>Edit 
                                                </button>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Staff Reply Section -->
                                        <c:if test="${not empty review.staffReply}">
                                            <div style="background-color: #f8f9fa; border-left: 4px solid #007bff; border-radius: 8px; padding: 16px; margin-top: 16px;">
                                                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                                                    <span style="color: #666; font-size: 14px;">
                                                        Reply by ${review.staffReply.staffName} • ${fn:substring(review.staffReply.createdAt, 0, 10)} ${fn:substring(review.staffReply.createdAt, 11, 16)}
                                                    </span>
                                                </div>
                                                <p style="margin: 0; color: #333; line-height: 1.6;">${review.staffReply.content}</p>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Reply Form (Hidden by default, only show if showReplyButton is true and no existing reply) -->
                                        <c:if test="${(param.showReplyButton == 'true' || param.showReplyButton == null) && empty review.staffReply}">
                                            <div id="replyForm-${review.reviewId}" class="reply-form" style="display: none; background-color: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; margin-top: 16px;">
                                                <form method="POST" action="<c:url value='/reviews'/>">
                                                    <input type="hidden" name="action" value="reply-review">
                                                    <input type="hidden" name="productId" value="${productId}">
                                                    <input type="hidden" name="reviewId" value="${review.reviewId}">
                                                    
                                                    <label for="replyContent-${review.reviewId}" style="font-weight: 600; color: #374151; margin-bottom: 8px; display: block;">Reply</label>
                                                    <textarea class="form-control" name="replyContent" id="replyContent-${review.reviewId}" 
                                                              placeholder="Write your reply here..." required style="border: 1px solid #d1d5db; border-radius: 6px; padding: 12px; font-size: 14px; resize: vertical; min-height: 100px; width: 100%;"></textarea>
                                                    
                                                    <div style="margin-top: 12px;">
                                                        <button type="submit" style="background-color: #3b82f6; border: none; color: white; padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500; margin-right: 8px;">
                                                            <i class="fas fa-paper-plane me-1"></i>Send Reply
                                                        </button>
                                                        <button type="button" onclick="cancelReply(${review.reviewId})" style="background-color: #6b7280; border: none; color: white; padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500;">
                                                            <i class="fas fa-times me-1"></i>Cancel
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Edit Reply Form (Hidden by default, only show if showReplyButton is true and reply exists) -->
                                        <c:if test="${(param.showReplyButton == 'true' || param.showReplyButton == null) && not empty review.staffReply}">
                                            <div id="editReplyForm-${review.reviewId}" class="edit-reply-form" style="display: none; background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 16px; margin-top: 16px;">
                                                <form method="POST" action="<c:url value='/reviews'/>">
                                                    <input type="hidden" name="action" value="edit-reply">
                                                    <input type="hidden" name="productId" value="${productId}">
                                                    <input type="hidden" name="reviewId" value="${review.reviewId}">
                                                    <input type="hidden" name="replyId" value="${review.staffReply.staffReplyId}">
                                                    
                                                    <label for="editReplyContent-${review.reviewId}" style="font-weight: 600; color: #856404; margin-bottom: 8px; display: block;">Edit Reply</label>
                                                    <textarea class="form-control" name="replyContent" id="editReplyContent-${review.reviewId}" 
                                                              required style="border: 1px solid #d1d5db; border-radius: 6px; padding: 12px; font-size: 14px; resize: vertical; min-height: 100px; width: 100%;">${review.staffReply.content}</textarea>
                                                    
                                                    <div style="margin-top: 12px;">
                                                        <button type="submit" style="background-color: #ffc107; border: none; color: #000; padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500; margin-right: 8px;">
                                                            <i class="fas fa-save me-1"></i>Update Reply
                                                        </button>
                                                        <button type="button" onclick="document.getElementById('editReplyForm-${review.reviewId}').style.display = 'none';" style="background-color: #6b7280; border: none; color: white; padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500;">
                                                            <i class="fas fa-times me-1"></i>Cancel
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Auto-hide success/error messages and clear URL
            setTimeout(function() {
                const successAlert = document.getElementById('successAlert');
                const errorAlert = document.getElementById('errorAlert');
                
                if (successAlert || errorAlert) {
                    // Hide the alert after 5 seconds
                    setTimeout(function() {
                        if (successAlert) successAlert.style.display = 'none';
                        if (errorAlert) errorAlert.style.display = 'none';
                    }, 5000);
                    
                    // Clear URL parameters after showing the message
                    if (window.location.search.includes('success=1') || window.location.search.includes('error=1')) {
                        const url = new URL(window.location);
                        url.searchParams.delete('success');
                        url.searchParams.delete('error');
                        window.history.replaceState({}, document.title, url.pathname + url.search);
                    }
                }
            }, 100);
            
            // Reply functions
            function replyToReview(reviewId) {
                // Hide all other reply forms
                document.querySelectorAll('.reply-form').forEach(form => {
                    form.style.display = 'none';
                });
                
                // Show the selected reply form
                document.getElementById('replyForm-' + reviewId).style.display = 'block';
                
                // Focus on textarea
                document.getElementById('replyContent-' + reviewId).focus();
            }

            function cancelReply(reviewId) {
                // Hide the reply form
                document.getElementById('replyForm-' + reviewId).style.display = 'none';
                
                // Clear the textarea
                document.getElementById('replyContent-' + reviewId).value = '';
            }
            
            
            // Simple filter function
            function filterReviews(rating, time) {
                // Prevent any default behavior
                if (window.event) {
                    window.event.preventDefault();
                    window.event.stopPropagation();
                    window.event.returnValue = false;
                }
                
                console.log('Filtering with rating:', rating, 'time:', time);
                
                // Update active buttons
                updateActiveButtons(rating, time);
                
                // Get all review cards
                const reviewCards = document.querySelectorAll('.review-card');
                let visibleCount = 0;
                
                reviewCards.forEach(card => {
                    let showCard = true;
                    
                    // Rating filter
                    if (rating !== 'all') {
                        const ratingElement = card.querySelector('.review-rating');
                        if (ratingElement) {
                            const reviewRating = ratingElement.getAttribute('data-rating');
                            if (reviewRating != rating) {
                                showCard = false;
                            }
                        }
                    }
                    
                    // Time filter
                    if (time !== 'all' && showCard) {
                        const dateElement = card.querySelector('.review-date');
                        if (dateElement) {
                            const reviewDate = new Date(dateElement.getAttribute('data-date'));
                            const now = new Date();
                            const diffTime = now - reviewDate;
                            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                            
                            switch(time) {
                                case 'today':
                                    if (diffDays > 1) showCard = false;
                                    break;
                                case 'week':
                                    if (diffDays > 7) showCard = false;
                                    break;
                                case 'month':
                                    if (diffDays > 30) showCard = false;
                                    break;
                            }
                        }
                    }
                    
                    // Show/hide card
                    if (showCard) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });
                
                // Update count
                const countElement = document.querySelector('.text-muted.small');
                if (countElement) {
                    countElement.textContent = 'Showing ' + visibleCount + ' of ' + reviewCards.length + ' review(s)';
                }
                
                // Show no results message if needed
                const noResults = document.getElementById('no-results-message');
                if (visibleCount === 0) {
                    if (!noResults) {
                        const reviewsContainer = document.getElementById('reviews-container');
                        if (reviewsContainer) {
                            const message = document.createElement('div');
                            message.id = 'no-results-message';
                            message.className = 'text-center text-muted py-4';
                            message.textContent = 'No reviews match your filter criteria.';
                            reviewsContainer.appendChild(message);
                        }
                    }
                } else {
                    if (noResults) {
                        noResults.remove();
                    }
                }
                
                return false;
            }
            
            function updateActiveButtons(rating, time) {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                
                // Add active class to rating buttons
                document.querySelectorAll('.filter-btn[data-rating]').forEach(btn => {
                    if (btn.getAttribute('data-rating') === rating) {
                        btn.classList.add('active');
                    }
                });
                
                // Add active class to time buttons
                document.querySelectorAll('.filter-btn[data-time]').forEach(btn => {
                    if (btn.getAttribute('data-time') === time) {
                        btn.classList.add('active');
                    }
                });
            }
            
            // Make functions globally available
            window.filterReviews = filterReviews;
            window.updateActiveButtons = updateActiveButtons;
            
            // Back button function
            function goBack() {
                // Get productId from URL parameter
                const urlParams = new URLSearchParams(window.location.search);
                const productId = urlParams.get('productId');
                
                if (productId) {
                    // Go back to staff product detail with specific productId
                    window.location.href = '/NeoShoes/staff/product?action=detail&productId=' + productId;
                } else {
                    // Fallback to staff product list
                    window.location.href = '/NeoShoes/staff/product';
                }
            }
            window.goBack = goBack;
            
            // Initialize on page load
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Reviews page initialized');
                // Set initial active state - only "All" buttons should be active
                updateActiveButtons('all', 'all');
            });
            
        </script>
       
</div>