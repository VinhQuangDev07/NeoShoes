<%-- 
    Document   : product-detail
    Created on : Oct 10, 2025, 7:30:53 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${product.productName} - Product Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

    </head>
    <body>
        <c:if test="${not empty sessionScope.flash}">
            <script>
                showNotification("${sessionScope.flash}", "success");
            </script>
            <c:remove var="flash" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_info}">
            <script>
                showNotification("${sessionScope.flash_info}", "info");
            </script>
            <c:remove var="flash_info" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_error}">
            <script>
                showNotification("${sessionScope.flash_error}", "error");
            </script>
            <c:remove var="flash_error" scope="session"/>
        </c:if>
        <div class="container mt-5">
            <div class="row">
                <!-- Product Image -->
                <div class="col-md-6">
                    <div class="product-image">
                        <img src="${product.imageUrl}" alt="${product.productName}" 
                             class="img-fluid rounded shadow" id="mainProductImage">
                    </div>
                </div>

                <!-- Product Info -->
                <div class="col-md-6">
                    <div class="product-info">
                        <h2 class="product-title">${product.productName}</h2>

                        <div class="product-description mb-4">
                            <h5>Description</h5>
                            <p>${product.description}</p>
                        </div>

                        <hr>

                        <!-- Include Variant Selector -->
                        <jsp:include page="common/variant-selector.jsp"/>

                        <hr>


                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-lg me-2" onclick="addToCartAction()">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                            <button class="btn btn-outline-danger btn-lg">
                                <i class="fas fa-heart me-2"></i>Wishlist
                            </button>
                        </div>

                        <!-- Product Meta -->
                        <div class="product-meta mt-4">
                            <p><strong>Product ID:</strong> ${product.productId}</p>
                            <p><strong>Category ID:</strong> ${product.categoryId}</p>
                            <p><strong>Brand ID:</strong> ${product.brandId}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Back Button -->
            <div class="row mt-5">
                <div class="col-12">
                    <a href="products" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Products
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                // Quantity controls
                                function increaseQuantity() {
                                    const input = document.getElementById('quantity');
                                    const currentValue = parseInt(input.value);
                                    if (currentValue < 999) {
                                        input.value = currentValue + 1;
                                    }
                                }

                                function decreaseQuantity() {
                                    const input = document.getElementById('quantity');
                                    const currentValue = parseInt(input.value);
                                    if (currentValue > 1) {
                                        input.value = currentValue - 1;
                                    }
                                }

                                // Add to cart action
                                function addToCartAction() {
                                    const variantId = sessionStorage.getItem('selectedVariantId');
                                    const quantity = document.getElementById('quantity').value;

                                    if (!variantId) {
                                        alert('Please select a variant first');
                                        return;
                                    }

                                    fetch('cart', {
                                        method: 'POST',
                                        headers: {
                                            'Content-Type': 'application/x-www-form-urlencoded',
                                        },
                                        body: 'action=addToCart&variantId=' + variantId + '&quantity=' + quantity
                                    })
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.success) {
                                                    alert('Product added to cart successfully!');
                                                    // Optionally redirect to cart page
                                                    // window.location.href = 'cart?action=view';
                                                } else {
                                                    alert('Error: ' + data.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                alert('An error occurred while adding to cart');
                                            });
                                }
        </script>

        <style>
            .product-image img {
                max-width: 100%;
                height: auto;
                object-fit: cover;
            }

            .product-title {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 1rem;
                color: #333;
            }

            .product-description {
                line-height: 1.8;
                color: #666;
            }

            .action-buttons .btn {
                padding: 12px 30px;
                font-weight: 600;
            }

            .product-meta p {
                margin-bottom: 0.5rem;
                color: #666;
            }

        </style>
    </body>
</html>
