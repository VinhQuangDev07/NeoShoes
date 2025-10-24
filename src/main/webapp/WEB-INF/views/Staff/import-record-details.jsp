<%-- 
    Document   : import-record-details
    Created on : Oct 19, 2025, 9:06:16 PM
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
        <title>Import Record Details - NeoShoes</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background-color: #f8f9fa;
                overflow-x: hidden;
            }

            /* Detail Header */
            .detail-header {
                background: #fff;
                padding: 1rem 0;
                margin-bottom: 1rem;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .detail-header h5 {
                color: #000;
                font-size: 1.5rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            /* Info Cards */
            .info-card {
                background: white;
                border-radius: 12px;
                padding: 0.9rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                transition: all 0.3s;
                border: 1px solid #f0f0f0;
                height: 100%;
            }

            .info-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
            }

            .info-card-icon {
                width: 32px;
                height: 32px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 0.5rem;
            }

            .icon-blue {
                background-color: #dbeafe;
                color: #2563eb;
            }

            .icon-purple {
                background-color: #ede9fe;
                color: #7c3aed;
            }

            .icon-green {
                background-color: #d1fae5;
                color: #10b981;
            }

            .icon-orange {
                background-color: #fed7aa;
                color: #f97316;
            }

            .info-card-label {
                color: #9ca3af;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.1rem;
            }

            .info-card-value {
                color: #1f2937;
                font-size: 1rem;
                font-weight: 500;
                margin: 0;
            }

            .info-card-subvalue {
                color: #6b7280;
                font-size: 0.875rem;
                margin: 0;
            }

            /* Details Section */
            .details-section {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                margin-top: 1.5rem;
            }

            .section-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            /* Variant Table */
            .variant-table {
                background: transparent;
            }

            .variant-table thead {
                background-color: #f8f9fa;
            }

            .variant-table thead th {
                color: #6b7280;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 0.75rem;
                border-bottom: 2px solid #e5e7eb;
            }

            .variant-table tbody td {
                padding: 1rem 0.75rem;
                vertical-align: middle;
                border-bottom: 1px solid #f3f4f6;
            }

            .variant-badge {
                display: inline-block;
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .color-badge {
                background-color: #dbeafe;
                color: #1e40af;
            }

            .size-badge {
                background-color: #fce7f3;
                color: #be185d;
            }

            .quantity-text {
                font-weight: 700;
                color: #10b981;
                font-size: 1rem;
            }

            .price-text {
                font-weight: 600;
                color: #1f2937;
                font-size: 0.95rem;
            }

            .timestamp-text {
                color: #9ca3af;
                font-size: 0.75rem;
            }

            /* Summary Card */
            .summary-card {
                background: #202020e4;
                color: white;
                border-radius: 12px;
                padding: 1.5rem;
            }

            .summary-card h6 {
                font-size: 0.875rem;
                font-weight: 600;
                opacity: 0.9;
                margin-bottom: 0.5rem;
            }

            .summary-card .value {
                font-size: 1.75rem;
                font-weight: 700;
            }

            /* Back Button */
            .btn-back {
                background-color: #f3f4f6;
                color: #374151;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.2s;
            }

            .btn-back:hover {
                background-color: #e5e7eb;
                color: #1f2937;
            }
        </style>
    </head>
    <body>
        <!-- Main Content -->
        <div id="main-content">
            <div class="container-fluid p-4">
                <!-- Page Header -->
                <div class="detail-header">
                    <div class="container">
                        <h5>
                            <i data-lucide="package" style="width: 21px; height: 21px;"></i>
                            Import Record Details - #${importRecord.importProductId}
                        </h5>
                    </div>
                </div>

                <!-- Import Header Information -->
                <div class="row g-2">
                    <!-- Import Date Card -->
                    <div class="col-md-3">
                        <div class="info-card">
                            <div class="info-card-icon icon-blue">
                                <i data-lucide="calendar" style="width: 16px; height: 16px;"></i>
                            </div>
                            <div class="info-card-label">Import Date</div>
                            <p class="info-card-value mb-1">
                                ${importRecord.formattedImportDate}
                            </p>
                        </div>
                    </div>

                    <!-- Supplier Card -->
                    <div class="col-md-3">
                        <div class="info-card">
                            <div class="info-card-icon icon-purple">
                                <i data-lucide="truck" style="width: 16px; height: 16px;"></i>
                            </div>
                            <div class="info-card-label">Supplier</div>
                            <p class="info-card-value">${importRecord.supplierName}</p>
                        </div>
                    </div>

                    <!-- Staff Card -->
                    <div class="col-md-3">
                        <div class="info-card">
                            <div class="info-card-icon icon-green">
                                <i data-lucide="user-check" style="width: 16px; height: 16px;"></i>
                            </div>
                            <div class="info-card-label">Staff</div>
                            <p class="info-card-value">${importRecord.staffName}</p>
                        </div>
                    </div>

                    <!-- Note Card -->
                    <div class="col-md-3">
                        <div class="info-card">
                            <div class="info-card-icon icon-orange">
                                <i data-lucide="file-text" style="width: 16px; height: 16px;"></i>
                            </div>
                            <div class="info-card-label">Note</div>
                            <p class="info-card-value" style="font-size: 0.875rem; font-style: italic;">
                                <c:choose>
                                    <c:when test="${not empty importRecord.note}">
                                        ${importRecord.note}
                                    </c:when>
                                    <c:otherwise>
                                        No note
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Import Details (Lines) -->
                <div class="details-section">
                    <h3 class="section-title">
                        <i data-lucide="list" style="width: 20px; height: 20px;"></i>
                        Import Lines
                    </h3>

                    <div class="table-responsive">
                        <table class="table variant-table mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>PRODUCT VARIANT</th>
                                    <th>COLOR</th>
                                    <th>SIZE</th>
                                    <th class="text-center">QUANTITY</th>
                                    <th class="text-center">COST PRICE</th>
                                    <th>CREATED AT</th>
                                    <th>UPDATED AT</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="detail" items="${importDetails}" varStatus="status">
                                    <tr>
                                        <td class="fw-semibold">#${status.count}</td>
                                        <td>
                                            <div class="fw-semibold">${detail.productName}</div>
                                        </td>
                                        <td>
                                            <span class="variant-badge color-badge">${detail.color}</span>
                                        </td>
                                        <td>
                                            <span class="variant-badge size-badge">${detail.size}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="quantity-text">${detail.quantity}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="price-text">
                                                <fmt:formatNumber value="${detail.costPrice}" type="number" groupingUsed="true"/> $
                                            </span>
                                        </td>
                                        <td>
                                            <div class="timestamp-text">
                                                ${detail.formattedCreatedAt}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="timestamp-text">
                                                ${detail.formattedUpdatedAt}
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Summary Section -->
                <div class="row g-3 mt-2">
                    <div class="col-md-4">
                        <div class="summary-card">
                            <h6>Total Items</h6>
                            <div class="value">${importDetails.size()} Variants</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="summary-card">
                            <h6>Total Quantity</h6>
                            <c:set var="totalQty" value="0"/>
                            <c:forEach var="detail" items="${importDetails}">
                                <c:set var="totalQty" value="${totalQty + detail.quantity}"/>
                            </c:forEach>
                            <div class="value">${totalQty} Units</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="summary-card">
                            <h6>Total Cost</h6>
                            <c:set var="totalCost" value="0"/>
                            <c:forEach var="detail" items="${importDetails}">
                                <c:set var="totalCost" value="${totalCost + (detail.quantity * detail.costPrice)}"/>
                            </c:forEach>
                            <div class="value">
                                <fmt:formatNumber value="${totalCost}" type="number" groupingUsed="true"/> $
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
