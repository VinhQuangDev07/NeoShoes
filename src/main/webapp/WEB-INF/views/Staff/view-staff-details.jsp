<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Staff Details - ${staff.name}</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://unpkg.com/lucide@latest"></script>
        <style>
            body {
                background: #f8f9fa;
                padding-top: 74px;
            }
            .main-content {
                margin-left: 300px;
                padding: 2rem;
            }
            .page-header {
                background: white;
                padding: 24px;
                border-radius: 8px;
                margin-bottom: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .detail-card {
                background: white;
                border-radius: 12px;
                padding: 2rem;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                margin-bottom: 1.5rem;
            }
            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
            }
            .info-row {
                display: flex;
                padding: 1rem 0;
                border-bottom: 1px solid #e9ecef;
            }
            .info-label {
                width: 200px;
                font-weight: 600;
                color: #666;
            }
            .info-value {
                flex: 1;
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
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold mb-1">Staff Details</h2>
                    <p class="text-muted mb-0">View information for <strong>${staff.name}</strong></p>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="detail-card text-center">
                        <img src="${staff.displayAvatar}" class="profile-avatar mb-3">
                        <h4>${staff.name}</h4>
                        <p class="text-muted">${staff.email}</p>
                        <span class="badge bg-primary">${staff.roleName}</span>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="detail-card">
                        <h5>Personal Information</h5>
                        <div class="info-row">
                            <div class="info-label">Full Name:</div>
                            <div class="info-value">${staff.name}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div class="info-value">${staff.email}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Phone:</div>
                            <div class="info-value">${staff.phoneNumber != null ? staff.phoneNumber : 'N/A'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Gender:</div>
                            <div class="info-value">${staff.gender != null ? staff.gender : 'N/A'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Date of Birth:</div>
                            <div class="info-value">${staff.formattedDob}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Address:</div>
                            <div class="info-value">${staff.address != null ? staff.address : 'N/A'}</div>
                        </div>
                    </div>

                    <div class="detail-card">
                        <h5>System Information</h5>
                        <div class="info-row">
                            <div class="info-label">Role:</div>
                            <div class="info-value"><span class="badge bg-primary">${staff.roleName}</span></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Created At:</div>
                            <div class="info-value">${staff.formattedCreatedAt}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status:</div>
                            <div class="info-value"><span class="badge bg-success">Active</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>