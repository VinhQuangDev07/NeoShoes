<%-- 
    Document   : header
    Created on : Oct 15, 2025, 9:14:17 PM
    Author     : Le Huu Nghia - CE181052
--%>

<!-- Header Bootstrap -->
<header class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow-sm" 
        style="backdrop-filter: blur(10px); background-color: rgba(15, 23, 42, 0.9) !important;">
    <div class="container-fluid px-3 px-lg-4">
        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <div style="height: 55px;">
                <img src="https://res.cloudinary.com/drqip0exk/image/upload/v1759560158/Logo_NeoShoes-removebg-preview_d0efnb.png" 
                     alt="Neo Shoes Logo" 
                     class="h-100" 
                     style="object-fit: cover;">
            </div>
        </a>

        <!--         Search Bar (Desktop) 
                <div class="flex-grow-1 px-3 d-none d-md-block" style="max-width: 600px;">
                    <form action="/search-products" method="get" autocomplete="off" class="position-relative">
                        <input type="text" 
                               name="keyword" 
                               placeholder="Search shoes..." 
                               class="form-control-header rounded-pill pe-5" 
                               value="${param.keyword != null ? param.keyword : ''}"
                               autocomplete="off"
                               style="background-color: #1e293b; color: white; border: 1px solid #475569;">
                        <button type="submit" 
                                class="btn position-absolute top-50 end-0 translate-middle-y border-0 text-warning"
                                style="padding-right: 1rem;">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>-->
        <!-- Search (Desktop) -->
        <!-- <div class="flex-grow-1 px-md-3 d-none d-md-block" style="max-width: 640px;">
            <form action="${pageContext.request.contextPath}/home" method="get" autocomplete="off" class="position-relative">
                <input type="hidden" name="action" value="search">
                <input type="text"
                       name="searchTerm"
                       placeholder="Search products..."
                       value="${param.searchTerm}"
                       class="form-control-header rounded-pill pe-5"
                       autocomplete="off"
                       style="background-color:#1e293b; color:#fff; border:1px solid #475569; width: 540px;">
                <button type="submit"
                        class="btn position-absolute top-50 end-0 translate-middle-y border-0 text-warning"
                        style="padding-right:1rem">
                    <i class="fas fa-search"></i>
                </button>
            </form>
        </div> -->

        <%
    
            String currentURI = request.getRequestURI();
            String searchAction;
            boolean isProductsPage = currentURI.contains("products") || currentURI.contains("product-list");
    
            if (isProductsPage) {
                searchAction = request.getContextPath() + "/products";
            } else {
                searchAction = request.getContextPath() + "/home";
            }
        %>

        <form action="<%= searchAction %>" method="get" autocomplete="off" class="position-relative">

            <c:if test="<%= isProductsPage %>">
                <input type="hidden" name="action" value="search">
            </c:if>

            <input type="text"
                   name="searchTerm"
                   placeholder="<%= isProductsPage ? "Search in products..." : "Search products..." %>"
                   value="${param.searchTerm}"
                   class="form-control-header rounded-pill pe-5"
                   autocomplete="off"
                   style="background-color:#1e293b; color:#fff; border:1px solid #475569; width: 540px;">

            <button type="submit"
                    class="btn position-absolute top-50 end-0 translate-middle-y border-0 text-warning"
                    style="padding-right:1rem">
                <i class="fas fa-search"></i>
            </button>
        </form>

        <!-- User Menu & Actions -->
        <div class="d-flex align-items-center gap-3 ms-auto">
            <!--            <c:choose>
                            <c:when test="${not empty sessionScope.customer}">-->
            <!-- Cart Icon -->
            <a href="${pageContext.request.contextPath}/cart" 
               class="btn btn-link text-warning position-relative p-2 text-decoration-none">
                <i class="fas fa-shopping-cart fs-5"></i>
                <span id="cartTotal" 
                      class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                      style="font-size: 0.625rem;">
                    ${sessionScope.cartQuantity != null ? sessionScope.cartQuantity : 0}
                </span>
            </a>

            <!-- User Dropdown -->
            <div class="dropdown">
                <button class="btn btn-link text-white text-decoration-none dropdown-toggle d-flex align-items-center gap-2" 
                        type="button" 
                        id="userDropdown" 
                        data-bs-toggle="dropdown" 
                        aria-expanded="false">
                    <i class="fas fa-user-circle text-warning fs-5"></i>
                    <span id="customerName" class="d-none d-lg-inline">${sessionScope.customer.name}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" 
                    aria-labelledby="userDropdown"
                    style="background-color: #1e293b; border: 1px solid #475569;">
                    <li>
                        <a class="dropdown-item text-white-50" 
                           href="${pageContext.request.contextPath}/profile?id=1"
                           style="transition: all 0.3s;">
                            <i class="fas fa-user me-2"></i>Profile
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item text-white-50" 
                           href="${pageContext.request.contextPath}/order?id=1"
                           style="transition: all 0.3s;">
                            <i class="fas fa-history me-2"></i>Orders
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/auth?action=logout" 
               class="btn btn-sm rounded-pill text-white fw-semibold"
               style="background: linear-gradient(to right, #ef4444, #f97316); box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: transform 0.2s;">
                Logout
            </a>
            <!--                </c:when>
                            <c:otherwise>
                                 Login Link 
                                <a href="${pageContext.request.contextPath}/auth?action=login" 
                                   class="btn btn-link text-white-50 text-decoration-none small">
                                    Login
                                </a>
            
                                 Register Button 
                                <a href="${pageContext.request.contextPath}/auth?action=register" 
                                   class="btn btn-sm rounded-pill text-white fw-semibold"
                                   style="background: linear-gradient(to right, #fbbf24, #f97316); box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: transform 0.2s;">
                                    Register
                                </a>
                            </c:otherwise>
                        </c:choose>-->
        </div>
    </div>
</header>

<!-- Add padding to body to prevent content from hiding under fixed header -->
<style>
    body {
        padding-top: 80px;
    }

    .dropdown-item:hover {
        background-color: #334155 !important;
        color: white !important;
    }

    .btn:hover {
        transform: scale(1.05);
    }

    .form-control-header:focus {
        background-color: #1e293b;
        color: white;
        border-color: #fbbf24;
        box-shadow: 0 0 0 0.2rem rgba(251, 191, 36, 0.25);
    }

    .form-control-header::placeholder {
        color: #bfdbfe;
    }
</style>

<!--<script src="/js/search.js"></script>-->
