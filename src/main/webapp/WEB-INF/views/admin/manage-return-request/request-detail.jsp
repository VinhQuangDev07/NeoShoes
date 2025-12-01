<%-- 
    Document   : detail
    Created on : Oct 20, 2025, 10:30:00 PM
    Author     : Nguyen Huynh Thien An - CE190979
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Return Request Detail - #${request.returnRequestId}</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f5f5f5;
                font-family: Arial, sans-serif;
            }
            .container-fluid {
                padding: 20px;
                max-width: 1400px;
            }
            .page-header {
                background-color: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .back-btn {
                color: #007bff;
                text-decoration: none;
                font-size: 14px;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                margin-bottom: 10px;
            }
            .back-btn:hover {
                text-decoration: underline;
            }
            .info-card {
                background-color: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .card-title {
                font-size: 16px;
                font-weight: 600;
                color: #212529;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #007bff;
            }
            .info-row {
                display: flex;
                padding: 10px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            .info-row:last-child {
                border-bottom: none;
            }
            .info-label {
                font-weight: 600;
                color: #6c757d;
                width: 200px;
                flex-shrink: 0;
            }
            .info-value {
                color: #212529;
                flex: 1;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 14px;
                font-weight: 500;
                display: inline-block;
            }
            .table-container {
                background-color: white;
                padding: 20px;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .table thead th {
                background-color: #f8f9fa;
                border-bottom: 2px solid #dee2e6;
                font-weight: 600;
                color: #495057;
                padding: 12px;
                vertical-align: middle;
            }
            .table tbody td {
                padding: 12px;
                vertical-align: middle;
            }
            .product-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .product-image {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 4px;
                border: 1px solid #dee2e6;
            }
            .action-buttons {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }
            .btn-approve {
                background-color: #28a745;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                font-weight: 500;
            }
            .btn-reject {
                background-color: #dc3545;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                font-weight: 500;
            }
            .btn-refund {
                background-color: #17a2b8;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                font-weight: 500;
            }
            .total-section {
                background-color: #f8f9fa;
                padding: 15px;
                margin-top: 15px;
                border-radius: 4px;
                text-align: right;
            }
            .total-label {
                font-size: 18px;
                font-weight: 600;
                color: #212529;
            }
            .total-amount {
                font-size: 24px;
                font-weight: 700;
                color: #28a745;
            }
            .timeline {
                position: relative;
                padding-left: 30px;
            }
            .timeline-item {
                position: relative;
                padding-bottom: 20px;
            }
            .timeline-item:before {
                content: '';
                position: absolute;
                left: -30px;
                top: 0;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background-color: #007bff;
                border: 2px solid white;
                box-shadow: 0 0 0 2px #007bff;
            }
            .timeline-item:after {
                content: '';
                position: absolute;
                left: -24px;
                top: 12px;
                width: 2px;
                height: calc(100% - 12px);
                background-color: #dee2e6;
            }
            .timeline-item:last-child:after {
                display: none;
            }
            .timeline-date {
                font-size: 12px;
                color: #6c757d;
                margin-bottom: 5px;
            }
            .timeline-content {
                font-size: 14px;
                color: #212529;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="page-header">
                <a href="${pageContext.request.contextPath}/admin/manage-return-request" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to All Returns
                </a>
                <h4 class="mb-0">Return Request Detail - #${returnRequest.returnRequestId}</h4>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <!-- Return Request Information -->
                    <div class="info-card">
                        <div class="card-title">
                            <i class="fas fa-info-circle"></i> Return Request Information
                        </div>
                        <div class="info-row">
                            <div class="info-label">Request ID:</div>
                            <div class="info-value">#${returnRequest.returnRequestId}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Order ID:</div>
                            <div class="info-value">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&orderId=${returnRequest.orderId}" class="text-primary">
                                    #${returnRequest.orderId}
                                </a>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Customer ID:</div>
                            <div class="info-value">${returnRequest.customerId}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Created Date:</div>
                            <div class="info-value">${returnRequest.formattedRequestDate}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Decision Date:</div>
                            <div class="info-value">${returnRequest.formattedDecideDate}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Return Status:</div>
                            <div class="info-value">
                                <span class="badge bg-${returnRequest.returnStatus == 'Approved' ? 'success' : returnRequest.returnStatus == 'Pending' ? 'warning' : returnRequest.returnStatus == 'Rejected' ? 'danger' : 'info'}">
                                    ${returnRequest.returnStatus}
                                </span>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Reason:</div>
                            <div class="info-value">${returnRequest.reason}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Bank Account Info:</div>
                            <div class="info-value">${returnRequest.bankAccountInfo}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Note:</div>
                            <div class="info-value">${returnRequest.note != null ? returnRequest.note : 'No additional notes'}</div>
                        </div>
                    </div>

                    <!-- Return Items -->
                    <div class="table-container">
                        <div class="card-title">
                            <i class="fas fa-box"></i> Return Items
                        </div>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Variant ID</th>
                                        <th class="text-center">Quantity</th>
                                        <th class="text-end">Amount</th>
                                        <th>Note</th>
                                        <th>Refund Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detail" items="${returnDetails}">
                                        <tr>
                                            <td>
                                                <div class="product-info">
                                                    <img src="${pageContext.request.contextPath}/images/product-placeholder.png" 
                                                         alt="Product" class="product-image">
                                                    <div>
                                                        <div>Product Variant</div>
                                                        <small class="text-muted">ID: ${detail.productVariantId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${detail.productVariantId}</td>
                                            <td class="text-center">${detail.quantity}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${detail.amount}" type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>${detail.note != null ? detail.note : '-'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${detail.refundDate != null}">
                                                        ${detail.formattedRefundDate}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty returnDetails}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">
                                                No items found for this return request
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Total Section -->
                        <c:if test="${not empty returnDetails}">
                            <div class="total-section">
                                <div class="total-label">Total Refund Amount:</div>
                                <div class="total-amount">
                                    <c:set var="totalAmount" value="0"/>
                                    <c:forEach var="detail" items="${returnDetails}">
                                        <c:set var="totalAmount" value="${totalAmount + detail.amount}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$"/>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Action Buttons -->
                    <c:if test="${returnRequest.returnStatus == 'Pending'}">
                        <div class="action-buttons">
                            <form method="post" action="${pageContext.request.contextPath}/admin/manage-return-request" style="display: inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                <button type="submit" class="btn-approve" onclick="return confirm('Are you sure you want to approve this return request?')">
                                    <i class="fas fa-check"></i> Approve Request
                                </button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/admin/manage-return-request" style="display: inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                <button type="submit" class="btn-reject" onclick="return confirm('Are you sure you want to reject this return request?')">
                                    <i class="fas fa-times"></i> Reject Request
                                </button>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${returnRequest.returnStatus == 'Approved'}">
                        <div class="action-buttons">
                            <form method="post" action="${pageContext.request.contextPath}/admin/manage-return-request" style="display: inline;">
                                <input type="hidden" name="action" value="processRefund">
                                <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                <button type="submit" class="btn-refund" onclick="return confirm('Are you sure you want to process the refund?')">
                                    <i class="fas fa-money-bill-wave"></i> Process Refund
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>

                <div class="col-md-4">
                    <!-- Timeline -->
                    <div class="info-card">
                        <div class="card-title">
                            <i class="fas fa-clock"></i> Timeline
                        </div>
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-date">${returnRequest.formattedRequestDate}</div>
                                <div class="timeline-content">
                                    <strong>Return Request Created</strong><br>
                                    Customer submitted return request
                                </div>
                            </div>

                            <c:if test="${returnRequest.returnStatus == 'Approved'}">
                                <div class="timeline-item">
                                    <div class="timeline-date">${returnRequest.formattedDecideDate}</div>
                                    <div class="timeline-content">
                                        <strong>Request Approved</strong><br>
                                        Return request was approved by admin
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Quick Stats -->
                    <div class="info-card">
                        <div class="card-title">
                            <i class="fas fa-chart-bar"></i> Quick Stats
                        </div>
                        <div class="info-row">
                            <div class="info-label">Total Items:</div>
                            <div class="info-value">${returnDetails.size()}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Total Quantity:</div>
                            <div class="info-value">
                                <c:set var="totalQty" value="0"/>
                                <c:forEach var="detail" items="${returnDetails}">
                                    <c:set var="totalQty" value="${totalQty + detail.quantity}"/>
                                </c:forEach>
                                ${totalQty}
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Processing Time:</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${returnRequest.returnStatus == 'Pending'}">
                                        In Progress
                                    </c:when>
                                    <c:otherwise>
                                        Completed
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>