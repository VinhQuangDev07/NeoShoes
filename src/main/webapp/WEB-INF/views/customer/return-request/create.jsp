<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        <title>Create Return Request</title>
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

            /* Order Summary Card */
            .order-summary {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 24px;
            }

            .order-summary h2 {
                font-size: 18px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 16px;
                padding-bottom: 12px;
                border-bottom: 2px solid #e2e8f0;
            }

            .order-info {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 16px;
            }

            .order-info-item {
                padding: 12px;
                background-color: #f8fafc;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .order-info-label {
                font-size: 12px;
                color: #64748b;
                margin-bottom: 4px;
            }

            .order-info-value {
                font-size: 16px;
                font-weight: 600;
                color: #1e293b;
            }

            /* Form Card */
            .form-card {
                background: white;
                padding: 32px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .form-section {
                margin-bottom: 32px;
            }

            .form-section:last-child {
                margin-bottom: 0;
            }

            .section-title {
                font-size: 16px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 20px;
                padding-bottom: 12px;
                border-bottom: 2px solid #e2e8f0;
            }

            /* Products Table */
            .products-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 16px;
            }

            .products-table thead {
                background-color: #f8fafc;
            }

            .products-table th {
                padding: 12px;
                text-align: left;
                font-size: 13px;
                font-weight: 600;
                color: #475569;
                border-bottom: 2px solid #e2e8f0;
            }

            .products-table td {
                padding: 16px 12px;
                border-bottom: 1px solid #e2e8f0;
                font-size: 14px;
                color: #1e293b;
            }

            .products-table tbody tr:hover {
                background-color: #f8fafc;
            }

            /* Checkbox Styling */
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

            .products-table .checkbox-cell {
                display: none;
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

            .qty-input[readonly] {
                background-color: #f1f5f9;
                cursor: not-allowed;
                color: #64748b;
                border-color: #cbd5e1;
            }

            /* Form Group */
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

            /* Two Column Layout */
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
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .btn-primary {
                background-color: #3b82f6;
                color: white;
            }

            .btn-primary:hover:not(:disabled) {
                background-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .btn-secondary {
                background-color: #e2e8f0;
                color: #475569;
            }

            .btn-secondary:hover:not(:disabled) {
                background-color: #cbd5e1;
            }

            /* Loading Spinner */
            .spinner {
                border: 2px solid #ffffff;
                border-top: 2px solid transparent;
                border-radius: 50%;
                width: 16px;
                height: 16px;
                animation: spin 0.8s linear infinite;
                display: none;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Helper Text */
            .helper-text {
                font-size: 12px;
                color: #64748b;
                margin-top: 6px;
            }

            /* Badge */
            .badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .badge-success {
                background-color: #d1fae5;
                color: #065f46;
            }

            .badge-warning {
                background-color: #fef3c7;
                color: #92400e;
            }

            /* Modal/Confirmation Dialog */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }

            .modal-overlay.active {
                display: flex;
            }

            .modal-content {
                background: white;
                padding: 24px;
                border-radius: 12px;
                max-width: 500px;
                width: 90%;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            }

            .modal-header {
                font-size: 18px;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 16px;
            }

            .modal-body {
                font-size: 14px;
                color: #475569;
                line-height: 1.6;
                margin-bottom: 20px;
            }

            .modal-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-wrapper {
                    margin-left: 0;
                    margin-top: 0;
                }

                .order-info {
                    grid-template-columns: 1fr;
                }

                .form-row {
                    grid-template-columns: 1fr;
                }

                .page-header {
                    flex-direction: column;
                    gap: 16px;
                    align-items: flex-start;
                }

                .products-table {
                    font-size: 12px;
                }

                .products-table th,
                .products-table td {
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
                <div class="container col-lg-9">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>
                            <span>↩️</span>
                            Create Return Request
                        </h1>
                        <a href="${pageContext.request.contextPath}/orders" class="btn-back">
                            ← Back to Orders
                        </a>
                    </div>




                    <!-- Order Summary -->
                    <div class="order-summary">
                        <h2>📦 Order Summary</h2>
                        <div class="order-info">
                            <div class="order-info-item">
                                <div class="order-info-label">Order ID</div>
                                <div class="order-info-value">#<c:out value="${order.orderId}"/></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Total Amount</div>
                                <div class="order-info-value">$<c:out value="${order.totalAmount}"/></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Order Status</div>
                                <div class="order-info-value">
                                    <span class="badge badge-success"><c:out value="${order.status}"/></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Form Card -->
                    <div class="form-card">
                        <form action="${pageContext.request.contextPath}/return-request" method="POST" id="returnRequestForm">               

                            <input type="hidden" name="action" value="create">
                            <input type="hidden" name="orderId" value="<c:out value='${order.orderId}'/>">
                            <input type="hidden" name="customerId" value="<c:out value='${sessionScope.user.customerId}'/>">

                            <!-- Select Items Section -->
                            <div class="form-section">
                                <h2 class="section-title">Items to Return</h2>
                                <table class="products-table">
                                    <thead>
                                        <tr>
                                            <th class="checkbox-cell">Select</th>
                                            <th>Product</th>
                                            <th>Ordered Qty</th>
                                            <th>Price</th>
                                            <th>Return Qty</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td class="checkbox-cell">
                                                    <input type="checkbox" 
                                                           name="productId" 
                                                           value="${item.productVariantId}"
                                                           data-max="${item.detailQuantity}"
                                                           checked
                                                           style="display:none;"
                                                           onchange="toggleQty(this, ${item.productVariantId})">
                                                </td>
                                                <td>
                                                    <strong><c:out value="${item.productName}"/></strong>
                                                </td>
                                                <td><c:out value="${item.detailQuantity}"/></td>
                                                <td>$<c:out value="${item.detailPrice}"/></td>
                                                <td>
                                                    <input type="hidden" 
                                                           name="price_${item.productVariantId}" 
                                                           value="${item.detailPrice}">

                                                    <input type="number" 
                                                           id="qty_${item.productVariantId}"
                                                           name="qty_${item.productVariantId}" 
                                                           value="${item.detailQuantity}"
                                                           min="1"
                                                           max="${item.detailQuantity}"
                                                           class="qty-input"
                                                           readonly>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Return Information Section -->
                            <div class="form-section">
                                <h2 class="section-title">Return Information</h2>

                                <div class="form-group">
                                    <label for="reason">
                                        Return Reason
                                        <span class="required">*</span>
                                    </label>
                                    <select id="reason" name="reason" class="form-control" required>
                                        <option value="">-- Select a reason --</option>
                                        <option value="Defective Product">Defective Product</option>
                                        <option value="Wrong Item">Wrong Item Received</option>
                                        <option value="Not as Described">Not as Described</option>
                                        <option value="Changed Mind">Changed Mind</option>
                                        <option value="Better Price Found">Better Price Found</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="note">Additional Note</label>
                                    <textarea id="note" 
                                              name="note" 
                                              class="form-control" 
                                              maxlength="500"
                                              placeholder="Please provide any additional details about your return request..."></textarea>
                                    <div class="helper-text">Optional: Add any relevant information about your return (max 500 characters)</div>
                                </div>
                            </div>

                            <!-- Bank Information Section -->
                            <div class="form-section">
                                <h2 class="section-title">Refund Bank Information</h2>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="bankName">
                                            Bank Name
                                            <span class="required">*</span>
                                        </label>
                                        <select id="bankName" name="bankName" class="form-control" required>
                                            <option value="">-- Select Bank --</option>
                                            <option value="VCB">Vietcombank</option>
                                            <option value="ACB">ACB Bank</option>
                                            <option value="VTB">VietinBank</option>
                                            <option value="TCB">Techcombank</option>
                                            <option value="MB">MB Bank</option>
                                            <option value="BIDV">BIDV</option>
                                            <option value="AGR">Agribank</option>
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
                                               required>
                                    </div>
                                </div>
                                <div class="helper-text">⚠️ Please ensure bank information is correct for refund processing</div>
                            </div>

                            <!-- Form Actions -->
                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                                    Cancel
                                </button>
                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                    <span id="submitBtnText">✓ Submit Return Request</span>
                                    <span class="spinner" id="submitSpinner"></span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <div class="modal-header">⚠️ Confirm Return Request</div>
                <div class="modal-body" id="confirmMessage">
                    Are you sure you want to submit this return request?
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeConfirmModal()">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-primary" onclick="confirmSubmit()">
                        Yes, Submit
                    </button>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/customer/common/footer.jsp"/>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                        // Global variables
                        let formSubmitting = false;

                        /**
                         * Toggle quantity input based on checkbox state
                         */
                        function toggleQty(checkbox, variantId) {
                            const qtyInput = document.getElementById('qty_' + variantId);
                            qtyInput.disabled = !checkbox.checked;

                            // Reset to max value when enabled
                            if (checkbox.checked) {
                                qtyInput.value = qtyInput.max;
                            }
                        }

                        /**
                         * Validate form before submission
                         */
                        function validateForm() {
                            // 1. Check if at least one product is selected
//                            const checkedBoxes = document.querySelectorAll('input[name="productId"]:checked');
//
//                            if (checkedBoxes.length === 0) {
//                                alert('⚠️ Please select at least one product to return');
//                                return false;
//                            }
                            const checkedBoxes = document.querySelectorAll('input[name="productId"]');

                            // 2. Validate quantities for selected products
                            for (let checkbox of checkedBoxes) {
                                const variantId = checkbox.value;
                                const qtyInput = document.getElementById('qty_' + variantId);
                                const qty = parseInt(qtyInput.value);
                                const max = parseInt(qtyInput.max);

                                if (isNaN(qty) || qty < 1 || qty > max) {
                                    alert('⚠️ Invalid return quantity for selected product. Must be between 1 and ' + max);
                                    qtyInput.focus();
                                    return false;
                                }
                            }

                            // 3. Validate required fields
                            const reason = document.getElementById('reason').value.trim();
                            if (!reason) {
                                alert('⚠️ Please select a return reason');
                                document.getElementById('reason').focus();
                                return false;
                            }

                            const bankName = document.getElementById('bankName').value.trim();
                            if (!bankName) {
                                alert('⚠️ Please select a bank name');
                                document.getElementById('bankName').focus();
                                return false;
                            }

                            const accountNumber = document.getElementById('accountNumber').value.trim();
                            if (!accountNumber) {
                                alert('⚠️ Please enter account number');
                                document.getElementById('accountNumber').focus();
                                return false;
                            }

                            // 4. Validate account number format
                            if (!/^\d{6,}$/.test(accountNumber)) {
                                alert('⚠️ Account number must be at least 6 digits and contain only numbers');
                                document.getElementById('accountNumber').focus();
                                return false;
                            }

                            const accountHolder = document.getElementById('accountHolder').value.trim();
                            if (!accountHolder) {
                                alert('⚠️ Please enter account holder name');
                                document.getElementById('accountHolder').focus();
                                return false;
                            }

                            return true;
                        }

                        /**
                         * Show confirmation modal
                         */
                        function showConfirmModal() {
                            const allProducts = document.querySelectorAll('input[name="productId"]');
                            const count = allProducts.length;
                            const message = 'You are about to submit a return request for ALL ' + count + ' product(s) in this order. Are you sure you want to continue?';

                            document.getElementById('confirmMessage').textContent = message;
                            document.getElementById('confirmModal').classList.add('active');
                        }

                        /**
                         * Close confirmation modal
                         */
                        function closeConfirmModal() {
                            document.getElementById('confirmModal').classList.remove('active');
                        }

                        /**
                         * Confirm and submit form
                         */
                        function confirmSubmit() {
                            closeConfirmModal();

                            // Disable submit button to prevent double submission
                            const submitBtn = document.getElementById('submitBtn');
                            const submitBtnText = document.getElementById('submitBtnText');
                            const submitSpinner = document.getElementById('submitSpinner');

                            submitBtn.disabled = true;
                            submitBtnText.textContent = 'Processing...';
                            submitSpinner.style.display = 'inline-block';

                            // Mark as submitting
                            formSubmitting = true;

                            // Submit form
                            document.getElementById('returnRequestForm').submit();
                        }

                        /**
                         * Handle form submission
                         */
                        document.getElementById('returnRequestForm').addEventListener('submit', function (e) {
                            e.preventDefault();

                            // Prevent double submission
                            if (formSubmitting) {
                                return false;
                            }

                            // Validate form
                            if (!validateForm()) {
                                return false;
                            }

                            // Show confirmation modal
                            showConfirmModal();
                        });

                        /**
                         * Close modal when clicking outside
                         */
                        document.getElementById('confirmModal').addEventListener('click', function (e) {
                            if (e.target === this) {
                                closeConfirmModal();
                            }
                        });



                        /**
                         * Character counter for note textarea
                         */
                        const noteTextarea = document.getElementById('note');
                        if (noteTextarea) {
                            const maxLength = noteTextarea.getAttribute('maxlength') || 500;
                            const helperText = noteTextarea.nextElementSibling;

                            noteTextarea.addEventListener('input', function () {
                                const remaining = maxLength - this.value.length;
                                if (this.value.length > 0) {
                                    helperText.textContent = remaining + ' characters remaining';
                                } else {
                                    helperText.textContent = 'Optional: Add any relevant information about your return (max ' + maxLength + ' characters)';
                                }
                            });
                        }

                        /**
                         * Real-time validation for account number
                         */
                        const accountNumberInput = document.getElementById('accountNumber');
                        if (accountNumberInput) {
                            accountNumberInput.addEventListener('input', function () {
                                // Remove non-digit characters
                                this.value = this.value.replace(/\D/g, '');
                            });

                            accountNumberInput.addEventListener('blur', function () {
                                const value = this.value.trim();
                                if (value && !/^\d{6,}$/.test(value)) {
                                    this.setCustomValidity('Account number must be at least 6 digits');
                                } else {
                                    this.setCustomValidity('');
                                }
                            });
                        }


        </script>
    </body>
</html>