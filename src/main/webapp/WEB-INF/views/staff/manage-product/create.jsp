<%-- 
    Document   : create-product
    Created on : Oct 26, 2025
    Author     : Nguyen Huynh Thien An - CE190979
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Product</title>
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

            /* Wrapper cho content chính */
            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .container {
                max-width: 900px;
                margin: 0 auto;
            }

            /* Header */
            .page-header {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 24px;
                display: flex;
                justify-content: space-between;
                align-items: center;
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

            textarea.form-control {
                resize: vertical;
                min-height: 120px;
                font-family: inherit;
            }

            /* Two Column Layout */
            .form-row {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            /* Helper Text */
            .helper-text {
                font-size: 12px;
                color: #64748b;
                margin-top: 6px;
            }

            /* Error Message */
            .error-message {
                background-color: #fee2e2;
                border: 1px solid #fecaca;
                color: #991b1b;
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            /* Success Message */
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

                .form-row {
                    grid-template-columns: 1fr;
                }

                .page-header {
                    flex-direction: column;
                    gap: 16px;
                    align-items: flex-start;
                }
            }

            /* Active Status Toggle */
            .status-toggle {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 16px;
                background-color: #f8fafc;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .toggle-switch {
                position: relative;
                display: inline-block;
                width: 48px;
                height: 24px;
            }

            .toggle-switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .toggle-slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #cbd5e1;
                transition: .3s;
                border-radius: 24px;
            }

            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 18px;
                width: 18px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .3s;
                border-radius: 50%;
            }

            input:checked + .toggle-slider {
                background-color: #10b981;
            }

            input:checked + .toggle-slider:before {
                transform: translateX(24px);
            }

            .status-label {
                font-size: 14px;
                font-weight: 500;
                color: #475569;
            }

            .status-text {
                font-size: 13px;
                color: #64748b;
            }
        </style>
    </head>
    <body>
        <div class="main-wrapper">
            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>
                        <span>➕</span>
                        Create New Product
                    </h1>
                    <a href="${pageContext.request.contextPath}/staff/product" class="btn-back">
                        ← Back to Products
                    </a>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        ❌ ${errorMessage}
                    </div>
                </c:if>

                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                    <div class="success-message">
                        ✅ ${successMessage}
                    </div>
                </c:if>

                <!-- Form Card -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/staff/product" method="POST">
                        <input type="hidden" name="action" value="create">

                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h2 class="section-title">Basic Information</h2>

                            <div class="form-group">
                                <label for="name">
                                    Product Name
                                    <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       id="name" 
                                       name="name" 
                                       class="form-control" 
                                       placeholder="Enter product name"
                                       value="${param.name}"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="description">
                                    Description
                                    <span class="required">*</span>
                                </label>
                                <textarea id="description" 
                                          name="description" 
                                          class="form-control" 
                                          placeholder="Enter product description"
                                          required>${param.description}</textarea>
                                <div class="helper-text">Provide a detailed description of the product</div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="brandId">
                                        Brand
                                        <span class="required">*</span>
                                    </label>
                                    <select id="brandId" name="brandId" class="form-control" required>
                                        <option value="">-- Select Brand --</option>
                                        <c:forEach var="brand" items="${brands}">
                                            <option value="${brand.brandId}" 
                                                    ${param.brandId == brand.brandId ? 'selected' : ''}>
                                                ${brand.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="categoryId">
                                        Category
                                        <span class="required">*</span>
                                    </label>
                                    <select id="categoryId" name="categoryId" class="form-control" required>
                                        <option value="">-- Select Category --</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}" 
                                                    ${param.categoryId == category.categoryId ? 'selected' : ''}>
                                                ${category.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Product Details Section -->
                        <div class="form-section">
                            <h2 class="section-title">Product Details</h2>

                            <div class="form-group">
                                <label for="material">
                                    Material
                                    <span class="required">*</span>
                                </label>
                                <input type="text" 
                                       id="material" 
                                       name="material" 
                                       class="form-control" 
                                       placeholder="e.g., Cotton, Polyester, Leather"
                                       value="${param.material}"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="defaultImageUrl">
                                    Default Image URL
                                    <span class="required">*</span>
                                </label>
                                <input type="url" 
                                       id="defaultImageUrl" 
                                       name="defaultImageUrl" 
                                       class="form-control" 
                                       placeholder="https://example.com/image.jpg"
                                       value="${param.defaultImageUrl}"
                                       required>
                                <div class="helper-text">Enter a valid image URL (must start with http:// or https://)</div>
                            </div>
                        </div>

                        <!-- Product Status Section -->
                        <div class="form-section">
                            <h2 class="section-title">Product Status</h2>
                            
                            <div class="status-toggle">
                                <label class="toggle-switch">
                                    <input type="checkbox" 
                                           name="isActive" 
                                           value="1"
                                           checked
                                           id="isActiveToggle">
                                    <span class="toggle-slider"></span>
                                </label>
                                <div>
                                    <div class="status-label">Activate Product</div>
                                    <div class="status-text" id="statusText">
                                        This product will be active and visible to customers
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">
                                Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                ✓ Create Product
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Update status text when toggle changes
            document.getElementById('isActiveToggle').addEventListener('change', function() {
                const statusText = document.getElementById('statusText');
                if (this.checked) {
                    statusText.textContent = 'This product will be active and visible to customers';
                } else {
                    statusText.textContent = 'This product will be inactive and hidden from customers';
                }
            });

            // Form validation
            document.querySelector('form').addEventListener('submit', function (e) {
                const name = document.getElementById('name').value.trim();
                const description = document.getElementById('description').value.trim();
                const material = document.getElementById('material').value.trim();
                const brandId = document.getElementById('brandId').value;
                const categoryId = document.getElementById('categoryId').value;
                const imageUrl = document.getElementById('defaultImageUrl').value.trim();

                if (!name || !description || !material || !brandId || !categoryId || !imageUrl) {
                    e.preventDefault();
                    alert('Please fill in all required fields!');
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
        </script>
    </body>
</html>