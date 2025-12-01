<%-- 
    Document   : customer-detail
    Created on : Oct 16, 2025, 10:44:46 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details - NeoShoes</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <style>
        body {
            background-color: #f8f9fa;
            overflow-x: hidden;
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
        
        .detail-header {
            background: #fff;
            padding: 1rem 0;
            margin-bottom: 1rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .detail-header h5 {
            color: #000;
            font-size: 1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .avatar-section {
            text-align: center;
            margin-bottom: 1rem;
        }
        
        .customer-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            object-fit: cover;
            position: relative;
        }
        
        .avatar-wrapper {
            position: relative;
            display: inline-block;
        }
        
        .status-indicator {
            position: absolute;
            bottom: 5px;
            right: 5px;
            width: 24px;
            height: 24px;
            border: 3px solid white;
            border-radius: 50%;
        }
        
        .status-active {
            background-color: #10b981;
        }
        
        .status-blocked {
            background-color: #ef4444;
        }
        
        .customer-name {
            font-size: 1rem;
            font-weight: 700;
            color: #1f2937;
            margin-top: 1rem;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-card {
            background: white;
            border-radius: 12px;
            padding: 0.9rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
            border: 1px solid #f0f0f0;
            height: 100%;
        }
        
        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }
        
        .info-card-icon {
            width: 32px;
            height: 32px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.5rem;
        }
        
        .icon-blue {
            background-color: #dbeafe;
            color: #2563eb;
        }
        
        .icon-purple {
            background-color: #ede9fe;
            color: #7c3aed;
        }
        
        .icon-green {
            background-color: #d1fae5;
            color: #10b981;
        }
        
        .icon-red {
            background-color: #fee2e2;
            color: #ef4444;
        }
        
        .info-card-label {
            color: #9ca3af;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.1rem;
        }
        
        .info-card-value {
            color: #1f2937;
            font-size: 1rem;
            font-weight: 500;
            margin: 0;
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .badge-active {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .badge-blocked {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }
        
        .dot-active {
            background-color: #10b981;
        }
        
        .dot-blocked {
            background-color: #ef4444;
        }
        
        .back-btn {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <!-- Header -->
        <jsp:include page="common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="common/staff-sidebar.jsp"/>
    
    <!-- Main Content -->
    <div id="main-content">
        <div class="container-fluid p-4">
            
            <!-- Page Header -->
            <div class="detail-header">
                <div class="container">
                    <h5>
                        <i data-lucide="file-text" style="width: 21px; height: 21px;"></i>
                        Customer Details
                    </h5>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${not empty customer}">
                    <!-- Avatar Section -->
                    <div class="avatar-section">
                        <div class="avatar-wrapper">
                            <img src="${not empty customer.avatar ? customer.avatar : 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg'}" 
                                 alt="Customer Avatar" 
                                 class="customer-avatar"
                                 onerror="this.src='https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg'">
                            <span class="status-indicator ${customer.isBlock() ? 'status-blocked' : 'status-active'}"></span>
                        </div>
                        <h2 class="customer-name">${customer.name}</h2>
                    </div>
                    
                    <!-- Info Cards Grid -->
                    <div class="row g-2">
                        <!-- Email Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon icon-blue">
                                    <i data-lucide="mail" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Email</div>
                                <p class="info-card-value">${customer.email}</p>
                            </div>
                        </div>
                        
                        <!-- Phone Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon icon-blue">
                                    <i data-lucide="phone" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Phone</div>
                                <p class="info-card-value">${not empty customer.phoneNumber ? customer.phoneNumber : 'N/A'}</p>
                            </div>
                        </div>
                        
                        <!-- Gender Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon icon-purple">
                                    <i data-lucide="user" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Gender</div>
                                <p class="info-card-value">${not empty customer.gender ? customer.gender : 'N/A'}</p>
                            </div>
                        </div>
                        
                        <!-- Customer ID Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon icon-purple">
                                    <i data-lucide="hash" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Customer ID</div>
                                <p class="info-card-value">#${customer.id}</p>
                            </div>
                        </div>
                        
                        <!-- Created At Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon icon-green">
                                    <i data-lucide="calendar" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Created At</div>
                                <p class="info-card-value">
                                    ${customer.formattedCreatedAt}
                                </p>
                            </div>
                        </div>
                        
                        <!-- Status Card -->
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="info-card-icon ${customer.isBlock() ? 'icon-red' : 'icon-green'}">
                                    <i data-lucide="${customer.isBlock() ? 'ban' : 'check-circle'}" style="width: 16px; height: 16px;"></i>
                                </div>
                                <div class="info-card-label">Status</div>
                                <div class="status-badge ${customer.isBlock() ? 'badge-blocked' : 'badge-active'}">
                                    <span class="status-dot ${customer.isBlock() ? 'dot-blocked' : 'dot-active'}"></span>
                                    ${customer.isBlock() ? 'Blocked' : 'Active'}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        <i data-lucide="alert-triangle" style="width: 18px; height: 18px;"></i>
                        Customer not found!
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>
