<%-- 
    Document   : Category-form
    Created on : 22-10-2025, 20:43:19
    Author     : Asus
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${formAction == 'add' ? 'Add' : 'Edit'} Category</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            :root {
                --header-h: 74px;
                --sidebar-w: 300px;
                --bg: #f5f6f8;
                --text: #111827;
                --line: #e5e7eb;
            }

            * {
                box-sizing: border-box;
                font-family: Arial, Helvetica, sans-serif;
            }

            html, body {
                height: 100%;
            }

            body {
                margin: 0;
                background: var(--bg);
                color: var(--text);
                padding-top: var(--header-h);
            }

            .wrap {
                padding: 20px 24px;
                max-width: 800px;
                margin: 0 auto 0 var(--sidebar-w);
            }

            .form-card {
                background: #fff;
                border: 1px solid var(--line);
                border-radius: 12px;
                padding: 32px;
                box-shadow: 0 10px 20px rgba(17, 24, 39, .04);
            }

            .form-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 24px;
                color: var(--text);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #374151;
            }

            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid var(--line);
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.15s;
            }

            .form-control:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .form-check {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-check-input {
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .image-preview {
                margin-top: 12px;
                max-width: 300px;
                border: 1px solid var(--line);
                border-radius: 8px;
                overflow: hidden;
            }

            .image-preview img {
                width: 100%;
                height: auto;
                display: block;
            }

            .btn-group {
                display: flex;
                gap: 12px;
                margin-top: 24px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.15s;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-primary {
                background: #111827;
                color: #fff;
            }

            .btn-primary:hover {
                filter: brightness(0.9);
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: #f3f4f6;
                color: #374151;
                border: 1px solid var(--line);
            }

            .btn-secondary:hover {
                background: #e5e7eb;
                color: #374151;
                text-decoration: none;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .alert-danger {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            @media (max-width: 992px) {
                :root {
                    --sidebar-w: 0px;
                }
                .wrap {
                    margin-left: 0;
                    padding: 16px;
                }
            }
        </style>
    </head>
    <body>

        <!-- Header & Sidebar -->
        <jsp:include page="common/staff-header.jsp"/>
        <jsp:include page="common/staff-sidebar.jsp"/>

        <div class="wrap">
            <div class="form-card">
                <h2 class="form-title">
                    ${formAction == 'add' ? 'Add New Category' : 'Edit Category'}
                </h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form method="post" 
                      action="<c:url value='/managecategoriesforstaff/${formAction}'>
                          <c:param name='role' value='${userRole}'/>
                      </c:url>"
                      enctype="multipart/form-data">

                    <c:if test="${formAction == 'update'}">
                        <input type="hidden" name="id" value="${category.categoryId}">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label" for="name">Category Name *</label>
                        <input type="text" 
                               class="form-control" 
                               id="name" 
                               name="name" 
                               value="${category.name}" 
                               required
                               maxlength="255"
                               placeholder="Enter category name...">
                    </div>

                    <div class="form-group">
                        <div class="image-upload d-flex flex-column align-items-center" id="imageUpload">
                            <img src="${empty category.image ? 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg' : category.image}" id="imagePreview" 
                                 class="image-preview img-thumbnail mb-2 " 
                                 style="width:160px;height:160px;object-fit:cover" />
                            <span id="imageText" class="text-muted">Drag and drop or click on image to select file</span>
                            <input type="file" name="image" id="imageInput" accept="image/*" class="d-none">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="form-check">
                            <input type="checkbox" 
                                   class="form-check-input" 
                                   id="isActive" 
                                   name="isActive"
                                   ${category.isActive || formAction == 'add' ? 'checked' : ''}>
                            <label class="form-check-label" for="isActive">
                                Active category
                            </label>
                        </div>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            ${formAction == 'add' ? 'Add Category' : 'Update'}
                        </button>
                        <a href="<c:url value='/managecategoriesforstaff/list'>
                               <c:param name='role' value='${userRole}'/>
                           </c:url>" 
                           class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Preview image
            function previewImage(url) {
                const preview = document.getElementById('imagePreview');
                const img = document.getElementById('previewImg');

                if (url && url.trim() !== '') {
                    img.src = url;
                    preview.style.display = 'block';

                    img.onerror = function () {
                        preview.style.display = 'none';
                    };
                } else {
                    preview.style.display = 'none';
                }
            }

            // Load preview on page load
            document.addEventListener('DOMContentLoaded', function () {
                const imageInput = document.getElementById('image');
                if (imageInput && imageInput.value) {
                    previewImage(imageInput.value);
                }

                // Active sidebar
                var el = document.getElementById('category');
                if (el)
                    el.classList.add('active');

                // Lucide icons
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            });

            // image upload preview
            const imageUpload = document.getElementById('imageUpload');
            const imageInput = document.getElementById('imageInput');
            const imagePreview = document.getElementById('imagePreview');

            imageUpload.addEventListener('click', () => {
                imageInput.click();
            });

            imageInput.addEventListener('change', (e) => {
                if (e.target.files.length > 0) {
                    const file = e.target.files[0];
                    const reader = new FileReader();

                    reader.onload = (e) => {
                        imagePreview.src = e.target.result;
                        imagePreview.style.display = 'block';
                    };

                    reader.readAsDataURL(file);
                }
            });

            // Handle drag and drop for image
            imageUpload.addEventListener('dragover', (e) => {
                e.preventDefault();
                imageUpload.style.borderColor = '#0d6efd';
            });

            imageUpload.addEventListener('dragleave', () => {
                imageUpload.style.borderColor = '#dee2e6';
            });

            imageUpload.addEventListener('drop', (e) => {
                e.preventDefault();
                imageUpload.style.borderColor = '#dee2e6';

                if (e.dataTransfer.files.length > 0) {
                    imageInput.files = e.dataTransfer.files;
                    const file = e.dataTransfer.files[0];
                    const reader = new FileReader();

                    reader.onload = (e) => {
                        imagePreview.src = e.target.result;
                        imagePreview.style.display = 'block';
                    };

                    reader.readAsDataURL(file);
                }
            });
        </script>
    </body>
</html>
