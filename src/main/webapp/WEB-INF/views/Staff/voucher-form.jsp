<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${formAction eq 'add' ? 'Add New' : 'Edit'} Voucher</title>

        <!-- Bootstrap & Lucide -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            .card {
                background: #fff;
                border-radius: 12px;
                padding: 28px;
                box-shadow: 0 2px 8px rgba(0,0,0,.05);
            }

            label {
                font-weight: 700;
                color: #374151;
                font-size: 14px;
            }
            .required {
                color: #dc2626;
            }
            input, select, textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
            }
            input:focus, select:focus, textarea:focus {
                outline: none;
                border-color: #3b82f6;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }
            .help-text {
                font-size: 12px;
                color: #6b7280;
                margin-top: 4px;
            }
            .btn-primary {
                background: #3b82f6;
                color: #fff;
                border: none;
                padding: 12px 20px;
                font-weight: 700;
                border-radius: 8px;
            }
            .btn-primary:hover {
                filter: brightness(.9);
                transform: translateY(-1px);
                color: #fff;
            }
            .btn-secondary {
                background: #e5e7eb;
                color: #374151;
                border: none;
                border-radius: 8px;
                padding: 12px 20px;
                font-weight: 700;
            }
            .btn-secondary:hover {
                background: #d1d5db;
            }
            .error-message {
                background: #fee2e2;
                color: #991b1b;
                border-radius: 6px;
                padding: 10px 14px;
                margin-bottom: 16px;
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

        <div class="main-content">
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">${formAction eq 'add' ? 'Add New' : 'Edit'} Voucher</h2>
                    <p class="text-muted mb-0">Configure voucher settings and restrictions</p>
                </div>
            </div>

            <div class="wrap">
                <div class="card">
                    <c:if test="${not empty error}">
                        <div class="error-message">❌ ${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/staff/manage-voucher/${formAction}">
                        <c:if test="${formAction eq 'update'}">
                            <input type="hidden" name="id" value="${voucher.voucherId}"/>
                        </c:if>

                        <!-- Voucher Code -->
                        <div class="mb-3">
                            <label>Voucher Code <span class="required">*</span></label>
                            <input type="text" name="voucherCode" value="${voucher.voucherCode}" placeholder="e.g., SUMMER2025" required maxlength="50"/>
                            <div class="help-text">Unique code customers will use</div>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label>Description</label>
                            <textarea name="voucherDescription" placeholder="Enter voucher description">${voucher.voucherDescription}</textarea>
                        </div>

                        <div class="form-row mb-3">
                            <div>
                                <label>Discount Type <span class="required">*</span></label>
                                <select name="type" required id="discountType" onchange="updateValueLabel()">
                                    <option value="PERCENTAGE" ${voucher.type eq 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                                    <option value="FIXED" ${voucher.type eq 'FIXED' ? 'selected' : ''}>Fixed Amount ($)</option>
                                </select>
                            </div>
                            <div>
                                <label id="valueLabel">Discount Value (%) <span class="required">*</span></label>
                                <input type="number" name="value" value="${voucher.value}" step="0.01" min="0" placeholder="e.g., 10 or 50" required/>
                            </div>
                        </div>

                        <div class="form-row mb-3">
                            <div>
                                <label>Min Order Value ($)</label>
                                <input type="number" name="minValue" value="${voucher.minValue}" step="0.01" min="0" placeholder="0.00"/>
                                <div class="help-text">Minimum order amount required</div>
                            </div>
                            <div>
                                <label>Max Discount Amount ($)</label>
                                <input type="number" name="maxValue" value="${voucher.maxValue}" step="0.01" min="0" placeholder="0.00"/>
                                <div class="help-text">Maximum discount cap</div>
                            </div>
                        </div>

                        <div class="form-row mb-3">
                            <div>
                                <label>Start Date</label>
                                <input type="date" name="startDate" value="<fmt:formatDate value='${voucher.startDateAsDate}' pattern='yyyy-MM-dd'/>"/>
                            </div>
                            <div>
                                <label>End Date</label>
                                <input type="date" name="endDate" value="<fmt:formatDate value='${voucher.endDateAsDate}' pattern='yyyy-MM-dd'/>"/>
                            </div>
                        </div>

                        <div class="form-row mb-3">
                            <div>
                                <label>Total Usage Limit</label>
                                <input type="number" name="totalUsageLimit" value="${voucher.totalUsageLimit}" min="1" placeholder="e.g., 100"/>
                            </div>
                            <div>
                                <label>User Usage Limit</label>
                                <input type="number" name="userUsageLimit" value="${voucher.userUsageLimit}" min="1" placeholder="e.g., 1"/>
                            </div>
                        </div>

                        <!-- Active checkbox -->
                        <div class="mb-3 form-check">
                            <input type="checkbox" name="isActive" id="isActive" class="form-check-input" value="1" ${voucher.active ? 'checked' : ''}/>
                            <label for="isActive" class="form-check-label fw-semibold">Active</label>
                            <div class="help-text">Enable or disable this voucher</div>
                        </div>

                        <div class="d-flex gap-3 mt-4">
                            <button type="submit" class="btn btn-primary flex-fill">
                                ${formAction eq 'add' ? 'Add Voucher' : 'Update Voucher'}
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/manage-voucher" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function updateValueLabel() {
                const type = document.getElementById('discountType').value;
                const label = document.getElementById('valueLabel');
                label.innerHTML = type === 'PERCENTAGE'
                        ? 'Discount Value (%) <span class="required">*</span>'
                        : 'Discount Value ($) <span class="required">*</span>';
            }
            updateValueLabel();
            lucide.createIcons();
        </script>
    </body>
</html>
