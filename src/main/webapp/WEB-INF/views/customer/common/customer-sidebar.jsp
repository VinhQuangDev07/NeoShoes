

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
.customer-sidebar{
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0,0,0,.08);
  padding: 12px 0;
  background: #fff;
  /* c? ??nh chi?u r?ng ?? không b? co giãn gây l?ch */
  width: 260px;
  box-sizing: border-box;
}

.nav-menu{ display:flex; flex-direction:column; gap:6px; }

.nav-link-item{
  position: relative;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px 12px 20px; /* padding trái ?n ??nh */
  text-decoration: none;
  color: #333;
  border: 1px solid #f0f2f5;   /* khung nh? cho ??u nhau */
  border-radius: 10px;
  background: #fff;
  transition: background .2s ease, color .2s ease, border-color .2s ease;
  /* b? border-left tr?c ti?p ?? không làm xô l?ch */
}

/* v?ch active/hover không chi?m layout */
.nav-link-item::before{
  content:"";
  position:absolute;
  left:6px;
  top:8px;
  bottom:8px;
  width:3px;
  border-radius: 3px;
  background: transparent;
  transition: background .2s ease;
}

.nav-link-item:hover{
  background:#f8f9fa;
  border-color:#e9eef5;
  color:#0d6efd;
}
.nav-link-item:hover::before{ background:#0d6efd; }

.nav-link-item.active{
  background:#e9f2ff;
  border-color:#cfe5ff;
  color:#0d6efd;
}
.nav-link-item.active::before{ background:#0d6efd; }

.nav-icon-wrapper{
  flex: 0 0 36px;         /* c? ??nh ?? icon không làm l?ch text */
  height:36px;
  display:flex; align-items:center; justify-content:center;
}
.nav-icon{ font-size:18px; color:inherit; }

.nav-text-wrapper{ flex:1; min-width:0; }  /* tránh ??y icon l?ch khi text dài */

.nav-title{
  font-weight:600; font-size:16px; line-height:1.2; margin:0 0 2px 0;
  white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
}
.nav-description{
  font-size:12px; color:#6c757d; opacity:.9; margin:0;
  white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
}

/* badge voucher luôn dính v? bên ph?i, không làm l?ch hàng */
.voucher-badge{
  margin-left:auto;
  background:#e74c3c; color:#fff; border-radius:50%;
  width:20px; height:20px; font-size:12px;
  display:flex; align-items:center; justify-content:center;
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

  // fallback theo data-page (không nhân ?ôi class)
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
  } catch(e){ console.error('Error loading voucher count:', e); }
}
// loadVoucherCount();
</script>
