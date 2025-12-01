<%-- 
    Document   : list
    Created on : Oct 20, 2025, 9:22:14 PM
    Author     : Nguyen Huynh Thien An - CE190979
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>All Active Returns</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f5f5f5;
                font-family: Arial, sans-serif;
            }
            .container-fluid {
                padding: 20px;
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
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="page-title">
                <h4 class="mb-0">All Active Returns</h4>
            </div>

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
                                            ${r.returnStatus}
                                        </span>
                                    </td>
                                    <td>${r.reason}</td>
                                    <td>${r.bankAccountInfo}</td>
                                    <td>${r.note}</td>
                                    <td class="text-center">
                                        <button class="btn btn-info btn-sm me-1" onclick="viewDetail(${r.returnRequestId})">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button class="btn btn-warning btn-sm me-1" 
                                                onclick="openEditModal(${r.returnRequestId}, '${r.returnStatus}')">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <c:choose>
                                            <c:when test="${r.returnStatus == 'APPROVED' || r.returnStatus == 'REJECTED'}">
                                                <button class="btn btn-danger btn-sm" 
                                                        onclick="openDeleteModal(${r.returnRequestId}, ${r.orderId})">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-secondary btn-sm" disabled title="Only APPROVED or REJECTED requests can be deleted">
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
                    <form id="editForm" action="${pageContext.request.contextPath}/admin/manage-return-request" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="requestId" id="editRequestId">

                        <div class="modal-body">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> Update the status for this return request.
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
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
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
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/manage-return-request" method="POST">
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
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-danger">
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
            });

            function viewDetail(requestId) {
                window.location.href = '${pageContext.request.contextPath}/admin/manage-return-request?action=detail&requestId=' + requestId;
            }

            function openEditModal(requestId, status) {
                document.getElementById('modalRequestId').textContent = requestId;
                document.getElementById('editRequestId').value = requestId;
                document.getElementById('editStatus').value = status || '';
                editModal.show();
            }

            function openDeleteModal(requestId, orderId) {
                document.getElementById('deleteRequestId').value = requestId;
                document.getElementById('deleteOrderIdHidden').value = orderId;
                document.getElementById('deleteRequestIdDisplay').textContent = requestId;
                document.getElementById('deleteOrderId').textContent = orderId;
                deleteModal.show();
            }
        </script>
    </body>
</html>