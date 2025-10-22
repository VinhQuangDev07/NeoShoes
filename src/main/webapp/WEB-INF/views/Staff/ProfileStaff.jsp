<%-- Staff Profile --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Staff Profile</title>

  <!-- Icons & Bootstrap -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://unpkg.com/lucide@latest"></script>

  <style>
    :root{
      --bg:#f6f7fb;
      --card:#fff;
      --text:#111827;
      --muted:#6b7280;
      --line:#e5e7eb;
      --primary:#111;
      --radius:14px;
      --header-h:74px;
      --sidebar-w:280px;
      --banana:#ffffff;
      --banana-weak:#f7f7ff;
    }

    body{ padding-top:var(--header-h); }
    *{ box-sizing:border-box }
    html,body{
      margin:0;background:var(--bg);color:var(--text);
      font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;
    }

    /* ====== LAYOUT ====== */
    .wrap{
      margin-left:var(--sidebar-w);
      width:calc(100% - var(--sidebar-w));
      padding:24px 20px;
    }
    .card{
      background:var(--card);
      border:1px solid var(--line);
      border-radius:var(--radius);
      box-shadow:0 4px 24px rgba(0,0,0,.06);
    }

    /* Căn giữa card trong trang */
    .container-centered{
      max-width:1200px;
      margin:0 auto;
    }

    /* ====== FORM GRID ====== */
    .body{ padding:32px; }
    .grid{
      display:grid;
      grid-template-columns:repeat(12,minmax(0,1fr));
      gap:24px;
      align-items:start;
    }
    .grid.profile-grid .col-field{ grid-column:span 6; }
    .grid.profile-grid .col-full{  grid-column:span 12; }
    .grid.pw-grid .pw-field{       grid-column:span 4;  }

    @media(max-width:992px){
      .grid.profile-grid .col-field,
      .grid.profile-grid .col-full,
      .grid.pw-grid .pw-field{ grid-column:span 12; }
    }

    .field{ display:flex;flex-direction:column;gap:8px;height:100%; }
    .label{ font-size:14px;font-weight:700;color:var(--muted);min-height:20px; }

    /* ====== INPUT CONTROL ====== */
    .ctrl{
      position:relative;             /* để vẽ tick bên trong */
      display:flex;align-items:center;gap:12px;
      background:var(--banana);border:1px solid var(--line);
      border-radius:10px;padding:14px 16px;min-height:52px;width:100%;
      transition: all .2s ease;
    }
    .ctrl.readonly{ background:var(--banana-weak); }
    .ctrl input,.ctrl select{
      border:0;background:transparent;width:100%;outline:0;font-size:15px;color:var(--text);font-family:inherit;
      padding-right:40px;            /* chừa chỗ icon bên phải */
      min-width:0;                   /* chống overflow trong flex */
    }
    .ctrl input::placeholder{ color:var(--muted);opacity:.7; }
    .ctrl.editing{
      background:#fef9c3;border-color:#3b82f6;box-shadow:0 0 0 3px rgba(59,130,246,.1);
    }

    /* Icon bút */
    .edit-icon{
      color:#3b82f6;cursor:pointer;margin-left:auto;transition:.2s;flex-shrink:0;position:relative;z-index:2;margin-right:8px;
    }
    .edit-icon:hover{ color:#1e40af;transform:scale(1.1) }

    /* ====== BUTTONS ====== */
    .btn{
      border:1px solid var(--line);background:#fff;padding:12px 20px;border-radius:10px;
      font-weight:600;font-size:14px;cursor:pointer;transition:.2s;display:inline-flex;align-items:center;gap:8px;
    }
    .btn-primary{ background:#E0E7FF;color:#111827;border-color:#c7d2fe; }
    .btn-primary:hover{ background:#d1daff;transform:translateY(-1px); }
    .btn-secondary{ background:#fff;color:#111827;border:1px solid var(--line); }
    .btn-secondary:hover{ background:#f9fafb;transform:translateY(-1px); }

    .actions{ display:flex;justify-content:flex-end;gap:12px;padding:0 32px 16px;margin-top:24px; }

    /* ====== ERROR / VALID ====== */
    .msg-error{ font-size:13px;color:#dc2626;margin-top:4px;line-height:1.35;min-height:18px; }
    .ctrl.invalid{ border-color:#fca5a5;background:#fef2f2; }
    .ctrl.valid{
      border-color:#22c55e !important;background:#ecfdf5;
      box-shadow:0 0 0 3px rgba(34,197,94,.18);
    }
    .ctrl.valid::after{
      content:"\f00c"; font-family:"Font Awesome 6 Free"; font-weight:900;
      color:#16a34a; position:absolute; right:10px; top:50%; transform:translateY(-50%); opacity:1; pointer-events:none; z-index:1;
    }
    .hidden{ display:none; }

    /* ====== PASSWORD FIELD ====== */
    .password-field{ position:relative;width:100%; }
    .password-field input{
      padding-right:72px !important; /* mắt + chấm than */
      width:100%;border:none;background:transparent;outline:none;font-size:15px;
    }
    .toggle-pass{
      position:absolute;right:36px;top:50%;transform:translateY(-50%);
      color:#6b7280;cursor:pointer;transition:.25s;z-index:2;background:none;border:none;padding:0;width:20px;height:20px;
      display:flex;align-items:center;justify-content:center;
    }
    .toggle-pass:hover{ color:#1e40af;transform:translateY(-50%) scale(1.15); }
    .error-icon{
      position:absolute;right:12px;top:50%;transform:translateY(-50%);
      color:#dc2626;font-size:16px;opacity:0;pointer-events:none;transition:opacity .2s ease;z-index:1;
    }
    .ctrl.invalid .error-icon{ opacity:1; }

    .divider{ height:1px;background:#e5e7eb;margin:28px 0; }

    /* ====== HEADER & AVATAR ====== */
    .head{ padding:32px;border-bottom:1px solid var(--line); }
    .avatar{
      width:80px;height:80px;border-radius:50%;overflow:hidden;display:flex;align-items:center;justify-content:center;
      background:var(--banana-weak);border:2px solid var(--line);
    }
    .avatar img{ width:100%;height:100%;object-fit:cover; }

    /* ====== ALERT ====== */
    .alert{
      margin:0 32px 24px;padding:12px 16px;border-radius:8px;border:1px solid;font-size:14px;display:flex;align-items:center;gap:8px;
    }
    .alert.success{ background:#f0fdf4;border-color:#bbf7d0;color:#166534; }
    .alert.error{   background:#fef2f2;border-color:#fecaca;color:#dc2626; }

    /* ====== PASSWORD CARD HEADER ====== */
    .password-header{ display:flex;align-items:center;gap:12px;margin-bottom:24px;padding-bottom:16px;border-bottom:1px solid var(--line); }
    .password-header h3{ font-size:20px;font-weight:600;margin:0;color:var(--text); }
    .password-header i{ color:#3b82f6;font-size:18px; }

    /* ====== SIDEBAR ====== */
    .staff-sidebar{
      position:fixed;top:var(--header-h);left:0;width:var(--sidebar-w);
      height:calc(100vh - var(--header-h));overflow-y:auto;background:#fff;border-right:1px solid #e5e7eb;z-index:900;
    }
    .staff-header{ position:fixed;top:0;left:0;right:0;z-index:999; }
    @media (max-width: 992px){
      :root{ --sidebar-w:0px; }
      .wrap{ margin-left:0;width:100%; }
      .staff-sidebar{ position:fixed;top:var(--header-h);left:0;width:260px;transform:translateX(-100%);transition:transform .3s ease; }
    }

    /* Ẩn nút reveal mặc định trong ô password */
    input[type="password"]::-ms-reveal,
    input[type="password"]::-ms-clear,
    input[type="password"]::-webkit-credentials-auto-fill-button,
    input[type="password"]::-webkit-contacts-auto-fill-button{
      display:none !important;width:0 !important;height:0 !important;opacity:0 !important;pointer-events:none !important;
    }

    /* ====== HIGHLIGHT SAU KHI SAVE (flash) ====== */
    .ctrl.saved{
      border-color:#22c55e !important;
      box-shadow:0 0 0 3px rgba(34,197,94,.25);
      position:relative;transition:all .4s ease;overflow:hidden;
    }
    .ctrl.saved::after{
      content:"\f00c"; font-family:"Font Awesome 6 Free"; font-weight:900;
      color:#22c55e; position:absolute; right:10px; top:50%; transform:translateY(-50%); opacity:1; transition:all .4s ease;
    }
  </style>
</head>

<body>
  <!-- Header -->
  <jsp:include page="common/staff-header.jsp"/>
  <!-- Sidebar -->
  <jsp:include page="common/staff-sidebar.jsp"/>
  <jsp:include page="/WEB-INF/views/common/notification.jsp" />

  <div class="wrap">
    <div class="container-centered">
      <div class="card">

        <div class="head text-center">
          <div class="avatar mx-auto mb-3" id="avatarBox">
            <c:choose>
              <c:when test="${not empty staff.avatar}">
                <img id="avatarImg" src="${staff.avatar}" alt="Avatar">
              </c:when>
              <c:otherwise>
                <i class="fa-solid fa-user fa-2x" style="color:#9ca3af"></i>
              </c:otherwise>
            </c:choose>
          </div>
          <label class="btn btn-secondary">
            <i class="fa-solid fa-image"></i> Change Avatar
            <input id="avatarFile" type="file" accept="image/*" style="display:none">
          </label>
        </div>

        <!-- Flash message -->
        <c:if test="${not empty message}">
          <div class="alert ${messageType}">
            <i class="fa-solid ${messageType eq 'success' ? 'fa-circle-check' : 'fa-triangle-exclamation'}"></i>
            ${message}
          </div>
        </c:if>

        <!-- Profile Form -->
        <form id="profileForm" class="body" action="${pageContext.request.contextPath}/profilestaff"
              method="post" enctype="multipart/form-data" novalidate>
          <input type="hidden" name="avatar" id="avatarUrlHidden" value="${staff.avatar}"/>
          <input type="hidden" name="action" value="updateProfile"/>

          <div class="grid profile-grid">
            <div class="col-full field">
              <span class="label">Full Name</span>
              <div class="ctrl readonly">
                <i class="fa-regular fa-user"></i>
                <input value="${staff.name}" readonly>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Email Address</span>
              <div class="ctrl readonly">
                <i class="fa-regular fa-envelope"></i>
                <input value="${staff.email}" readonly>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Staff ID</span>
              <div class="ctrl readonly">
                <i class="fa-solid fa-id-badge"></i>
                <input value="${staff.staffId}" readonly>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Gender</span>
              <div class="ctrl editable" id="genderCtrl">
                <i class="fa-solid fa-venus-mars"></i>
                <span id="genderText">${staff.gender}</span>
                <select name="gender" id="genderSelect" class="hidden">
                  <option value="Male"   <c:if test="${staff.gender eq 'Male'}">selected</c:if>>Male</option>
                  <option value="Female" <c:if test="${staff.gender eq 'Female'}">selected</c:if>>Female</option>
                  <option value="Other"  <c:if test="${staff.gender eq 'Other'}">selected</c:if>>Other</option>
                </select>
                <i class="fa-solid fa-pen-to-square edit-icon" onclick="editGender()"></i>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Address</span>
              <div class="ctrl editable">
                <i class="fa-solid fa-location-dot"></i>
                <input name="address" value="${staff.address}" placeholder="Street, City, ..." readonly>
                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Date of Birth</span>
              <div class="ctrl editable">
                <i class="fa-regular fa-calendar"></i>
                <input type="date" name="dateOfBirth" value="${staff.dateOfBirth}" readonly>
                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
              </div>
            </div>

            <div class="col-field field">
              <span class="label">Phone Number</span>
              <div class="ctrl editable" id="phoneCtrl">
                <i class="fa-solid fa-phone"></i>
                <input id="phoneNumber" name="phoneNumber" value="${staff.phoneNumber}"
                       placeholder="0xxxxxxxxx or +84xxxxxxxxx" readonly>
                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
              </div>
              <div class="msg-error hidden" id="errPhone">Phone must be 10 digits starting with 0, or +84 + 9 digits.</div>
            </div>
          </div>

          <div class="actions">
            <button type="button" id="togglePasswordForm" class="btn btn-secondary">
              <i class="fa-solid fa-key"></i> Change Password
            </button>
            <button class="btn btn-primary" type="submit">
              <i class="fa-regular fa-floppy-disk"></i> Save changes
            </button>
          </div>
        </form>

        <div class="divider"></div>

        <!-- Change Password -->
        <div class="card shadow-sm mt-3 hidden" id="passwordCard">
          <div class="body">
            <div class="password-header">
              <i class="fa-solid fa-lock"></i>
              <h3>Change Password</h3>
            </div>

            <form method="post" id="passwordForm" action="${pageContext.request.contextPath}/profilestaff" novalidate>
              <input type="hidden" name="action" value="changePassword"/>

              <div class="grid pw-grid">
                <div class="pw-field field">
                  <span class="label">Current Password</span>
                  <div class="ctrl password-field" id="ctrlCur">
                    <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password"/>
                    <button type="button" class="toggle-pass" onclick="togglePassword(this)">
                      <i class="fa-solid fa-eye-slash"></i>
                    </button>
                    <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                  </div>
                  <div class="msg-error hidden" id="errCur"></div>
                </div>

                <div class="pw-field field">
                  <span class="label">New Password</span>
                  <div class="ctrl password-field" id="ctrlNew">
                    <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password"/>
                    <button type="button" class="toggle-pass" onclick="togglePassword(this)">
                      <i class="fa-solid fa-eye-slash"></i>
                    </button>
                    <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                  </div>
                  <div class="msg-error hidden" id="errNew">Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.</div>
                </div>

                <div class="pw-field field">
                  <span class="label">Confirm Password</span>
                  <div class="ctrl password-field" id="ctrlConfirm">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password"/>
                    <button type="button" class="toggle-pass" onclick="togglePassword(this)">
                      <i class="fa-solid fa-eye-slash"></i>
                    </button>
                    <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                  </div>
                  <div class="msg-error hidden" id="errConfirm">Passwords do not match.</div>
                </div>
              </div>

              <div class="actions">
                <button class="btn btn-primary" type="submit">
                  <i class="fa-solid fa-key"></i> Update Password
                </button>
              </div>
            </form>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- ======== Scripts ======== -->

  <!-- Save marker: ghi nhận form nào submit để highlight sau redirect -->
  <script>
    (function(){
      const profileForm  = document.getElementById('profileForm');
      const passwordForm = document.getElementById('passwordForm');

      profileForm?.addEventListener('submit', function(){
        localStorage.setItem('savedForm', 'profile');
      });
      passwordForm?.addEventListener('submit', function(){
        localStorage.setItem('savedForm', 'password');
      });
    })();
  </script>

  <!-- Sau khi load lại trang: highlight xanh theo savedForm -->
  <script>
    (function(){
      const saved = localStorage.getItem('savedForm');
      if (!saved) return;

      let targets;
      if (saved === 'password'){
        targets = document.querySelectorAll('#passwordForm .ctrl.password-field');
      } else {
        targets = document.querySelectorAll('#profileForm .ctrl.editable');
      }

      requestAnimationFrame(() => {
        targets.forEach(ctrl => {
          if (ctrl.classList.contains('invalid')) return;
          ctrl.classList.add('saved');
          setTimeout(() => ctrl.classList.remove('saved'), 1800);
        });
      });

      localStorage.removeItem('savedForm');
    })();
  </script>

  <!-- Realtime VALID phone -->
  <script>
    (function(){
      const phoneInput = document.getElementById('phoneNumber');
      const phoneCtrl  = document.getElementById('phoneCtrl');
      if (!phoneInput || !phoneCtrl) return;

      const reVN = /^(\+84[0-9]{9}|0[0-9]{9})$/;

      function updatePhoneValid(){
        const v = (phoneInput.value || '').trim();
        const editable = !phoneInput.hasAttribute('readonly') && !phoneInput.disabled;
        if (!editable){ phoneCtrl.classList.remove('valid'); return; }

        if (reVN.test(v)){
          phoneCtrl.classList.remove('invalid');
          phoneCtrl.classList.add('valid');
        } else {
          phoneCtrl.classList.remove('valid');
        }
      }

      phoneInput.addEventListener('input', updatePhoneValid);
      phoneInput.addEventListener('blur', updatePhoneValid);
    })();
  </script>

  <!-- Preview/reset avatar -->
  <script>
    const file   = document.getElementById('avatarFile');
    const img    = document.getElementById('avatarImg');
    const box    = document.getElementById('avatarBox');
    const hidden = document.getElementById('avatarUrlHidden');
    const resetBtn = document.getElementById('btnResetAvatar');

    file?.addEventListener('change', e => {
      const f = e.target.files?.[0]; if (!f) return;
      const url = URL.createObjectURL(f);
      if (img) img.src = url;
      else {
        const newImg = document.createElement('img');
        newImg.id = 'avatarImg'; newImg.src = url; newImg.alt = 'Avatar';
        box.innerHTML = ''; box.appendChild(newImg);
      }
    });

    resetBtn?.addEventListener('click', () => {
      const original = "${staff.avatar}";
      if (original){
        if (img) img.src = original;
        else {
          const n = document.createElement('img'); n.id = 'avatarImg';
          n.src = original; n.alt = 'Avatar'; box.innerHTML = ''; box.appendChild(n);
        }
      } else {
        box.innerHTML = '<i class="fa-solid fa-user fa-2x" style="color:#9ca3af"></i>';
      }
      hidden.value = original; if (file) file.value = "";
    });
  </script>

  <!-- Edit enable + Gender toggle -->
  <script>
    function enableEdit(icon){
      const ctrl = icon.closest('.ctrl'); if (!ctrl) return;
      const input = ctrl.querySelector('input, select'); if (!input) return;
      if (input.hasAttribute('readonly')) input.removeAttribute('readonly');
      if (input.disabled) input.disabled = false;
      ctrl.classList.add('editing'); input.focus();
    }
    function editGender(){
      const text = document.getElementById('genderText');
      const select = document.getElementById('genderSelect');
      const ctrl = document.getElementById('genderCtrl');
      text.classList.add('hidden'); select.classList.remove('hidden');
      ctrl.classList.add('editing'); select.focus();
      select.addEventListener('change', () => {
        text.textContent = select.value;
        select.classList.add('hidden'); text.classList.remove('hidden');
        ctrl.classList.remove('editing');
      });
    }
  </script>

  <!-- Toggle Change Password card -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const btnToggle = document.getElementById('togglePasswordForm');
      const passwordCard = document.getElementById('passwordCard');
      if (btnToggle && passwordCard) {
        btnToggle.addEventListener('click', () => {
          passwordCard.classList.toggle('hidden');
          btnToggle.textContent = passwordCard.classList.contains('hidden')
            ? 'Change Password' : 'Hide Change Password';
          if (!passwordCard.classList.contains('hidden')) {
            setTimeout(() => passwordCard.scrollIntoView({behavior:'smooth', block:'start'}), 50);
          }
        });
      }
    });
  </script>

  <!-- Validate Change Password (submit-time) + Realtime valid -->
  <script>
    (function(){
      const form = document.getElementById('passwordForm'); if (!form) return;
      const cur = document.getElementById('currentPassword');
      const nw  = document.getElementById('newPassword');
      const cf  = document.getElementById('confirmPassword');
      const ctrlCur = document.getElementById('ctrlCur');
      const ctrlNew = document.getElementById('ctrlNew');
      const ctrlCf  = document.getElementById('ctrlConfirm');
      const errCur = document.getElementById('errCur');
      const errNew = document.getElementById('errNew');
      const errCf  = document.getElementById('errConfirm');

      const isStrong = (pw) => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(pw);

      function setError(ctrl, errEl, msg){
        ctrl.classList.add('invalid');
        if (errEl){ errEl.textContent = msg; errEl.classList.remove('hidden'); }
      }
      function clearError(ctrl, errEl){
        ctrl.classList.remove('invalid'); if (errEl){ errEl.classList.add('hidden'); }
      }
      function setValid(ctrl, ok){
        if (!ctrl) return;
        if (ok){ ctrl.classList.add('valid'); ctrl.classList.remove('invalid'); }
        else { ctrl.classList.remove('valid'); }
      }

      function onCur(){ setValid(ctrlCur, !!cur.value && isStrong(cur.value)); if (errCur) errCur.classList.add('hidden'); }
      function onNew(){ setValid(ctrlNew, !!nw.value && isStrong(nw.value)); if (errNew) errNew.classList.add('hidden'); onCf(); }
      function onCf(){  setValid(ctrlCf, !!cf.value && cf.value === nw.value); if (errCf)  errCf.classList.add('hidden'); }

      cur?.addEventListener('input', onCur);
      nw?.addEventListener('input', onNew);
      cf?.addEventListener('input', onCf);

      form.addEventListener('submit', (e) => {
        let ok = true;

        if (!cur.value.trim()){ setError(ctrlCur, errCur, 'Current password cannot be blank.'); ok = false; }
        else if (!isStrong(cur.value)){ setError(ctrlCur, errCur, 'Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.'); ok = false; }
        else { clearError(ctrlCur, errCur); }

        if (!nw.value.trim()){ setError(ctrlNew, errNew, 'New password cannot be blank.'); ok = false; }
        else if (!isStrong(nw.value)){ setError(ctrlNew, errNew, 'Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.'); ok = false; }
        else { clearError(ctrlNew, errNew); }

        if (!cf.value.trim()){ setError(ctrlCf, errCf, 'Confirm password cannot be blank.'); ok = false; }
        else if (cf.value !== nw.value){ setError(ctrlCf, errCf, 'Passwords do not match.'); ok = false; }
        else { clearError(ctrlCf, errCf); }

        if (!ok){ e.preventDefault(); form.scrollIntoView({behavior:'smooth', block:'start'}); }
      });

      // chạy realtime 1 lần nếu có auto-fill
      onCur(); onNew(); onCf();
    })();
  </script>

  <!-- Toggle mắt password -->
  <script>
    function togglePassword(el){
      const icon = el.querySelector('i');
      const input = el.closest('.password-field').querySelector('input');
      if (!input) return;
      if (input.type === 'password'){
        input.type = 'text'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); el.style.color='#2563eb';
      } else {
        input.type = 'password'; icon.classList.add('fa-eye-slash'); icon.classList.remove('fa-eye'); el.style.color='#6b7280';
      }
    }

    // Ẩn/hiện icon mắt khi input rỗng/có chữ
    document.querySelectorAll('.password-field input').forEach(input => {
      const field = input.closest('.password-field');
      const toggle = field.querySelector('.toggle-pass');
      const updateEye = () => {
        if (!toggle) return;
        if (input.value.trim() === ''){ toggle.style.opacity='0'; toggle.style.pointerEvents='none'; }
        else { toggle.style.opacity='1'; toggle.style.pointerEvents='auto'; }
      };
      input.addEventListener('input', updateEye); updateEye();
    });
  </script>

  <!-- Profile form: validate phone on submit + unhide edit -->
  <script>
    (() => {
      const form = document.getElementById('profileForm'); if (!form) return;
      const phoneInput = document.getElementById('phoneNumber');
      const phoneCtrl  = document.getElementById('phoneCtrl');
      const errPhone   = document.getElementById('errPhone');
      const reVN = /^(\+84[0-9]{9}|0[0-9]{9})$/;

      phoneInput.addEventListener('input', () => {
        phoneCtrl.classList.remove('invalid'); errPhone.classList.add('hidden');
      });

      form.addEventListener('submit', (e) => {
        if (phoneInput.hasAttribute('readonly')) return;
        const v = (phoneInput.value || '').trim();
        if (!reVN.test(v)) {
          e.preventDefault();
          phoneCtrl.classList.add('invalid'); errPhone.classList.remove('hidden');
          errPhone.textContent = (reVN.toString().includes('\\+84'))
            ? 'Invalid phone number. Please enter 0xxxxxxxxx (10 digits) or +84xxxxxxxxx (9 digits).'
            : 'Invalid Phone. Please enter 10 digits starting with 0.';
          phoneInput.focus();
          return;
        }
      });

      // hook enableEdit: clear lỗi phone khi bật edit
      const __oldEnableEdit = window.enableEdit;
      window.enableEdit = function(icon){
        __oldEnableEdit ? __oldEnableEdit(icon) : (function(){
          const ctrl = icon.closest('.ctrl');
          const input = ctrl.querySelector('input,select');
          if (input?.hasAttribute('readonly')) input.removeAttribute('readonly');
          if (input?.disabled) input.disabled = false;
          ctrl.classList.add('editing'); input?.focus();
        })();
        const ctrl = icon.closest('.ctrl');
        if (ctrl && ctrl.id === 'phoneCtrl') {
          ctrl.classList.remove('invalid'); errPhone.classList.add('hidden');
        }
      }
    })();
  </script>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script> lucide.createIcons(); </script>
</body>
</html>
