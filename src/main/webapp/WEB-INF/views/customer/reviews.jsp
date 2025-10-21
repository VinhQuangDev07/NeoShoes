<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
                transform: translateY(0);
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
                        </div>
                        <div class="row align-items-center mb-4">
                            <div class="col-md-3 text-center">
                                <div class="rating-score">${formattedRating}</div>
                                <div class="rating-text">Based on ${totalReviews} reviews</div>
                            </div>
                            <div class="col-md-9">
                                <div class="filter-section">
                                    <span class="filter-label">Rating:</span>
                                    <a href="?id=${product.productId}&rating=all&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${empty selectedRating ? 'active' : ''}">
                                        All
                                    </a>
                                    <a href="?id=${product.productId}&rating=5&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 5 ? 'active' : ''}">
                                        5 <i class="fas fa-star"></i>
                                    </a>
                                    <a href="?id=${product.productId}&rating=4&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 4 ? 'active' : ''}">
                                        4 <i class="fas fa-star"></i>
                                    </a>
                                    <a href="?id=${product.productId}&rating=3&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 3 ? 'active' : ''}">
                                        3 <i class="fas fa-star"></i>
                                    </a>
                                    <a href="?id=${product.productId}&rating=2&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 2 ? 'active' : ''}">
                                        2 <i class="fas fa-star"></i>
                                    </a>
                                    <a href="?id=${product.productId}&rating=1&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 1 ? 'active' : ''}">
                                        1 <i class="fas fa-star"></i>
                                    </a>
                                </div>
                                <div class="filter-section">
                                    <span class="filter-label">Time Posted:</span>
                                    <a href="?id=${product.productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=all" class="filter-btn ${selectedTime == 'all' || selectedTime == null || empty selectedTime ? 'active' : ''}">
                                        All Time
                                    </a>
                                    <a href="?id=${product.productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=today" class="filter-btn ${selectedTime == 'today' ? 'active' : ''}">
                                        Today
                                    </a>
                                    <a href="?id=${product.productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=week" class="filter-btn ${selectedTime == 'week' ? 'active' : ''}">
                                        This Week
                                    </a>
                                    <a href="?id=${product.productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=month" class="filter-btn ${selectedTime == 'month' ? 'active' : ''}">
                                        This Month
                                    </a>
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
                                                        <div style="color: gold; font-size: 18px;">
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
                                            <div style="color: #999; font-size: 14px;">
                                                ${fn:substring(review.createdAt, 0, 10)}
                                            </div>
                                        </div>
                                        <div style="margin-top: 15px;">
                                            <p style="margin: 0; color: #333; line-height: 1.6;">${review.reviewContent}</p>
                                        </div>
                                    </div>
                                </c:forEach>
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
            
        </script>
</div>