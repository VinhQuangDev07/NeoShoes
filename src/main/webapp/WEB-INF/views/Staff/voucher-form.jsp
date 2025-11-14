<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <fmt:setLocale value="en_US" />

<!DOCTYPE html> 
<html lang="vi"> <head> <meta charset="UTF-8" /> <meta name="viewport" content="width=device-width, initial-scale=1.0"/> <title><c:out value="${formAction == 'update' ? 'Edit Voucher' : 'Add Voucher'}"/> - NeoShoes</title> <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/> <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/> <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis() %>"></script> <style> :root{
            --primary-color:#ff6b6b;
            --border-color:#e0e0e0;
        }
        *{
            box-sizing:border-box;
        }
        body{
            font-family:Segoe UI, Tahoma, Geneva, Verdana, sans-serif;
            background:#f8f9fa;
            min-height:100vh;
        }
        #main-content{
            margin-left:0;
            padding-top:74px;
        }
        @media(min-width:992px){
            #main-content{
                margin-left:300px;
            }
        }
        .container-inner{
            padding:20px;
        }
        .form-card{
            background:#fff;
            border-radius:8px;
            padding:24px;
            box-shadow:0 1px 6px rgba(0,0,0,0.06);
        }
        .form-label{
            font-weight:600;
            color:#374151;
        }
        .form-control{
            border-radius:8px;
            padding:10px 12px;
        }
        .btn-primary{
            background:#0d6efd;
            border:none;
            border-radius:8px;
            padding:10px 16px;
            color:#fff;
        } </style> </head> <body> <!-- header/sidebar/notification --> <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/> <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/> <jsp:include page="/WEB-INF/views/common/notification.jsp"/>
        <div id="main-content">
            <div class="container-fluid container-inner">
                <div class="page-header mb-3">
                    <h2 class="mb-1 fw-bold"><c:out value="${formAction == 'update' ? 'Edit Voucher' : 'Add New Voucher'}"/></h2>
                    <p class="text-muted mb-0">Điền thông tin voucher</p>
                </div>

                <div class="form-card">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"><c:out value="${error}"/></div>
                    </c:if>

                    <!-- Nếu servlet đã set startDateStr/endDateStr thì dùng, nếu không để rỗng -->
                    <c:set var="sd" value="${startDateStr != null ? startDateStr : ''}"/>
                    <c:set var="ed" value="${endDateStr != null ? endDateStr : ''}"/>

                    <form method="post" action="<c:url value='/staff/manage-voucher/${formAction}'/>" enctype="multipart/form-data">
                        <c:if test="${formAction == 'update'}">
                            <input type="hidden" name="id" value="${voucher.voucherId}" />
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label">Voucher Code *</label>
                            <input name="voucherCode" type="text" class="form-control" required maxlength="50"
                                   value="<c:out value='${voucher.voucherCode}'/>"
                                   placeholder="e.g., SUMMER2025"/>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="voucherDescription" class="form-control" rows="3"><c:out value='${voucher.voucherDescription}'/></textarea>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Discount Type *</label>
                                <select id="discountType" name="type" class="form-control" required onchange="updateValueLabel()">
                                    <option value="PERCENTAGE" <c:if test="${voucher.type == 'PERCENTAGE'}">selected</c:if>>Percentage (%)</option>
                                    <option value="FIXED" <c:if test="${voucher.type == 'FIXED'}">selected</c:if>>Fixed Amount ($)</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label id="valueLabel" class="form-label">Discount Value *</label>
                                    <input name="value" type="number" step="0.01" min="0" class="form-control" required value="<c:out value='${voucher.value}'/>" placeholder="10 or 50"/>
                            </div>
                        </div>

                        <div class="row g-3 mt-2">
                            <div class="col-md-6">
                                <label class="form-label">Min Order Value ($)</label>
                                <input name="minValue" type="number" step="0.01" min="0" class="form-control" value="<c:out value='${voucher.minValue}'/>"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Max Discount Amount ($)</label>
                                <input name="maxValue" type="number" step="0.01" min="0" class="form-control" value="<c:out value='${voucher.maxValue}'/>"/>
                            </div>
                        </div>

                        <div class="row g-3 mt-2">
                            <div class="col-md-6">
                                <label class="form-label">Start Date</label>
                                <input name="startDate" type="date" class="form-control" value="${sd}"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">End Date</label>
                                <input name="endDate" type="date" class="form-control" value="${ed}"/>
                            </div>
                        </div>

                        <div class="row g-3 mt-2">
                            <div class="col-md-6">
                                <label class="form-label">Total Usage Limit</label>
                                <input name="totalUsageLimit" type="number" min="1" class="form-control" value="<c:out value='${voucher.totalUsageLimit}'/>"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">User Usage Limit</label>
                                <input name="userUsageLimit" type="number" min="1" class="form-control" value="<c:out value='${voucher.userUsageLimit}'/>"/>
                            </div>
                        </div>

                        <div class="form-check form-switch mt-3">
                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" value="1" <c:if test="${voucher.active}">checked</c:if>/>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>

                            <div class="mt-4 d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                <c:out value="${formAction == 'update' ? 'Save Changes' : 'Add Voucher'}"/>
                            </button>
                            <a href="<c:url value='/staff/manage-voucher'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Không include footer tại đây nếu project của bạn quản lý footer ở chỗ khác -->

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    function updateValueLabel() {
                                        const sel = document.getElementById('discountType');
                                        const type = sel ? sel.value : 'PERCENTAGE';
                                        const label = document.getElementById('valueLabel');
                                        if (!label)
                                            return;
                                        label.textContent = type === 'PERCENTAGE' ? 'Discount Value (%) *' : 'Discount Value ($) *';
                                    }
                                    document.addEventListener('DOMContentLoaded', updateValueLabel);
        </script>

    </body> 
</html>