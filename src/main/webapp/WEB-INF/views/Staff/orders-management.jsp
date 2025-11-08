<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management - NeoShoes Staff</title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f7fa;
                padding: 20px;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                /*background: white;*/
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .page-header {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .order-table {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }
            .header h1 {
                color: #333;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 15px;
            }
            .orders-icon {
                width: 40px;
                height: 40px;
                background: #007bff;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 18px;
            }
            .stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            .stat-card {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .stat-content h3 {
                color: #64748b;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 8px;
            }
            .stat-content .number {
                color: #1e293b;
                font-size: 32px;
                font-weight: 700;
            }
            .stat-icon {
                width: 56px;
                height: 56px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }
            .stat-icon.blue {
                background-color: #dbeafe;
                color: #3b82f6;
            }
            .stat-icon.yellow {
                background-color: #fef3c7;
                color: #f59e0b;
            }
            .stat-icon.green {
                background-color: #d1fae5;
                color: #10b981;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #f8f9fa;
                font-weight: bold;
            }
            .status-badge {
                font-size: 0.8rem;
                padding: 0.25rem 0.5rem;
            }
            .voucher-badge {
                background: #d4edda;
                color: #155724;
                padding: 2px 6px;
                border-radius: 3px;
                font-size: 11px;
            }
            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary {
                background: #007bff;
                color: white;
            }
            .btn-primary:hover {
                background: #0056b3;
            }
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #666;
            }

            /* Modal Styling */
            .modal-content {
                border: none;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }

            .modal-body {
                padding: 2rem;
            }

            .modal-title {
                font-weight: 600;
            }

            .text-success {
                color: #10b981 !important;
            }

            .text-danger {
                color: #ef4444 !important;
            }

            /* Pagination Styles */
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 0;
                margin-top: 20px;
                border-top: 1px solid #e2e8f0;
            }

            .pagination-info {
                color: #64748b;
                font-size: 14px;
            }

            .pagination {
                display: flex;
                list-style: none;
                margin: 0;
                padding: 0;
            }

            .page-item {
                margin: 0 2px;
            }

            .page-link {
                display: block;
                padding: 8px 12px;
                color: #475569;
                text-decoration: none;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                transition: all 0.2s;
            }

            .page-link:hover {
                background-color: #f1f5f9;
                border-color: #cbd5e1;
            }

            .page-item.active .page-link {
                background-color: #3b82f6;
                color: white;
                border-color: #3b82f6;
            }

            .page-item.disabled .page-link {
                color: #94a3b8;
                cursor: not-allowed;
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

        <div class="container" style="margin-top: 80px; margin-left: 300px;">
            <div class="page-header">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1 fw-bold">Manage Order</h2>
                        <p class="text-muted mb-0 mt-1">Manage all customer orders</p>
                    </div>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="order-table">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                            <h3>No orders found</h3>
                            <p>There are no orders to display at the moment.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Voucher</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td><strong>#${order.orderId}</strong></td>
                                        <td>
                                            <div>
                                                <strong>${order.customerName}</strong><br>
                                                <small>${order.customerEmail}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="order-date" data-date="${order.placedAt}">
                                                ${order.placedAt}
                                            </span>
                                        </td>
                                        <td>
                                            <strong>$<fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="2"/></strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty order.voucher}">
                                                    <div>
                                                        <span class="voucher-badge">${order.voucher.voucherCode}</span><br>
                                                        <small>
                                                            <c:choose>
                                                                <c:when test="${order.voucher.type == 'PERCENTAGE'}">
                                                                    <fmt:formatNumber value="${order.voucher.value}" type="number" maxFractionDigits="0"/>%
                                                                </c:when>
                                                                <c:otherwise>
                                                                    $<fmt:formatNumber value="${order.voucher.value}" type="number" maxFractionDigits="2"/>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </small>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999;">No voucher</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty order.status}">
                                                    <span class="badge bg-secondary status-badge">No Status</span>
                                                </c:when>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="badge bg-warning status-badge">Pending</span>
                                                </c:when>
                                                <c:when test="${order.status == 'APPROVED'}">
                                                    <span class="badge bg-info status-badge">Approved</span>
                                                </c:when>
                                                <c:when test="${order.status == 'SHIPPED'}">
                                                    <span class="badge bg-primary status-badge">Shipping</span>
                                                </c:when>
                                                <c:when test="${order.status == 'COMPLETED'}">
                                                    <span class="badge bg-success status-badge">Completed</span>
                                                </c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">
                                                    <span class="badge bg-danger status-badge">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary status-badge">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.paymentStatusName == 'Pending'}">
                                                    <span class="badge bg-warning">${order.paymentStatusName}</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatusName == 'Complete'}">
                                                    <span class="badge bg-success">${order.paymentStatusName}</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatusName == 'Failed'}">
                                                    <span class="badge bg-danger">${order.paymentStatusName}</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatusName == 'Cancelled'}">
                                                    <span class="badge bg-danger">${order.paymentStatusName}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${order.paymentStatusName}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <button class="btn btn-primary" style="padding: 4px 8px; font-size: 12px;" onclick="viewOrder(${order.orderId})">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                                <c:choose>
                                                    <c:when test="${order.status == 'CANCELLED'}">
                                                        <button class="btn btn-secondary" style="padding: 4px 8px; font-size: 12px;" disabled title="Cannot update cancelled orders">
                                                            <i class="fas fa-ban"></i> Cancelled
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-warning" style="padding: 4px 8px; font-size: 12px;" onclick="updateStatus(${order.orderId}, '${order.status != null ? order.status : 'No Status'}')">
                                                            <i class="fas fa-arrow-up"></i> Update
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Success Modal -->
        <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center py-4">
                        <div class="mb-3">
                            <i class="fas fa-check-circle text-success" style="font-size: 3rem;"></i>
                        </div>
                        <h5 class="modal-title text-success mb-2">Status Updated Successfully!</h5>
                        <p class="text-muted mb-0">The order status has been updated successfully.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Error Modal -->
        <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center py-4">
                        <div class="mb-3">
                            <i class="fas fa-exclamation-circle text-danger" style="font-size: 3rem;"></i>
                        </div>
                        <h5 class="modal-title text-danger mb-2">Update Failed!</h5>
                        <p class="text-muted mb-0" id="errorMessage">An error occurred while updating the status.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center py-4">
                        <div class="mb-3">
                            <i class="fas fa-question-circle text-warning" style="font-size: 3rem;"></i>
                        </div>
                        <h5 class="modal-title mb-2">Confirm Update</h5>
                        <p class="text-muted mb-4" id="confirmMessage">Are you sure you want to update this order status?</p>
                        <div class="d-flex gap-3 justify-content-center">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-warning" id="confirmUpdateBtn">Update</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                            function viewOrder(orderId) {
                                                                window.location.href = '${pageContext.request.contextPath}/staff/order-detail?orderId=' + orderId;
                                                            }

                                                            let currentOrderId, currentNextStatus;

                                                            function updateStatus(orderId, currentStatus) {
                                                                // Handle null/undefined/empty status
                                                                if (!currentStatus || currentStatus === 'null' || currentStatus === 'undefined' || currentStatus === '') {
                                                                    currentStatus = 'No Status';
                                                                }

                                                                // Determine next status
                                                                let nextStatus = 'PENDING'; // Default value

                                                                if (currentStatus === 'PENDING') {
                                                                    nextStatus = 'APPROVED';
                                                                } else if (currentStatus === 'APPROVED') {
                                                                    nextStatus = 'SHIPPED';
                                                                } else if (currentStatus === 'SHIPPED') {
                                                                    nextStatus = 'COMPLETED';
                                                                } else if (currentStatus === 'COMPLETED') {
                                                                    alert('Order is already completed!');
                                                                    return;
                                                                } else if (currentStatus === 'CANCELLED') {
                                                                    alert('Cannot update cancelled order!');
                                                                    return;
                                                                }

                                                                // Store for later use
                                                                currentOrderId = orderId;
                                                                currentNextStatus = nextStatus;

                                                                // Show custom confirmation modal
                                                                document.getElementById('confirmMessage').textContent = 'Update status?';
                                                                const confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
                                                                confirmModal.show();
                                                            }

                                                            function performUpdate() {
                                                                // Create URL encoded data
                                                                const params = new URLSearchParams();
                                                                params.append('orderId', currentOrderId);
                                                                params.append('newStatus', currentNextStatus);

                                                                // Submit via fetch
                                                                fetch('${pageContext.request.contextPath}/staff/orders', {
                                                                    method: 'POST',
                                                                    headers: {
                                                                        'Content-Type': 'application/x-www-form-urlencoded',
                                                                    },
                                                                    body: params.toString()
                                                                })
                                                                        .then(response => {
                                                                            if (response.ok) {
                                                                                return response.text();
                                                                            } else {
                                                                                throw new Error('Server returned: ' + response.status);
                                                                            }
                                                                        })
                                                                        .then(data => {
                                                                            showSuccessModal();
                                                                        })
                                                                        .catch(error => {
                                                                            showErrorModal(error.message);
                                                                        });
                                                            }

                                                            function showSuccessModal() {
                                                                const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                                                                successModal.show();

                                                                // Auto close after 2 seconds and reload
                                                                setTimeout(() => {
                                                                    successModal.hide();
                                                                    location.reload();
                                                                }, 2000);
                                                            }

                                                            function showErrorModal(message) {
                                                                document.getElementById('errorMessage').textContent = message;
                                                                const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
                                                                errorModal.show();
                                                            }

                                                            // Format dates
                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                const dateElements = document.querySelectorAll('.order-date');
                                                                dateElements.forEach(function (element) {
                                                                    const dateValue = element.getAttribute('data-date');
                                                                    if (dateValue) {
                                                                        try {
                                                                            const date = new Date(dateValue);
                                                                            element.textContent = date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
                                                                        } catch (e) {
                                                                            // Keep original value if parsing fails
                                                                        }
                                                                    }
                                                                });

                                                                // Add event listener for confirm button
                                                                document.getElementById('confirmUpdateBtn').addEventListener('click', function () {
                                                                    const confirmModal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
                                                                    confirmModal.hide();
                                                                    performUpdate();
                                                                });
                                                            });
        </script>
    </body>
</html>