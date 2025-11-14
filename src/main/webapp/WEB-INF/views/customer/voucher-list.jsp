<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Vouchers - NeoShoes</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>
        <style>
            :root {
                --primary-color: #ff6b6b;
                --secondary-color: #000000;
                --success-color: #1dd1a1;
                --warning-color: #feca57;
                --dark-color: #2d3436;
                --light-color: #f7f7f7;
                --border-color: #e0e0e0;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #ffffff; /* nền trắng */
                min-height: 100vh;
                padding: 20px;
            }


            .voucher-container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .voucher-header {
                background: #000000;
                color: white;
                padding: 30px;
                text-align: center;
            }

            .voucher-header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 700;
            }

            .voucher-header p {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            .voucher-tabs {
                display: flex;
                background: var(--light-color);
                border-bottom: 1px solid var(--border-color);
            }

            .tab-btn {
                flex: 1;
                padding: 20px;
                background: none;
                border: none;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
            }

            .tab-btn.active {
                color: var(--primary-color);
            }

            .tab-btn.active::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: var(--primary-color);
            }

            .tab-btn .badge {
                background: var(--primary-color);
                color: white;
                border-radius: 20px;
                padding: 2px 8px;
                font-size: 0.8rem;
                margin-left: 5px;
            }

            .tab-content {
                display: none;
                padding: 30px;
                min-height: 400px;
            }

            .tab-content.active {
                display: block;
            }

            .voucher-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 25px;
                margin-top: 20px;
            }

            .voucher-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid var(--border-color);
                position: relative;
            }

            .voucher-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            }

            .voucher-card.used {
                opacity: 0.7;
                filter: grayscale(0.5);
            }

            .voucher-card.used::before {
                content: 'ĐÃ SỬ DỤNG';
                position: absolute;
                top: 20px;
                right: -30px;
                background: var(--dark-color);
                color: white;
                padding: 5px 30px;
                transform: rotate(45deg);
                font-size: 0.8rem;
                font-weight: bold;
                z-index: 2;
            }

            .voucher-card.expired::before {
                content: 'HẾT HẠN';
                position: absolute;
                top: 20px;
                right: -30px;
                background: #e74c3c;
                color: white;
                padding: 5px 30px;
                transform: rotate(45deg);
                font-size: 0.8rem;
                font-weight: bold;
                z-index: 2;
            }

            .voucher-ribbon {
                background: #000000;
                color: white;
                padding: 15px 20px;
                position: relative;
            }

            .voucher-ribbon::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 0;
                right: 0;
                height: 10px;
                background: repeating-linear-gradient(
                    45deg,
                    transparent,
                    transparent 5px,
                    rgba(255,255,255,0.3) 5px,
                    rgba(255,255,255,0.3) 10px
                    );
            }

            .voucher-code {
                font-size: 1.3rem;
                font-weight: 700;
                letter-spacing: 2px;
                margin-bottom: 5px;
            }

            .voucher-value {
                font-size: 2rem;
                font-weight: 800;
                margin: 15px 0;
                text-align: center;
            }

            .voucher-value.percentage {
                color: var(--primary-color);
            }

            .voucher-value.fixed {
                color: var(--success-color);
            }

            .voucher-body {
                padding: 25px;
            }

            .voucher-description {
                font-size: 1.1rem;
                color: var(--dark-color);
                margin-bottom: 15px;
                line-height: 1.5;
            }

            .voucher-details {
                background: var(--light-color);
                padding: 15px;
                border-radius: 10px;
                margin: 15px 0;
            }

            .voucher-detail {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                font-size: 0.9rem;
            }

            .voucher-detail:last-child {
                margin-bottom: 0;
            }

            .voucher-detail .label {
                color: #666;
                font-weight: 500;
            }

            .voucher-detail .value {
                color: var(--dark-color);
                font-weight: 600;
            }

            .voucher-actions {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }

            .btn {
                flex: 1;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                text-decoration: none;
                display: inline-block;
            }

            .btn-primary {
                background: #000000;
                color: white;
            }

            .btn-primary:hover {
                background: #ff5252;
                transform: translateY(-2px);
            }

            .btn-secondary{
                background: var(--secondary-color);
                color:#fff;
            }

            .btn-secondary{
                background: var(--secondary-color);
                color:#fff;
            }

            .btn-outline {
                background: transparent;
                border: 2px solid var(--border-color);
                color: var(--dark-color);
            }

            .btn-outline:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .empty-state i {
                font-size: 4rem;
                color: #ddd;
                margin-bottom: 20px;
            }

            .empty-state h3 {
                font-size: 1.5rem;
                margin-bottom: 10px;
                color: #888;
            }

            .voucher-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 3px 15px rgba(0,0,0,0.1);
                text-align: center;
            }

            .stat-card .number {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 5px;
            }

            .stat-card.available .number {
                color: var(--success-color);
            }

            .stat-card.used .number {
                color: var(--primary-color);
            }

            .stat-card.total .number {
                color: var(--secondary-color);
            }

            .stat-card .label {
                color: #666;
                font-size: 0.9rem;
            }

            @media (max-width: 768px) {
                .voucher-grid {
                    grid-template-columns: 1fr;
                }

                .voucher-tabs {
                    flex-direction: column;
                }

                .voucher-header h1 {
                    font-size: 2rem;
                }

                .voucher-stats {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body class="bg-light">
        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />

        <div class="orders-container">
            <div class="container">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-lg-3">
                        <jsp:include page="common/customer-sidebar.jsp"/>
                    </div>
                    <!-- Main Content -->
                    <div class="col-lg-9">
                        <div id="main-content" class="main-content-wrapper mt-2 mb-5">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h3 class="mb-3">My Voucher Wallet</h3>
                                    <p>Explore special offers and discounts made just for you</p>
                                </div>

                                <!-- Stats -->
                                <div class="voucher-stats">
                                    <div class="stat-card available">
                                        <div class="number">${fn:length(availableVouchers)}</div>
                                        <div class="label">Available Vouchers</div>
                                    </div>
                                    <div class="stat-card used">
                                        <div class="number">${fn:length(usedVouchers)}</div>
                                        <div class="label">Used Vouchers</div>
                                    </div>
                                    <div class="stat-card total">
                                        <div class="number">${fn:length(availableVouchers) + fn:length(usedVouchers)}</div>
                                        <div class="label">Total Vouchers</div>
                                    </div>
                                </div>

                                <!-- Tabs -->
                                <div class="voucher-tabs">
                                    <button class="tab-btn active" onclick="switchTab('available')">
                                        <i class="fas fa-gift"></i> Available
                                        <span class="badge">${fn:length(availableVouchers)}</span>
                                    </button>
                                    <button class="tab-btn" onclick="switchTab('used')">
                                        <i class="fas fa-history"></i> Used
                                        <span class="badge">${fn:length(usedVouchers)}</span>
                                    </button>
                                    <button class="tab-btn" onclick="switchTab('all')">
                                        <i class="fas fa-list"></i> All
                                        <span class="badge">${fn:length(availableVouchers) + fn:length(usedVouchers)}</span>
                                    </button>
                                </div>

                                <!-- Available Vouchers Tab -->
                                <div id="available-tab" class="tab-content active">
                                    <!-- ... phần empty state giữ nguyên ... -->

                                    <div class="voucher-grid">
                                        <c:forEach var="voucher" items="${availableVouchers}">
                                            <!-- ✅ THAY THẾ TOÀN BỘ VOUCHER-CARD NÀY -->
                                            <div class="voucher-card">
                                                <div class="voucher-ribbon">
                                                    <div class="voucher-code">${voucher.voucherCode}</div>
                                                    <div>SPECIAL OFFER</div>
                                                </div>
                                                <div class="voucher-body">
                                                    <div class="voucher-value ${voucher.type == 'PERCENTAGE' ? 'percentage' : 'fixed'}">
                                                        <c:choose>
                                                            <c:when test="${voucher.type == 'PERCENTAGE'}">
                                                                ${voucher.value}% OFF
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>₫
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="voucher-description">
                                                        ${voucher.voucherDescription}
                                                    </div>

                                                    <!-- ✅ RÚT GỌN CHỈ HIỂN THỊ THÔNG TIN CƠ BẢN -->
                                                    <div class="voucher-details">
                                                        <div class="voucher-detail">
                                                            <span class="label"><i class="far fa-calendar"></i> Expires:</span>
                                                            <span class="value"><fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                                        </div>
                                                        <c:if test="${voucher.minValue != null}">
                                                            <div class="voucher-detail">
                                                                <span class="label"><i class="fas fa-shopping-cart"></i> Min order:</span>
                                                                <span class="value"><fmt:formatNumber value="${voucher.minValue}" pattern="#,##0"/>₫</span>
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                    <!-- ✅ SỬA ACTIONS: THÊM BUTTON VIEW DETAILS -->
                                                    <div class="voucher-actions">
                                                        <a href="${pageContext.request.contextPath}/voucher?action=details&code=${voucher.voucherCode}" 
                                                           class="btn btn-primary" style="text-decoration: none;">
                                                            <i class="fas fa-eye"></i> View Details
                                                        </a>
                                                        <button class="btn btn-outline" onclick="copyVoucherCode('${voucher.voucherCode}')">
                                                            <i class="fas fa-copy"></i> Copy
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Used Vouchers Tab -->
                                <div id="used-tab" class="tab-content">
                                    <!-- ... empty state giữ nguyên ... -->

                                    <div class="voucher-grid">
                                        <c:forEach var="voucher" items="${usedVouchers}">
                                            <!-- ✅ SỬA TƯƠNG TỰ CHO USED VOUCHERS -->
                                            <div class="voucher-card used">
                                                <div class="voucher-ribbon">
                                                    <div class="voucher-code">${voucher.voucherCode}</div>
                                                    <div>USED</div>
                                                </div>
                                                <div class="voucher-body">
                                                    <div class="voucher-value ${voucher.type == 'PERCENTAGE' ? 'percentage' : 'fixed'}">
                                                        <c:choose>
                                                            <c:when test="${voucher.type == 'PERCENTAGE'}">
                                                                ${voucher.value}% OFF
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>₫
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="voucher-description">${voucher.voucherDescription}</div>

                                                    <div class="voucher-details">
                                                        <div class="voucher-detail">
                                                            <span class="label"><i class="far fa-calendar"></i> Expired:</span>
                                                            <span class="value"><fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                                        </div>
                                                        <div class="voucher-detail">
                                                            <span class="label"><i class="fas fa-redo"></i> Used:</span>
                                                            <span class="value">${voucher.usageCount} times</span>
                                                        </div>
                                                    </div>

                                                    <div class="voucher-actions">
                                                        <a href="${pageContext.request.contextPath}/voucher?action=details&code=${voucher.voucherCode}" 
                                                           class="btn btn-secondary" style="text-decoration: none;">
                                                            <i class="fas fa-history"></i> View History
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- All Vouchers Tab -->
                                <div id="all-tab" class="tab-content">
                                    <c:if test="${empty availableVouchers && empty usedVouchers}">
                                        <div class="empty-state">
                                            <i class="fas fa-tags"></i>
                                            <h3>No vouchers yet</h3>
                                            <p>Join promotions to earn vouchers!</p>
                                        </div>
                                    </c:if>

                                    <div class="voucher-grid">
                                        <c:forEach var="voucher" items="${availableVouchers}">
                                            <div class="voucher-card">
                                                <!-- Same as available tab -->
                                                <div class="voucher-ribbon">
                                                    <div class="voucher-code">${voucher.voucherCode}</div>
                                                    <div>SPECIAL OFFER</div>
                                                </div>
                                                <div class="voucher-body">
                                                    <div class="voucher-value ${voucher.type == 'PERCENTAGE' ? 'percentage' : 'fixed'}">
                                                        <c:choose>
                                                            <c:when test="${voucher.type == 'PERCENTAGE'}">
                                                                ${voucher.value}% OFF
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>₫
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="voucher-description">${voucher.voucherDescription}</div>
                                                    <div class="voucher-details">
                                                        <div class="voucher-detail">
                                                            <span class="label"><i class="far fa-calendar"></i> Expiration:</span>
                                                            <span class="value"><fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd/MM/yyyy"/></span>
                                                        </div>
                                                        <c:if test="${voucher.minValue != null}">
                                                            <div class="voucher-detail">
                                                                <span class="label"><i class="fas fa-shopping-cart"></i> Minimum order:</span>
                                                                <span class="value"><fmt:formatNumber value="${voucher.minValue}" pattern="#,##0"/>₫</span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="voucher-actions">
                                                        <button class="btn btn-primary" onclick="applyVoucher('${voucher.voucherCode}')">
                                                            <i class="fas fa-check"></i> Use Now
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <c:forEach var="voucher" items="${usedVouchers}">
                                            <div class="voucher-card used">
                                                <!-- Same as used tab -->
                                                <div class="voucher-ribbon" style="background: linear-gradient(135deg, #95a5a6, #7f8c8d);">
                                                    <div class="voucher-code">${voucher.voucherCode}</div>
                                                    <div>USED</div>
                                                </div>
                                                <div class="voucher-body">
                                                    <div class="voucher-value" style="color: #95a5a6;">
                                                        <c:choose>
                                                            <c:when test="${voucher.type == 'PERCENTAGE'}">
                                                                ${voucher.value}% OFF
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>₫
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="voucher-description" style="color: #95a5a6;">${voucher.voucherDescription}</div>
                                                    <div class="voucher-actions">
                                                        <button class="btn btn-outline" disabled style="cursor: not-allowed;">
                                                            <i class="fas fa-check"></i> Used
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

        <script>
                                                            function switchTab(tabName) {
                                                                // Hide all tabs
                                                                document.querySelectorAll('.tab-content').forEach(tab => {
                                                                    tab.classList.remove('active');
                                                                });

                                                                // Remove active class from all buttons
                                                                document.querySelectorAll('.tab-btn').forEach(btn => {
                                                                    btn.classList.remove('active');
                                                                });

                                                                // Show selected tab
                                                                document.getElementById(tabName + '-tab').classList.add('active');

                                                                // Activate selected button
                                                                event.target.classList.add('active');
                                                            }

                                                            function applyVoucher(voucherCode) {
                                                                if (confirm('Bạn muốn sử dụng voucher "' + voucherCode + '" cho đơn hàng tiếp theo?')) {
                                                                    // Redirect to shopping page or apply voucher
                                                                    window.location.href = '${pageContext.request.contextPath}/products?applyVoucher=' + voucherCode;
                                                                }
                                                            }

                                                            function copyVoucherCode(voucherCode) {
                                                                navigator.clipboard.writeText(voucherCode).then(function () {
                                                                    alert('Đã sao chép mã voucher: ' + voucherCode);
                                                                }, function (err) {
                                                                    console.error('Could not copy text: ', err);
                                                                });
                                                            }

                                                            // Add some interactive effects
                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                const cards = document.querySelectorAll('.voucher-card');
                                                                cards.forEach((card, index) => {
                                                                    card.style.animationDelay = (index * 0.1) + 's';
                                                                    card.style.animation = 'fadeInUp 0.6s ease forwards';
                                                                });
                                                            });
        </script>

        <style>
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .voucher-card {
                opacity: 0;
            }
        </style>
    </body>
</html>