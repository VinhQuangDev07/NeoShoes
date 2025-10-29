<%-- 
    Document   : staff-sidebar
    Created on : Oct 17, 2025, 10:24:55 AM
    Author     : Le Huu Nghia - CE181052
--%>

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
    
    .nav-link i {
        width: 20px;
        height: 20px;
    }
    
    .logout-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        width: 100%;
        padding: 0.75rem 1.5rem;
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
                <a id="dashboard" data-page="dashboard" href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                    <i data-lucide="layout-dashboard"></i>
                    Dashboard
                </a>
            </div>
            
            <!-- User Management Section -->
            <div>
                <h3 class="sidebar-section-title">User Management</h3>
                <div class="d-flex flex-column gap-1">
                    <a id="customer" data-page="customer" href="${pageContext.request.contextPath}/manage-customer" class="nav-link">
                        <i data-lucide="users"></i>
                        Customer
                    </a>
                    <a id="staff" data-page="profile" href="${pageContext.request.contextPath}/profilestaff" class="nav-link">
                        <i data-lucide="user-cog"></i>
                        Profile
                    </a>
                </div>
            </div>
            
            <!-- Product Management Section -->
            <div>
                <h3 class="sidebar-section-title">Store Management</h3>
                <div class="d-flex flex-column gap-1">
                    <a id="product" data-page="product" href="${pageContext.request.contextPath}/staff/product" class="nav-link">
                        <i data-lucide="package"></i>
                        Products
                    </a>
                    <a id="product" data-page="import-product-records" href="${pageContext.request.contextPath}/staff/import-records" class="nav-link">
                        <i data-lucide="package"></i>
                        Import Product
                    </a>
                    <a id="order" data-page="order" href="${pageContext.request.contextPath}/staff/orders" class="nav-link">
                        <i data-lucide="shopping-cart"></i>
                        Orders
                    </a>
                    <a id="return-request" data-page="return-request" href="${pageContext.request.contextPath}/staff/orders" class="nav-link">
                        <i data-lucide="shopping-cart"></i>
                        Return Request
                    </a>
                    <a id="category" data-page="category" href="${pageContext.request.contextPath}/managecategoriesforstaff" class="nav-link">
                        <i data-lucide="tags"></i>
                        Categories
                    </a>
                    <a id="voucher" data-page="voucher" href="${pageContext.request.contextPath}/vouchermanage" class="nav-link">
                        <i data-lucide="ticket"></i>
                        Vouchers
                    </a>
                    <a id="brand" data-page="brand" href="${pageContext.request.contextPath}/managebrands" class="nav-link">
                        <i data-lucide="layers"></i>
                        Brands
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Logout Button -->
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                          d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                </svg>
                Logout
            </a>
        </div>
    </div>
</div>

<script>
    // Initialize Lucide icons
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Highlight current page
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentPath || 
                (currentPath.includes('/staff/orders') && link.getAttribute('href').includes('/staff/orders')) ||
                (currentPath.includes('/staff/order-detail') && link.getAttribute('href').includes('/staff/orders'))) {
                link.classList.add('active');
            }
        });
    });
</script>
