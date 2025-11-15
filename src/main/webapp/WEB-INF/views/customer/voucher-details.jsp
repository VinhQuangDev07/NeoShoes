<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="en_US" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Voucher Details - ${voucher.voucherCode}</title>
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
                background: #ffffff;
                min-height: 100vh;
                padding: 20px;
            }
            .voucher-container {
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
            .breadcrumb-nav {
                background: var(--light-color);
                padding: 15px 30px;
                border-bottom: 1px solid var(--border-color);
            }
            .breadcrumb-nav a {
                color: var(--dark-color);
                text-decoration: none;
                transition: color 0.3s ease;
            }
            .breadcrumb-nav a:hover {
                color: var(--primary-color);
            }
            .breadcrumb-nav .separator {
                margin: 0 10px;
                color: #999;
            }
            .breadcrumb-nav .current {
                color: var(--primary-color);
                font-weight: 600;
            }
            .voucher-details-content {
                padding: 40px;
            }
            .voucher-hero {
                background: linear-gradient(135deg, #000000 0%, #434343 100%);
                color: white;
                padding: 60px 40px;
                border-radius: 20px;
                text-align: center;
                margin-bottom: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                position: relative;
                overflow: hidden;
            }
            .voucher-hero::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
                animation: pulse 15s infinite;
            }
            @keyframes pulse {
                0%,100%{
                    transform:scale(1) rotate(0deg);
                }
                50%{
                    transform:scale(1.1) rotate(5deg);
                }
            }
            .voucher-code-display {
                font-size: 3.5rem;
                font-weight: 800;
                letter-spacing: 8px;
                margin: 20px 0;
                text-shadow: 3px 3px 6px rgba(0,0,0,0.3);
                position: relative;
                z-index: 1;
            }
            .voucher-value-display {
                font-size: 5rem;
                font-weight: 900;
                margin: 30px 0;
                position: relative;
                z-index: 1;
            }
            .voucher-description-hero {
                font-size: 1.3rem;
                opacity: 0.95;
                max-width: 600px;
                margin: 0 auto;
                position: relative;
                z-index: 1;
            }
            .status-badge {
                display: inline-block;
                padding: 12px 30px;
                border-radius: 25px;
                font-weight: 700;
                font-size: 1rem;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .status-active {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                color: white;
            }
            .status-expired {
                background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
                color: white;
            }
            .status-used {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
            }
            .details-card {
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 5px 25px rgba(0,0,0,0.08);
                margin-bottom: 25px;
                border: 1px solid var(--border-color);
            }
            .details-card h3 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 30px;
                color: #2c3e50;
                border-bottom: 3px solid #000;
                padding-bottom: 15px;
            }
            .detail-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:20px 0;
                border-bottom:1px solid #f0f0f0;
                transition: background 0.3s ease;
            }
            .detail-row:hover {
                background: #f9f9f9;
                padding-left:10px;
                padding-right:10px;
                border-radius:8px;
            }
            .detail-row:last-child{
                border-bottom:none;
            }
            .detail-label{
                font-weight:600;
                color:#7f8c8d;
                font-size:1.05rem;
            }
            .detail-label i{
                margin-right:10px;
                color:#000;
            }
            .detail-value{
                font-weight:700;
                color:#2c3e50;
                font-size:1.1rem;
            }
            .terms-list{
                list-style:none;
                padding:0;
            }
            .terms-list li{
                padding:12px 0;
                padding-left:35px;
                position:relative;
                font-size:1rem;
                color:#555;
                line-height:1.6;
            }
            .terms-list li::before{
                content:'\f00c';
                font-family:'Font Awesome 6 Free';
                font-weight:900;
                position:absolute;
                left:0;
                color:#27ae60;
                font-size:1.1rem;
            }
            .action-buttons{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
                gap:20px;
                margin-top:40px;
            }
            .btn-action{
                padding:18px 35px;
                border-radius:12px;
                font-weight:700;
                font-size:1.05rem;
                border:none;
                cursor:pointer;
                transition:all 0.3s ease;
                text-decoration:none;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:10px;
                box-shadow:0 4px 15px rgba(0,0,0,0.1);
            }
            .btn-primary-action{
                background:linear-gradient(135deg,#000000 0%,#434343 100%);
                color:white;
            }
            .btn-secondary-action{
                background:#ecf0f1;
                color:#2c3e50;
            }
            .progress-bar-usage{
                width:100%;
                height:12px;
                background:#ecf0f1;
                border-radius:10px;
                overflow:hidden;
                margin-top:8px;
            }
            .progress-bar-fill{
                height:100%;
                background:linear-gradient(90deg,#000000 0%,#434343 100%);
                transition:width 0.5s ease;
            }
            @media (max-width:768px){
                body{
                    padding:10px;
                }
                .voucher-header h1{
                    font-size:1.8rem;
                }
                .voucher-code-display{
                    font-size:2rem;
                    letter-spacing:3px;
                }
                .voucher-value-display{
                    font-size:3rem;
                }
                .voucher-details-content{
                    padding:20px;
                }
                .action-buttons{
                    grid-template-columns:1fr;
                }
                .details-card{
                    padding:25px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />

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
                                <h3 class="mb-3">Voucher Details</h3>
                                <p>View complete information about your voucher</p>
                            </div>

                            <div class="voucher-container p-4">

                                <!-- Main Voucher Content -->
                                <div class="voucher-details-content">
                                    <!-- Hero Section -->
                                    <div class="voucher-hero">
                                        <div class="voucher-code-display">${voucher.voucherCode}</div>
                                        <div class="voucher-value-display">
                                            <c:choose>
                                                <c:when test="${voucher.type == 'PERCENTAGE'}">
                                                    ${voucher.value}% OFF
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${voucher.value}" pattern="#,##0"/>$ OFF
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p class="voucher-description-hero">${voucher.voucherDescription}</p>
                                    </div>

                                    <!-- Status Badge -->
                                    <div class="text-center mb-3">
                                        <c:choose>
                                            <c:when test="${voucher.expired}">
                                                <span class="status-badge status-expired"><i class="fas fa-times-circle"></i> EXPIRED</span>
                                            </c:when>
                                            <c:when test="${not isUsable}">
                                                <span class="status-badge status-used"><i class="fas fa-check-circle"></i> FULLY USED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-active"><i class="fas fa-check-circle"></i> ACTIVE & READY TO USE</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Details Card -->
                                    <div class="details-card">
                                        <h3><i class="fas fa-info-circle"></i> Voucher Information</h3>

                                        <div class="detail-row">
                                            <span class="detail-label"><i class="far fa-calendar-alt"></i> Valid From</span>
                                            <span class="detail-value"><fmt:formatDate value="${voucher.startDateAsDate}" pattern="dd MMMM yyyy"/></span>
                                        </div>

                                        <div class="detail-row">
                                            <span class="detail-label"><i class="far fa-calendar-times"></i> Valid Until</span>
                                            <span class="detail-value"><fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd MMMM yyyy"/></span>
                                        </div>

                                        <c:if test="${voucher.minValue != null}">
                                            <div class="detail-row">
                                                <span class="detail-label"><i class="fas fa-shopping-cart"></i> Minimum Order Value</span>
                                                <span class="detail-value"><fmt:formatNumber value="${voucher.minValue}" pattern="#,##0"/>$</span>
                                            </div>
                                        </c:if>

                                        <c:if test="${voucher.maxValue != null && voucher.type == 'PERCENTAGE'}">
                                            <div class="detail-row">
                                                <span class="detail-label"><i class="fas fa-chart-line"></i> Maximum Discount</span>
                                                <span class="detail-value"><fmt:formatNumber value="${voucher.maxValue}" pattern="#,##0"/>$</span>
                                            </div>
                                        </c:if>

                                        <c:if test="${voucher.userUsageLimit != null}">
                                            <div class="detail-row">
                                                <span class="detail-label"><i class="fas fa-redo"></i> Usage Limit</span>
                                                <span class="detail-value">
                                                    ${voucher.usageCount} / ${voucher.userUsageLimit} times used
                                                    <div class="progress-bar-usage"><div class="progress-bar-fill" style="width:${(voucher.usageCount * 100.0 / voucher.userUsageLimit)}%"></div></div>
                                                </span>
                                            </div>
                                        </c:if>

                                        <div class="detail-row">
                                            <span class="detail-label"><i class="fas fa-tag"></i> Discount Type</span>
                                            <span class="detail-value">
                                                <c:choose>
                                                    <c:when test="${voucher.type == 'PERCENTAGE'}">Percentage Discount</c:when>
                                                    <c:otherwise>Fixed Amount Discount</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Terms & Conditions -->
                                    <div class="details-card">
                                        <h3><i class="fas fa-file-contract"></i> Terms & Conditions</h3>
                                        <ul class="terms-list">
                                            <li>This voucher is valid for online purchases only</li>
                                            <li>Cannot be combined with other promotional vouchers</li>
                                            <li>Non-transferable and non-refundable</li>
                                            <li>NeoShoes reserves the right to cancel this voucher at any time</li>
                                            <c:if test="${voucher.minValue != null}"><li>Minimum order value required: <strong><fmt:formatNumber value="${voucher.minValue}" pattern="#,##0"/>$</strong></li></c:if>
                                            <c:if test="${voucher.maxValue != null && voucher.type == 'PERCENTAGE'}"><li>Maximum discount capped at: <strong><fmt:formatNumber value="${voucher.maxValue}" pattern="#,##0"/>$</strong></li></c:if>
                                            <li>Valid until: <strong><fmt:formatDate value="${voucher.endDateAsDate}" pattern="dd/MM/yyyy"/></strong></li>
                                        </ul>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="action-buttons">
                                        <c:if test="${isUsable}">
                                            <button class="btn-action btn-primary-action" onclick="useVoucher('${voucher.voucherCode}')">
                                                <i class="fas fa-check-circle"></i> Use This Voucher
                                            </button>
                                        </c:if>

                                        <button class="btn-action btn-secondary-action" onclick="copyCode('${voucher.voucherCode}')">
                                            <i class="fas fa-copy"></i> Copy Voucher Code
                                        </button>

                                        <a href="${pageContext.request.contextPath}/voucher" class="btn-action btn-secondary-action">
                                            <i class="fas fa-arrow-left"></i> Back to Vouchers
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div> <!-- end card -->
                    </div> <!-- end main-content -->
                </div>
            </div>
        </div>

        <jsp:include page="common/footer.jsp"/>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script>
                                            function useVoucher(code) {
                                                if (confirm('Apply voucher "' + code + '" to your cart now?')) {
                                                    window.location.href = '${pageContext.request.contextPath}/cart?applyVoucher=' + code;
                                                }
                                            }

                                            function copyCode(code) {
                                                navigator.clipboard.writeText(code).then(() => {
                                                    alert('Voucher code copied: ' + code);
                                                }).catch(() => {
                                                    const input = document.createElement('input');
                                                    input.value = code;
                                                    document.body.appendChild(input);
                                                    input.select();
                                                    document.execCommand('copy');
                                                    document.body.removeChild(input);
                                                    alert('Voucher code copied: ' + code);
                                                });
                                            }
        </script>
    </body>
</html>