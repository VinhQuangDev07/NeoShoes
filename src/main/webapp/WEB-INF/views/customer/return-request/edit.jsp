<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Return Request</title>
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
            margin-left: 300px;
            margin-top: 74px;
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

        .btn-back {
            padding: 10px 20px;
            background-color: #64748b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-back:hover {
            background-color: #475569;
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

        /* Info Display */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
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

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #475569;
            margin-bottom: 8px;
        }

        .form-group label .required {
            color: #ef4444;
            margin-left: 4px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            color: #1e293b;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        select.form-control {
            cursor: pointer;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        /* Helper Text */
        .helper-text {
            font-size: 12px;
            color: #64748b;
            margin-top: 6px;
        }

        /* Error Message */
        .error-message {
            background-color: #fee2e2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
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

        .checkbox-cell {
            width: 50px;
            text-align: center;
        }

        .checkbox-cell input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #3b82f6;
        }

        /* Quantity Input */
        .qty-input {
            width: 80px;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            transition: all 0.2s;
        }

        .qty-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .qty-input:disabled {
            background-color: #f1f5f9;
            cursor: not-allowed;
            color: #94a3b8;
        }

        /* Form Row */
        .form-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
        }

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

        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary {
            background-color: #e2e8f0;
            color: #475569;
        }

        .btn-secondary:hover {
            background-color: #cbd5e1;
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

        .alert-info {
            background-color: #dbeafe;
            border: 1px solid #93c5fd;
            color: #1e40af;
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

            .info-grid {
                grid-template-columns: 1fr;
            }

            .form-row {
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
    <div class="main-wrapper">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <span>✏️</span>
                    Edit Return Request
                </h1>
                <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${returnRequest.returnRequestId}" 
                   class="btn-back">
                    ← Back to Details
                </a>
            </div>

            <!-- Info Alert -->
            <div class="alert alert-info">
                <span>ℹ️</span>
                <div>
                    <strong>Edit Mode:</strong> You can modify your return request details below. Changes will be reviewed by our team.
                </div>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="error-message">
                    ❌ ${errorMessage}
                </div>
            </c:if>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/return-request" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="customerId" value="${returnRequest.customerId}">
                <input type="hidden" name="requestId" value="${returnRequest.returnRequestId}">
                <input type="hidden" name="orderId" value="${returnRequest.orderId}">

                <!-- Order Information (Read-only) -->
                <div class="card">
                    <h2 class="card-title">📦 Order Information</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Order ID</div>
                            <div class="info-value">#${returnRequest.orderId}</div>
                        </div>
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
                    </div>
                </div>

                <!-- Select Items to Return -->
                <div class="card">
                    <h2 class="card-title">
                        📋 Select Items to Return
                        <span style="color: #ef4444; font-size: 14px;">*</span>
                    </h2>
                    <div class="helper-text" style="margin-bottom: 12px;">
                        Check the items you want to return and specify the quantity for each
                    </div>
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th class="checkbox-cell">Select</th>
                                <th>Product</th>
                                <th>Available Qty</th>
                                <th>Return Qty</th>
                                <th>Unit Price</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <c:set var="isSelected" value="${selectedOrderDetailIds.contains(item.orderDetailId)}" />
                                
                                <tr>
                                    <td class="checkbox-cell">
                                        <input type="checkbox" 
                                               name="orderDetailIds" 
                                               value="${item.orderDetailId}"
                                               data-detail-id="${item.orderDetailId}"
                                               data-max-qty="${item.detailQuantity}"
                                               ${isSelected ? 'checked' : ''}
                                               class="item-checkbox"
                                               onchange="toggleQuantityInput(this)">
                                    </td>
                                    <td><strong><c:out value="${item.productName}"/></strong></td>
                                    <td><c:out value="${item.detailQuantity}"/></td>
                                    <td>
                                        <input type="hidden" 
                                               name="price_${item.orderDetailId}" 
                                               value="${item.detailPrice}">
                                        
                                        <input type="number" 
                                               id="qty_${item.orderDetailId}"
                                               name="qty_${item.orderDetailId}" 
                                               value="${item.detailQuantity}"
                                               min="1"
                                               max="${item.detailQuantity}"
                                               class="qty-input"
                                               ${isSelected ? '' : 'disabled'}
                                               oninput="validateQuantity(this, ${item.detailQuantity})">
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.detailPrice}" 
                                                          type="currency" 
                                                          currencySymbol="$" 
                                                          maxFractionDigits="2"/>
                                    </td>
                                    <td id="subtotal_${item.orderDetailId}">
                                        <fmt:formatNumber value="${item.detailPrice * item.detailQuantity}" 
                                                          type="currency" 
                                                          currencySymbol="$" 
                                                          maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="helper-text">* Select products and adjust return quantities as needed (max = available quantity)</div>
                </div>

                <!-- Return Information -->
                <div class="card">
                    <h2 class="card-title">💬 Return Information</h2>

                    <div class="form-group">
                        <label for="reason">
                            Return Reason
                            <span class="required">*</span>
                        </label>
                        <select id="reason" name="reason" class="form-control" required>
                            <option value="">-- Select a reason --</option>
                            <option value="Defective Product" ${returnRequest.reason == 'Defective Product' ? 'selected' : ''}>
                                Defective Product
                            </option>
                            <option value="Wrong Item" ${returnRequest.reason == 'Wrong Item' ? 'selected' : ''}>
                                Wrong Item Received
                            </option>
                            <option value="Not as Described" ${returnRequest.reason == 'Not as Described' ? 'selected' : ''}>
                                Not as Described
                            </option>
                            <option value="Changed Mind" ${returnRequest.reason == 'Changed Mind' ? 'selected' : ''}>
                                Changed Mind
                            </option>
                            <option value="Better Price Found" ${returnRequest.reason == 'Better Price Found' ? 'selected' : ''}>
                                Better Price Found
                            </option>
                            <option value="Other" ${returnRequest.reason == 'Other' ? 'selected' : ''}>
                                Other
                            </option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="note">Additional Note</label>
                        <textarea id="note" 
                                  name="note" 
                                  class="form-control"
                                  maxlength="500"
                                  placeholder="Please provide more details about your return request...">${returnRequest.note}</textarea>
                        <div class="helper-text">Optional: Provide additional details (max 500 characters)</div>
                    </div>
                </div>

                <!-- Bank Information -->
                <div class="card">
                    <h2 class="card-title">🏦 Bank Account Information</h2>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="bankName">
                                Bank Name
                                <span class="required">*</span>
                            </label>
                            <select id="bankName" name="bankName" class="form-control" required>
                                <option value="">-- Select Bank --</option>
                                <option value="VCB" ${savedBankName == 'VCB' ? 'selected' : ''}>Vietcombank</option>
                                <option value="ACB" ${savedBankName == 'ACB' ? 'selected' : ''}>ACB Bank</option>
                                <option value="VTB" ${savedBankName == 'VTB' ? 'selected' : ''}>VietinBank</option>
                                <option value="TCB" ${savedBankName == 'TCB' ? 'selected' : ''}>Techcombank</option>
                                <option value="MB" ${savedBankName == 'MB' ? 'selected' : ''}>MB Bank</option>
                                <option value="BIDV" ${savedBankName == 'BIDV' ? 'selected' : ''}>BIDV</option>
                                <option value="AGR" ${savedBankName == 'AGR' ? 'selected' : ''}>Agribank</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="accountNumber">
                                Account Number
                                <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="accountNumber"
                                   name="accountNumber" 
                                   class="form-control"
                                   placeholder="Enter account number" 
                                   value="${savedAccountNumber}"
                                   pattern="\d{6,}"
                                   title="Account number must be at least 6 digits"
                                   required>
                            <div class="helper-text">Enter at least 6 digits</div>
                        </div>

                        <div class="form-group">
                            <label for="accountHolder">
                                Account Holder Name
                                <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="accountHolder"
                                   name="accountHolder" 
                                   class="form-control"
                                   placeholder="Enter account holder name" 
                                   value="${savedAccountHolder}"
                                   required>
                        </div>
                    </div>
                    <div class="helper-text">⚠️ Please ensure bank information is correct for refund processing</div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/return-request?action=detail&requestId=${returnRequest.returnRequestId}" 
                       class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        ✓ Update Request
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        /**
         * Toggle quantity input when checkbox is checked/unchecked
         */
        function toggleQuantityInput(checkbox) {
            const detailId = checkbox.getAttribute('data-detail-id');
            const qtyInput = document.getElementById('qty_' + detailId);
            const maxQty = parseInt(checkbox.getAttribute('data-max-qty'));
            
            if (!qtyInput) {
                console.error('Quantity input not found for detail ID:', detailId);
                return;
            }
            
            qtyInput.disabled = !checkbox.checked;
            
            // Reset to max value when enabled
            if (checkbox.checked) {
                qtyInput.value = maxQty;
                updateSubtotal(detailId);
            }
        }

        /**
         * Validate quantity input value
         */
        function validateQuantity(input, maxQty) {
            let value = parseInt(input.value);
            
            // Remove any non-digit characters
            input.value = input.value.replace(/\D/g, '');
            
            if (isNaN(value) || value < 1) {
                input.value = 1;
            } else if (value > maxQty) {
                input.value = maxQty;
                alert(`⚠️ Maximum quantity is ${maxQty}`);
            }
            
            // Update subtotal
            const detailId = input.id.replace('qty_', '');
            updateSubtotal(detailId);
        }

        /**
         * Update subtotal for a specific item
         */
        function updateSubtotal(detailId) {
            const qtyInput = document.getElementById('qty_' + detailId);
            const priceInput = document.querySelector(`input[name="price_${detailId}"]`);
            const subtotalCell = document.getElementById('subtotal_' + detailId);
            
            if (qtyInput && priceInput && subtotalCell) {
                const qty = parseInt(qtyInput.value) || 0;
                const price = parseFloat(priceInput.value) || 0;
                const subtotal = qty * price;
                
                // Format as currency
                subtotalCell.textContent = '$' + subtotal.toFixed(2);
            }
        }

        /**
         * Validate form before submission
         */
        function validateForm() {
            // Check if at least one item is selected
            const checkboxes = document.querySelectorAll('.item-checkbox');
            const checkedBoxes = Array.from(checkboxes).filter(cb => cb.checked);

            if (checkedBoxes.length === 0) {
                alert('⚠️ Please select at least one item to return');
                return false;
            }

            // Validate quantities for checked items
            for (let checkbox of checkedBoxes) {
                const detailId = checkbox.getAttribute('data-detail-id');
                const qtyInput = document.getElementById('qty_' + detailId);
                const maxQty = parseInt(checkbox.getAttribute('data-max-qty'));
                const qty = parseInt(qtyInput.value);

                if (isNaN(qty) || qty < 1 || qty > maxQty) {
                    alert(`⚠️ Invalid quantity for selected item. Must be between 1 and ${maxQty}`);
                    qtyInput.focus();
                    return false;
                }
            }

            // Validate reason
            const reason = document.getElementById('reason').value;
            if (!reason || reason.trim() === '') {
                alert('⚠️ Please select a return reason');
                document.getElementById('reason').focus();
                return false;
            }

            // Validate bank info
            const bankName = document.getElementById('bankName').value;
            const accountNumber = document.getElementById('accountNumber').value.trim();
            const accountHolder = document.getElementById('accountHolder').value.trim();

            if (!bankName || !accountNumber || !accountHolder) {
                alert('⚠️ Please fill in all bank information fields');
                return false;
            }

            // Validate account number format
            if (!/^\d{6,}$/.test(accountNumber)) {
                alert('⚠️ Account number must be at least 6 digits and contain only numbers');
                document.getElementById('accountNumber').focus();
                return false;
            }

            // Disable submit button to prevent double submission
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Updating...';

            return true;
        }

        /**
         * Real-time validation for account number
         */
        const accountNumberInput = document.getElementById('accountNumber');
        if (accountNumberInput) {
            accountNumberInput.addEventListener('input', function() {
                // Remove non-digit characters
                this.value = this.value.replace(/\D/g, '');
            });

            accountNumberInput.addEventListener('blur', function() {
                const value = this.value.trim();
                if (value && !/^\d{6,}$/.test(value)) {
                    this.setCustomValidity('Account number must be at least 6 digits');
                } else {
                    this.setCustomValidity('');
                }
            });
        }

        /**
         * Character counter for note textarea
         */
        const noteTextarea = document.getElementById('note');
        if (noteTextarea) {
            const maxLength = noteTextarea.getAttribute('maxlength') || 500;
            const helperText = noteTextarea.nextElementSibling;

            noteTextarea.addEventListener('input', function() {
                const remaining = maxLength - this.value.length;
                if (this.value.length > 0) {
                    helperText.textContent = `${remaining} characters remaining`;
                } else {
                    helperText.textContent = `Optional: Provide additional details (max ${maxLength} characters)`;
                }
            });
        }

        /**
         * Initialize on page load
         */
        window.addEventListener('load', function() {
            // Initialize all checked items
            const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');
            checkedBoxes.forEach(checkbox => {
                const detailId = checkbox.getAttribute('data-detail-id');
                updateSubtotal(detailId);
            });

            // Auto-hide error messages after 5 seconds
            const errorMsg = document.querySelector('.error-message');
            if (errorMsg) {
                setTimeout(() => {
                    errorMsg.style.transition = 'opacity 0.5s';
                    errorMsg.style.opacity = '0';
                    setTimeout(() => errorMsg.remove(), 500);
                }, 5000);
            }
        });
    </script>
</body>
</html>