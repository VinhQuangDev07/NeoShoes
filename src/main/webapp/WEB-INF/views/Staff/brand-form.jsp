<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${formAction == 'update' ? 'Edit Brand' : 'Add New Brand'} - NeoShoes</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background-color: #f8f9fa;
                overflow-x: hidden;
            }

            #main-content {
                margin-left: 0;
                transition: margin-left 0.3s ease;
                padding-top: 74px;
            }

            @media (min-width: 992px) {
                #main-content {
                    margin-left: 300px;
                }
            }

            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .form-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                padding: 32px;
            }

            .form-label {
                font-weight: 600;
                color: #374151;
            }

            .form-control {
                border-radius: 8px;
                padding: 10px 12px;
            }

            .form-control:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
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

            .btn-primary {
                background-color: #0d6efd;
                border: none;
                border-radius: 8px;
                padding: 10px 20px;
                font-weight: 500;
            }

            .btn-primary:hover {
                background-color: #0b5ed7;
            }

            .btn-secondary {
                background-color: #f3f4f6;
                color: #374151;
                border-radius: 8px;
                padding: 10px 20px;
                border: 1px solid #dee2e6;
            }

            .btn-secondary:hover {
                background-color: #e5e7eb;
                color: #111;
            }
        </style>
    </head>
    <body>

        <!-- Header & Sidebar -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <!-- Main -->
        <div id="main-content">
            <div class="container-fluid p-4">

                <!-- Page Header -->
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1 fw-bold">${formAction == 'update' ? 'Edit Brand' : 'Add New Brand'}</h2>
                        <p class="text-muted mb-0 mt-1">Fill in the brand details below</p>
                    </div>
                </div>

                <!-- Form -->
                <div class="form-card">
                    <form action="<c:url value='/staff/manage-brands/${formAction}'/>" method="post" enctype="multipart/form-data">

                        <c:if test="${formAction == 'update'}">
                            <input type="hidden" name="id" value="${brand.brandId}">
                        </c:if>

                        <!-- Brand Name -->
                        <div class="mb-3">
                            <input id="name" name="name" type="text" class="form-control"
                            value="${brand.name}" required maxlength="255"
                            placeholder="Enter brand name..."
                            oninvalid="this.setCustomValidity(''); showNotification('Brand name cannot be empty', 'error');"
                            oninput="this.setCustomValidity('');">
                        </div>

                        <!-- Logo Upload -->
                        <div class="mb-3">
                            <label class="form-label">Brand Logo</label>
                            <div class="image-upload" id="imageUpload">
                                <img src="${empty brand.logo ? 'https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png' : brand.logo}" 
                                     id="imagePreview" alt="Brand Logo Preview" />
                                <div class="text-muted small">Click or drag & drop an image</div>
                                <input type="file" name="logoFile" id="imageInput" accept="image/*" class="d-none">
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i data-lucide="${formAction == 'update' ? 'save' : 'plus'}" style="width:18px; height:18px;"></i>
                                ${formAction == 'update' ? 'Save Changes' : 'Add Brand'}
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/manage-brands" class="btn btn-secondary">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Active sidebar
                var el = document.getElementById('brand');
                if (el)
                    el.classList.add('active');

                // Lucide icons
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }

                // Image upload preview
                const uploadArea = document.getElementById('imageUpload');
                const fileInput = document.getElementById('imageInput');
                const preview = document.getElementById('imagePreview');

                uploadArea.addEventListener('click', () => fileInput.click());

                fileInput.addEventListener('change', (e) => {
                    if (e.target.files.length > 0) {
                        const reader = new FileReader();
                        reader.onload = (event) => preview.src = event.target.result;
                        reader.readAsDataURL(e.target.files[0]);
                    }
                });

                // Drag & Drop
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
                        reader.onload = (event) => preview.src = event.target.result;
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
    </body>
</html>
