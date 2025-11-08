<%-- 
    Document   : list (FIXED VERSION with proper validation)
    Created on : Oct 20, 2025, 9:22:14 PM
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
        <title>All Active Returns</title>
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
            }

            .main-wrapper {
                margin-left: 300px;
                margin-top: 74px;
                padding: 20px;
                min-height: calc(100vh - 74px);
            }
            .page-header {
                background-color: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .page-title {
                background-color: white;
                padding: 15px 20px;
                margin-bottom: 20px;
                border-bottom: 1px solid #ddd;
            }
            .table-container {
                background-color: white;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 4px;
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
            .order-link {
                color: #007bff;
                text-decoration: none;
                font-weight: 500;
            }
            .order-link:hover {
                text-decoration: underline;
            }
            .modal-header {
                background-color: #f8f9fa;
            }
            .form-label {
                font-weight: 600;
            }
            .text-truncate-custom {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
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
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Return Request Detail</h2>
                    </div>
                </div>
            </div>
            <div class="container-fluid">
                <div class="page-title">
                    <h4 class="mb-0">All Active Returns</h4>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${fn:escapeXml(sessionScope.successMessage)}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${fn:escapeXml(sessionScope.errorMessage)}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Request ID</th>
                                    <th>Order ID</th>
                                    <th>Customer ID</th>
                                    <th>Created on Date</th>
                                    <th>Return Status</th>
                                    <th>Reason</th>
                                    <th>Bank Account Info</th>
                                    <th>Note</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${requests}">
                                    <tr>
                                        <td>#${r.returnRequestId}</td>
                                        <td><a href="#" class="order-link">#${r.orderId}</a></td>
                                        <td>${r.customerId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.requestDate != null}">
                                                    ${r.requestDate.toLocalDate()}
                                                </c:when>
                                                <c:otherwise>
                                                    N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge bg-${r.returnStatus == 'APPROVED' ? 'success' : r.returnStatus == 'PENDING' ? 'warning' : 'danger'}">
                                                ${fn:escapeXml(r.returnStatus)}
                                            </span>
                                        </td>
                                        <td class="text-truncate-custom" title="${fn:escapeXml(r.reason)}">
                                            <c:out value="${r.reason}" default="N/A"/>
                                        </td>
                                        <td class="text-truncate-custom" title="${fn:escapeXml(r.bankAccountInfo)}">
                                            <c:out value="${r.bankAccountInfo}" default="N/A"/>
                                        </td>
                                        <td class="text-truncate-custom" title="${fn:escapeXml(r.note)}">
                                            <c:out value="${r.note}" default="N/A"/>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn btn-info btn-sm me-1" 
                                                    data-action="view" 
                                                    data-request-id="${r.returnRequestId}">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                            <button class="btn btn-warning btn-sm me-1" 
                                                    data-action="edit"
                                                    data-request-id="${r.returnRequestId}" 
                                                    data-status="${fn:escapeXml(r.returnStatus)}">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <c:choose>
                                                <c:when test="${r.returnStatus == 'APPROVED' || r.returnStatus == 'REJECTED'}">
                                                    <button class="btn btn-danger btn-sm" 
                                                            data-action="delete"
                                                            data-request-id="${r.returnRequestId}" 
                                                            data-order-id="${r.orderId}">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm" disabled 
                                                            title="Only finalized (APPROVED/REJECTED) requests can be deleted">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty requests}">
                                    <tr>
                                        <td colspan="9" class="text-center text-muted">
                                            No return requests found
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">
                            <i class="fas fa-edit"></i> Edit Return Request #<span id="modalRequestId"></span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="editForm" action="${pageContext.request.contextPath}/staff/manage-return-request" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" id="editRequestId">
                        <input type="hidden" name="currentStatus" id="currentStatus">

                        <div class="modal-body">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> Update the status for this return request.
                            </div>

                            <div class="alert alert-warning" id="statusWarning" style="display: none;">
                                <i class="fas fa-exclamation-triangle"></i> 
                                <strong>Warning:</strong> Changing status from PENDING to APPROVED/REJECTED is irreversible!
                            </div>

                            <div class="mb-3">
                                <label for="editStatus" class="form-label">
                                    <i class="fas fa-tasks"></i> Return Status *
                                </label>
                                <select name="status" id="editStatus" class="form-select" required>
                                    <option value="">-- Select Status --</option>
                                    <option value="PENDING">Pending</option>
                                    <option value="APPROVED">Approved</option>
                                    <option value="REJECTED">Rejected</option>
                                </select>
                                <div class="invalid-feedback">
                                    Please select a valid status.
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary" id="saveBtn">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Delete Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="deleteModalLabel">
                            <i class="fas fa-exclamation-triangle"></i> Confirm Delete
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/staff/manage-return-request" method="POST">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="requestId" id="deleteRequestId">
                        <input type="hidden" name="orderId" id="deleteOrderIdHidden">

                        <div class="modal-body">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i> 
                                <strong>Warning!</strong> This action cannot be undone.
                            </div>
                            <p>Are you sure you want to delete this return request?</p>
                            <ul class="list-unstyled mt-3">
                                <li><strong>Request ID:</strong> #<span id="deleteRequestIdDisplay"></span></li>
                                <li><strong>Order ID:</strong> #<span id="deleteOrderId"></span></li>
                            </ul>
                            <p class="text-muted small">
                                <i class="fas fa-info-circle"></i> This will permanently remove the return request from the system.
                            </p>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">
                                <i class="fas fa-trash"></i> Delete Request
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script>
            let editModal;
            let deleteModal;

            document.addEventListener('DOMContentLoaded', function () {
                editModal = new bootstrap.Modal(document.getElementById('editModal'));
                deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

                // Event delegation for action buttons
                document.querySelector('.table-responsive').addEventListener('click', function (e) {
                    const btn = e.target.closest('button[data-action]');
                    if (!btn)
                        return;

                    const action = btn.dataset.action;
                    const requestId = parseInt(btn.dataset.requestId);

                    // Validate requestId
                    if (!requestId || isNaN(requestId) || requestId <= 0) {
                        alert('Invalid request ID');
                        return;
                    }

                    switch (action) {
                        case 'view':
                            viewDetail(requestId);
                            break;
                        case 'edit':
                            const status = btn.dataset.status;
                            openEditModal(requestId, status);
                            break;
                        case 'delete':
                            const orderId = parseInt(btn.dataset.orderId);
                            if (!orderId || isNaN(orderId) || orderId <= 0) {
                                alert('Invalid order ID');
                                return;
                            }
                            openDeleteModal(requestId, orderId);
                            break;
                    }
                });

                // Form validation for edit form
                const editForm = document.getElementById('editForm');
                editForm.addEventListener('submit', function (e) {
                    if (!editForm.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                    } else {
                        // Double check before submission
                        const status = document.getElementById('editStatus').value;
                        const currentStatus = document.getElementById('currentStatus').value;

                        if (currentStatus === 'PENDING' && (status === 'APPROVED' || status === 'REJECTED')) {
                            if (!confirm('Are you sure you want to finalize this status? This action cannot be undone.')) {
                                e.preventDefault();
                                return;
                            }
                        }

                        // Disable submit button to prevent double submission
                        document.getElementById('saveBtn').disabled = true;
                    }
                    editForm.classList.add('was-validated');
                });

                // Status change warning
                document.getElementById('editStatus').addEventListener('change', function () {
                    const currentStatus = document.getElementById('currentStatus').value;
                    const newStatus = this.value;
                    const warning = document.getElementById('statusWarning');

                    if (currentStatus === 'PENDING' && (newStatus === 'APPROVED' || newStatus === 'REJECTED')) {
                        warning.style.display = 'block';
                    } else {
                        warning.style.display = 'none';
                    }
                });

                // Prevent double submission for delete form
                const deleteForm = document.getElementById('deleteForm');
                deleteForm.addEventListener('submit', function () {
                    document.getElementById('confirmDeleteBtn').disabled = true;
                });
            });

            function viewDetail(requestId) {
                // Validate before redirect
                if (!requestId || isNaN(requestId) || requestId <= 0) {
                    alert('Invalid request ID');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/staff/manage-return-request?action=detail&requestId=' + encodeURIComponent(requestId);
            }

            function openEditModal(requestId, status) {
                // Sanitize and validate inputs
                requestId = parseInt(requestId);
                if (!requestId || isNaN(requestId) || requestId <= 0) {
                    alert('Invalid request ID');
                    return;
                }

                // Validate status
                const validStatuses = ['PENDING', 'APPROVED', 'REJECTED'];
                if (!validStatuses.includes(status)) {
                    status = '';
                }

                // Reset form validation
                document.getElementById('editForm').classList.remove('was-validated');
                document.getElementById('saveBtn').disabled = false;
                document.getElementById('statusWarning').style.display = 'none';

                // Set form values
                document.getElementById('modalRequestId').textContent = requestId;
                document.getElementById('editRequestId').value = requestId;
                document.getElementById('currentStatus').value = status;
                document.getElementById('editStatus').value = status;

                editModal.show();
            }

            function openDeleteModal(requestId, orderId) {
                // Validate inputs
                requestId = parseInt(requestId);
                orderId = parseInt(orderId);

                if (!requestId || isNaN(requestId) || requestId <= 0 ||
                        !orderId || isNaN(orderId) || orderId <= 0) {
                    alert('Invalid request or order ID');
                    return;
                }

                // Reset button state
                document.getElementById('confirmDeleteBtn').disabled = false;

                // Set form values with sanitized data
                document.getElementById('deleteRequestId').value = requestId;
                document.getElementById('deleteOrderIdHidden').value = orderId;
                document.getElementById('deleteRequestIdDisplay').textContent = requestId;
                document.getElementById('deleteOrderId').textContent = orderId;

                deleteModal.show();
            }
        </script>
    </body>
</html>