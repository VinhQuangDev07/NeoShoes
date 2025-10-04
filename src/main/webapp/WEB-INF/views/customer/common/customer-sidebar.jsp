<%-- 
    Document   : customer-sidebar
    Created on : Oct 2, 2025, 7:28:31 AM
    Author     : Le Huu Nghia - CE181052
--%>

<div class="customer-sidebar bg-white">
    <div class="d-flex flex-column">

        <!-- Navigation Menu -->
        <nav class="nav-menu flex-fill px-3">
            <div>
                <!-- Profile Link -->
                <a href="${pageContext.request.contextPath}/profile" 
                   id="profile" 
                   data-page="profile" 
                   class="nav-link-item">
                    <div class="nav-icon-wrapper">
                        <i class="fas fa-user nav-icon"></i>
                    </div>
                    <div class="nav-text-wrapper">
                        <span class="nav-title">Profile</span>
                        <p class="nav-description mb-0">Manage your account</p>
                    </div>
                </a>

                <!-- Orders Link -->
                <a href="${pageContext.request.contextPath}/orders" 
                   id="order" 
                   data-page="order" 
                   class="nav-link-item">
                    <div class="nav-icon-wrapper">
                        <i class="fas fa-shopping-bag nav-icon"></i>
                    </div>
                    <div class="nav-text-wrapper">
                        <span class="nav-title">Orders</span>
                        <p class="nav-description mb-0">View your purchases</p>
                    </div>
                </a>


            </div>
        </nav>
    </div>
</div>
