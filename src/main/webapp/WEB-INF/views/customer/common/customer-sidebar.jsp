

<div class="customer-sidebar bg-white" style="height: 500px; overflow: hidden;">
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
                <a href="${pageContext.request.contextPath}/orders?id=2" 
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

                <!-- Vouchers Link -->
                <a href="${pageContext.request.contextPath}/voucher?action=list" 
                   id="voucher" 
                   data-page="voucher" 
                   class="nav-link-item">
                    <div class="nav-icon-wrapper">
                        <i class="fas fa-tags nav-icon"></i>
                    </div>
                    <div class="nav-text-wrapper">
                        <span class="nav-title">Vouchers</span>
                        <p class="nav-description mb-0">My vouchers & discounts</p>
                    </div>
                </a>

            </div>
        </nav>
    </div>
</div>

<style>
    /* Sidebar Styles */
    .customer-sidebar {
        background: white;
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        overflow: hidden;
        min-height: 350px;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        margin-right: 12px;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .customer-sidebar {
            margin-top: 1rem;
            margin-bottom: 2rem;
        }

        .profile-info-card {
            padding: 1.5rem;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
        }
    }

    .profile-section {
        padding: 1.5rem 2rem;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        text-align: center;
        position: relative;
    }

    .profile-avatar {
        width: 80px;
        height: 80px;
        border: 3px solid #d1d5db;
        border-radius: 50%;
        object-fit: cover;
    }

    .profile-name {
        color: #1f2937;
        font-size: 1.125rem;
        font-weight: 600;
        line-height: 1.3;
        margin-bottom: 0.25rem;
    }

    .profile-subtitle {
        color: #6b7280;
        font-size: 0.75rem;
    }

    .profile-divider {
        position: absolute;
        bottom: 0;
        left: 1.5rem;
        right: 1.5rem;
        height: 1px;
        background: linear-gradient(to right, transparent, #e5e7eb, transparent);
        transition: transform 0.5s ease;
        transform-origin: center;
    }

    .profile-section:hover .profile-divider {
        transform: scaleX(1.1);
    }

    /* Sidebar */
    .nav-menu {
        padding: 2rem 0;
    }

    .nav-link-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 1rem 1.5rem;
        margin-bottom: 0.75rem;
        border-radius: 8px;
        color: #374151;
        text-decoration: none;
        transition: all 0.2s ease-in-out;
        position: relative;
        overflow: hidden;
    }

    .nav-link-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        height: 100%;
        width: 4px;
        background: #4b5563;
        transform: translateX(-100%);
        transition: transform 0.3s ease;
    }

    .nav-link-item:hover {
        color: #000000;
        background-color: #eff6ff;
        transform: scale(1.05);
    }

    .nav-link-item:hover::before {
        transform: translateX(0);
    }

    .nav-link-item.active {
        color: #000000;
        background-color: #eff6ff;
    }

    .nav-link-item.active::before {
        transform: translateX(0);
        background: #000000;
    }

    .nav-icon-wrapper {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        background: white;
        border-radius: 8px;
        transition: background-color 0.2s ease;
        flex-shrink: 0;
    }

    .nav-link-item:hover .nav-icon-wrapper {
        background-color: #eff6ff;
    }

    .nav-icon {
        width: 20px;
        height: 20px;
        color: currentColor;
    }

    .nav-text-wrapper {
        flex: 1;
    }

    .nav-title {
        font-weight: 500;
        display: block;
        margin-bottom: 0.125rem;
    }

    .nav-description {
        font-size: 0.75rem;
        color: #6b7280;
        margin: 0;
    }

    .nav-link-item:hover .nav-description {
        color: #1f2937;
    }

    /* badge voucher lu�n d�nh v? b�n ph?i, kh�ng l�m l?ch h�ng */
    .voucher-badge{
        margin-left:auto;
        background:#e74c3c;
        color:#fff;
        border-radius:50%;
        width:20px;
        height:20px;
        font-size:12px;
        display:flex;
        align-items:center;
        justify-content:center;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', () => {
    // path + query hi?n t?i
    const href = window.location.pathname + window.location.search;
    // clear active
    document.querySelectorAll('.nav-link-item').forEach(a => a.classList.remove('active'));
    // set active theo id c? th?
    if (href.includes('/voucher')) {
    document.getElementById('voucher')?.classList.add('active');
    } else if (href.includes('/orders')) {
    document.getElementById('order')?.classList.add('active');
    } else if (href.includes('/profile')) {
    document.getElementById('profile')?.classList.add('active');
    }

    // fallback theo data-page (kh�ng nh�n ?�i class)
    document.querySelectorAll('.nav-link-item').forEach(item => {
    const key = item.getAttribute('data-page');
    if (key && href.includes(key)) item.classList.add('active');
    });
    });
// (tu? ch?n) hi?n s? voucher
    async function loadVoucherCount() {
    try {
    const res = await fetch('${pageContext.request.contextPath}/voucher?action=count');
    const data = await res.json();
    if (data?.count > 0) {
    const badge = document.createElement('span');
    badge.className = 'voucher-badge';
    badge.textContent = data.count;
    document.getElementById('voucher')?.appendChild(badge);
    }
    } catch (e){ console.error('Error loading voucher count:', e); }
    }
// loadVoucherCount();
</script>
