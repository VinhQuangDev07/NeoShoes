<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Categories - NeoShoes</title>

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

            .category-table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
            }

            .table thead {
                background-color: #f8f9fa;
            }

            .category-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                background: #fff;
            }

            .badge-active {
                background-color: #d1f4e0;
                color: #0f7d3f;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
                font-size: 0.75rem;
            }

            .badge-inactive {
                background-color: #ffe0e0;
                color: #d32f2f;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
                font-size: 0.75rem;
            }

            .action-btn {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
                margin: 0 2px;
            }

            .btn-edit {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .btn-edit:hover {
                background-color: #1976d2;
                color: white;
                transform: scale(1.1);
            }

            .btn-toggle {
                background-color: #fff7e6;
                color: #b45309;
            }

            .btn-toggle:hover {
                background-color: #facc15;
                color: white;
                transform: scale(1.1);
            }

            .btn-delete {
                background-color: #ffebee;
                color: #d32f2f;
            }

            .btn-delete:hover {
                background-color: #d32f2f;
                color: white;
                transform: scale(1.1);
            }

            .page-header .btn-add {
                background-color: #0d6efd;
                color: white;
                border-radius: 8px;
                padding: 10px 16px;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-weight: 500;
                transition: all 0.2s;
                border: none;
                text-decoration: none;
            }

            .page-header .btn-add:hover {
                background-color: #0b5ed7;
                transform: translateY(-1px);
            }

            .empty-message {
                text-align: center;
                padding: 24px;
                color: #6c757d;
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

        <!-- Main Content -->
        <div id="main-content">
            <div class="container-fluid p-4">

                <!-- Page Header -->
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1 fw-bold">Category List</h2>
                        <p class="text-muted mb-0 mt-1">Manage and view all categories</p>
                    </div>
                    <c:if test="${sessionScope.role eq 'admin'}">
                        <a href="${pageContext.request.contextPath}/staff/manage-categories/add" class="btn-add">
                            <i data-lucide="plus" style="width:18px; height:18px;"></i>
                            New Category
                        </a>
                    </c:if>
                </div>

                <!-- Category Table -->
                <div class="card border-0 shadow-sm category-table">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="px-4 py-3" style="width: 80px;">#</th>
                                        <th class="py-3">IMAGE</th>
                                        <th class="py-3">NAME</th>
                                        <th class="py-3 text-center">STATUS</th>
                                            <c:if test="${sessionScope.role eq 'admin'}">
                                            <th class="py-3 text-center">ACTIONS</th>
                                            </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty categories}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">No categories found</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="category" items="${categories}" varStatus="status">
                                                <tr>
                                                    <td class="px-4">${status.index + 1}</td>
                                                    <td>
                                                        <c:if test="${not empty category.image}">
                                                            <img src="${category.image}" alt="${category.name}" class="category-image"
                                                                 onerror="this.src='https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png'">
                                                        </c:if>
                                                        <c:if test="${empty category.image}">
                                                            <img src="https://res.cloudinary.com/drqip0exk/image/upload/v1762335624/image-not-found_0221202211372462137974b6c1a_wgc1rc.png" class="category-image" alt="No image">
                                                        </c:if>
                                                    </td>
                                                    <td>${category.name}</td>
                                                    <td class="text-center">
                                                        <span class="${category.isActive ? 'badge-active' : 'badge-inactive'}">
                                                            ${category.isActive ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <c:if test="${sessionScope.role eq 'admin'}">
                                                        <td class="text-center">
                                                            <div class="d-inline-flex align-items-center">
                                                                <a href="${pageContext.request.contextPath}/staff/manage-categories/edit?id=${category.categoryId}" 
                                                                   class="action-btn btn-edit" title="Edit">
                                                                    <i data-lucide="edit"></i>
                                                                </a>

                                                                <button type="button" 
                                                                        class="action-btn btn-delete"
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#confirmDeleteModal"
                                                                        data-category-id="${category.categoryId}">
                                                                    <i data-lucide="trash-2"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </c:if>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
            </div>
        </div>

        <!-- Confirm Delete Modal -->
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-sm">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Confirm Delete</h5>
                    </div>
                    <div class="modal-body text-center">
                        <p>Are you sure you want to delete this category?</p>
                    </div>
                    <div class="modal-footer border-0 d-flex justify-content-center">
                        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/staff/manage-categories/delete">
                            <input type="hidden" name="id" id="deleteCategoryId">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            lucide.createIcons();

            const confirmDeleteModal = document.getElementById('confirmDeleteModal');
            confirmDeleteModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                const categoryId = button.getAttribute('data-category-id');
                document.getElementById('deleteCategoryId').value = categoryId;
            });
        </script>
    </body>
</html>
