<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Details - ${voucher.voucherCode}</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            * {
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }
            body {
                margin: 0;
                background: #f5f6f8;
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
                margin-top: 74px;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .btn-back {
                padding: 10px 16px;
                background: #374151;
                color: #fff;
                text-decoration: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
            }
            .btn-back:hover {
                background: #4b5563;
            }

            .wrap {
                max-width: 1300px;
                margin: 0 auto;
            }

            .card {
                background: #fff;
                border-radius: 12px;
                padding: 28px;
                box-shadow: 0 2px 8px rgba(0,0,0,.05);
            }

            .voucher-header {
                text-align: center;
                padding: 24px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border-radius: 12px;
                margin-bottom: 24px;
            }
            .voucher-code {
                font-size: 32px;
                font-weight: 700;
                letter-spacing: 2px;
                margin-bottom: 8px;
            }
            .voucher-value {
                font-size: 48px;
                font-weight: 700;
                margin: 16px 0;
            }

            .info-section {
                margin-bottom: 24px;
            }
            .section-title {
                font-size: 16px;
                font-weight: 700;
                color: #374151;
                margin-bottom: 12px;
                padding-bottom: 8px;
                border-bottom: 2px solid #e5e7eb;
            }

            .info-row {
                display: grid;
                grid-template-columns: 180px 1fr;
                padding: 14px 0;
                border-bottom: 1px solid #f3f4f6;
            }
            .info-row:last-child {
                border-bottom: none;
            }
            .info-label {
                font-weight: 700;
                color: #6b7280;
                font-size: 14px;
            }
            .info-value {
                color: #111827;
                font-size: 14px;
            }

            .badge {
                display: inline-block;
                padding: 6px 14px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: 700;
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
            .badge-percentage {
                background: #dbeafe;
                color: #1e40af;
            }
            .badge-fixed {
                background: #fef3c7;
                color: #92400e;
            }

            .highlight-value {
                font-weight: 700;
                color: #111827;
                font-size: 15px;
            }

            @media (max-width: 768px) {
                .voucher-code {
                    font-size: 24px;
                }
                .voucher-value {
                    font-size: 36px;
                }
                .info-row {
                    grid-template-columns: 1fr;
                    gap: 4px;
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
        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Voucher Detail</h2>
                        <p class="text-muted mb-0">View voucher detail</p>
                    </div>
                </div>
            </div>

            <div class="wrap">
                <div class="card">
                    <!-- Voucher Header -->
                    <div class="voucher-header">
                        <div class="voucher-code">${voucher.voucherCode}</div>
                        <div class="voucher-value">
                            <c:choose>
                                <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                    ${voucher.value}% OFF
                                </c:when>
                                <c:otherwise>
                                    $<fmt:formatNumber value="${voucher.value}" pattern="#,##0.00"/> OFF
                                </c:otherwise>
                            </c:choose>
                        </div>
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
                    </div>

                    <!-- Basic Information -->
                    <div class="info-section">
                        <h3 class="section-title">Basic Information</h3>

                        <div class="info-row">
                            <div class="info-label">Voucher ID:</div>
                            <div class="info-value">#${voucher.voucherId}</div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Voucher Code:</div>
                            <div class="info-value"><span class="highlight-value">${voucher.voucherCode}</span></div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Description:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.voucherDescription}">
                                        ${voucher.voucherDescription}
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #9ca3af;">No description</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Discount Type:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                        <span class="badge badge-percentage">PERCENTAGE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-fixed">FIXED AMOUNT</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Discount Details -->
                    <div class="info-section">
                        <h3 class="section-title">Discount Details</h3>

                        <div class="info-row">
                            <div class="info-label">Discount Value:</div>
                            <div class="info-value">
                                <span class="highlight-value" style="color: #dc2626; font-size: 18px;">
                                    <c:choose>
                                        <c:when test="${voucher.type eq 'PERCENTAGE'}">
                                            ${voucher.value}%
                                        </c:when>
                                        <c:otherwise>
                                            $<fmt:formatNumber value="${voucher.value}" pattern="#,##0.00"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Min Order Value:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.minValue && voucher.minValue > 0}">
                                        <span class="highlight-value">$<fmt:formatNumber value="${voucher.minValue}" pattern="#,##0.00"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #059669;">No minimum required</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Max Discount Amount:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.maxValue && voucher.maxValue > 0}">
                                        <span class="highlight-value">$<fmt:formatNumber value="${voucher.maxValue}" pattern="#,##0.00"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #059669;">Unlimited</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Validity Period -->
                    <div class="info-section">
                        <h3 class="section-title">Validity Period</h3>

                        <div class="info-row">
                            <div class="info-label">Start Date:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.startDate}">
                                        <span class="highlight-value">
                                            ${voucher.getFormattedDateTime(voucher.startDate)}
                                        </span>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">End Date:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.endDate}">
                                        <span class="highlight-value">
                                            ${voucher.getFormattedDateTime(voucher.endDate)}
                                        </span>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Usage Limits -->
                    <div class="info-section">
                        <h3 class="section-title">Usage Limits</h3>

                        <div class="info-row">
                            <div class="info-label">Total Usage Limit:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.totalUsageLimit && voucher.totalUsageLimit > 0}">
                                        <span class="highlight-value">${voucher.totalUsageLimit} times</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #059669;">Unlimited</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">User Usage Limit:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.userUsageLimit && voucher.userUsageLimit > 0}">
                                        <span class="highlight-value">${voucher.userUsageLimit} time(s) per user</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #059669;">Unlimited per user</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- System Information -->
                    <div class="info-section">
                        <h3 class="section-title">System Information</h3>

                        <div class="info-row">
                            <div class="info-label">Status:</div>
                            <div class="info-value">
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
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Created At:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.createdAt}">
                                        ${voucher.getFormattedDateTime(voucher.createdAt)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-label">Last Updated:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty voucher.updatedAt}">
                                        ${voucher.getFormattedDateTime(voucher.updatedAt)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
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