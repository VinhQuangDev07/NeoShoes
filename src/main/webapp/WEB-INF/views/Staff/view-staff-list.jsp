<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Staff - NeoShoes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

            .staff-table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
            }

            .table thead {
                background-color: #f8f9fa;
            }

            .staff-avatar {
                width: 45px;
                height: 45px;
                object-fit: cover;
            }

            .badge-admin {
                background-color: #d1f4e0;
                color: #0f7d3f;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
                font-size: 0.75rem;
            }

            .badge-staff {
                background-color: #e3f2fd;
                color: #1976d2;
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

            .btn-view {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .btn-view:hover {
                background-color: #1976d2;
                color: white;
                transform: scale(1.1);
            }

            .btn-edit {
                background-color: #fff3cd;
                color: #b58100;
            }
            .btn-edit:hover {
                background-color: #b58100;
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

            .sidebar-toggle {
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1100;
                display: none;
            }

            @media (max-width: 991.98px) {
                .sidebar-toggle {
                    display: block;
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

        <div id="main-content">
            <div class="container-fluid p-4">

                <!-- Page Header -->
                <div class="page-header">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h2 class="mb-0 fw-bold">Staff List</h2>
                            <p class="text-muted mb-0 mt-1">Manage and view all staff members</p>
                        </div>
                        <div class="col-md-6 text-md-end mt-3 mt-md-0">
                            <a href="${pageContext.request.contextPath}/staff/manage-staff?action=add" class="btn btn-primary px-4">
                                <i data-lucide="plus-circle"></i> Add Staff
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Staff Table -->
                <div class="card border-0 shadow-sm staff-table">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="px-4 py-3" style="width: 80px;">#</th>
                                        <th class="py-3">INFORMATION</th>
                                        <th class="py-3">EMAIL</th>
                                        <th class="py-3">PHONE</th>
                                        <th class="py-3 text-center">ROLE</th>
                                        <th class="py-3 text-center">ACTIONS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty staffList}">
                                            <tr>
                                                <td colspan="6" class="text-center py-4 text-muted">
                                                    No staff found
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="staff" items="${staffList}" varStatus="status">
                                                <tr>
                                                    <td class="px-4">${status.index + 1}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${not empty staff.displayAvatar ? staff.displayAvatar : 'https://png.pngtree.com/png-clipart/20220704/original/pngtree-administrator-account-avatar-boss-business-png-image_8307920.png'}"
                                                                 alt="Avatar"
                                                                 class="rounded-circle staff-avatar me-3"
                                                                 onerror="this.src='https://png.pngtree.com/png-clipart/20220704/original/pngtree-administrator-account-avatar-boss-business-png-image_8307920.png'">
                                                            <div>
                                                                <div class="fw-semibold">${staff.name}</div>
                                                                <div class="text-muted small">#${staff.staffId}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${staff.email}</td>
                                                    <td>${not empty staff.phoneNumber ? staff.phoneNumber : 'N/A'}</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${staff.roleName eq 'Admin'}">
                                                                <span class="badge-admin">Admin</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-staff">Staff</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <button type="button"
                                                                class="action-btn btn-view"
                                                                title="View"
                                                                onclick="location.href = '${pageContext.request.contextPath}/staff/manage-staff?action=view&id=${staff.staffId}'">
                                                            <i data-lucide="eye" style="width:16px;height:16px;"></i>
                                                        </button>
                                                        <button type="button"
                                                                class="action-btn btn-edit"
                                                                title="Edit"
                                                                onclick="location.href = '${pageContext.request.contextPath}/staff/manage-staff?action=edit&id=${staff.staffId}'">
                                                            <i data-lucide="edit" style="width:16px;height:16px;"></i>
                                                        </button>
                                                        <button type="button"
                                                                class="action-btn btn-delete"
                                                                title="Delete"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#confirmModal"
                                                                data-id="${staff.staffId}"
                                                                data-name="${staff.name}">
                                                            <i data-lucide="trash" style="width:16px;height:16px;"></i>
                                                        </button>
                                                    </td>
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
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-sm">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p id="confirmModalMessage">Are you sure you want to delete this staff?</p>
                    </div>
                    <div class="modal-footer border-0 d-flex justify-content-center">
                        <form id="confirmForm" action="${pageContext.request.contextPath}/staff/manage-staff" method="post">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="confirmStaffId">
                            <button type="submit" class="btn btn-danger px-4" id="confirmSubmitBtn">Delete</button>
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                    document.addEventListener('DOMContentLoaded', function () {
                                                                        const confirmModal = document.getElementById('confirmModal');
                                                                        confirmModal.addEventListener('show.bs.modal', function (event) {
                                                                            const button = event.relatedTarget;
                                                                            const id = button.getAttribute('data-id');
                                                                            const name = button.getAttribute('data-name');

                                                                            document.getElementById('confirmStaffId').value = id;
                                                                            document.getElementById('confirmModalMessage').textContent =
                                                                                    'Are you sure you want to delete staff: ' + name + '?';
                                                                        });

                                                                        if (typeof lucide !== 'undefined')
                                                                            lucide.createIcons();
                                                                    });
        </script>

    </body>
</html>
