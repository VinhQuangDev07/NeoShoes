<%-- Staff Profile --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

        <style>
            :root{
                --bg:#f6f7fb;
                --card:#fff;
                --text:#111827;
                --muted:#6b7280;
                --line:#e5e7eb;
                --primary:#111;
                --radius:14px;

            }

            *{
                box-sizing:border-box
            }
            html,body{
                margin:0;
                background:var(--bg);
                color:var(--text);
                font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif
            }
            .wrap{
                max-width:1120px;
                margin:24px auto;
                padding:0 20px
            }
            .card{
                background:var(--card);
                border:1px solid var(--line);
                border-radius:var(--radius);
                box-shadow:0 4px 24px rgba(0,0,0,.06)
            }
            .head{
                padding:24px;
                border-bottom:1px solid var(--line);
                display:flex;
                gap:12px;
                justify-content:center;
                align-items:center;
                flex-wrap:wrap;
                flex-direction: column !important;
            }
            .avatar{
                width:96px;
                height:96px;
                border-radius:999px;
                background:#f1f5f9;
                border:3px solid #fff;
                display:grid;
                place-items:center;
                box-shadow:0 6px 18px rgba(0,0,0,.08);
                overflow:hidden
            }
            .avatar img{
                width:100%;
                height:100%;
                object-fit:cover
            }
            .btn{
                border:1px solid var(--line);
                background:#fff;
                padding:10px 14px;
                border-radius:10px;
                font-weight:600;
                cursor:pointer
            }
            .btn-primary{
                background:#E0E7FF;
                color:#111827;
                border-color:#c7d2fe;
            }
            .btn-secondary{
                background:#fff;
                color:#111827;
                border:1px solid var(--line);
            }
            .btn-secondary:hover{
                filter:brightness(.98)
            }

            .body{
                padding:24px
            }
            .grid{
                display:grid;
                gap:16px;
                grid-template-columns:repeat(12,minmax(0,1fr))
            }
            .col-6{
                grid-column:span 6
            }
            .col-12{
                grid-column:span 12
            }
            .col-4{
                grid-column: span 4;
            }

            @media(max-width:920px){
                .col-6{
                    grid-column:span 12
                }
                .col-4{
                    grid-column:span 12
                }
            }

            .field{
                display:flex;
                flex-direction:column;
                gap:6px
            }
            .label{
                font-size:13px;
                font-weight:700;
                color:var(--muted)
            }

            .ctrl{
                display:flex;
                align-items:center;
                gap:10px;
                background:var(--banana);
                border:1px solid var(--line);
                border-radius:10px;
                padding:12px;
                min-height:44px
            }
            .ctrl.readonly{
                background:var(--banana-weak)
            }
            .ctrl input,.ctrl select{
                border:0;
                background:transparent;
                width:100%;
                outline:0;
                font-size:15px;
                color:var(--text)
            }
            .ctrl.editing{
                background:#fef9c3;
            }

            .edit-icon{
                color:#3b82f6;
                cursor:pointer;
                margin-left:auto;
                transition:.2s
            }
            .edit-icon:hover{
                color:#1e40af;
                transform:scale(1.1)
            }

            .actions{
                display:flex;
                justify-content:flex-end;
                padding:0 24px 12px;
                margin-top:12px;
                gap:10px; /* có khoảng trống giữa 2 nút */
            }

            .alert{
                margin:12px 24px 0;
                padding:12px 14px;
                border-radius:10px;
                border:1px solid;
                display:flex;
                gap:10px;
                font-weight:600
            }
            .success{
                color:#065f46;
                background:#ecfdf5;
                border-color:#a7f3d0
            }
            .error{
                color:#991b1b;
                background:#fef2f2;
                border-color:#fecaca
            }

            .divider{
                height:1px;
                background:#e5e7eb;
                margin:20px 0
            }

            /* Ẩn icon reveal mặc định của trình duyệt */
            input[type="password"]::-ms-reveal, input[type="password"]::-ms-clear{
                display:none
            }
            input[type="password"]::-moz-password-reveal{
                display:none
            }
            input[type="password"]::-webkit-credentials-auto-fill-button,
            input[type="password"]::-webkit-contacts-auto-fill-button{
                display:none
            }

            /* helper + lỗi */
            .pw-grid{
                align-items:start
            }
            .msg-error{
                font-size:13px;
                color:#dc2626;
                margin-top:6px;
                line-height:1.35
            }
            .ctrl.invalid{
                border-color:#fca5a5;
                background:#fef2f2
            }
            .ctrl.valid {
                border-color: #22c55e;   /* xanh lá tươi */
                background: #ecfdf5;     /* nền xanh nhạt */
            }
            .hidden{
                display:none
            }

            .password-field {
                position: relative;
            }
            .password-field input {
                padding-right: 72px;
            }
            .toggle-pass {
                position: absolute;
                right: 36px;
                top: 50%;
                transform: translateY(-50%);
                color: #6b7280;
                cursor: pointer;
                transition: 0.25s;
                z-index: 1;
            }
            .toggle-pass:hover {
                color: #1e40af;
                transform: translateY(-50%) scale(1.15);
            }
            .error-icon {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                color: #dc2626;
                font-size: 16px;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.2s ease;
            }
            .ctrl.invalid .error-icon {
                opacity: 1;
            }

        </style>
    </head>

    <body>
        <div class="wrap">
            <div class="card">

                <!-- Header -->
                <div class="head">
                    <div class="avatar" id="avatarBox">
                        <c:choose>
                            <c:when test="${not empty staff.avatar}">
                                <img id="avatarImg" src="${staff.avatar}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-user fa-2x" style="color:#9ca3af"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <label class="btn">
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

                <!-- Profile form -->
                <form id="profileForm" class="body" action="${pageContext.request.contextPath}/profilestaff"
                      method="post" enctype="multipart/form-data" novalidate>

                    <input type="hidden" name="avatar" id="avatarUrlHidden" value="${staff.avatar}"/>
                    <input type="hidden" name="action" value="updateProfile">

                    <div class="grid">
                        <div class="col-12 field">
                            <span class="label">Full Name</span>
                            <div class="ctrl readonly"><input value="${staff.name}" readonly></div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Email Address</span>
                            <div class="ctrl readonly">
                                <i class="fa-regular fa-envelope"></i>
                                <input value="${staff.email}" readonly>
                            </div>
                        </div>

                        <div class="col-6 field">
                            <span class="label">Staff ID</span>
                            <div class="ctrl readonly">
                                <i class="fa-solid fa-id-badge"></i>
                                <input value="${staff.staffId}" readonly>
                            </div>
                        </div>

                        <!-- Gender -->
                        <div class="col-6 field">
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

                            <!-- Address -->
                            <div class="col-6 field">
                                <span class="label">Address</span>
                                <div class="ctrl editable">
                                    <i class="fa-solid fa-location-dot"></i>
                                    <input name="address" value="${staff.address}" placeholder="Street, City, ..." readonly>
                                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
                            </div>
                        </div>

                        <!-- Date of Birth -->
                        <div class="col-6 field">
                            <span class="label">Date of Birth</span>
                            <div class="ctrl editable">
                                <i class="fa-regular fa-calendar"></i>
                                <input type="date" name="dateOfBirth" value="${staff.dateOfBirth}" readonly>
                                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
                            </div>
                        </div>

                        <!-- Phone -->
                        <div class="col-6 field">
                            <span class="label">Phone Number</span>
                            <div class="ctrl editable" id="phoneCtrl">
                                <i class="fa-solid fa-phone"></i>
                                <input id="phoneNumber" name="phoneNumber" value="${staff.phoneNumber}"
                                       placeholder="0xxxxxxxxx hoặc +84xxxxxxxxx" readonly>
                                <i class="fa-solid fa-pen-to-square edit-icon" onclick="enableEdit(this)"></i>
                            </div>
                            <div class="msg-error hidden" id="errPhone">Phone must be 10 digits starting with 0, or +84 + 9 digits.</div>
                        </div>
                    </div>

                    <div class="actions">
                        <!-- Nút bật/tắt form đổi mật khẩu (mới) -->
                        <button type="button" id="togglePasswordForm" class="btn btn-secondary">Change Password</button>

                        <button class="btn btn-primary" type="submit">
                            <i class="fa-regular fa-floppy-disk"></i> Save changes
                        </button>
                    </div>
                </form>

                <div class="divider"></div>

                <!-- Change password (chuẩn hóa theo mẫu) -->
                <div class="card shadow-sm mt-3 hidden" id="passwordCard">
                    <div class="body" style="padding-top: 16px;">
                        <h3 style="margin:0 0 16px 0; font-size:18px;">Change Password</h3>

                        <form method="post" id="passwordForm" action="${pageContext.request.contextPath}/profilestaff" novalidate>
                            <input type="hidden" name="action" value="changePassword"/>

                            <div class="grid pw-grid">
                                <!-- Current -->
                                <div class="col-4 field">
                                    <span class="label">Current Password</span>
                                    <div class="ctrl editable password-field" id="ctrlCur">
                                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Current password"/>
                                        <i class="fa-solid fa-eye-slash toggle-pass" onclick="togglePassword(this)"></i>
                                        <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                                    </div>
                                    <div class="msg-error hidden" id="errCur"></div>
                                </div>

                                <!-- New -->
                                <div class="col-4 field">
                                    <span class="label">New Password</span>
                                    <div class="ctrl editable password-field" id="ctrlNew">
                                        <input type="password" id="newPassword" name="newPassword" placeholder="New Password"/>
                                        <i class="fa-solid fa-eye-slash toggle-pass" onclick="togglePassword(this)"></i>
                                        <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                                    </div>
                                    <div class="msg-error hidden" id="errNew">Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.</div>
                                </div>

                                <!-- Confirm -->
                                <div class="col-4 field">
                                    <span class="label">Confirm Password</span>
                                    <div class="ctrl editable password-field" id="ctrlConfirm">
                                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password"/>
                                        <i class="fa-solid fa-eye-slash toggle-pass" onclick="togglePassword(this)"></i>
                                        <i class="fa-solid fa-circle-exclamation error-icon hidden"></i>
                                    </div>
                                    <div class="msg-error hidden" id="errConfirm">Passwords do not match.</div>
                                </div>
                            </div>

                            <div class="actions" style="justify-content:flex-end;">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fa-regular fa-floppy-disk"></i> Update Password
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <!-- Scripts -->
        <script>
            (() => {
            const form = document.getElementById('profileForm');
            if (!form) return;
            const phoneInput = document.getElementById('phoneNumber');
            const phoneCtrl = document.getElementById('phoneCtrl');
            const errPhone = document.getElementById('errPhone');
            // === CHỌN 1 TRONG 2 REGEX DƯỚI ĐÂY ===
            // 1) Cho phép 0xxxxxxxxx (10 số) HOẶC +84xxxxxxxxx (9 số):
            const reVN = /^(\+84[0-9]{9}|0[0-9]{9})$/;
            // Clear lỗi khi user gõ lại
            phoneInput.addEventListener('input', () => {
            phoneCtrl.classList.remove('invalid');
            errPhone.classList.add('hidden');
            });
            form.addEventListener('submit', (e) => {
            // Nếu đang readonly (chưa bấm bút), bỏ qua check để cho submit bình thường
            if (phoneInput.hasAttribute('readonly')) return;
            const v = (phoneInput.value || '').trim();
            if (!reVN.test(v)) {
            e.preventDefault();
            phoneCtrl.classList.add('invalid');
            errPhone.classList.remove('hidden');
            // Gợi ý message theo regex đang dùng
            errPhone.textContent = (reVN.toString().includes('\\+84'))
                    ? 'Invalid phone number. Please enter 0xxxxxxxxx (10 digits) or +84xxxxxxxxx (9 digits).'
                    : 'Invalid Phone. Please enter 10 digits starting with 0.';
            // Focus vào input
            phoneInput.focus();
            return;
            }

            // Hợp lệ -> submit
            // Không gọi e.preventDefault(), form sẽ submit bình thường
            });
            // Khi click bút enableEdit, bạn đã có hàm enableEdit(). Thêm xoá lỗi khi bật edit:
            const __oldEnableEdit = window.enableEdit;
            window.enableEdit = function(icon){
            __oldEnableEdit ? __oldEnableEdit(icon) : (function(){
            const ctrl = icon.closest('.ctrl');
            const input = ctrl.querySelector('input,select');
            if (input?.hasAttribute('readonly')) input.removeAttribute('readonly');
            if (input?.disabled) input.disabled = false;
            ctrl.classList.add('editing');
            input?.focus();
            })();
            // nếu đây là ô phone thì clear lỗi ngay khi bật edit
            const ctrl = icon.closest('.ctrl');
            if (ctrl && ctrl.id === 'phoneCtrl') {
            ctrl.classList.remove('invalid');
            errPhone.classList.add('hidden');
            }
            }
            })();</script>

        <script>
            // preview/reset avatar (đơn giản)
            const file = document.getElementById('avatarFile');
            const img = document.getElementById('avatarImg');
            const box = document.getElementById('avatarBox');
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

        <script>
            function enableEdit(icon){
            const ctrl = icon.closest('.ctrl');
            if (!ctrl) return;
            const input = ctrl.querySelector('input, select');
            if (!input) return;
            if (input.hasAttribute('readonly')) input.removeAttribute('readonly');
            if (input.disabled) input.disabled = false;
            ctrl.classList.add('editing');
            input.focus();
            }
            function editGender() {
            const text = document.getElementById('genderText');
            const select = document.getElementById('genderSelect');
            const ctrl = document.getElementById('genderCtrl');
            text.classList.add('hidden');
            select.classList.remove('hidden');
            ctrl.classList.add('editing');
            select.focus();
            select.addEventListener('change', () => {
            text.textContent = select.value;
            select.classList.add('hidden');
            text.classList.remove('hidden');
            ctrl.classList.remove('editing');
            });
            }
        </script>

        <!-- Toggle card Change Password -->
        <script>
            document.addEventListener('DOMContentLoaded', () => {
            const btnToggle = document.getElementById('togglePasswordForm');
            const passwordCard = document.getElementById('passwordCard');
            if (btnToggle && passwordCard) {
            btnToggle.addEventListener('click', () => {
            passwordCard.classList.toggle('hidden');
            btnToggle.textContent = passwordCard.classList.contains('hidden')
                    ? 'Change Password'
                    : 'Hide Change Password';
            if (!passwordCard.classList.contains('hidden')) {
            setTimeout(() => passwordCard.scrollIntoView({behavior:'smooth', block:'start'}), 50);
            }
            });
            }
            });
        </script>

        <!-- Validate Change Password -->
        <script>
            (function(){
            const form = document.getElementById('passwordForm');
            if (!form) return;
            const cur = document.getElementById('currentPassword');
            const nw = document.getElementById('newPassword');
            const cf = document.getElementById('confirmPassword');
            const ctrlCur = document.getElementById('ctrlCur');
            const ctrlNew = document.getElementById('ctrlNew');
            const ctrlCf = document.getElementById('ctrlConfirm');
            const errCur = document.getElementById('errCur');
            const errNew = document.getElementById('errNew');
            const errCf = document.getElementById('errConfirm');
            function setError(ctrl, errEl, msg){
            ctrl.classList.add('invalid');
            if (errEl){ errEl.textContent = msg; errEl.classList.remove('hidden');
            // Hiện icon ❗ nếu có
            const errIcon = ctrl.querySelector('.error-icon');
            if (errIcon) errIcon.classList.remove('hidden');
            }
            }
            function clearError(ctrl, errEl){
            ctrl.classList.remove('invalid');
            if (errEl){ errEl.classList.add('hidden'); }
            }
            function isStrong(pw){
            return /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(pw);
            }

            form.addEventListener('submit', (e) => {
            let ok = true;
            // Current (nếu chỉ muốn check rỗng thì bỏ nhánh isStrong)
            if (!cur.value.trim()){
            setError(ctrlCur, errCur, 'Current password cannot be blank.');
            ok = false;
            } else if (!isStrong(cur.value)){
            setError(ctrlCur, errCur, 'Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.');
            ok = false;
            } else {
            clearError(ctrlCur, errCur);
            }

            // New
            if (!nw.value.trim()){
            setError(ctrlNew, errNew, 'New password cannot be blank.');
            ok = false;
            } else if (!isStrong(nw.value)){
            setError(ctrlNew, errNew, 'Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.');
            ok = false;
            } else {
            clearError(ctrlNew, errNew);
            }

            // Confirm
            if (!cf.value.trim()){
            setError(ctrlCf, errCf, 'Confirm password cannot be blank.');
            ok = false;
            } else if (cf.value !== nw.value){
            setError(ctrlCf, errCf, 'Passwords do not match.');
            ok = false;
            } else {
            clearError(ctrlCf, errCf);
            }

            if (!ok){
            e.preventDefault();
            form.scrollIntoView({behavior:'smooth', block:'start'});
            }
            });
            })();
        </script>
        <script>
            function togglePassword(el) {
            const input = el.parentElement.querySelector('input');
            if (!input) return;
            if (input.type === 'password') {
            input.type = 'text';
            el.classList.remove('fa-eye-slash');
            el.classList.add('fa-eye');
            el.style.color = '#2563eb';
            } else {
            input.type = 'password';
            el.classList.add('fa-eye-slash');
            el.classList.remove('fa-eye');
            el.style.color = '#6b7280';
            }
            }
        </script>
        <script>
            document.querySelectorAll('.password-field input').forEach(input => {
            const field = input.closest('.password-field');
            const toggle = field.querySelector('.toggle-pass');
            const updateEye = () => {
            if (!toggle) return;
            if (input.value.trim() === '') {
            toggle.style.opacity = '0';
            toggle.style.pointerEvents = 'none';
            } else {
            toggle.style.opacity = '1';
            toggle.style.pointerEvents = 'auto';
            }
            };
            input.addEventListener('input', updateEye);
            updateEye();
            });
        </script>

    </body>
</html>
