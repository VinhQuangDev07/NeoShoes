<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <head>
        <title>Return Request Details</title>
        <style>
            .container {
                max-width: 1000px;
                margin: 20px auto;
                padding: 20px;
            }
            .section {
                margin-bottom: 30px;
            }
            .info-group {
                margin-bottom: 15px;
            }
            .label {
                font-weight: bold;
                color: #333;
            }
            .value {
                margin-left: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th, td {
                padding: 10px;
                text-align: left;
                border: 1px solid #ddd;
            }
            th {
                background-color: #f5f5f5;
            }
            .status {
                padding: 5px 10px;
                border-radius: 3px;
                display: inline-block;
                text-transform: uppercase;
                font-size: 0.9em;
            }
            .status-PENDING {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-APPROVED {
                background-color: #d4edda;
                color: #155724;
            }
            .status-REJECTED {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-COMPLETED {
                background-color: #d1ecf1;
                color: #0c5460;
            }
            .btn {
                padding: 10px 20px;
                margin-right: 10px;
                text-decoration: none;
                border: none;
                cursor: pointer;
                border-radius: 4px;
                display: inline-block;
            }
            .btn-back {
                background-color: #6c757d;
                color: white;
            }
            .btn-cancel {
                background-color: #dc3545;
                color: white;
            }
            .no-data {
                color: #999;
                font-style: italic;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Return Request Details</h2>

            <!-- Return Request Information -->
            <div class="section">
                <h3>Request Information</h3>
                <div class="info-group">
                    <span class="label">Request ID:</span>
                    <span class="value">${returnRequest.returnRequestId}</span>
                </div>
                <div class="info-group">
                    <span class="label">Request Date:</span>
                    <span class="value">${formattedRequestDate}</span>
                </div>
                <div class="info-group">
                    <span class="label">Status:</span>
                    <span class="value">
                        <span class="status status-${returnRequest.returnStatus}">
                            ${returnRequest.returnStatus}
                        </span>
                    </span>
                </div>
                <div class="info-group">
                    <span class="label">Total Refund Amount:</span>
                    <span class="value">
                        <fmt:formatNumber value="${totalRefund}" type="currency" 
                                          currencySymbol="$" maxFractionDigits="2" />
                    </span>
                </div>
                <c:if test="${not empty returnRequest.decideDate}">
                    <div class="info-group">
                        <span class="label">Decision Date:</span>
                        <span class="value">${formattedDecideDate}</span>
                    </div>
                </c:if>
            </div>

            <!-- Order Information -->
            <div class="section">
                <h3>Related Order</h3>
                <div class="info-group">
                    <span class="label">Order ID:</span>
                    <span class="value">${returnRequest.orderId}</span>
                </div>
                <c:if test="${not empty order}">
                    <div class="info-group">
                        <span class="label">Order Date:</span>
                        <span class="value">${formattedOrderDate}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">Order Total:</span>
                        <span class="value">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                              currencySymbol="$" maxFractionDigits="2" />
                        </span>
                    </div>
                </c:if>
            </div>

            <!-- Return Items -->
            <div class="section">
                <h3>Returned Items</h3>
                <c:choose>
                    <c:when test="${not empty returnRequestDetails}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Unit price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td><c:out value="${item.productName}"/></td>
                                        <td><c:out value="${item.detailQuantity}"/></td>
                                        <td><fmt:formatNumber value="${item.detailPrice}" type="currency" currencySymbol="$" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="2" style="text-align: right;">Total Refund:</th>
                                    <th>
                                        <fmt:formatNumber value="${totalRefund}" type="currency" currencySymbol="$" maxFractionDigits="2"/>
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">No items found</p>
                    </c:otherwise>
                </c:choose>
            </div>


            <!-- Return Reason -->
            <div class="section">
                <h3>Return Reason</h3>
                <p>${returnRequest.reason}</p>
            </div>

            <!-- Bank Account Info -->
            <c:if test="${not empty returnRequest.bankAccountInfo}">
                <div class="section">
                    <h3>Bank Account Information</h3>
                    <p>${returnRequest.bankAccountInfo}</p>
                </div>
            </c:if>

            <!-- Additional Note -->
            <c:if test="${not empty returnRequest.note}">
                <div class="section">
                    <h3>Additional Note</h3>
                    <p>${returnRequest.note}</p>
                </div>
            </c:if>


            <!-- Action Buttons -->
            <div class="section">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-back">
                    Back to List
                </a>

                <c:if test="${returnRequest.returnStatus == 'PENDING'}">
                    <a href="${pageContext.request.contextPath}/return-request?action=edit&requestId=${returnRequest.returnRequestId}" class="btn" style="background-color: #007bff; color: white;">
                        Edit Request
                    </a>
                    <button onclick="confirmCancel()" class="btn btn-cancel">
                        Cancel Request
                    </button>
                </c:if>
            </div>
        </div>

        <script>
            function confirmCancel() {
                if (confirm('Are you sure you want to cancel this return request?')) {
                    window.location.href = '${pageContext.request.contextPath}/return-request?action=delete&requestId=${returnRequest.returnRequestId}';
                            }
                        }
        </script>
    </body>
</html>