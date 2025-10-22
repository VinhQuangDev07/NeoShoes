<%-- 
    Document   : import-record-list
    Created on : Oct 19, 2025, 8:32:21 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Import Records - Admin Dashboard</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background-color: #f8f9fa;
                padding-top: 74px;
            }

            .main-content {
                margin-left: 300px;
                padding: 2rem;
                transition: margin-left 0.3s ease;
            }

            @media (max-width: 991.98px) {
                .main-content {
                    margin-left: 0;
                }
            }

            .page-header {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .filter-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .table-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .btn-action {
                padding: 0.375rem 0.75rem;
                font-size: 0.875rem;
            }

            .table-responsive {
                border-radius: 8px;
                overflow: hidden;
            }

            .table > :not(caption) > * > * {
                padding: 1rem 0.75rem;
            }

            .table thead th {
                background-color: #f8f9fa;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.5px;
                color: #6c757d;
                border-bottom: 2px solid #dee2e6;
            }

            .badge-staff {
                background-color: #e7f1ff;
                color: #0d6efd;
                padding: 0.35rem 0.75rem;
                border-radius: 6px;
                font-weight: 500;
            }

            .action-buttons {
                display: flex;
                gap: 0.5rem;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="common/staff-sidebar.jsp"/>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Import Records</h2>
                        <p class="text-muted mb-0">Manage product import transactions</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/staff/import-product" class="btn btn-primary">
                        <i data-lucide="plus" style="width: 18px; height: 18px;"></i>
                        Import Product
                    </a>
                </div>
            </div>

            <!-- Filters -->
            <div class="filter-card">
                <form method="get" action="${pageContext.request.contextPath}/staff/import-records">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Search</label>
                            <input type="text" 
                                   name="phrase" 
                                   class="form-control" 
                                   placeholder="Supplier, note, or staff name..."
                                   value="${param.phrase}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">From Date</label>
                            <input type="date" 
                                   name="from" 
                                   class="form-control"
                                   value="${param.from}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">To Date</label>
                            <input type="date" 
                                   name="to" 
                                   class="form-control"
                                   value="${param.to}">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i data-lucide="search" style="width: 16px; height: 16px;"></i>
                                Search
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Import Date</th>
                                <th>Supplier</th>
                                <th>Staff</th>
                                <th>Note</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="record" items="${importRecords}">
                                <tr>
                                    <td>
                                        <strong>#${record.importProductId}</strong>
                                    </td>
                                    <td>
                                        <p>${record.formattedImportDate}</p>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty record.supplierName}">
                                                ${record.supplierName}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge-staff">${record.staffName}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty record.note}">
                                                ${record.note}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons justify-content-end">
                                            <a href="${pageContext.request.contextPath}/staff/import-record-details?id=${record.importProductId}" 
                                               class="btn btn-sm btn-outline-primary btn-action"
                                               title="View Details">
                                                <i data-lucide="eye" style="width: 16px; height: 16px;"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/staff/update-import-record?id=${record.importProductId}" 
                                               class="btn btn-sm btn-outline-secondary btn-action"
                                               title="Edit">
                                                <i data-lucide="edit" style="width: 16px; height: 16px;"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty importRecords}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i data-lucide="inbox" style="width: 48px; height: 48px;" class="text-muted mb-3"></i>
                                        <p class="text-muted mb-0">No import records found</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${not empty importRecords && totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&phrase=${param.phrase}&from=${param.from}&to=${param.to}">
                                    Previous
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&phrase=${param.phrase}&from=${param.from}&to=${param.to}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&phrase=${param.phrase}&from=${param.from}&to=${param.to}">
                                    Next
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Initialize Lucide icons
            lucide.createIcons();

            // Set active sidebar link
            document.addEventListener('DOMContentLoaded', function () {
                const importLink = document.querySelector('#sidebar a[href*="import"]');
                if (importLink) {
                    document.querySelectorAll('#sidebar .nav-link').forEach(l => l.classList.remove('active'));
                    importLink.classList.add('active');
                }
            });
        </script>
    </body>
</html>