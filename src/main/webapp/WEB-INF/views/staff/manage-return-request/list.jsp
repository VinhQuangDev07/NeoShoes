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
                background-color: #f8f9fa;
                overflow-x: hidden;
                font-family: 'Inter', sans-serif;
            }

            #main-content {
                margin-left: 0;
                transition: margin-left 0.3s ease;
                padding-top: 74px;
            }

            @media (min-width: 992px) {
                #main-content {
                    margin-left: 300px;
                }
            }

            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .return-table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }

            .table thead {
                background-color: #f8f9fa;
            }

            .badge-status {
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 500;
                padding: 6px 12px;
            }

            .status-pending {
                background-color: #fff8e1;
                color: #f59e0b;
            }

            .status-approved {
                background-color: #d1f4e0;
                color: #0f7d3f;
            }

            .status-rejected {
                background-color: #ffe0e0;
                color: #d32f2f;
            }

            .action-btn {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                border: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
                margin: 0 2px;
            }

            .btn-view {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .btn-edit {
                background-color: #fff3e0;
                color: #f57c00;
            }
            .btn-delete {
                background-color: #ffebee;
                color: #d32f2f;
            }

            .action-btn:hover {
                transform: scale(1.1);
                color: white;
            }

            .btn-view:hover {
                background-color: #1976d2;
            }
            .btn-edit:hover {
                background-color: #f57c00;
            }
            .btn-delete:hover {
                background-color: #d32f2f;
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

        <div id="main-content">
            <div class="container-fluid p-4">

                <!-- Page Header -->
                <div class="page-header">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h2 class="mb-0 fw-bold">Return Requests</h2>
                            <p class="text-muted mb-0 mt-1">Manage and review all return requests</p>
                        </div>
                    </div>
                </div>

                <!-- Table -->
                <div class="card border-0 shadow-sm return-table">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="px-4 py-3">#</th>
                                        <th>Order ID</th>
                                        <th>Customer ID</th>
                                        <th>Created On</th>
                                        <th>Status</th>
                                        <th>Reason</th>
                                        <th>Bank Info</th>
                                        <th>Note</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty requests}">
                                            <tr>
                                                <td colspan="9" class="text-center py-4 text-muted">
                                                    No return requests found
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="r" items="${requests}" varStatus="status">
                                                <tr>
                                                    <td class="px-4">${status.index + 1}</td>
                                                    <td><a href="#" class="order-link fw-semibold text-decoration-none text-primary">#${r.orderId}</a></td>
                                                    <td>${r.customerId}</td>
                                                    <td>${r.requestDate != null ? r.requestDate.toLocalDate() : 'N/A'}</td>
                                                    <td>
                                                        <span class="badge-status
                                                              ${r.returnStatus eq 'APPROVED' ? 'status-approved' :
                                                                r.returnStatus eq 'REJECTED' ? 'status-rejected' : 'status-pending'}">
                                                                  ${r.returnStatus}
                                                              </span>
                                                        </td>
                                                        <td class="text-truncate-custom">${r.reason}</td>
                                                        <td class="text-truncate-custom">${r.bankAccountInfo}</td>
                                                        <td class="text-truncate-custom">${r.note}</td>
                                                        <td class="text-center">
                                                            <button class="action-btn btn-view" data-action="view" data-request-id="${r.returnRequestId}">
                                                                <i data-lucide="eye"></i>
                                                            </button>
                                                            <button class="action-btn btn-edit" data-action="edit" data-request-id="${r.returnRequestId}" data-status="${r.returnStatus}">
                                                                <i data-lucide="edit"></i>
                                                            </button>
                                                            <button class="action-btn btn-delete"
                                                                    data-action="delete"
                                                                    data-request-id="${r.returnRequestId}"
                                                                    data-order-id="${r.orderId}"
                                                                    title="Delete Request">
                                                                <i data-lucide="trash-2"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="/WEB-INF/views/common/pagination.jsp" />
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