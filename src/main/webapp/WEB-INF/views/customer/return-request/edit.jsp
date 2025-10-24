<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Parse bank account info: format is "BANK_ACCOUNT_HOLDER" --%>
<c:if test="${not empty returnRequest.bankAccountInfo}">
    <c:set var="bankParts" value="${fn:split(returnRequest.bankAccountInfo, '_')}" />
    <c:if test="${fn:length(bankParts) >= 3}">
        <c:set var="savedBankName" value="${bankParts[0]}" />
        <c:set var="savedAccountNumber" value="${bankParts[1]}" />
        <c:set var="savedAccountHolder" value="${bankParts[2]}" />
    </c:if>
</c:if>

<html>
    <head>
        <title>Edit Return Request</title>
        <style>
            .container {
                max-width: 1000px;
                margin: 20px auto;
                padding: 20px;
            }
            .section {
                margin-bottom: 30px;
                padding: 20px;
                background-color: #f9f9f9;
                border-radius: 5px;
            }
            .info-group {
                margin-bottom: 15px;
            }
            .label {
                font-weight: bold;
                color: #333;
                display: block;
                margin-bottom: 5px;
            }
            .value {
                color: #666;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                color: #333;
            }
            .form-group input[type="text"],
            .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
            }
            .form-group textarea {
                min-height: 100px;
                resize: vertical;
            }
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            .required {
                color: red;
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
            .checkbox-cell {
                text-align: center;
                width: 80px;
            }
            .btn {
                padding: 10px 20px;
                margin-right: 10px;
                text-decoration: none;
                border: none;
                cursor: pointer;
                border-radius: 4px;
                display: inline-block;
                font-size: 14px;
            }
            .btn-submit {
                background-color: #28a745;
                color: white;
            }
            .btn-submit:hover {
                background-color: #218838;
            }
            .btn-cancel {
                background-color: #6c757d;
                color: white;
            }
            .btn-cancel:hover {
                background-color: #5a6268;
            }
            .error-message {
                color: #dc3545;
                background-color: #f8d7da;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 20px;
            }
            .help-text {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Edit Return Request</h2>

            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/return-request" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="customerId" value="${returnRequest.customerId}">
                <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                <input type="hidden" name="orderId" value="${returnRequest.orderId}">

                <!-- Order Information (Read-only) -->
                <div class="section">
                    <h3>Order Information</h3>
                    <div class="info-group">
                        <span class="label">Order ID:</span>
                        <span class="value">${returnRequest.orderId}</span>
                    </div>
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
                </div>

                <!-- Select Items to Return -->
                <div class="section">
                    <h3>Select Items to Return <span class="required">*</span></h3>
                    <p class="help-text">Check the items you want to return from your order</p>
                    <table>
                        <thead>
                            <tr>
                                <th class="checkbox-cell">Return</th>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <%-- FIXED: Check using Set from servlet --%>
                                <c:set var="isSelected" value="${selectedOrderDetailIds.contains(item.orderDetailId)}" />
                                
                                <tr>
                                    <td class="checkbox-cell">
                                        <input type="checkbox" 
                                               name="orderDetailIds" 
                                               value="${item.orderDetailId}"
                                               ${isSelected ? 'checked' : ''}
                                               class="item-checkbox">
                                    </td>
                                    <td><c:out value="${item.productName}"/></td>
                                    <td><c:out value="${item.detailQuantity}"/></td>
                                    <td>
                                        <fmt:formatNumber value="${item.detailPrice}" 
                                                          type="currency" 
                                                          currencySymbol="$" 
                                                          maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.detailPrice * item.detailQuantity}" 
                                                          type="currency" 
                                                          currencySymbol="$" 
                                                          maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Return Reason -->
                <div class="section">
                    <div class="form-group">
                        <label for="reason">Return Reason <span class="required">*</span></label>
                        <select id="reason" name="reason" required>
                            <option value="">-- Select a reason --</option>
                            <option value="Defective Product" ${returnRequest.reason == 'Defective Product' ? 'selected' : ''}>Defective Product</option>
                            <option value="Wrong Item" ${returnRequest.reason == 'Wrong Item' ? 'selected' : ''}>Wrong Item</option>
                            <option value="Not as Described" ${returnRequest.reason == 'Not as Described' ? 'selected' : ''}>Not as Described</option>
                            <option value="Changed Mind" ${returnRequest.reason == 'Changed Mind' ? 'selected' : ''}>Changed Mind</option>
                            <option value="Better Price Found" ${returnRequest.reason == 'Better Price Found' ? 'selected' : ''}>Better Price Found</option>
                            <option value="Other" ${returnRequest.reason == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="note">Additional Note</label>
                        <textarea id="note" 
                                  name="note" 
                                  placeholder="Please provide more details about your return request...">${returnRequest.note}</textarea>
                        <p class="help-text">Optional: Provide additional details about your return</p>
                    </div>

                    <!-- Bank Information -->
                    <div class="form-group">
                        <label>Bank <span class="required">*</span></label>
                        <select name="bankName" required>
                            <option value="">-- Select Bank --</option>
                            <option value="VCB" ${savedBankName == 'VCB' ? 'selected' : ''}>Vietcombank</option>
                            <option value="ACB" ${savedBankName == 'ACB' ? 'selected' : ''}>ACB</option>
                            <option value="VTB" ${savedBankName == 'VTB' ? 'selected' : ''}>VietinBank</option>
                            <option value="TCB" ${savedBankName == 'TCB' ? 'selected' : ''}>Techcombank</option>
                            <option value="MB" ${savedBankName == 'MB' ? 'selected' : ''}>MB Bank</option>
                            <option value="BIDV" ${savedBankName == 'BIDV' ? 'selected' : ''}>BIDV</option>
                            <option value="AGR" ${savedBankName == 'AGR' ? 'selected' : ''}>Agribank</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Account Number <span class="required">*</span></label>
                        <input type="text" name="accountNumber" required 
                               placeholder="Enter account number" 
                               value="${savedAccountNumber}">
                    </div>

                    <div class="form-group">
                        <label>Account Holder Name <span class="required">*</span></label>
                        <input type="text" name="accountHolder" required 
                               placeholder="Enter account holder name" 
                               value="${savedAccountHolder}">
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="section">
                    <button type="submit" class="btn btn-submit">Update Request</button>
                    <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${returnRequest.returnRequestId}" 
                       class="btn btn-cancel">Cancel</a>
                </div>
            </form>
        </div>

        <script>
            function validateForm() {
                // Check if at least one item is selected
                const checkboxes = document.querySelectorAll('.item-checkbox');
                const isAnyChecked = Array.from(checkboxes).some(cb => cb.checked);

                if (!isAnyChecked) {
                    alert('Please select at least one item to return');
                    return false;
                }

                // Validate reason
                const reason = document.getElementById('reason').value;
                if (!reason || reason.trim() === '') {
                    alert('Please select a return reason');
                    return false;
                }

                return true;
            }
        </script>
    </body>
</html>