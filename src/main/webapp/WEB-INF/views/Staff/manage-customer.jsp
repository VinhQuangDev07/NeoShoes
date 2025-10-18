<%-- 
    Document   : manage-customer
    Created on : Oct 16, 2025, 10:32:31 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Customer - NeoShoes</title>

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

            .customer-table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
            }

            .table thead {
                background-color: #f8f9fa;
            }

            .customer-avatar {
                width: 45px;
                height: 45px;
                object-fit: cover;
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

            .btn-view {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .btn-view:hover {
                background-color: #1976d2;
                color: white;
                transform: scale(1.1);
            }

            .btn-block {
                background-color: #ffebee;
                color: #d32f2f;
            }

            .btn-block:hover {
                background-color: #d32f2f;
                color: white;
                transform: scale(1.1);
            }

            .btn-unblock {
                background-color: #e8f5e9;
                color: #388e3c;
            }

            .btn-unblock:hover {
                background-color: #388e3c;
                color: white;
                transform: scale(1.1);
            }

            .search-wrapper {
                position: relative;
            }

            .search-icon {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            .search-input {
                padding-left: 40px;
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }

            .search-input:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
            }

            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
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

            #sidebar.show {
                transform: translateX(0) !important;
            }

            .sidebar-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 999;
                display: none;
            }

            .sidebar-overlay.show {
                display: block;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="common/staff-sidebar.jsp"/>

        <!-- Main Content -->
        <div id="main-content">
            <div class="container-fluid p-4">
                <!-- Success/Error Messages -->
                <jsp:include page="/WEB-INF/views/common/notification.jsp" />

                <!-- Page Header -->
                <div class="page-header">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h2 class="mb-0 fw-bold">Customer List</h2>
                            <p class="text-muted mb-0 mt-1">Manage and view all customers</p>
                        </div>
                        <div class="col-md-6 text-md-end mt-3 mt-md-0">
                            <span class="badge bg-primary fs-6">Total: ${totalRecords} customers</span>
                        </div>
                    </div>
                </div>

                <!-- Customer Table -->
                <div class="card border-0 shadow-sm customer-table">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="px-4 py-3" style="width: 80px;">#</th>
                                        <th class="py-3">INFORMATION</th>
                                        <th class="py-3">PHONE</th>
                                        <th class="py-3 text-center">STATUS</th>
                                        <th class="py-3 text-center">ACTIONS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty customers}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">
                                                    No customers found
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="customer" items="${customers}" varStatus="status">
                                                <tr>
                                                    <td class="px-4">${status.index + 1}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${not empty customer.avatar ? customer.avatar : 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg'}" 
                                                                 alt="Avatar" 
                                                                 class="rounded-circle customer-avatar me-3"
                                                                 onerror="this.src='https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg'">
                                                            <div>
                                                                <div class="fw-semibold">${customer.name}</div>
                                                                <div class="text-muted small">${customer.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${not empty customer.phoneNumber ? customer.phoneNumber : 'N/A'}</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${customer.isBlock()}">
                                                                <span class="badge-inactive">Blocked</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-active">Active</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <!-- View Detail Button -->
                                                        <form action="manage-customer" method="POST" style="display: inline;">
                                                            <input type="hidden" name="action" value="view-detail">
                                                            <input type="hidden" name="customerId" value="${customer.id}">
                                                            <button type="submit" class="action-btn btn-view" title="View Details">
                                                                <i data-lucide="eye" style="width: 18px; height: 18px;"></i>
                                                            </button>
                                                        </form>

                                                        <!-- Block/Unblock Button (Admin Only) -->
                                                        <c:if test="${sessionScope.role eq 'admin'}">
                                                            <c:choose>
                                                                <c:when test="${customer.isBlock()}">
                                                                    <form action="manage-customer" method="POST" style="display: inline;">
                                                                        <input type="hidden" name="action" value="unblock">
                                                                        <input type="hidden" name="customerId" value="${customer.id}">
                                                                        <button type="submit" class="action-btn btn-unblock" 
                                                                                title="Unblock Customer"
                                                                                onclick="return confirm('Are you sure you want to unblock this customer?')">
                                                                            <i data-lucide="unlock" style="width: 18px; height: 18px;"></i>
                                                                        </button>
                                                                    </form>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form action="manage-customer" method="POST" style="display: inline;">
                                                                        <input type="hidden" name="action" value="block">
                                                                        <input type="hidden" name="customerId" value="${customer.id}">
                                                                        <button type="submit" class="action-btn btn-block" 
                                                                                title="Block Customer"
                                                                                onclick="return confirm('Are you sure you want to block this customer?')">
                                                                            <i data-lucide="ban" style="width: 18px; height: 18px;"></i>
                                                                        </button>
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                                    // Initialize Lucide icons
                                                                                    lucide.createIcons();

        </script>
    </body>
</html>
