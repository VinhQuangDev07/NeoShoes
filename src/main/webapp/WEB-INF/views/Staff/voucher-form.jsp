<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${formAction eq 'add' ? 'Add New' : 'Edit'} Voucher</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        body {
            margin: 0;
            background: #f5f6f8;
        }
        
        .page-head {
            background: #000;
            color: #fff;
            padding: 20px 24px;
        }
        .page-head h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
        }
        
        .wrap {
            padding: 24px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-card {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,.05);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 700;
            font-size: 14px;
            color: #374151;
        }
        label .required {
            color: #dc2626;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color .2s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #3b82f6;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 24px;
        }
        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background: #111827;
            color: #fff;
            flex: 1;
        }
        .btn-primary:hover {
            background: #374151;
        }
        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }
        .btn-secondary:hover {
            background: #d1d5db;
        }
        
        .error-message {
            color: #dc2626;
            font-size: 13px;
            margin-top: 4px;
            padding: 8px 12px;
            background: #fee2e2;
            border-radius: 6px;
            margin-bottom: 16px;
        }
        
        .help-text {
            font-size: 12px;
            color: #6b7280;
            margin-top: 4px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="page-head">
        <h1>${formAction eq 'add' ? 'Add New' : 'Edit'} Voucher</h1>
    </div>

    <div class="wrap">
        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="error-message">❌ ${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/vouchermanage/${formAction}?role=${userRole}">
                <c:if test="${formAction eq 'update'}">
                    <input type="hidden" name="id" value="${voucher.voucherId}"/>
                </c:if>

                <!-- Voucher Code -->
                <div class="form-group">
                    <label>Voucher Code <span class="required">*</span></label>
                    <input type="text" 
                           name="voucherCode" 
                           value="${voucher.voucherCode}" 
                           placeholder="e.g., SUMMER2024"
                           required 
                           maxlength="50"/>
                    <div class="help-text">Unique code that customers will use</div>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="voucherDescription" 
                              placeholder="Enter voucher description">${voucher.voucherDescription}</textarea>
                </div>

                <div class="form-row">
                    <!-- Type -->
                    <div class="form-group">
                        <label>Discount Type <span class="required">*</span></label>
                        <select name="type" required id="discountType" onchange="updateValueLabel()">
                            <option value="PERCENTAGE" ${voucher.type eq 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                            <option value="FIXED" ${voucher.type eq 'FIXED' ? 'selected' : ''}>Fixed Amount ($)</option>
                        </select>
                    </div>

                    <!-- Value -->
                    <div class="form-group">
                        <label id="valueLabel">Discount Value <span class="required">*</span></label>
                        <input type="number" 
                               name="value" 
                               value="${voucher.value}" 
                               step="0.01" 
                               min="0"
                               placeholder="e.g., 10 or 50"
                               required/>
                    </div>
                </div>

                <div class="form-row">
                    <!-- Min Order Value -->
                    <div class="form-group">
                        <label>Min Order Value ($)</label>
                        <input type="number" 
                               name="minValue" 
                               value="${voucher.minValue}" 
                               step="0.01" 
                               min="0"
                               placeholder="0.00"/>
                        <div class="help-text">Minimum order amount required</div>
                    </div>

                    <!-- Max Discount Amount -->
                    <div class="form-group">
                        <label>Max Discount Amount ($)</label>
                        <input type="number" 
                               name="maxValue" 
                               value="${voucher.maxValue}" 
                               step="0.01" 
                               min="0"
                               placeholder="0.00"/>
                        <div class="help-text">Maximum discount cap</div>
                    </div>
                </div>

                <div class="form-row">
                    <!-- Start Date -->
                    <div class="form-group">
                        <label>Start Date</label>
                        <input type="date" 
                               name="startDate" 
                               value="<fmt:formatDate value='${voucher.startDateAsDate}' pattern='yyyy-MM-dd'/>"/>
                    </div>

                    <!-- End Date -->
                    <div class="form-group">
                        <label>End Date</label>
                        <input type="date" 
                               name="endDate" 
                               value="<fmt:formatDate value='${voucher.endDateAsDate}' pattern='yyyy-MM-dd'/>"/>
                    </div>
                </div>

                <div class="form-row">
                    <!-- Total Usage Limit -->
                    <div class="form-group">
                        <label>Total Usage Limit</label>
                        <input type="number" 
                               name="totalUsageLimit" 
                               value="${voucher.totalUsageLimit}" 
                               min="1"
                               placeholder="e.g., 100"/>
                        <div class="help-text">Total times voucher can be used</div>
                    </div>

                    <!-- User Usage Limit -->
                    <div class="form-group">
                        <label>User Usage Limit</label>
                        <input type="number" 
                               name="userUsageLimit" 
                               value="${voucher.userUsageLimit}" 
                               min="1"
                               placeholder="e.g., 1"/>
                        <div class="help-text">Times per user can use</div>
                    </div>
                </div>

                <!-- Is Active -->
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" 
                               name="isActive" 
                               id="isActive" 
                               value="1" 
                               ${voucher.active ? 'checked' : ''}/>
                        <label for="isActive" style="margin: 0; font-weight: 600;">Active</label>
                    </div>
                    <div class="help-text">Enable or disable this voucher</div>
                </div>

                <!-- Buttons -->
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        ${formAction eq 'add' ? '✓ Add Voucher' : '✓ Update Voucher'}
                    </button>
                    <a href="${pageContext.request.contextPath}/vouchermanage/list?role=${userRole}" 
                       class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        function updateValueLabel() {
            const type = document.getElementById('discountType').value;
            const label = document.getElementById('valueLabel');
            if (type === 'PERCENTAGE') {
                label.innerHTML = 'Discount Value (%) <span class="required">*</span>';
            } else {
                label.innerHTML = 'Discount Value ($) <span class="required">*</span>';
            }
        }
        
        // Initialize on page load
        updateValueLabel();
    </script>
</body>
</html>