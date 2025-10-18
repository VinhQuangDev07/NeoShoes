<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <style>
            /* ========== BASE STYLES ========== */
            * {
                box-sizing: border-box;
                font-family: Arial, Helvetica, sans-serif;
            }
            body {
                margin: 0;
                padding: 0;
                background: #f5f6f8;
                color: #111827;
            }

            /* ========== PAGE HEADER ========== */
            .page-head {
                background: #000;
                color: #fff;
                padding: 20px 24px;
            }
            .page-head h1 {
                margin: 0;
                font-size: 22px;
                font-weight: 700;
                letter-spacing: .2px;
            }

            /* ========== CONTAINER ========== */
            .wrap {
                padding: 20px 24px;
                max-width: 1400px;
                margin: 0 auto;
            }

            /* ========== ROLE SWITCHER ========== */
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

            /* ========== ALERTS ========== */
            .alert {
                padding: 12px 16px;
                margin-bottom: 16px;
                border-radius: 8px;
                font-weight: 600;
            }
            .alert-success {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #86efac;
            }
            .alert-error {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* ========== ADD BUTTON ========== */
            .toolbar {
                margin: 14px 0 18px;
            }
            .btn-add {
                display: inline-block;
                padding: 10px 16px;
                border-radius: 10px;
                background: #111827;
                color: #fff;
                text-decoration: none;
                font-weight: 700;
                transition: 0.2s;
            }
            .btn-add:hover {
                background: #1f2937;
                transform: translateY(-1px);
            }

            /* ========== TABLE ========== */
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
                min-width: 1000px;
                table-layout: fixed;
            }
            thead th {
                background: #111827;
                color: #fff;
                padding: 12px 14px;
                text-align: left;
                font-weight: 700;
                letter-spacing: .2px;
                white-space: nowrap;
            }
            tbody td {
                padding: 12px 14px;
                border-top: 1px solid #f1f5f9;
                vertical-align: middle;
            }

            /* ========== BADGES ========== */
            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 12px;
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
            .badge-percentage {
                background: #dbeafe;
                color: #1e40af;
            }
            .badge-fixed {
                background: #fef3c7;
                color: #92400e;
            }
            .badge-expired {
                background: #f3f4f6;
                color: #6b7280;
            }

            /* ========== CODE COLUMN ========== */
            .voucher-code {
                font-family: 'Courier New', monospace;
                font-weight: 700;
                color: #111827;
                font-size: 14px;
            }

            /* ========== ACTIONS COLUMN (FINAL) ========== */

            /* Khóa cột cố định & căn phải */
            thead th:last-child,
            tbody td:last-child {
                width: 180px;
                text-align: right;
                white-space: nowrap;
            }

            /* Container */
            .actions {
                display: inline-flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
            }

            /* Icon buttons */
            .icon-btn {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border: 1px solid transparent;
                text-decoration: none;
                font-size: 18px;
                line-height: 1;
                transition: all 0.25s ease;
                cursor: pointer;
            }
            .icon-btn i {
                pointer-events: none;
            }

            /* Màu theo chức năng */
            .icon-btn.edit {
                background: #eef2ff;
                color: #3730a3;
                border-color: #c7d2fe;
            }
            .icon-btn.toggle {
                background: #ecfdf5;
                color: #065f46;
                border-color: #bbf7d0;
            }
            .icon-btn.delete {
                background: #fef2f2;
                color: #991b1b;
                border-color: #fecaca;
            }

            /* Hover effect */
            .icon-btn:hover {
                transform: scale(1.08);
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            }
            .icon-btn.edit:hover {
                background: #e0e7ff;
                color: #1e3a8a;
            }
            .icon-btn.toggle:hover {
                background: #d1fae5;
                color: #064e3b;
            }
            .icon-btn.delete:hover {
                background: #fee2e2;
                color: #7f1d1d;
            }

            /* ========== EMPTY STATE ========== */
            .empty {
                padding: 32px 16px;
                text-align: center;
                color: #6b7280;
                font-size: 14px;
            }

            /* ========== RESPONSIVE ========== */
            @media (max-width: 768px) {
                .wrap {
                    padding: 12px;
                }
                .table-card {
                    border-radius: 8px;
                }
                thead th:last-child, tbody td:last-child {
                    width: 1%;
                    text-align: left;
                }
                .actions {
                    justify-content: flex-start;
                    gap: 10px;
                }
                .icon-btn {
                    width: 36px;
                    height: 36px;
                    font-size: 16px;
                }
            }





        </style>
    </head>
    <body>
        <!-- PAGE HEADER -->
        <div class="page-head">
            <h1>Voucher Management</h1>
        </div>

        <div class="wrap">
            <!-- Role switch -->
            <div class="role-switcher">
                <strong>Current Role:</strong> <code>${userRole}</code> &nbsp;|&nbsp;
                <a href="<c:url value='/vouchermanage'><c:param name='role' value='admin'/></c:url>">Set as Admin</a>
                <a href="<c:url value='/vouchermanage'><c:param name='role' value='staff'/></c:url>">Set as Staff</a>
                </div>

                <!-- Success/Error messages -->
            <c:if test="${param.success eq 'added'}">
                <div class="alert alert-success">✅ Voucher added successfully!</div>
            </c:if>
            <c:if test="${param.success eq 'updated'}">
                <div class="alert alert-success">✅ Voucher updated successfully!</div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="alert alert-success">✅ Voucher deleted successfully!</div>
            </c:if>
            <c:if test="${param.success eq 'toggled'}">
                <div class="alert alert-success">✅ Voucher status toggled successfully!</div>
            </c:if>
            <c:if test="${param.error eq 'delete_failed'}">
                <div class="alert alert-error">❌ Failed to delete voucher!</div>
            </c:if>
            <c:if test="${param.error eq 'toggle_failed'}">
                <div class="alert alert-error">❌ Failed to toggle voucher status!</div>
            </c:if>

            <!-- Add button (Admin only) -->
            <c:if test="${canModify}">
                <div class="toolbar">
                    <a class="btn-add" href="<c:url value='/vouchermanage/add'><c:param name='role' value='${userRole}'/></c:url>">+ Add New Voucher</a>
                    </div>
            </c:if>

            <!-- Table -->
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Value</th>
                            <th>Min Order</th>
                            <th>Max Discount</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Usage</th>
                            <th>Status</th>
                                <c:if test="${canModify}">
                                <th>Actions</th>
                                </c:if>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="voucher" items="${vouchers}">
                            <tr>
                                <td>${voucher.voucherId}</td> 
                                <td><span class="voucher-code">${voucher.voucherCode}</span></td>

                                <td>
                                    <c:choose>
                                        <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                            <strong>${voucher.value}%</strong>
                                        </c:when>
                                        <c:otherwise>
                                            <strong>$<fmt:formatNumber value="${voucher.value}" pattern="#,##0.00"/></strong>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty voucher.minValue}">
                                            $<fmt:formatNumber value="${voucher.minValue}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty voucher.maxValue}">
                                            $<fmt:formatNumber value="${voucher.maxValue}" pattern="#,##0.00"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${voucher.startDateAsDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty voucher.usageCount && not empty voucher.totalUsageLimit}">
                                            ${voucher.usageCount} / ${voucher.totalUsageLimit}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
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

                                <c:if test="${canModify}">
                                    <td>
                                        <div class="actions">
                                            <!-- Edit -->
                                            <a class="icon-btn edit" title="Edit"
                                               href="<c:url value='/vouchermanage/edit'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i class="fas fa-edit"></i>
                                            </a>

                                            <!-- Toggle -->
                                            <a class="icon-btn toggle" title="${voucher.active ? 'Deactivate' : 'Activate'}"
                                               href="<c:url value='/vouchermanage/toggle'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>">
                                                <i class="fas ${voucher.active ? 'fa-toggle-on' : 'fa-toggle-off'}"></i>
                                            </a>

                                            <!-- Delete -->
                                            <a class="icon-btn delete" title="Delete"
                                               href="<c:url value='/vouchermanage/delete'>
                                                   <c:param name='id' value='${voucher.voucherId}'/>
                                                   <c:param name='role' value='${userRole}'/>
                                               </c:url>"
                                               onclick="return confirm('Are you sure you want to delete this voucher?');">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty vouchers}">
                    <div class="empty">No vouchers found.</div>
                </c:if>
            </div>
        </div>
    </body>

</html>