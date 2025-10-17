<%-- 
    Document   : staff-header
    Created on : Oct 17, 2025, 10:14:02 AM
    Author     : Le Huu Nghia - CE181052
--%>

<style>
    .dashboard-header {
        height: 74px;
        background-color: #ffffff;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        border-bottom: 1px solid #e5e7eb;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
    }

    .header-logo {
        height: 100%;
        object-fit: cover;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border: 2px solid #d1d5db;
        transition: border-color 0.3s;
    }

    .user-info:hover .user-avatar {
        border-color: #3b82f6;
    }

    .user-name {
        font-size: 0.875rem;
        font-weight: 500;
        color: #111827;
        margin: 0;
    }

    .user-role {
        font-size: 0.75rem;
        color: #6b7280;
        margin: 0;
    }
</style>

<header class="dashboard-header">
    <div class="container-fluid h-100">
        <div class="d-flex h-100 align-items-center justify-content-between px-3">
            <!-- Logo -->
            <div class="d-flex align-items-center" style="height: 62px;">
                <img class="header-logo" 
                     src="https://res.cloudinary.com/drqip0exk/image/upload/v1759560158/Logo_NeoShoes-removebg-preview_d0efnb.png" 
                     alt="NeoShoes Logo">
            </div>

            <!-- User Info -->
            <c:if test="${not empty sessionScope.staff}">
                <div class="d-flex align-items-center user-info" style="cursor: pointer;">
                    <div class="text-end me-3 d-none d-md-block">
                        <p class="user-name">${sessionScope.staff.name}</p>
                        <p class="user-role">${sessionScope.staff.getRoleName()}</p>
                    </div>
                    <img src="${sessionScope.staff.avatar}" 
                         alt="Avatar"
                         class="rounded-circle user-avatar"
                         onerror="this.src='https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg'">
                </div>
            </c:if>
        </div>
    </div>
</header>
