<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>

            :root{
                --header-h: 74px;   /* cao header cố định */
                --sidebar-w: 300px; /* đúng đúng với staff-sidebar.jsp của bạn */
            }

            * {
                box-sizing: border-box;
                font-family: Arial, Helvetica, sans-serif;
            }
            body{
                margin:0;
                background:#f5f6f8;
                color:#111827;
                padding-top: var(--header-h);   /* QUAN TRỌNG */
            }



            /* CONTENT WRAP */
            .wrap{
                padding: 20px 24px;
                margin-left: var(--sidebar-w);  /* QUAN TRỌNG */
                width: calc(100% - var(--sidebar-w));  /* QUAN TRỌNG */
                max-width: none;                /* để full chiều ngang còn lại */
            }

            /* Role switcher */
            .role-switcher {
                margin-bottom: 12px;
                padding: 10px 12px;
                background: #f3f4f6;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
            }
            .role-switcher a {
                margin-right: 12px;
                text-decoration: none;
                color: #2563eb;
                font-weight: 600;
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

            /* Toolbar */
            .toolbar {
                margin: 14px 0 18px;
            }
            .btn-add {
                display: inline-block;
                padding: 10px 14px;
                border-radius: 10px;
                background: #111827;
                color: #fff;
                text-decoration: none;
                font-weight: 700;
                transition: .15s;
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

            /* Column widths */
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
                background: #111827;
                color: #fff;
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

            /* Voucher Code */
            .voucher-code {
                font-family: 'Courier New', monospace;
                font-weight: 700;
                color: #111827;
                font-size: 13px;
                display: block;
                text-decoration: none;
                transition: color 0.2s;
            }
            .voucher-code:hover {
                color: #2563eb;
            }

            /* Value column */
            .value-cell {
                font-weight: 700;
                font-size: 14px;
                color: #dc2626;
                white-space: nowrap;
            }

            /* Currency values */
            .currency {
                color: #059669;
                font-weight: 600;
                white-space: nowrap;
            }

            /* Date values */
            .date-value {
                font-size: 12px;
                color: #374151;
                white-space: nowrap;
            }

            /* Usage column */
            .usage-cell {
                font-weight: 600;
                text-align: center;
                white-space: nowrap;
            }

            /* Badges */
            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 700;
                white-space: nowrap;
            }
            .badge-active {
                background: #dcfce7;
                color: #166534;
            }
            .badge-inactive {
                background: #fee2e2;
                color: #991b1b;
            }
            .badge-expired {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* Actions buttons */
            .actions {
                display: flex;
                gap: 6px;
                flex-wrap: nowrap;
            }
            .btn-action {
                padding: 7px 12px;
                border-radius: 7px;
                border: 1px solid;
                text-decoration: none;
                font-weight: 700;
                font-size: 12px;
                transition: .15s;
                white-space: nowrap;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }
            .btn-view {
                background: #f0f9ff;
                color: #0369a1;
                border-color: #bae6fd;
            }
            .btn-view:hover {
                background: #e0f2fe;
                transform: translateY(-1px);
                color: #0369a1;
            }
            .btn-edit {
                background: #eef2ff;
                color: #3730a3;
                border-color: #c7d2fe;
            }
            .btn-edit:hover {
                background: #e0e7ff;
                transform: translateY(-1px);
                color: #3730a3;
            }
            .btn-delete {
                background: #fef2f2;
                color: #991b1b;
                border-color: #fecaca;
            }
            .btn-delete:hover {
                background: #fee2e2;
                transform: translateY(-1px);
                color: #991b1b;
            }
            .btn-toggle {
                background: #f0fdf4;
                color: #166534;
                border-color: #bbf7d0;
            }
            .btn-toggle:hover {
                background: #dcfce7;
                transform: translateY(-1px);
                color: #166534;
            }

            /* Empty state */
            .empty {
                padding: 40px 16px;
                text-align: center;
                color: #6b7280;
                font-size: 14px;
            }

            /* ID column */
            .id-cell {
                color: #6b7280;
                font-weight: 600;
                font-size: 12px;
                text-align: center;
            }

            /* Text alignment */
            .text-center {
                text-align: center;
            }
            .text-right {
                text-align: right;
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

        <div class="wrap">
            <!-- Role switch -->
            <div class="role-switcher">
                <strong>Current Role:</strong> <code>${userRole}</code> &nbsp;|&nbsp;
                <a href="<c:url value='/vouchermanage'><c:param name='role' value='admin'/></c:url>">
                        <i class="fas fa-user-shield"></i> Set as Admin
                    </a>
                    <a href="<c:url value='/vouchermanage'><c:param name='role' value='staff'/></c:url>">
                        <i class="fas fa-user"></i> Set as Staff
                    </a>
                </div>


                <!-- Add button (Admin only) -->
            <c:if test="${canModify}">
                <div class="toolbar">
                    <a class="btn-add" href="<c:url value='/vouchermanage/add'><c:param name='role' value='${userRole}'/></c:url>">
                            <i class="fas fa-plus"></i> Add New Voucher
                        </a>
                    </div>
            </c:if>

            <!-- Table -->
            <!-- Chỉ thay thế phần từ <div class="table-card"> đến hết </div> -->

            <div class="table-card">
                <table>
                    <colgroup>
                        <col style="width: 60px;" />      <!-- ID -->
                        <col style="width: 100px;" />     <!-- Code -->
                        <col style="width: 60px;" />     <!-- Value -->
                        <col style="width: 60px;" />     <!-- Min Order -->
                        <col style="width: 60px;" />     <!-- Max Disc -->
                        <col style="width: 60px;" />     <!-- Usage -->
                        <col style="width: 70px;" />      <!-- Status -->
                        <col style="width: 200px;" />      <!-- Actions -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th style="text-align: center;">ID</th>
                            <th>Code</th>
                            <th>Value</th>
                            <th style="text-align: right;">Min Order</th>
                            <th style="text-align: right;">Max Disc.</th>
                            <th style="text-align: center;">Usage</th>
                            <th style="text-align: center;">Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="voucher" items="${vouchers}">
                            <tr>
                                <!-- ID -->
                                <td style="text-align: center; color: #6b7280; font-weight: 600; font-size: 12px;">
                                    ${voucher.voucherId}
                                </td>

                                <!-- Code -->
                                <td>
                                    <a href="<c:url value='/vouchermanage/detail'>
                                           <c:param name='id' value='${voucher.voucherId}'/>
                                           <c:param name='role' value='${userRole}'/>
                                       </c:url>" 
                                       style="font-family: 'Courier New', monospace; font-weight: 700; color: #111827; font-size: 13px; text-decoration: none;"
                                       onmouseover="this.style.color = '#2563eb'"
                                       onmouseout="this.style.color = '#111827'">
                                        ${voucher.voucherCode}
                                    </a>
                                </td>

                                <!-- Value -->
                                <td style="font-weight: 700; font-size: 14px; color: #dc2626; white-space: nowrap;">
                                    <c:choose>
                                        <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                            ${voucher.value}%
                                        </c:when>
                                        <c:otherwise>
                                            $<fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Min Order -->
                                <td style="text-align: right;">
                                    <c:choose>
                                        <c:when test="${not empty voucher.minValue && voucher.minValue > 0}">
                                            <span style="color: #059669; font-weight: 600;">
                                                $<fmt:formatNumber value="${voucher.minValue}" pattern="#,##0"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #9ca3af;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Max Discount -->
                                <td style="text-align: right;">
                                    <c:choose>
                                        <c:when test="${not empty voucher.maxValue && voucher.maxValue > 0}">
                                            <span style="color: #059669; font-weight: 600;">
                                                $<fmt:formatNumber value="${voucher.maxValue}" pattern="#,##0"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #9ca3af;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Usage -->
                                <td style="text-align: center; font-weight: 600;">
                                    <c:choose>
                                        <c:when test="${not empty voucher.usageCount && not empty voucher.totalUsageLimit}">
                                            ${voucher.usageCount}/${voucher.totalUsageLimit}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #9ca3af;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Status -->
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${voucher.expired}">
                                            <span class="badge badge-expired">Expired</span>
                                        </c:when>
                                        <c:when test="${voucher.active}">
                                            <span class="badge badge-active">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-inactive">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Actions -->
                                <td>
                                    <div class="actions">
                                        <a class="btn btn-view"
                                           href="<c:url value='/vouchermanage/detail'>
                                               <c:param name='id' value='${voucher.voucherId}'/>
                                               <c:param name='role' value='${userRole}'/>
                                           </c:url>">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <c:if test="${canModify}">
                                            <a class="btn btn-edit"
                                               href="<c:url value='/vouchermanage/edit'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i class="fas fa-edit"></i>
                                            </a>

                                            <a class="btn btn-toggle"
                                               href="<c:url value='/vouchermanage/toggle'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i class="fas fa-toggle-${voucher.active ? 'on' : 'off'}"></i>
                                                ${voucher.active ? 'Off' : 'On'}
                                            </a>

                                            <a class="btn btn-delete"
                                               href="<c:url value='/vouchermanage/delete'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>"
                                               onclick="return confirm('Delete ${voucher.voucherCode}?');">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty vouchers}">
                    <div class="empty">
                        <i class="fas fa-inbox fa-3x mb-3" style="color: #d1d5db;"></i>
                        <p>No vouchers found.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                   // Initialize Lucide icons
                                                   lucide.createIcons();

        </script>

        <!--        <script>
                    // 1) Tự ẩn sau 3 giây
                    window.addEventListener('DOMContentLoaded', () => {
                        document.querySelectorAll('.alert').forEach(el => {
                            setTimeout(() => {
                                // dùng API của Bootstrap 5 để đóng alert
                                const inst = bootstrap.Alert.getOrCreateInstance(el);
                                inst.close();
                            }, 3000); // đổi 3000 -> 5000 nếu muốn lâu hơn
                        });
                    });
        
                    // 2) Xóa param success/error khỏi URL sau khi đã render
                    (function removeMsgParams() {
                        const url = new URL(window.location.href);
                        let changed = false;
                        ['success', 'error'].forEach(k => {
                            if (url.searchParams.has(k)) {
                                url.searchParams.delete(k);
                                changed = true;
                            }
                        });
                        if (changed) {
                            window.history.replaceState({}, '', url.pathname + (url.search ? url.search : ''));
                        }
                    })();
                </script>-->

    </body>
</html>