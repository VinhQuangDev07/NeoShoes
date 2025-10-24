<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff List - NeoShoes Admin</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background: #f8f9fa;
                padding-top: 74px;
            }
            .main-content {
                margin-left: 300px;
                padding: 2rem;
            }
            .page-title {
                font-size: 28px;
                font-weight: 700;
                color: #111827;
                margin-bottom: .5rem;
            }
            .page-subtitle {
                color: #6b7280;
                margin-bottom: 2rem;
            }
            .role-switcher {
                margin-bottom: 1rem;
                padding: 10px 12px;
                background: #f3f4f6;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                font-size: 14px;
            }
            .role-switcher a {
                color: #2563eb;
                font-weight: 600;
                text-decoration: none;
                margin-left: 10px;
            }
            .role-switcher a:hover {
                text-decoration: underline;
            }
            .stat-card {
                background: #fff;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 1px 3px rgba(0,0,0,.1);
                border: 1px solid #e5e7eb;
            }
            .stat-card:hover {
                transform: translateY(-2px);
            }
            .stat-icon {
                width: 48px;
                height: 48px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                color: #fff;
            }
            .table-card {
                background: #fff;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 1px 3px rgba(0,0,0,.1);
                border: 1px solid #e5e7eb;
            }
            .search-box {
                background: #fff;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 1px 3px rgba(0,0,0,.1);
                border: 1px solid #e5e7eb;
            }
            .avatar-sm {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid #e5e7eb;
            }
            .badge-role {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge-admin {
                background: #dbeafe;
                color: #1e40af;
            }
            .badge-staff {
                background: #d1fae5;
                color: #065f46;
            }
            .btn-action {
                padding: 6px 12px;
                font-size: 13px;
                border-radius: 6px;
            }
            .table thead th {
                background: #f9fafb;
                color: #374151;
                font-weight: 600;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <!-- Header / Sidebar / Notification -->

        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <div class="main-content">

            <!-- Role Switcher (only Set as Admin) -->
            <div class="role-switcher">
                <strong>Current Role:</strong> <code>${userRole}</code>
                <c:url var="setAdminUrl" value="/manage-staff">
                    <c:param name="role" value="admin"/>
                </c:url>
                <c:choose>
                    <c:when test="${userRole ne 'admin'}">
                        | <a href="${setAdminUrl}">Set as Admin</a>
                    </c:when>
                    <c:otherwise>
                        | <span class="badge bg-primary">Admin active</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Page Header -->
            <div class="mb-4">
                <h1 class="page-title"><i class="fas fa-users-cog"></i> Staff Management</h1>
                <p class="page-subtitle">View and manage all staff members</p>
            </div>

            <!-- Statistics -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon" style="background: linear-gradient(135deg,#667eea 0%,#764ba2 100%);">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="ms-3">
                                <h3 class="mb-0">${totalRecords}</h3>
                                <p class="text-muted mb-0">Total Staff</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search & Filter -->
                <div class="search-box">
                    <form method="get" action="${pageContext.request.contextPath}/manage-staff" class="row g-3">
                        <input type="hidden" name="role" value="${userRole}"/>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Search Staff</label>
                            <input type="text" name="keyword" class="form-control"
                                   placeholder="Search by name, email, phone..."
                                   value="${keyword}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Filter by Role</label>
                            <select name="roleFilter" class="form-select">
                                <option value="">All Roles</option>
                                <option value="admin" <c:if test="${roleFilter eq 'admin'}">selected</c:if>>Admin</option>
                                <option value="staff" <c:if test="${roleFilter eq 'staff'}">selected</c:if>>Staff</option>
                                </select>
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-search"></i> Search
                                </button>
                                <a href="${pageContext.request.contextPath}/manage-staff?role=${userRole}" class="btn btn-outline-secondary">
                                <i class="fas fa-redo"></i> Reset
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Staff Table -->
                <div class="table-card">
                    <h5 class="mb-3">
                        <i class="fas fa-list"></i> Staff List
                        <span class="text-muted">(${fn:length(staffList)} results)</span>
                    </h5>

                    <c:choose>
                        <c:when test="${empty staffList}">
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No staff found</h5>
                                <p class="text-muted">Try adjusting your search criteria</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Staff</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Created</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- ✅ MỚI - Chỉ hiển thị Staff (bỏ Admin) -->
                                        <c:forEach items="${staffList}" var="staff">
                                            <c:if test="${!staff.role}">
                                                <tr>
                                                    <td><strong>#${staff.staffId}</strong></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${staff.displayAvatar}" alt="${staff.name}" class="avatar-sm me-2">
                                                            <strong>${staff.name}</strong>
                                                        </div>
                                                    </td>
                                                    <td><small>${staff.email}</small></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty staff.phoneNumber}">
                                                                <small>${staff.phoneNumber}</small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="badge-role badge-staff">
                                                            <i class="fas fa-user"></i>
                                                            ${staff.roleName}
                                                        </span>
                                                    </td>
                                                    <td><small class="text-muted">${staff.formattedCreatedAt}</small></td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/manage-staff?action=view&id=${staff.staffId}" 
                                                           class="btn btn-sm btn-info btn-action">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                            </div>
                        </c:otherwise>
                    </c:choose>


                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script> if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }</script>
    </body>
</html>
