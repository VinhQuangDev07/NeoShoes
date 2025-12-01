<%-- 
    Document   : staff-sidebar
    Updated    : Oct 2025
    Author     : Le Huu Nghia - CE181052
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #sidebar {
        position: fixed;
        top: 74px;
        left: 0;
        width: 300px;
        height: calc(100vh - 74px);
        background-color: #ffffff;
        border-right: 1px solid #e5e7eb;
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
        overflow-y: auto;
        transition: transform 0.3s ease;
        z-index: 999;
    }

    .sidebar-section-title {
        font-size: 0.75rem;
        font-weight: 600;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-bottom: 0.5rem;
        padding-left: 0.75rem;
    }

    .nav-link {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem 0.75rem;
        border-radius: 0.5rem;
        color: #374151;
        text-decoration: none;
        transition: all 0.2s;
        font-size: 0.95rem;
    }

    .nav-link:hover {
        background-color: #f3f4f6;
        color: #2563eb;
    }

    .nav-link:active {
        background-color: #e5e7eb;
    }

    .nav-link.active {
        background-color: #dbeafe;
        color: #1d4ed8;
        font-weight: 500;
    }

    .logout-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        width: 100%;
        margin-top: 10px;
        padding: 0.5rem 1.5rem;
        background-color: #ef4444;
        color: white;
        font-weight: 600;
        border-radius: 0.5rem;
        border: none;
        transition: background-color 0.2s;
        text-decoration: none;
    }

    .logout-btn:hover {
        background-color: #dc2626;
        color: white;
    }

    .logout-btn svg {
        width: 20px;
        height: 20px;
    }

    .sidebar-content {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
        padding: 1.25rem;
    }

    .sidebar-nav {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .sidebar-footer {
        padding: 0 0.75rem;
        margin-bottom: 1rem;
    }
</style>

<div id="sidebar">
    <div class="sidebar-content">
        <!-- Navigation Links -->
        <div class="sidebar-nav">
            <!-- General Section -->
            <div>
                <h3 class="sidebar-section-title">General</h3>
                <a id="dashboard" data-page="dashboard" 
                   href="${pageContext.request.contextPath}/staff/dashboard" 
                   class="nav-link">
                    <i data-lucide="layout-dashboard"></i>
                    Dashboard
                </a>
            </div>

            <!-- User Management Section -->
            <div>
                <h3 class="sidebar-section-title">User Management</h3>
                <div class="d-flex flex-column gap-1">
                    <a id="customer" data-page="customer" 
                       href="${pageContext.request.contextPath}/staff/manage-customer" 
                       class="nav-link">
                        <i data-lucide="users"></i>
                        Customers
                    </a>
                    <c:if test="${sessionScope.role eq 'staff'}">
                        <a id="staff" data-page="profile" 
                           href="${pageContext.request.contextPath}/staff/profile" 
                           class="nav-link">
                            <i data-lucide="id-card"></i>
                            My Profile
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.role eq 'admin'}">
                        <a id="staff" data-page="profile" 
                           href="${pageContext.request.contextPath}/staff/manage-staff" 
                           class="nav-link">
                            <i data-lucide="id-card"></i>
                            Manage Staff
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Store Management Section -->
            <div>
                <h3 class="sidebar-section-title">Store Management</h3>
                <div class="d-flex flex-column gap-1">
                    <a id="product" data-page="product" 
                       href="${pageContext.request.contextPath}/staff/product" 
                       class="nav-link">
                        <i data-lucide="boxes"></i>
                        Products
                    </a>

                    <a id="order" data-page="order" 
                       href="${pageContext.request.contextPath}/staff/orders" 
                       class="nav-link">
                        <i data-lucide="shopping-bag"></i>
                        Orders
                    </a>

                    <!-- Only Admin -->
                    <c:if test="${sessionScope.role eq 'admin'}">
                        <a id="import-product-records" data-page="import-product-records" 
                           href="${pageContext.request.contextPath}/staff/import-records" 
                           class="nav-link">
                            <i data-lucide="truck"></i>
                            Import Product
                        </a>
                        <a id="return-request" data-page="return-request" 
                           href="${pageContext.request.contextPath}/staff/manage-return-request" 
                           class="nav-link">
                            <i data-lucide="rotate-ccw"></i>
                            Return Requests
                        </a>
                    </c:if>

                    <a id="category" data-page="category" 
                       href="${pageContext.request.contextPath}/staff/manage-categories" 
                       class="nav-link">
                        <i data-lucide="tags"></i>
                        Categories
                    </a>

                    <a id="brand" data-page="brand" 
                       href="${pageContext.request.contextPath}/staff/manage-brands" 
                       class="nav-link">
                        <i data-lucide="layers"></i>
                        Brands
                    </a>

                    <a id="voucher" data-page="voucher" 
                       href="${pageContext.request.contextPath}/staff/manage-voucher" 
                       class="nav-link">
                        <i data-lucide="ticket"></i>
                        Vouchers
                    </a>
                </div>
            </div>
        </div>

        <!-- Logout Button -->
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <i data-lucide="log-out"></i>
                Logout
            </a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        const currentPath = window.location.pathname.toLowerCase();
        const navLinks = document.querySelectorAll('#sidebar .nav-link');

        navLinks.forEach(link => {
            const href = link.getAttribute('href').toLowerCase();
            if (currentPath === href || currentPath.startsWith(href)) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });
</script>
