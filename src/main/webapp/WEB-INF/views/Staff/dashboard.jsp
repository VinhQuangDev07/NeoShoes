<%-- 
    Document   : dashboard
    Created on : Oct 28, 2025, 7:33:26 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Admin Panel</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background-color: #f8f9fa;
                padding-top: 74px;
            }

            .main-content {
                margin-left: 300px;
                padding: 2rem;
                transition: margin-left 0.3s ease;
            }

            @media (max-width: 991.98px) {
                .main-content {
                    margin-left: 0;
                }
            }

            .page-header {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            
            .stat-card {
                border-radius: 1rem;
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-2px);
            }
            .stat-icon {
                width: 56px;
                height: 56px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .chart-card {
                border-radius: 1rem;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .chart-tab-btn {
                font-weight: 600;
                border-radius: 0.5rem;
                padding: 0.5rem 1.25rem;
                transition: all 0.2s;
            }
            .chart-tab-btn:hover {
                transform: scale(1.02);
            }
            .chart-tab-btn.active {
                background-color: #6366f1 !important;
                color: white !important;
                box-shadow: 0 4px 6px rgba(99, 102, 241, 0.25);
            }
            .filter-card {
                background-color: #f8f9fa;
                border-radius: 0.75rem;
                padding: 1rem;
            }
            .product-img {
                width: 48px;
                height: 48px;
                object-fit: cover;
                border-radius: 0.375rem;
            }
            .badge-sold {
                background-color: #d1fae5;
                color: #065f46;
                padding: 0.25rem 0.5rem;
                border-radius: 0.375rem;
                font-weight: 600;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="common/staff-header.jsp"/>

        <!-- Sidebar -->
        <jsp:include page="common/staff-sidebar.jsp"/>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Dashboard</h2>
                        <p class="text-muted mb-0">Statistics revenue by day/month/year and best seller</p>
                    </div>
                </div>
            </div>
            <!-- Embed Data as JSON -->
            <script type="application/json" id="revenueDailyScript">
                <c:choose>
                    <c:when test="${not empty revenueDaily}">
                        ${revenueDaily}
                    </c:when>
                    <c:otherwise>[]</c:otherwise>
                </c:choose>
            </script>
            <script type="application/json" id="revenueMonthlyScript">
                <c:choose>
                    <c:when test="${not empty revenueMonthly}">
                        ${revenueMonthly}
                    </c:when>
                    <c:otherwise>[]</c:otherwise>
                </c:choose>
            </script>
            <script type="application/json" id="revenueYearlyScript">
                <c:choose>
                    <c:when test="${not empty revenueYearly}">
                        ${revenueYearly}
                    </c:when>
                    <c:otherwise>[]</c:otherwise>
                </c:choose>
            </script>
            <script type="application/json" id="orderStatusDataScript">
                <c:choose>
                    <c:when test="${not empty orderStatus}">
                        ${orderStatus}
                    </c:when>
                    <c:otherwise>{}</c:otherwise>
                </c:choose>
            </script>
            <input type="hidden" id="filterTypeValue" value="${filterType}" />

            <div class="container-fluid py-4">
                <!-- Error Message -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error!</strong> ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Overview Cards -->
                <div class="row g-4 mb-4">
                    <!-- Total Revenue -->
                    <div class="col-12 col-md-6 col-xl-3">
                        <div class="card stat-card border-0 shadow-sm">
                            <div class="card-body d-flex align-items-center">
                                <div class="stat-icon bg-success bg-opacity-10 me-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#198754" stroke-width="2">
                                    <rect x="2" y="6" width="20" height="12" rx="2"/>
                                    <circle cx="12" cy="12" r="3"/>
                                    </svg>
                                </div>
                                <div>
                                    <div class="text-muted small">Total Revenue</div>
                                    <div class="fs-4 fw-bold text-dark" title="${dashboardData.totalRevenue}">
                                        ${dashboardData.totalRevenue}$
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Total Orders -->
                    <div class="col-12 col-md-6 col-xl-3">
                        <div class="card stat-card border-0 shadow-sm">
                            <div class="card-body d-flex align-items-center">
                                <div class="stat-icon bg-primary bg-opacity-10 me-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#0d6efd" stroke-width="2">
                                    <rect x="3" y="6" width="18" height="12" rx="2"/>
                                    <path d="M6 10h12M6 14h12"/>
                                    </svg>
                                </div>
                                <div>
                                    <div class="text-muted small">Total Orders</div>
                                    <div class="fs-4 fw-bold text-dark">${dashboardData.totalOrders}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Total Customers -->
                    <div class="col-12 col-md-6 col-xl-3">
                        <div class="card stat-card border-0 shadow-sm">
                            <div class="card-body d-flex align-items-center">
                                <div class="stat-icon bg-warning bg-opacity-10 me-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#ffc107" stroke-width="2">
                                    <circle cx="12" cy="10" r="4"/>
                                    <path d="M6 18c0-2.5 2-4 6-4s6 1.5 6 4"/>
                                    </svg>
                                </div>
                                <div>
                                    <div class="text-muted small">Total Customers</div>
                                    <div class="fs-4 fw-bold text-dark">${totalCustomers}</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Total Staff -->
                    <div class="col-12 col-md-6 col-xl-3">
                        <div class="card stat-card border-0 shadow-sm">
                            <div class="card-body d-flex align-items-center">
                                <div class="stat-icon bg-info bg-opacity-10 me-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#0dcaf0" stroke-width="2">
                                    <circle cx="12" cy="10" r="4"/>
                                    <path d="M6 18c0-2.5 2-4 6-4s6 1.5 6 4"/>
                                    </svg>
                                </div>
                                <div>
                                    <div class="text-muted small">Total Employee</div>
                                    <div class="fs-4 fw-bold text-dark">${totalStaff}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="row g-4 mb-4">
                    <!-- Revenue Chart -->
                    <div class="col-12 col-lg-8">
                        <div class="card chart-card border-0">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="card-title fw-bold mb-0">Revenue Chart</h5>
                                    <div class="btn-group" role="group">
                                        <button type="button" id="btn-daily" class="btn btn-sm chart-tab-btn active">
                                            Last 30 days
                                        </button>
                                        <button type="button" id="btn-monthly" class="btn btn-sm chart-tab-btn btn-outline-secondary">
                                            Monthly
                                        </button>
                                        <button type="button" id="btn-yearly" class="btn btn-sm chart-tab-btn btn-outline-secondary">
                                            Yearly
                                        </button>
                                    </div>
                                </div>

                                <!-- Filter Forms -->
                                <form id="filter-form-daily" class="filter-form filter-card mb-3" method="get" action="dashboard">
                                    <input type="hidden" name="filterType" value="daily">
                                    <div class="row g-2 align-items-end">
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">From date</label>
                                            <input type="date" name="startDate" value="${startDate}" class="form-control form-control-sm">
                                        </div>
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">To date</label>
                                            <input type="date" name="endDate" value="${endDate}" class="form-control form-control-sm">
                                        </div>
                                        <div class="col-auto">
                                            <button type="button" class="btn btn-primary btn-sm filter-submit-btn">
                                                Filter
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <form id="filter-form-monthly" class="filter-form filter-card mb-3 d-none" method="get" action="dashboard">
                                    <input type="hidden" name="filterType" value="monthly">
                                    <div class="row g-2 align-items-end">
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">From month</label>
                                            <input type="month" name="startMonth" value="${startMonth}" class="form-control form-control-sm">
                                        </div>
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">To month</label>
                                            <input type="month" name="endMonth" value="${endMonth}" class="form-control form-control-sm">
                                        </div>
                                        <div class="col-auto">
                                            <button type="button" class="btn btn-primary btn-sm filter-submit-btn">
                                                Filter
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <form id="filter-form-yearly" class="filter-form filter-card mb-3 d-none" method="get" action="dashboard">
                                    <input type="hidden" name="filterType" value="yearly">
                                    <div class="row g-2 align-items-end">
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">From year</label>
                                            <input type="number" name="startYear" min="2000" max="2100" value="${startYear}" class="form-control form-control-sm" style="width: 100px;">
                                        </div>
                                        <div class="col-auto">
                                            <label class="form-label small text-muted mb-1">To year</label>
                                            <input type="number" name="endYear" min="2000" max="2100" value="${endYear}" class="form-control form-control-sm" style="width: 100px;">
                                        </div>
                                        <div class="col-auto">
                                            <button type="button" class="btn btn-primary btn-sm filter-submit-btn">
                                                Filter
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <div style="height: 320px;">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pie Chart -->
                    <div class="col-12 col-lg-4">
                        <div class="card chart-card border-0">
                            <div class="card-body text-center">
                                <h5 class="card-title fw-bold mb-4">Order Status Distribution</h5>
                                <canvas id="statusPieChart" width="320" height="320"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top Products -->
                <div class="card chart-card border-0">
                    <div class="card-body">
                        <h5 class="card-title fw-bold mb-4">Top 10 Best-Selling Products</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Image</th>
                                        <th>Product</th>
                                        <th>Sold</th>
                                        <th>Revenue</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${dashboardData.topProducts}" var="product" varStatus="loop">
                                        <tr>
                                            <td class="fw-bold">${loop.index + 1}</td>
                                            <td>
                                                <img src="${not empty product.defaultImageUrl ? product.defaultImageUrl : 'https://nftcalendar.io/storage/uploads/2022/02/21/image-not-found_0221202211372462137974b6c1a.png'}"
                                                     alt="${product.name}" class="product-img shadow-sm" />
                                            </td>
                                            <td>
                                                <div class="fw-semibold">${product.name}</div>
                                                <small class="text-muted">ID: ${product.productId}</small>
                                            </td>
                                            <td>
                                                <span class="badge-sold">${product.totalSold} sold</span>
                                            </td>
                                            <td class="text-danger fw-bold">
                                                ${product.totalRevenue}$
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Dashboard Script -->
        <script>
// ====== Order Status Labels and Colors ======
const ORDER_STATUS_LABELS = ["Pending", "Processing", "Shipped", "Delivered"];
const ORDER_STATUS_COLORS = [
    "#0d6efd", // Pending (Bootstrap primary blue)
    "#a78bfa", // Processing (purple)
    "#ffc107", // Shipped (Bootstrap warning yellow)
    "#198754", // Delivered (Bootstrap success green)
];

// ================== DASHBOARD MAIN FUNCTION ==================
window.initDashboardTabs = function () {
    // ---- Chart Cleanup ----
    if (window.revenueChart && typeof window.revenueChart.destroy === 'function')
        window.revenueChart.destroy();
    if (window.statusPieChart && typeof window.statusPieChart.destroy === 'function')
        window.statusPieChart.destroy();

    // ---- Format Date ----
    function formatDate(dateString) {
        if (!dateString)
            return '';
        if (dateString.includes('/'))
            return dateString;
        const parts = dateString.split('-');
        if (parts.length === 3)
            return parts[2] + '/' + parts[1]; // dd/MM
        if (parts.length === 2)
            return parts[1] + '/' + parts[0]; // MM/yyyy
        return dateString;
    }

    // ---- Draw Revenue Chart ----
    function initRevenueChart(data, label) {
        const canvas = document.getElementById('revenueChart');
        if (!canvas)
            return;
        const noDataMsg = canvas.parentElement.querySelector('.no-data-msg');
        if (noDataMsg)
            noDataMsg.remove();
        if (!data || data.length === 0) {
            const noData = document.createElement('p');
            noData.innerHTML = 'No revenue data available';
            noData.className = 'no-data-msg text-center text-muted py-5';
            canvas.parentElement.appendChild(noData);
            canvas.style.display = 'none';
            return;
        }
        canvas.style.display = '';
        const ctx = canvas.getContext('2d');
        if (window.revenueChart && typeof window.revenueChart.destroy === 'function')
            window.revenueChart.destroy();
        const labels = data.map(d => formatDate(d.period));
        const revenues = data.map(d => typeof d.revenue === "number" ? d.revenue : parseFloat(d.revenue) || 0);
        window.revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels,
                datasets: [{
                        label: label || 'Revenue',
                        data: revenues,
                        borderColor: '#6366f1',
                        backgroundColor: 'rgba(99, 102, 241, 0.10)',
                        borderWidth: 3,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        fill: true,
                        tension: 0.35
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    maximumFractionDigits: 0
                                }).format(ctx.parsed.y)
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    maximumFractionDigits: 0
                                }).format(value)
                        }
                    }
                }
            }
        });
    }

    // ---- Draw Order Status Pie Chart ----
    function initStatusPieChart(data) {
        const canvas = document.getElementById('statusPieChart');
        if (!canvas)
            return;
        if (window.statusPieChart && typeof window.statusPieChart.destroy === 'function')
            window.statusPieChart.destroy();
        const values = ORDER_STATUS_LABELS.map(key => data && typeof data[key] !== "undefined" ? data[key] : 0);
        window.statusPieChart = new Chart(canvas, {
            type: 'pie',
            data: {
                labels: ORDER_STATUS_LABELS,
                datasets: [{
                        data: values,
                        backgroundColor: ORDER_STATUS_COLORS,
                        borderColor: '#fff',
                        borderWidth: 2
                    }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'right',
                        labels: {
                            boxWidth: 18,
                            font: {size: 14, family: 'inherit', weight: '500'},
                            padding: 15
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: context => context.label + ':' + context.parsed
                        }
                    }
                }
            }
        });
    }

    // ---- Get JSON data from Script Tag ----
    function getJson(id, def = []) {
        const el = document.getElementById(id);
        if (!el)
            return def;
        try {
            return JSON.parse(el.textContent);
        } catch (e) {
            console.error('Error parsing JSON from #' + id + ':', e);
            return def;
    }
    }

    const revenueDaily = getJson('revenueDailyScript', []);
    const revenueMonthly = getJson('revenueMonthlyScript', []);
    const revenueYearly = getJson('revenueYearlyScript', []);
    const statusPieData = getJson('orderStatusDataScript', {});

    // ---- Show correct Filter Form ----
    function showFilterForm(type) {
        document.querySelectorAll('.filter-form').forEach(f => f.classList.add('d-none'));
        const form = document.getElementById('filter-form-' + type);
        if (form) {
            form.classList.remove('d-none');
            const input = form.querySelector('input[name="filterType"]');
            if (input)
                input.value = type;
        }
    }

    // ---- Tab Switching ----
    function setTabActive(btn) {
        document.querySelectorAll('.chart-tab-btn').forEach(b => {
            b.classList.remove('active');
            b.classList.add('btn-outline-secondary');
        });
        btn.classList.add('active');
        btn.classList.remove('btn-outline-secondary');
    }

    ['daily', 'monthly', 'yearly'].forEach(type => {
        const btn = document.getElementById('btn-' + type);
        if (btn) {
            btn.onclick = () => {
                setTabActive(btn);
                showFilterForm(type);
                if (type === "daily")
                    initRevenueChart(revenueDaily, "30 Day Revenue");
                else if (type === "monthly")
                    initRevenueChart(revenueMonthly, "Monthly Revenue");
                else
                    initRevenueChart(revenueYearly, "Yearly Revenue");
                initStatusPieChart(statusPieData);
            };
        }
    });

    // ---- Filter Submit (validation) ----
    document.querySelectorAll('.filter-submit-btn').forEach(btn => {
        btn.onclick = function (e) {
            e.preventDefault();
            const form = btn.closest('form');
            if (!form)
                return;
            const type = form.id.replace('filter-form-', '');
            let valid = true, msg = "";

            if (type === "daily") {
                const from = form.querySelector('input[name="startDate"]').value;
                const to = form.querySelector('input[name="endDate"]').value;
                if (!from || !to) {
                    valid = false;
                    msg = "Please select both start and end dates.";
                } else if (from > to) {
                    valid = false;
                    msg = "The start date must be before or equal to the end date.";
                } else {
                    const diffDays = Math.ceil((new Date(to) - new Date(from)) / (1000 * 60 * 60 * 24)) + 1;
                    if (diffDays > 30) {
                        valid = false;
                        msg = "You can select up to 30 days only.";
                    }
                }
            }

            if (type === "monthly") {
                const from = form.querySelector('input[name="startMonth"]').value;
                const to = form.querySelector('input[name="endMonth"]').value;
                if (!from || !to) {
                    valid = false;
                    msg = "Please select both start and end months.";
                } else if (from > to) {
                    valid = false;
                    msg = "The start month must be before or equal to the end month.";
                }
            }

            if (type === "yearly") {
                const from = Number(form.querySelector('input[name="startYear"]').value);
                const to = Number(form.querySelector('input[name="endYear"]').value);
                if (!from || !to) {
                    valid = false;
                    msg = "Please enter both start and end years.";
                } else if (from > to) {
                    valid = false;
                    msg = "The start year must be before or equal to the end year.";
                } else if (from < 2000 || to > 2100) {
                    valid = false;
                    msg = "Years are allowed only from 2000 to 2100.";
                }
            }

            if (!valid) {
                if (window.Swal) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Validation Error',
                        text: msg,
                        confirmButtonColor: '#6366f1',
                        confirmButtonText: 'OK'
                    });
                } else {
                    alert(msg);
                }
                return false;
            }

            // Build query parameters
            const params = [{name: 'filterType', value: type}];
            if (type === "daily") {
                params.push({name: 'startDate', value: form.querySelector('input[name="startDate"]').value});
                params.push({name: 'endDate', value: form.querySelector('input[name="endDate"]').value});
            } else if (type === "monthly") {
                params.push({name: 'startMonth', value: form.querySelector('input[name="startMonth"]').value});
                params.push({name: 'endMonth', value: form.querySelector('input[name="endMonth"]').value});
            } else if (type === "yearly") {
                params.push({name: 'startYear', value: form.querySelector('input[name="startYear"]').value});
                params.push({name: 'endYear', value: form.querySelector('input[name="endYear"]').value});
            }

            // If loadContent function exists (AJAX), use it; otherwise submit form normally
            if (typeof loadContent === 'function') {
                loadContent('dashboard', true, params);
            } else {
                form.submit();
            }
        };
    });

    // ---- On Page Load (init) ----
    const filterTypeDefault = document.getElementById('filterTypeValue');
    const type = filterTypeDefault ? (filterTypeDefault.value || 'daily') : 'daily';
    showFilterForm(type);
    const btnActive = document.getElementById('btn-' + type);
    if (btnActive)
        setTabActive(btnActive);
    if (type === "daily")
        initRevenueChart(revenueDaily, "30 Day Revenue");
    else if (type === "monthly")
        initRevenueChart(revenueMonthly, "Monthly Revenue");
    else if (type === "yearly")
        initRevenueChart(revenueYearly, "Yearly Revenue");
    initStatusPieChart(statusPieData);
};

// Initialize on page load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', window.initDashboardTabs);
} else {
    window.initDashboardTabs();
}
        </script>
    </body>
</html>
