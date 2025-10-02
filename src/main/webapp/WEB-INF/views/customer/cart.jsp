<%-- 
    Document   : cart
    Created on : Sep 30, 2025, 9:06:44 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .cart-item-img {
            width: 130px;
            height: 130px;
            object-fit: cover;
            border-radius: 8px;
        }
        .quantity-control {
            width: 120px;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
            border-left: none;
            border-right: none;
        }
        .btn-quantity {
            width: 30px;
            padding: 0;
        }
        .color-select {
            width: 200px;
        }
        .price-text {
            font-size: 1.25rem;
            font-weight: 600;
        }
        .total-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        .btn-checkout {
            background-color: #000;
            color: #fff;
            padding: 15px;
            font-size: 1.1rem;
            border-radius: 8px;
        }
        .btn-checkout:hover {
            background-color: #333;
            color: #fff;
        }
        .btn-delete {
            color: #dc3545;
            font-size: 1.5rem;
            border: none;
            background: none;
            cursor: pointer;
        }
        .btn-delete:hover {
            color: #bb2d3b;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <!-- Header -->
        <div class="d-flex align-items-center mb-4">
            <a href="#" class="text-dark text-decoration-none me-3">
                <i class="bi bi-chevron-left fs-2"></i>
            </a>
            <h1 class="mb-0 fw-bold">Shopping Cart</h1>
        </div>

        <!-- Cart Items -->
        <div class="row">
            <div class="col-lg-12">
                <!-- Header Row -->
                <div class="row mb-3 d-none d-md-flex fw-semibold">
                    <div class="col-md-4">Product</div>
                    <div class="col-md-2 text-center">Quantity</div>
                    <div class="col-md-2 text-center">Color</div>
                    <div class="col-md-2 text-center">Price</div>
                    <div class="col-md-2"></div>
                </div>

                <!-- Cart Item 1 -->
                <div class="card mb-3 shadow-sm">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <!-- Product Info -->
                            <div class="col-md-4 mb-3 mb-md-0">
                                <div class="d-flex align-items-center">
                                    <img src="https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400" 
                                         alt="Fullset Black Chair & Sofa" 
                                         class="cart-item-img me-3">
                                    <h5 class="mb-0 fw-semibold">Fullset Black Chair & Sofa</h5>
                                </div>
                            </div>

                            <!-- Quantity Control -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="d-flex justify-content-center">
                                    <div class="input-group quantity-control">
                                        <button class="btn btn-outline-secondary btn-quantity" type="button" 
                                                onclick="updateQuantity(this, -1)">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="text" class="form-control quantity-input" value="1" readonly>
                                        <button class="btn btn-outline-secondary btn-quantity" type="button" 
                                                onclick="updateQuantity(this, 1)">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Color Select -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="d-flex justify-content-center">
                                    <select class="form-select color-select">
                                        <option value="black" selected>Black</option>
                                        <option value="white">White</option>
                                        <option value="gray">Gray</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Price -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="text-center price-text">$120</div>
                            </div>

                            <!-- Delete Button -->
                            <div class="col-md-2 text-center">
                                <button class="btn-delete" onclick="removeItem(this)">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Cart Item 2 -->
                <div class="card mb-3 shadow-sm">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <!-- Product Info -->
                            <div class="col-md-4 mb-3 mb-md-0">
                                <div class="d-flex align-items-center">
                                    <img src="https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=400" 
                                         alt="Orange Cool Chair" 
                                         class="cart-item-img me-3">
                                    <h5 class="mb-0 fw-semibold">Orange Cool Chair</h5>
                                </div>
                            </div>

                            <!-- Quantity Control -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="d-flex justify-content-center">
                                    <div class="input-group quantity-control">
                                        <button class="btn btn-outline-secondary btn-quantity" type="button" 
                                                onclick="updateQuantity(this, -1)">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="text" class="form-control quantity-input" value="1" readonly>
                                        <button class="btn btn-outline-secondary btn-quantity" type="button" 
                                                onclick="updateQuantity(this, 1)">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Color Select -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="d-flex justify-content-center">
                                    <select class="form-select color-select">
                                        <option value="orange" selected>Orange</option>
                                        <option value="red">Red</option>
                                        <option value="yellow">Yellow</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Price -->
                            <div class="col-md-2 mb-3 mb-md-0">
                                <div class="text-center price-text">$120</div>
                            </div>

                            <!-- Delete Button -->
                            <div class="col-md-2 text-center">
                                <button class="btn-delete" onclick="removeItem(this)">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total and Checkout -->
                <div class="row mt-4">
                    <div class="col-lg-8"></div>
                    <div class="col-lg-4">
                        <div class="total-section">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="mb-0 fw-bold">Total</h4>
                                <h3 class="mb-0 fw-bold" id="totalPrice">$240</h3>
                            </div>
                            <button class="btn btn-checkout w-100" onclick="checkout()">
                                Checkout
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateQuantity(btn, change) {
            const input = btn.parentElement.querySelector('.quantity-input');
            let currentValue = parseInt(input.value);
            let newValue = currentValue + change;
            
            if (newValue >= 1) {
                input.value = newValue;
                calculateTotal();
            }
        }

        function removeItem(btn) {
            const card = btn.closest('.card');
            if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
                card.remove();
                calculateTotal();
            }
        }

        function calculateTotal() {
            const cards = document.querySelectorAll('.card');
            let total = 0;
            
            cards.forEach(card => {
                const quantity = parseInt(card.querySelector('.quantity-input').value);
                const priceText = card.querySelector('.price-text').textContent;
                const price = parseInt(priceText.replace('$', ''));
                total += quantity * price;
            });
            
            document.getElementById('totalPrice').textContent = '$' + total;
        }

        function checkout() {
            alert('Proceeding to checkout...');
            // Thêm logic checkout ở đây
        }
    </script>
</body>
</html>
