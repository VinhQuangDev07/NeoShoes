<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Details - ${staff.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; padding-top: 74px; }
        .main-content { margin-left: 300px; padding: 2rem; }
        .detail-card { background: white; border-radius: 12px; padding: 2rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 1.5rem; }
        .profile-avatar { width: 120px; height: 120px; border-radius: 50%; }
        .info-row { display: flex; padding: 1rem 0; border-bottom: 1px solid #e9ecef; }
        .info-label { width: 200px; font-weight: 600; color: #666; }
        .info-value { flex: 1; }
    </style>
</head>
<body>
    
<jsp:include page="/WEB-INF/views/Staff/common/staff-header.jsp"/>
<jsp:include page="/WEB-INF/views/Staff/common/staff-sidebar.jsp"/>


    <div class="main-content">
        <div class="d-flex justify-content-between mb-4">
            <h2><i class="fas fa-user-circle"></i> Staff Details</h2>
            <a href="${pageContext.request.contextPath}/manage-staff" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
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