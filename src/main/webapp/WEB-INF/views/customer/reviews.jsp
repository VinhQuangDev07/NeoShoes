<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Product Reviews - NeoShoes" scope="request"/>

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
            .filters-container {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: center;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <!-- Review Header -->
            <div class="review-header">
                <h4 class="mb-4">Reviews</h4>
                <div class="row align-items-center mb-4">
                    <div class="col-md-3 text-center">
                        <div class="rating-score">4,0</div>
                        <div class="rating-text">Based on ${reviewCount} reviews</div>
                    </div>
                    <div class="col-md-9">
                        <div class="filter-section">
                            <span class="filter-label">Rating:</span>
                            <a href="?productId=${productId}&rating=all&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${empty selectedRating ? 'active' : ''}">
                                All
                            </a>
                            <a href="?productId=${productId}&rating=5&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 5 ? 'active' : ''}">
                                5 <i class="fas fa-star"></i>
                            </a>
                            <a href="?productId=${productId}&rating=4&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 4 ? 'active' : ''}">
                                4 <i class="fas fa-star"></i>
                            </a>
                            <a href="?productId=${productId}&rating=3&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 3 ? 'active' : ''}">
                                3 <i class="fas fa-star"></i>
                            </a>
                            <a href="?productId=${productId}&rating=2&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 2 ? 'active' : ''}">
                                2 <i class="fas fa-star"></i>
                            </a>
                            <a href="?productId=${productId}&rating=1&time=${empty selectedTime ? 'all' : selectedTime}" class="filter-btn ${selectedRating == 1 ? 'active' : ''}">
                                1 <i class="fas fa-star"></i>
                            </a>
                        </div>
                        <div class="filter-section">
                            <span class="filter-label">Time Posted:</span>
                            <a href="?productId=${productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=all" class="filter-btn ${selectedTime == 'all' || selectedTime == null || empty selectedTime ? 'active' : ''}">
                                All Time
                            </a>
                            <a href="?productId=${productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=today" class="filter-btn ${selectedTime == 'today' ? 'active' : ''}">
                                Today
                            </a>
                            <a href="?productId=${productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=week" class="filter-btn ${selectedTime == 'week' ? 'active' : ''}">
                                This Week
                            </a>
                            <a href="?productId=${productId}&rating=${empty selectedRating ? 'all' : selectedRating}&time=month" class="filter-btn ${selectedTime == 'month' ? 'active' : ''}">
                                This Month
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="text-muted small">
                    Showing ${reviewCount} review(s)
                </div>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${errorMessage}
                </div>
            </c:if>
            
            <!-- Invalid Filter Message -->
            <c:if test="${not empty invalidFilterMessage}">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${invalidFilterMessage}
                </div>
            </c:if>


            <!-- No Matching Reviews Message -->
            <c:if test="${not empty noMatchingMessage}">
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle"></i>
                    ${noMatchingMessage}
                </div>
            </c:if>

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
                        <c:forEach items="${reviews}" var="review" varStatus="status">
                            <div class="review-card">
                                <div class="d-flex">
                                    <div class="me-3">
                                        <div class="reviewer-avatar" style="background: linear-gradient(135deg, ${fn:length(review.customerName) % 5 == 0 ? '#007bff' : fn:length(review.customerName) % 5 == 1 ? '#6f42c1' : fn:length(review.customerName) % 5 == 2 ? '#28a745' : fn:length(review.customerName) % 5 == 3 ? '#fd7e14' : '#e83e8c'}, ${fn:length(review.customerName) % 5 == 0 ? '#0056b3' : fn:length(review.customerName) % 5 == 1 ? '#5a2d91' : fn:length(review.customerName) % 5 == 2 ? '#1e7e34' : fn:length(review.customerName) % 5 == 3 ? '#e55a00' : '#c2185b'}); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                            ${fn:substring(review.customerName, 0, 2)}
                                        </div>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <div class="reviewer-name">${review.customerName}</div>
                                                <div class="review-stars">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i class="fas fa-star${star <= review.star ? '' : ' star-empty'}"></i>
                                                    </c:forEach>
                                                    <span class="text-muted ms-2">${review.star}/5</span>
                                                </div>
                                            </div>
                                            <div class="review-time">${review.createdAt}</div>
                                        </div>
                                        <div class="review-text">
                                            ${review.reviewContent}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Add hover effects and animations
            document.addEventListener('DOMContentLoaded', function() {
                // Review card hover effects - DISABLED
                // const reviewCards = document.querySelectorAll('.review-card');
                // reviewCards.forEach(card => {
                //     card.addEventListener('mouseenter', function() {
                //         this.style.transform = 'translateY(-3px)';
                //         this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.15)';
                //         this.style.transition = 'all 0.3s ease';
                //     });
                //     
                //     card.addEventListener('mouseleave', function() {
                //         this.style.transform = 'translateY(0)';
                //         this.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
                //     });
                // });
                
                // Filter button hover effects
                const filterBtns = document.querySelectorAll('.filter-btn');
                filterBtns.forEach(btn => {
                    btn.addEventListener('mouseenter', function() {
                        if (!this.classList.contains('active')) {
                            this.style.backgroundColor = '#f8f9fa';
                            this.style.borderColor = '#dee2e6';
                            this.style.transform = 'translateY(-2px)';
                            this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
                        }
                    });
                    
                    btn.addEventListener('mouseleave', function() {
                        if (!this.classList.contains('active')) {
                            this.style.backgroundColor = '#fff';
                            this.style.borderColor = '#ddd';
                            this.style.transform = 'translateY(0)';
                            this.style.boxShadow = 'none';
                        }
                    });
                });
                
                // Avatar hover effects
                const avatars = document.querySelectorAll('.reviewer-avatar');
                avatars.forEach(avatar => {
                    avatar.addEventListener('mouseenter', function() {
                        this.style.transform = 'scale(1.1)';
                        this.style.transition = 'transform 0.3s ease';
                    });
                    
                    avatar.addEventListener('mouseleave', function() {
                        this.style.transform = 'scale(1)';
                    });
                });
                
                // Star rating hover effects
                const starRatings = document.querySelectorAll('.review-stars');
                starRatings.forEach(rating => {
                    const stars = rating.querySelectorAll('.fas.fa-star');
                    stars.forEach((star, index) => {
                        star.addEventListener('mouseenter', function() {
                            // Highlight stars up to this point
                            for (let i = 0; i <= index; i++) {
                                stars[i].style.color = '#ffc107';
                                stars[i].style.transform = 'scale(1.2)';
                            }
                        });
                        
                        star.addEventListener('mouseleave', function() {
                            // Reset all stars
                            stars.forEach(s => {
                                s.style.color = '#ffc107';
                                s.style.transform = 'scale(1)';
                            });
                        });
                    });
                });
                
                // Smooth scroll for page transitions
                const links = document.querySelectorAll('a[href*="productId"]');
                links.forEach(link => {
                    link.addEventListener('click', function(e) {
                        // Add loading effect
                        document.body.style.opacity = '0.8';
                        document.body.style.transition = 'opacity 0.3s ease';
                        
                        setTimeout(() => {
                            document.body.style.opacity = '1';
                        }, 100);
                    });
                });
                
                // Add fade-in animation for review cards
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }
                    });
                });
                
                reviewCards.forEach(card => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    observer.observe(card);
                });
            });
        </script>
    </body>
</html>
