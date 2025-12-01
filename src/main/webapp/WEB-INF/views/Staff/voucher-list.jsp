<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Management - NeoShoes</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            :root{
                --header-h: 74px;
                --sidebar-w: 300px;
            }

            * {
                box-sizing: border-box;
                font-family: Arial, Helvetica, sans-serif;
            }
            body{
                margin:0;
                background:#f5f6f8;
                color:#111827;
                padding-top: var(--header-h);
            }

            .wrap{
                padding: 20px 24px;
                margin-left: var(--sidebar-w);
                width: calc(100% - var(--sidebar-w));
                max-width: none;
            }

            /* Alert messages */
            .alert-success {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #86efac;
            }
            .alert-danger {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Page header */
            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .page-header h2 {
                margin: 0;
                font-weight: 700;
            }

            /* Toolbar */
            .toolbar {
                margin: 14px 0 18px;
            }
            .btn-add {
                display: inline-block;
                padding: 10px 14px;
                border-radius: 10px;
                color: #fff;
                text-decoration: none;
                font-weight: 700;
                transition: .15s;
                background: #3b82f6;
            }
            .btn-add:hover {
                filter: brightness(.9);
                transform: translateY(-1px);
                color: #fff;
            }

            /* Table */
            .table-card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                overflow-x: auto;
                box-shadow: 0 10px 20px rgba(17,24,39,.04);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
                min-width: 1200px;
            }

            colgroup col.col-id {
                width: 60px;
            }
            colgroup col.col-code {
                width: 150px;
            }
            colgroup col.col-value {
                width: 110px;
            }
            colgroup col.col-min {
                width: 100px;
            }
            colgroup col.col-max {
                width: 100px;
            }
            colgroup col.col-start {
                width: 110px;
            }
            colgroup col.col-end {
                width: 110px;
            }
            colgroup col.col-usage {
                width: 100px;
            }
            colgroup col.col-status {
                width: 90px;
            }
            colgroup col.col-actions {
                width: auto;
            }

            thead th {
                background-color: #f8f9fa;
                color: #6c757d;
                padding: 14px 12px;
                text-align: left;
                font-weight: 700;
                letter-spacing: .3px;
                font-size: 13px;
                white-space: nowrap;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            tbody td {
                padding: 14px 12px;
                border-top: 1px solid #f1f5f9;
                vertical-align: middle;
                font-size: 13px;
            }

            tbody tr:hover {
                background: #f9fafb;
            }

            .voucher-code {
                font-family: 'Courier New', monospace;
                font-weight: 700;
                color: #111827;
                font-size: 13px;
            }

            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .badge-active {
                background: #dcfce7;
                color: #166534;
            }

            .badge-inactive {
                background: #fee2e2;
                color: #991b1b;
            }

            .badge-percentage {
                background: #dbeafe;
                color: #1e40af;
            }

            .badge-fixed {
                background: #fef3c7;
                color: #92400e;
            }

            /* Actions */
            .actions {
                display: flex;
                gap: 8px;
                justify-content: center;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
                border: none;
                cursor: pointer;
            }

            .btn-view {
                background: #e0edff;
                color: #2563eb;
            }

            .btn-view:hover {
                background: #4338ca;
                color: white;
            }

            .btn-edit {
                background: #fff7e0;          /* nền vàng nhạt */
                color: #f59e0b;
            }

            .btn-edit:hover {
                background: #1e40af;
                color: white;
            }

            .btn-toggle {
                background: #fef3c7;
                color: #92400e;
            }

            .btn-toggle:hover {
                background: #92400e;
                color: white;
            }

            .btn-delete {
                background: #fee2e2;          /* nền đỏ nhạt */
                color: #dc2626;
            }

            .btn-delete:hover {
                background: #991b1b;
                color: white;
            }

            .empty-message {
                text-align: center;
                padding: 40px;
                color: #6b7280;
            }
        </style>
    </head>
    <body>
        <!-- Header & Sidebar -->
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <div class="wrap">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h2>Voucher Management</h2>
                    <p class="text-muted mb-0 mt-1">Manage discount vouchers</p>
                </div>
                <!-- Chỉ admin mới thấy nút Add -->
                <c:if test="${canModify}">
                    <a href="${pageContext.request.contextPath}/staff/manage-voucher/add" class="btn-add" >
                        <i class="fas fa-plus"></i> New Voucher
                    </a>
                </c:if>
            </div>

            <!-- Voucher Table -->
            <div class="table-card">
                <table>
                    <colgroup>
                        <col class="col-id">
                        <col class="col-code">
                        <col class="col-value">
                        <col class="col-min">
                        <col class="col-max">
                        <col class="col-start">
                        <col class="col-end">
                        <col class="col-usage">
                        <col class="col-status">
                        <col class="col-actions">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>CODE</th>
                            <th>TYPE/VALUE</th>
                            <th>MIN ORDER</th>
                            <th>MAX DISC</th>
                            <th>START</th>
                            <th>END</th>
                            <th>USAGE</th>
                            <th>STATUS</th>
                            <th style="text-align: center;">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty vouchers}">
                                <tr>
                                    <td colspan="10" class="empty-message">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>No vouchers found</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="voucher" items="${vouchers}">
                                    <tr>
                                        <td>${voucher.voucherId}</td>
                                        <td>
                                            <span class="voucher-code">${voucher.voucherCode}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                                    <span class="badge badge-percentage">${voucher.value}%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-fixed">$${voucher.value}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty voucher.minValue}">
                                                    $${voucher.minValue}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty voucher.maxValue}">
                                                    $${voucher.maxValue}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${voucher.startDateAsDate}" pattern="yyyy-MM-dd"/>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${voucher.endDateAsDate}" pattern="yyyy-MM-dd"/>
                                        </td>
                                        <td>
                                            ${voucher.usageCount != null ? voucher.usageCount : 0}
                                            <c:if test="${voucher.totalUsageLimit != null}">
                                                / ${voucher.totalUsageLimit}
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${voucher.active}">
                                                    <span class="badge badge-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <!-- View - Cả admin và staff đều xem được -->
                                                <a class="btn btn-view"
                                                   href="${pageContext.request.contextPath}/staff/manage-voucher/detail?id=${voucher.voucherId}"
                                                   title="View">
                                                    <i data-lucide="eye"></i>
                                                </a>

                                                <!-- Edit, Toggle, Delete - Chỉ admin -->
                                                <c:if test="${canModify}">
                                                    <a class="btn btn-edit"
                                                       href="${pageContext.request.contextPath}/staff/manage-voucher/edit?id=${voucher.voucherId}"
                                                       title="Edit">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <button type="button" class="btn btn-delete"
                                                            data-id="${voucher.voucherId}"
                                                            data-code="${voucher.voucherCode}"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmDeleteModal"
                                                            title="Delete">
                                                        <i data-lucide="trash-2"></i>
                                                    </button>

                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            lucide.createIcons();
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const deleteModal = document.getElementById("confirmDeleteModal");
                const deleteMessage = document.getElementById("deleteMessage");
                const deleteForm = document.getElementById("deleteForm");

                deleteModal.addEventListener("show.bs.modal", (event) => {
                    const button = event.relatedTarget; // nút được bấm
                    const id = button.getAttribute("data-id");
                    const code = button.getAttribute("data-code");

                    // Cập nhật nội dung modal
                    deleteMessage.textContent = 'Are you sure you want to delete voucher "' + code + '"?';
                    deleteForm.action = `${window.contextPath || '${pageContext.request.contextPath}'}/staff/manage-voucher/delete?id=${id}`;
                            });

                            // Render icon lại khi modal hiển thị
                            deleteModal.addEventListener("shown.bs.modal", () => lucide.createIcons());
                        });
        </script>

        <!-- Confirm Delete Modal -->
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-sm rounded-3">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold text-danger">
                            <i data-lucide="trash-2" class="me-1"></i> Delete Voucher
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body text-center">
                        <p id="deleteMessage" class="mb-2">Are you sure you want to delete this voucher?</p>
                        <p class="text-muted small mb-0">This action cannot be undone.</p>
                    </div>

                    <div class="modal-footer border-0 d-flex justify-content-center gap-2">
                        <form id="deleteForm" method="post" action="">
                            <button type="submit" class="btn btn-danger px-4">
                                <i data-lucide="trash-2" class="me-1"></i> Delete
                            </button>
                        </form>
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>