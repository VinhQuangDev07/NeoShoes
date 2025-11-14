<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <title>Return Request Details</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                background-color: #f5f7fa;
                padding: 0;
                margin: 0;
            }

            /* Wrapper cho content chính */
            .main-wrapper {
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .container {
                max-width: 1100px;
                margin: 0 auto;
            }

            /* Header */
            .page-header {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 24px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .page-header h1 {
                font-size: 24px;
                font-weight: 600;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .header-actions {
                display: flex;
                gap: 12px;
            }

            /* Cards */
            .card {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 24px;
            }

            .card-title {
                font-size: 16px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 20px;
                padding-bottom: 12px;
                border-bottom: 2px solid #e2e8f0;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            /* Info Grid */
            .info-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            .info-item {
                padding: 16px;
                background-color: #f8fafc;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .info-label {
                font-size: 12px;
                color: #64748b;
                margin-bottom: 6px;
                font-weight: 500;
            }

            .info-value {
                font-size: 15px;
                color: #1e293b;
                font-weight: 500;
            }

            /* Status Badge */
            .status-badge {
                display: inline-block;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-PENDING {
                background-color: #fef3c7;
                color: #92400e;
            }

            .status-APPROVED {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-REJECTED {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status-COMPLETED {
                background-color: #dbeafe;
                color: #1e40af;
            }
            
            .status-RETURNED {
                background-color: #dbeafe;
                color: #1e40af;
            }

            /* Table */
            .items-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 16px;
            }

            .items-table thead {
                background-color: #f8fafc;
            }

            .items-table th {
                padding: 12px;
                text-align: left;
                font-size: 13px;
                font-weight: 600;
                color: #475569;
                border-bottom: 2px solid #e2e8f0;
            }

            .items-table td {
                padding: 16px 12px;
                border-bottom: 1px solid #e2e8f0;
                font-size: 14px;
                color: #1e293b;
            }

            .items-table tbody tr:hover {
                background-color: #f8fafc;
            }

            .items-table tfoot th {
                background-color: #f1f5f9;
                padding: 14px 12px;
                font-weight: 600;
                font-size: 15px;
                color: #1e293b;
            }

            /* Text Content Box */
            .text-content {
                padding: 16px;
                background-color: #f8fafc;
                border-radius: 8px;
                border-left: 4px solid #3b82f6;
                font-size: 14px;
                line-height: 1.6;
                color: #475569;
            }

            /* No Data */
            .no-data {
                text-align: center;
                padding: 40px;
                color: #94a3b8;
                font-style: italic;
            }

            /* Buttons */
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-block;
            }

            .btn-back {
                background-color: #64748b;
                color: white;
            }

            .btn-back:hover {
                background-color: #475569;
            }

            .btn-edit {
                background-color: #3b82f6;
                color: white;
            }

            .btn-edit:hover {
                background-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .btn-cancel {
                background-color: #ef4444;
                color: white;
            }

            .btn-cancel:hover {
                background-color: #dc2626;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            }

            /* Alert Box */
            .alert {
                padding: 16px 20px;
                border-radius: 8px;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
            }

            .alert-warning {
                background-color: #fef3c7;
                border: 1px solid #fde047;
                color: #92400e;
            }

            .alert-info {
                background-color: #dbeafe;
                border: 1px solid #93c5fd;
                color: #1e40af;
            }

            /* Highlight Amount */
            .highlight-amount {
                font-size: 20px;
                font-weight: 700;
                color: #059669;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-wrapper {
                    margin-left: 0;
                }

                .page-header {
                    flex-direction: column;
                    gap: 16px;
                    align-items: flex-start;
                }

                .header-actions {
                    width: 100%;
                    flex-direction: column;
                }

                .header-actions .btn {
                    width: 100%;
                    text-align: center;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                }

                .items-table {
                    font-size: 12px;
                }

                .items-table th,
                .items-table td {
                    padding: 8px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/WEB-INF/views/customer/common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        <div class="main-wrapper">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <jsp:include page="/WEB-INF/views/customer/common/customer-sidebar.jsp"/>
                </div>
                <div class="container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>
                            <span>📄</span>
                            Return Request Details
                        </h1>
                        <div class="header-actions">
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-back">
                                ← Back to Orders
                            </a>

                            <c:if test="${returnRequest.returnStatus == 'Pending' || returnRequest.returnStatus == 'PENDING'}">
                                <a href="${pageContext.request.contextPath}/return-request?action=edit&requestId=${returnRequest.returnRequestId}" 
                                   class="btn btn-edit">
                                    ✏️ Edit Request
                                </a>
                                <button onclick="confirmCancel()" class="btn btn-cancel">
                                    ❌ Cancel Request
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <!-- Status Alert -->
                    <c:if test="${returnRequest.returnStatus == 'Pending' || returnRequest.returnStatus == 'PENDING'}">
                        <div class="alert alert-warning">
                            <span>⏳</span>
                            <div>
                                <strong>Pending Review</strong> - Your return request is being processed by our team.
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${returnRequest.returnStatus == 'Approved' || returnRequest.returnStatus == 'APPROVED'}">
                        <div class="alert alert-info">
                            <span>✅</span>
                            <div>
                                <strong>Approved</strong> - Your return request has been approved. Refund will be processed soon.
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${returnRequest.returnStatus == 'Rejected' || returnRequest.returnStatus == 'REJECTED'}">
                        <div class="alert alert-info">
                            <span>❌</span>
                            <div>
                                <strong>Rejected</strong> - Your return request has been rejected.
                            </div>
                        </div>
                    </c:if>

                    <!-- Request Information Card -->
                    <div class="card">
                        <h2 class="card-title">📋 Request Information</h2>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Request ID</div>
                                <div class="info-value">#${returnRequest.returnRequestId}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Request Date</div>
                                <div class="info-value">${formattedRequestDate}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Status</div>
                                <div class="info-value">
                                    <span class="status-badge status-${returnRequest.returnStatus}">
                                        ${returnRequest.returnStatus}
                                    </span>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Total Refund Amount</div>
                                <div class="info-value highlight-amount">
                                    <fmt:formatNumber value="${totalRefund}" type="currency" 
                                                      currencySymbol="$" maxFractionDigits="2" />
                                </div>
                            </div>

                            <c:if test="${not empty returnRequest.decideDate}">
                                <div class="info-item">
                                    <div class="info-label">Decision Date</div>
                                    <div class="info-value">${formattedDecideDate}</div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Order Information Card -->
                    <div class="card">
                        <h2 class="card-title">📦 Related Order</h2>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Order ID</div>
                                <div class="info-value">#${returnRequest.orderId}</div>
                            </div>
                            <c:if test="${not empty order}">
                                <div class="info-item">
                                    <div class="info-label">Order Date</div>
                                    <div class="info-value">${formattedOrderDate}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Order Total</div>
                                    <div class="info-value">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                          currencySymbol="$" maxFractionDigits="2" />
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Returned Items Card -->
                    <div class="card">
                        <h2 class="card-title">📦 Returned Items</h2>
                        <c:choose>
                            <c:when test="${not empty returnRequestDetails}">
                                <table class="items-table">
                                    <thead>
                                        <tr>
                                            <th>Product Variant ID</th>

                                            <th>Quantity</th>

                                            <th>Amount</th>
                                                <c:if test="${not empty returnRequestDetails[0].note}">
                                                <th>Note</th>
                                                </c:if>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="detail" items="${returnRequestDetails}">
                                            <tr>
                                                <td><strong>#${detail.productVariantId}</strong></td>
                                                <td>${detail.quantity}</td>
                                                <td>
                                                    <fmt:formatNumber value="${detail.amount}" 
                                                                      type="currency" 
                                                                      currencySymbol="$" 
                                                                      maxFractionDigits="2"/>
                                                </td>
                                                <c:if test="${not empty detail.note}">
                                                    <td><c:out value="${detail.note}"/></td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th colspan="2" style="text-align: right;">Total Refund:</th>
                                            <th>
                                                <span class="highlight-amount">
                                                    <fmt:formatNumber value="${totalRefund}" 
                                                                      type="currency" 
                                                                      currencySymbol="$" 
                                                                      maxFractionDigits="2"/>
                                                </span>
                                            </th>
                                            <c:if test="${not empty returnRequestDetails[0].note}">
                                                <th></th>
                                                </c:if>
                                        </tr>
                                    </tfoot>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="no-data">
                                    📭 No items found
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Return Reason Card -->
                    <div class="card">
                        <h2 class="card-title">💬 Return Reason</h2>
                        <div class="text-content">
                            <c:out value="${returnRequest.reason}"/>
                        </div>
                    </div>

                    <!-- Bank Account Info Card -->
                    <c:if test="${not empty returnRequest.bankAccountInfo}">
                        <div class="card">
                            <h2 class="card-title">🏦 Bank Account Information</h2>
                            <div class="text-content">
                                <c:out value="${returnRequest.bankAccountInfo}"/>
                            </div>
                        </div>
                    </c:if>

                    <!-- Additional Note Card -->
                    <c:if test="${not empty returnRequest.note}">
                        <div class="card">
                            <h2 class="card-title">📝 Additional Note</h2>
                            <div class="text-content">
                                <c:out value="${returnRequest.note}"/>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/customer/common/footer.jsp"/>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                    function confirmCancel() {
                                        if (!confirm('⚠️ Are you sure you want to cancel this return request?\n\nThis action cannot be undone.')) {
                                            return;
                                        }

                                        // Create form
                                        const form = document.createElement('form');
                                        form.method = 'POST';
                                        form.action = '${pageContext.request.contextPath}/return-request';

                                        // Add hidden inputs
                                        const actionInput = document.createElement('input');
                                        actionInput.type = 'hidden';
                                        actionInput.name = 'action';
                                        actionInput.value = 'delete';

                                        const requestIdInput = document.createElement('input');
                                        requestIdInput.type = 'hidden';
                                        requestIdInput.name = 'requestId';
                                        requestIdInput.value = '${returnRequest.returnRequestId}';

                                        const customerIdInput = document.createElement('input');
                                        customerIdInput.type = 'hidden';
                                        customerIdInput.name = 'customerId';
                                        customerIdInput.value = '${returnRequest.customerId}';

                                        form.appendChild(actionInput);
                                        form.appendChild(requestIdInput);
                                        form.appendChild(customerIdInput);

                                        document.body.appendChild(form);
                                        form.submit();
                                    }
        </script>
    </body>
</html>