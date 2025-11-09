<%-- 
    Document   : create-variant
    Created on : Oct 26, 2025
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
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <title>Create Product Variant</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                background-color: #f5f7fa;
                padding: 0;
                margin: 0;
            }

            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .container {
                max-width: 73rem;
                margin: 0 auto;
            }

            /* Page Header */
            .page-header {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 24px;
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }

            .page-header h1 {
                font-size: 24px;
                font-weight: 600;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .btn-back {
                padding: 10px 20px;
                background-color: #64748b;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-block;
            }

            .btn-back:hover {
                background-color: #475569;
            }

            /* Product Info Banner */
            .product-info-banner {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 8px;
                color: white;
            }

            .product-banner-image {
                width: 60px;
                height: 60px;
                border-radius: 8px;
                object-fit: cover;
                border: 2px solid rgba(255, 255, 255, 0.3);
            }

            .product-banner-info h3 {
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 4px;
            }

            .product-banner-info p {
                font-size: 13px;
                opacity: 0.9;
            }

            /* Form Card */
            .form-card {
                background: white;
                padding: 32px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .form-section {
                margin-bottom: 32px;
            }

            .form-section:last-child {
                margin-bottom: 0;
            }

            .section-title {
                font-size: 16px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 20px;
                padding-bottom: 12px;
                border-bottom: 2px solid #e2e8f0;
            }

            /* Form Group */
            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 500;
                color: #475569;
                margin-bottom: 8px;
            }

            .form-group label .required {
                color: #ef4444;
                margin-left: 4px;
            }

            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                color: #1e293b;
                transition: all 0.2s;
            }

            .form-control:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            select.form-control {
                cursor: pointer;
            }

            .image-upload {
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                background-color: #fafafa;
                cursor: pointer;
                transition: border-color 0.3s;
            }

            .image-upload:hover {
                border-color: #0d6efd;
            }

            .image-upload img {
                width: 160px;
                height: 160px;
                border-radius: 8px;
                object-fit: cover;
                margin-bottom: 12px;
                border: 1px solid #dee2e6;
            }

            /* Two Column Layout */
            .form-row {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            /* Three Column Layout for Color/Size */
            .form-row-three {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }

            /* Helper Text */
            .helper-text {
                font-size: 12px;
                color: #64748b;
                margin-top: 6px;
            }

            /* Color Picker Group */
            .color-select-group {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .color-preview {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                border: 2px solid #e2e8f0;
                cursor: pointer;
                transition: all 0.2s;
            }

            .color-preview:hover {
                border-color: #3b82f6;
                transform: scale(1.05);
            }

            /* Image Preview */
            .image-preview {
                margin-top: 12px;
                border: 2px dashed #e2e8f0;
                border-radius: 8px;
                padding: 16px;
                text-align: center;
                background: #f8fafc;
            }

            .image-preview img {
                max-width: 250px;
                max-height: 250px;
                border-radius: 8px;
                object-fit: cover;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .image-preview.empty {
                color: #94a3b8;
                padding: 60px 16px;
            }

            /* Price Input with Icon */
            .input-group {
                position: relative;
            }

            .input-group .currency-symbol {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #64748b;
                font-weight: 500;
                pointer-events: none;
            }

            .input-group .form-control {
                padding-left: 36px;
            }

            /* Messages */
            .error-message {
                background-color: #fee2e2;
                border: 1px solid #fecaca;
                color: #991b1b;
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .success-message {
                background-color: #d1fae5;
                border: 1px solid #a7f3d0;
                color: #065f46;
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            /* Form Actions */
            .form-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid #e2e8f0;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-primary {
                background-color: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .btn-secondary {
                background-color: #e2e8f0;
                color: #475569;
            }

            .btn-secondary:hover {
                background-color: #cbd5e1;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-wrapper {
                    margin-left: 0;
                }

                .form-row, .form-row-three {
                    grid-template-columns: 1fr;
                }

                .header-content {
                    flex-direction: column;
                    gap: 16px;
                    align-items: flex-start;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>

        <!-- Notification -->
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        <div class="main-wrapper">
            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="header-content">
                        <h1>
                            <span>✨</span>
                            Create Product Variant
                        </h1>
                        <a href="${pageContext.request.contextPath}/staff/product?action=detail&productId=${product.productId}" class="btn-back">
                            ← Back to Product
                        </a>
                    </div>

                    <!-- Product Info Banner -->
                    <div class="product-info-banner">
                        <img src="${product.defaultImageUrl}" alt="${product.name}" class="product-banner-image">
                        <div class="product-banner-info">
                            <h3>${product.name}</h3>
                            <p>Product ID: #${product.productId} | ${product.material}</p>
                        </div>
                    </div>
                </div>
                <!-- Form Card -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/staff/variant" method="POST" enctype="multipart/form-data" id="variantForm">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <!-- Variant Details Section -->
                        <div class="form-section">
                            <h2 class="section-title">Variant Details</h2>

                            <div class="form-row-three">
                                <div class="form-group">
                                    <label for="color">
                                        Color
                                        <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           id="color" 
                                           name="color" 
                                           class="form-control" 
                                           placeholder="e.g., Red, Blue, Black"
                                           value="${param.color}"
                                           required>
                                    <div class="helper-text">Enter color name</div>
                                </div>

                                <div class="form-group">
                                    <label for="size">
                                        Size
                                        <span class="required">*</span>
                                    </label>
                                    <input type="text" 
                                           id="size" 
                                           name="size" 
                                           class="form-control" 
                                           placeholder="e.g., S, M, L, XL"
                                           value="${param.size}"
                                           required>
                                    <div class="helper-text">Enter size code</div>
                                </div>
                                <div class="form-group">
                                    <label for="price">
                                        Price
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="currency-symbol">$</span>
                                        <input type="number" 
                                               id="price" 
                                               name="price" 
                                               class="form-control" 
                                               placeholder="0.00"
                                               step="0.01"
                                               min="0"
                                               value="${param.price}"
                                               required>
                                    </div>
                                    <div class="helper-text">Enter price in USD</div>
                                </div>
                            </div>


                        </div>

                        <!-- Variant Image Section -->
                        <div class="form-section">
                            <h2 class="section-title">Variant Image</h2>

                            <div class="form-group">
                                <label class="form-label">Upload Image <span class="required">*</span></label>
                                <div class="image-upload" id="variantImageUpload">
                                    <img src="${empty param.image 
                                                ? 'https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png' 
                                                : param.image}" 
                                         id="variantImagePreview" 
                                         alt="Variant Image Preview" />
                                    <div class="text-muted small">Click or drag & drop an image</div>
                                    <input type="file" name="imageFile" id="variantImageInput" accept="image/*" class="d-none">
                                </div>
                                <input type="hidden" name="image" id="imageUrlHidden" value="${param.image}">
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">
                                Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                ✓ Create Variant
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Preview image when URL changes
            function previewImage() {
                const url = document.getElementById('image').value;
                const preview = document.getElementById('imagePreview');

                if (url) {
                    preview.innerHTML = '<img src="' + url + '" alt="Variant Image" id="previewImg" onerror="imageLoadError()">';
                } else {
                    preview.innerHTML = '<div class="empty">📷<br>Image preview will appear here</div>';
                }
            }

            // Handle image load error
            function imageLoadError() {
                const preview = document.getElementById('imagePreview');
                preview.innerHTML = '<div class="empty" style="color: #ef4444;">❌ Failed to load image<br>Please check the URL</div>';
            }

            // Form validation
            document.getElementById('variantForm').addEventListener('submit', function (e) {
                const color = document.getElementById('color').value.trim();
                const size = document.getElementById('size').value.trim();
                const price = parseFloat(document.getElementById('price').value);
                const quantity = parseInt(document.getElementById('quantityAvailable').value);
                const imageUrl = document.getElementById('image').value.trim();

                // Validate required fields
                if (!color || !size || !imageUrl) {
                    e.preventDefault();
                    alert('Please fill in all required fields!');
                    return false;
                }

                // Validate price
                if (isNaN(price) || price < 0) {
                    e.preventDefault();
                    alert('Please enter a valid price (must be 0 or greater)!');
                    return false;
                }

                // Validate quantity
                if (isNaN(quantity) || quantity < 0) {
                    e.preventDefault();
                    alert('Please enter a valid quantity (must be 0 or greater)!');
                    return false;
                }

                // Validate URL format
                try {
                    new URL(imageUrl);
                } catch (_) {
                    e.preventDefault();
                    alert('Please enter a valid image URL!');
                    return false;
                }

                return true;
            });

            // Auto-focus first input
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('color').focus();
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const uploadArea = document.getElementById('variantImageUpload');
                const fileInput = document.getElementById('variantImageInput');
                const preview = document.getElementById('variantImagePreview');
                const hiddenUrl = document.getElementById('imageUrlHidden');

                uploadArea.addEventListener('click', () => fileInput.click());

                fileInput.addEventListener('change', (e) => {
                    if (e.target.files.length > 0) {
                        const file = e.target.files[0];
                        const reader = new FileReader();
                        reader.onload = (event) => {
                            preview.src = event.target.result;
                            hiddenUrl.value = '';
                        };
                        reader.readAsDataURL(file);
                    }
                });

                uploadArea.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    uploadArea.style.borderColor = '#0d6efd';
                });

                uploadArea.addEventListener('dragleave', () => {
                    uploadArea.style.borderColor = '#dee2e6';
                });

                uploadArea.addEventListener('drop', (e) => {
                    e.preventDefault();
                    uploadArea.style.borderColor = '#dee2e6';
                    const file = e.dataTransfer.files[0];
                    if (file) {
                        fileInput.files = e.dataTransfer.files;
                        const reader = new FileReader();
                        reader.onload = (event) => {
                            preview.src = event.target.result;
                            hiddenUrl.value = '';
                        };
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>

    </body>
</html>