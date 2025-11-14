<%-- 
    Document   : detail
    Created on : Oct 20, 2025, 10:30:00 PM
    Author     : Nguyen Huynh Thien An - CE190979
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Return Request Detail - #${returnRequest.returnRequestId}</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                background-color: #f5f5f5;
                font-family: Arial, sans-serif;
            }
            .container-fluid {
                padding: 20px;
                max-width: 1400px;
            }

            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }

            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
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
                border-radius: 8px;
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
                word-break: break-word;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                display: inline-block;
            }
            .table-container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
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
                border-radius: 8px;
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
                border-radius: 8px;
                font-weight: 500;
            }
            .btn-reject {
                background-color: #dc3545;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 500;
            }
            .btn-refund {
                background-color: #17a2b8;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 500;
            }
            .btn-complete {
                background-color: #0d6efd;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 500;
            }
            .total-section {
                background-color: #f8f9fa;
                padding: 15px;
                margin-top: 15px;
                border-radius: 8px;
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
            .error-container {
                background-color: white;
                padding: 40px;
                text-align: center;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
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

        <div class="main-wrapper">
            <!-- ✅ FIX 1: Check returnRequest null -->
            <c:if test="${empty returnRequest}">
                <div class="container-fluid">
                    <div class="error-container">
                        <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                        <h4>Return Request Not Found</h4>
                        <p class="text-muted">The requested return request could not be found.</p>
                        <a href="${pageContext.request.contextPath}/staff/manage-return-request" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to All Returns
                        </a>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty returnRequest}">
                <div class="container-fluid">
                    <div class="page-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0 fw-bold">Return Request Detail - #${returnRequest.returnRequestId}</h4>
                            </div>
                            <a href="${pageContext.request.contextPath}/staff/manage-return-request" 
                               class="btn btn-outline-secondary">
                                <i data-lucide="arrow-left" style="width: 18px; height: 18px;"></i>
                                Back to List
                            </a>
                        </div>
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
                                        #${returnRequest.orderId}
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Customer ID:</div>
                                    <div class="info-value">${returnRequest.customerId}</div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Created Date:</div>
                                    <div class="info-value">
                                        <c:out value="${returnRequest.formattedRequestDate}" default="N/A"/>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Decision Date:</div>
                                    <div class="info-value">
                                        <c:out value="${returnRequest.formattedDecideDate}" default="N/A"/>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Return Status:</div>
                                    <div class="info-value">
                                        <!-- ✅ FIX 2: Sửa logic status badge - case insensitive -->
                                        <c:set var="statusUpper" value="${fn:toUpperCase(returnRequest.returnStatus)}"/>
                                        <!--<span class="badge bg-${statusUpper == 'APPROVED' ? 'success' : statusUpper == 'PENDING' ? 'warning' : statusUpper == 'REJECTED' ? 'danger' : 'secondary'}">-->
                                        <span class="badge bg-${statusUpper == 'APPROVED' ? 'success' : statusUpper == 'PENDING' ? 'warning' : statusUpper == 'REJECTED' ? 'danger' : statusUpper == 'RETURNED' ? 'info' : 'secondary'}">
                                            <c:out value="${returnRequest.returnStatus}"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Reason:</div>
                                    <!-- ✅ FIX 3: Escape XSS -->
                                    <div class="info-value">
                                        <c:out value="${returnRequest.reason}" default="N/A"/>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Bank Account Info:</div>
                                    <div class="info-value">
                                        <c:out value="${returnRequest.bankAccountInfo}" default="N/A"/>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Note:</div>
                                    <div class="info-value">
                                        <c:out value="${returnRequest.note}" default="No additional notes"/>
                                    </div>
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
                                                <th>Variant ID</th>
                                                <th class="text-center">Quantity</th>
                                                <th class="text-end">Amount</th>
                                                <th>Note</th>
                                                <th>Refund Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- ✅ FIX 4: Check returnDetails not empty -->
                                            <c:if test="${not empty returnDetails}">
                                                <c:forEach var="detail" items="${returnDetails}">
                                                    <tr>
                                                        <td>${detail.productVariantId}</td>
                                                        <td class="text-center">${detail.quantity}</td>
                                                        <td class="text-end">
                                                            <!-- ✅ FIX 5: Handle null amount -->
                                                            <c:choose>
                                                                <c:when test="${detail.amount != null}">
                                                                    <fmt:formatNumber value="${detail.amount}" type="currency" currencySymbol="$"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    $0.00
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:out value="${detail.note}" default="-"/>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${detail.refundDate != null}">
                                                                    <c:out value="${detail.formattedRefundDate}"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not refunded</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:if>

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
                                            <!-- ✅ FIX 6: Safe total calculation -->
                                            <c:set var="totalAmount" value="0"/>
                                            <c:forEach var="detail" items="${returnDetails}">
                                                <c:if test="${detail.amount != null}">
                                                    <c:set var="totalAmount" value="${totalAmount + detail.amount}"/>
                                                </c:if>
                                            </c:forEach>
                                            <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$"/>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Action Buttons -->
                            <!-- ✅ FIX 7: Case-insensitive status check -->
                            <c:set var="statusUpper" value="${fn:toUpperCase(returnRequest.returnStatus)}"/>

                            <c:if test="${statusUpper == 'PENDING'}">
                                <div class="action-buttons">
                                    <form method="post" action="${pageContext.request.contextPath}/staff/manage-return-request" style="display: inline;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                        <input type="hidden" name="status" value="APPROVED">
                                        <button type="submit" class="btn-approve" onclick="return confirm('Are you sure you want to approve this return request?')">
                                            <i class="fas fa-check"></i> Approve Request
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/manage-return-request" style="display: inline;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <button type="submit" class="btn-reject" onclick="return confirm('Are you sure you want to reject this return request?')">
                                            <i class="fas fa-times"></i> Reject Request
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <!-- ✅ FIX 8: Chỉ hiện nút Process Refund nếu chưa refund -->
                            <c:if test="${statusUpper == 'APPROVED'}">
                                <div class="action-buttons">
                                    <form method="post" action="${pageContext.request.contextPath}/staff/manage-return-request" style="display: inline;">
                                        <input type="hidden" name="action" value="completeReturn">
                                        <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                                        <button type="submit" class="btn-complete" onclick="return confirm('Mark this return as completed? Inventory will be restored.')">
                                            <i class="fas fa-box-open"></i> Complete Return
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
                                        <div class="timeline-date">
                                            <c:out value="${returnRequest.formattedRequestDate}" default="N/A"/>
                                        </div>
                                        <div class="timeline-content">
                                            <strong>Return Request Created</strong><br>
                                            Customer submitted return request
                                        </div>
                                    </div>

                                    <!-- ✅ FIX 9: Case-insensitive check -->
                                    <c:if test="${statusUpper == 'APPROVED' || statusUpper == 'REJECTED'}">
                                        <div class="timeline-item">
                                            <div class="timeline-date">
                                                <c:out value="${returnRequest.formattedDecideDate}" default="N/A"/>
                                            </div>
                                            <div class="timeline-content">
                                                <strong>Request ${fn:toLowerCase(statusUpper) == 'approved' ? 'Approved' : 'Rejected'}</strong><br>
                                                Return request was ${fn:toLowerCase(statusUpper)} by admin
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${statusUpper == 'RETURNED'}">
                                        <div class="timeline-item">
                                            <div class="timeline-date">
                                                <c:out value="${returnRequest.formattedDecideDate}" default="N/A"/>
                                            </div>
                                            <div class="timeline-content">
                                                <strong>Return Completed</strong><br>
                                                Inventory restored and order closed
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Show refund timeline if applicable -->
                                    <c:if test="${statusUpper == 'RETURNED'}">
                                        <c:set var="hasRefundProcessing" value="false"/>
                                        <c:set var="refundDate" value=""/>
                                        <c:forEach var="detail" items="${returnDetails}">
                                            <c:if test="${detail.refundDate != null && !hasRefundProcessing}">
                                                <c:set var="hasRefundProcessing" value="true"/>
                                                <c:set var="refundDate" value="${detail.formattedRefundDate}"/>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${hasRefundProcessing}">
                                            <div class="timeline-item">
                                                <div class="timeline-date"><c:out value="${refundDate}"/></div>
                                                <div class="timeline-content">
                                                    <strong>Refund Processed</strong><br>
                                                    Payment has been refunded to customer
                                                </div>
                                            </div>
                                        </c:if>
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
                                    <!-- ✅ FIX 10: Safe size check -->
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty returnDetails}">
                                                ${fn:length(returnDetails)}
                                            </c:when>
                                            <c:otherwise>
                                                0
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Total Quantity:</div>
                                    <div class="info-value">
                                        <c:set var="totalQty" value="0"/>
                                        <c:if test="${not empty returnDetails}">
                                            <c:forEach var="detail" items="${returnDetails}">
                                                <c:set var="totalQty" value="${totalQty + detail.quantity}"/>
                                            </c:forEach>
                                        </c:if>
                                        ${totalQty}
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Processing Time:</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${statusUpper == 'PENDING'}">
                                                <span class="text-warning">In Progress</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-success">Completed</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
</html>