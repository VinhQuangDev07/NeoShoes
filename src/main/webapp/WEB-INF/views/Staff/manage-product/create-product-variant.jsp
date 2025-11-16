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
                background-color: white;
            }

            .form-control:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .form-control.is-invalid {
                border-color: #ef4444;
            }

            .form-control.is-invalid:focus {
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
            }

            select.form-control {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23475569' d='M10.293 3.293L6 7.586 1.707 3.293A1 1 0 00.293 4.707l5 5a1 1 0 001.414 0l5-5a1 1 0 10-1.414-1.414z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 16px center;
                padding-right: 40px;
            }

            .invalid-feedback {
                color: #ef4444;
                font-size: 12px;
                margin-top: 6px;
                display: none;
            }

            .form-control.is-invalid ~ .invalid-feedback {
                display: block;
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

            .image-upload.is-invalid {
                border-color: #ef4444;
            }

            .image-upload img {
                width: 160px;
                height: 160px;
                border-radius: 8px;
                object-fit: cover;
                margin-bottom: 12px;
                border: 1px solid #dee2e6;
            }

            /* Color Preview Badge */
            .color-preview-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 6px 12px;
                border-radius: 6px;
                background-color: #f8fafc;
                border: 1px solid #e2e8f0;
                margin-top: 8px;
            }

            .color-preview-badge .color-dot {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                border: 2px solid white;
                box-shadow: 0 0 0 1px #e2e8f0;
            }

            .color-preview-badge .color-name {
                font-size: 13px;
                color: #475569;
                font-weight: 500;
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
                z-index: 1;
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

            .btn-primary:hover:not(:disabled) {
                background-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .btn-primary:disabled {
                background-color: #94a3b8;
                cursor: not-allowed;
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
                    <form action="${pageContext.request.contextPath}/staff/variant" 
                          method="POST" 
                          enctype="multipart/form-data" 
                          id="variantForm">
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
                                    <select id="color" 
                                            name="color" 
                                            class="form-control" 
                                            required>
                                        <option value="">-- Select Color --</option>
                                        <option value="Black" data-hex="#000000">Black</option>
                                        <option value="White" data-hex="#FFFFFF">White</option>
                                        <option value="Gray" data-hex="#808080">Gray</option>
                                        <option value="Red" data-hex="#DC2626">Red</option>
                                        <option value="Blue" data-hex="#2563EB">Blue</option>
                                        <option value="Navy" data-hex="#1E3A8A">Navy</option>
                                        <option value="Green" data-hex="#16A34A">Green</option>
                                        <option value="Yellow" data-hex="#EAB308">Yellow</option>
                                        <option value="Orange" data-hex="#EA580C">Orange</option>
                                        <option value="Pink" data-hex="#EC4899">Pink</option>
                                        <option value="Purple" data-hex="#9333EA">Purple</option>
                                        <option value="Brown" data-hex="#92400E">Brown</option>
                                        <option value="Beige" data-hex="#D4A574">Beige</option>
                                        <option value="Khaki" data-hex="#C3B091">Khaki</option>
                                        <option value="Maroon" data-hex="#7C2D12">Maroon</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a color</div>
                                    <!--<div id="colorPreview"></div>-->
                                </div>

                                <div class="form-group">
                                    <label for="size">
                                        Size
                                        <span class="required">*</span>
                                    </label>
                                    <select id="size" 
                                            name="size" 
                                            class="form-control" 
                                            required>
                                        <option value="">-- Select Size --</option>
                                        <option value="28">28 - Size 28</option>
                                        <option value="29">29 - Size 29</option>
                                        <option value="30">30 - Size 30</option>
                                        <option value="31">31 - Size 31</option>
                                        <option value="32">32 - Size 32</option>
                                        <option value="33">33 - Size 33</option>
                                        <option value="34">34 - Size 34</option>
                                        <option value="36">36 - Size 36</option>
                                        <option value="38">38 - Size 38</option>
                                        <option value="40">40 - Size 40</option>
                                        <option value="42">42 - Size 42</option>
                                        <option value="44">44 - Size 44</option>
                                        <option value="46">46 - Size 46</option>
                                        <option value="48">48 - Size 48</option>
                                        <option value="50">50 - Size 50</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a size</div>
                                    <div class="helper-text">Choose appropriate size</div>
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
                                               min="0.01"
                                               max="999999.99"
                                               required>
                                    </div>
                                    <div class="invalid-feedback">Price must be greater than 0</div>
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
                                    <img src="https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png" 
                                         id="variantImagePreview" 
                                         alt="Variant Image Preview" />
                                    <div class="text-muted small">Click or drag & drop an image</div>
                                    <input type="file" 
                                           name="imageFile" 
                                           id="variantImageInput" 
                                           accept="image/*" 
                                           class="d-none" 
                                           required>
                                </div>
                                <div class="invalid-feedback">Please upload a variant image</div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/staff/product?action=detail&productId=${product.productId}'">
                                Cancel
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                ✓ Create Variant
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // ===== FORM ELEMENTS =====
    const variantForm = document.getElementById('variantForm');
    const colorSelect = document.getElementById('color');
    const sizeSelect = document.getElementById('size');
    const priceInput = document.getElementById('price');
    const uploadArea = document.getElementById('variantImageUpload');
    const fileInput = document.getElementById('variantImageInput');
    const preview = document.getElementById('variantImagePreview');
    const submitBtn = document.getElementById('submitBtn');

    // ===== SIZE VALIDATION =====
    sizeSelect.addEventListener('change', function() {
        if (this.value) {
            this.classList.remove('is-invalid');
        }
    });

    // ===== PRICE VALIDATION =====
    priceInput.addEventListener('input', function() {
        const value = parseFloat(this.value);
        
        if (value > 0 && value <= 999999.99) {
            this.classList.remove('is-invalid');
        }
    });

    priceInput.addEventListener('blur', function() {
        const value = parseFloat(this.value);
        
        if (this.value && value > 0) {
            this.value = value.toFixed(2);
        }
    });

    // ===== IMAGE UPLOAD =====
    uploadArea.addEventListener('click', () => fileInput.click());

    fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            handleImageFile(e.target.files[0]);
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
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleImageFile(files[0]);
            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(files[0]);
            fileInput.files = dataTransfer.files;
        }
    });

    function handleImageFile(file) {
        if (!file.type.startsWith('image/')) {
            alert('Please select a valid image file!');
            fileInput.value = '';
            uploadArea.classList.add('is-invalid');
            return;
        }
        
        if (file.size > 5 * 1024 * 1024) {
            alert('Image size must be less than 5MB!');
            fileInput.value = '';
            uploadArea.classList.add('is-invalid');
            return;
        }
        
        const reader = new FileReader();
        reader.onload = (event) => {
            preview.src = event.target.result;
            uploadArea.classList.remove('is-invalid');
        };
        reader.readAsDataURL(file);
    }

    // ===== FORM VALIDATION =====
    let isSubmitting = false;
    
    variantForm.addEventListener('submit', function (e) {
        e.preventDefault();
        
        if (isSubmitting) {
            return false;
        }
        
        let isValid = true;

        // Validate color
        if (!colorSelect.value) {
            colorSelect.classList.add('is-invalid');
            isValid = false;
        } else {
            colorSelect.classList.remove('is-invalid');
        }

        // Validate size
        if (!sizeSelect.value) {
            sizeSelect.classList.add('is-invalid');
            isValid = false;
        } else {
            sizeSelect.classList.remove('is-invalid');
        }

        // Validate price
        const price = parseFloat(priceInput.value);
        if (!priceInput.value || isNaN(price) || price <= 0 || price > 999999.99) {
            priceInput.classList.add('is-invalid');
            isValid = false;
        } else {
            priceInput.classList.remove('is-invalid');
        }

        // Validate image
        const hasFile = fileInput.files && fileInput.files.length > 0;

        if (!hasFile) {
            uploadArea.classList.add('is-invalid');
            alert('Please upload a variant image!');
            isValid = false;
        } else {
            uploadArea.classList.remove('is-invalid');
        }

        // If all validations pass, submit the form
        if (isValid) {
            isSubmitting = true;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
            
            // Native form submit
            this.submit();
        } else {
            const firstInvalid = document.querySelector('.is-invalid');
            if (firstInvalid) {
                firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstInvalid.focus();
            }
        }

        return false;
    });

    // Auto-focus first select
    colorSelect.focus();
});
</script>
    </body>
</html>