<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${empty staff ? 'Add' : 'Edit'} Staff - NeoShoes Admin</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background: #f8f9fa;
                padding-top: 74px;
            }
            .main-content {
                margin-left: 300px;
                padding: 2rem;
            }
            .page-title {
                font-size: 28px;
                font-weight: 700;
                color: #111827;
                margin-bottom: .5rem;
            }
            .form-card {
                background: #fff;
                border-radius: 12px;
                padding: 2rem;
                box-shadow: 0 1px 3px rgba(0,0,0,.1);
                border: 1px solid #e5e7eb;
            }
            .form-label {
                font-weight: 600;
                color: #374151;
                margin-bottom: .5rem;
            }
            .required {
                color: #ef4444;
            }
            .btn-save {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border: none;
                padding: 10px 24px;
                border-radius: 8px;
                font-weight: 600;
            }
            .btn-save:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102,126,234,0.4);
            }
            .input-icon {
                position: relative;
            }
            .input-icon input,
            .input-icon select {
                padding-right: 40px;
                transition: all 0.3s ease;
                background-clip: padding-box;
                background-color: #ffffff !important;
            }
            /* Override autofill styles */
            .input-icon input:-webkit-autofill,
            .input-icon input:-webkit-autofill:hover,
            .input-icon input:-webkit-autofill:focus,
            .input-icon input:-webkit-autofill:active {
                -webkit-box-shadow: 0 0 0 1000px white inset !important;
                box-shadow: 0 0 0 1000px white inset !important;
                background-color: #ffffff !important;
            }
            .input-icon select {
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                background-color: #ffffff !important;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 16px;
            }
            .input-icon.has-left-icon input,
            .input-icon.has-left-icon select {
                padding-left: 45px;
            }
            .input-icon .icon-left {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #374151;
                font-size: 18px;
                pointer-events: none;
                z-index: 10;
            }
            /* Phone icon with bold stroke */
            .input-icon .icon-left.fa-phone {
                font-weight: 900;
                -webkit-text-stroke: 0.5px currentColor;
            }
            .input-icon input.editable,
            .input-icon select.editable {
                background-color: #fef9c3;
                border-color: #3b82f6;
                border-width: 2px;
            }
            .input-icon select.editable {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            }
            .input-icon .icon {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #3b82f6;
                font-size: 16px;
                cursor: pointer;
                pointer-events: auto;
                z-index: 10;
            }
            .input-icon .icon:hover {
                color: #2563eb;
            }
            /* Move calendar icon closer to edit icon */
            .input-icon input[type="date"]::-webkit-calendar-picker-indicator {
                position: absolute;
                right: 12px;
                cursor: pointer;
                opacity: 1;
                pointer-events: auto;
                transition: opacity 0.3s ease;
            }
            /* Show calendar icon when editable */
            .input-icon input[type="date"].editable::-webkit-calendar-picker-indicator {
                opacity: 1;
                pointer-events: auto;
            }
            /* Show dropdown arrow for select */
            .input-icon select {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") !important;
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 16px;
            }
            .input-icon select.editable {
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") !important;
            }
            /* Error state: red border, white background */
            .input-icon.error input,
            .input-icon.error select {
                border: 1.5px solid #dc2626 !important;
                background-color: #fff !important;
            }
            /* Success state: green border, white background */
            .input-icon.success input,
            .input-icon.success select {
                border: 1.5px solid #22c55e !important;
                background-color: #fff !important;
            }
            /* Unified focus style for all inputs - Higher specificity */
            .input-icon input.form-control:focus,
            .input-icon input:focus,
            .form-control:focus {
                border-color: #22c55e !important;
                box-shadow: 0 0 0 0.25rem rgba(34,197,94,0.15) !important;
                outline: 0 !important;
                background-color: #fff !important;
                -webkit-box-shadow: 0 0 0 1000px white inset !important;
                background-clip: padding-box !important;
            }
            /* If the wrapper has an error, keep focus styles red (override green focus) */
            .input-icon.error input.form-control:focus,
            .input-icon.error input:focus,
            .input-icon.error select.form-select:focus,
            .input-icon.error select:focus {
                border-color: #dc2626 !important;
                box-shadow: 0 0 0 0.15rem rgba(220,38,38,0.12) !important;
                outline: 0 !important;
                background-color: #fff !important;
            }
            /* Focus style for select - keep dropdown arrow */
            .input-icon select.form-select:focus,
            .input-icon select:focus,
            .form-select:focus {
                border-color: #22c55e !important;
                box-shadow: 0 0 0 0.25rem rgba(34,197,94,0.15) !important;
                outline: 0 !important;
                background-color: #fff !important;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E") !important;
                background-repeat: no-repeat !important;
                background-position: right 12px center !important;
                background-size: 16px !important;
            }
            /* Override autofill background on focus */
            .input-icon input:-webkit-autofill:focus,
            input.form-control:-webkit-autofill:focus {
                -webkit-box-shadow: 0 0 0 1000px white inset !important;
                background-color: #ffffff !important;
            }
            /* Hide default password reveal button */
            input[type="password"]::-ms-reveal,
            input[type="password"]::-ms-clear {
                display: none;
            }
            input[type="password"]::-webkit-contacts-auto-fill-button,
            input[type="password"]::-webkit-credentials-auto-fill-button {
                display: none !important;
                visibility: hidden;
                pointer-events: none;
                position: absolute;
                right: 0;
            }
            .text-danger {
                color: #dc2626;
                font-size: 13px;
                margin-top: 4px;
                display: block;
            }
            .d-none {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/staff/common/staff-header.jsp"/>
        <jsp:include page="/WEB-INF/views/staff/common/staff-sidebar.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <div class="main-content">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-user-${empty staff ? 'plus' : 'edit'}"></i> 
                        ${empty staff ? 'Add New' : 'Edit'} Staff
                    </h1>
                    <p class="text-muted">${empty staff ? 'Create a new staff member account' : 'Update staff member information'}</p>
                </div>
                
            </div>

            <!-- Form -->
            <div class="form-card">
                <form method="post" action="${pageContext.request.contextPath}/manage-staff">
                    <input type="hidden" name="action" value="${empty staff ? 'create' : 'update'}">
                    <c:if test="${not empty staff}">
                        <input type="hidden" name="staffId" value="${staff.staffId}">
                    </c:if>

                    <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Full Name <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="nameWrapper">
                                    <i class="far fa-user icon-left"></i>
                                    <input type="text" id="nameInput" name="name" class="form-control" 
                                           value="${not empty staff ? staff.name : ''}" placeholder="Full name">
                                </div>
                                <small class="text-danger d-none" id="nameError">
                                    Full name is required.
                                </small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Role</label>
                                <div class="input-icon has-left-icon">
                                    <i class="far fa-id-badge icon-left"></i>
                                    <input type="text" class="form-control" value="Staff" readonly disabled>
                                </div>
                                <input type="hidden" name="role" value="staff">
                            </div> 


                        <!-- Email (editable for both Add and Edit) -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email <span class="required">*</span></label>
                            <div class="input-icon has-left-icon" id="emailWrapper">
                                <i class="far fa-envelope icon-left"></i>
                                <input type="text" id="emailInput" name="email" class="form-control" placeholder="email@example.com" value="${not empty staff ? staff.email : ''}">
                            </div>
                            <small class="text-danger d-none" id="emailError">
                                Invalid email format. Email must contain '@' and a domain (e.g., name@example.com).
                            </small>
                        </div>

                        <c:if test="${not empty staff}">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Staff ID</label>
                                <input type="text" class="form-control" value="#${staff.staffId}" readonly disabled>
                            </div>
                        </c:if>

                        <!-- Password only when adding -->
                        <c:if test="${empty staff}">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Password <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="passwordWrapper">
                                    <i class="fas fa-lock icon-left"></i>
                                    <input type="password" id="passwordInput" name="password" class="form-control" placeholder="password@123" style="padding-right: 50px;">
                                    <i class="fas fa-eye-slash icon d-none" id="togglePasswordIcon" style="cursor: pointer; right: 15px; pointer-events: auto;"></i>
                                </div>
                                <small class="text-danger d-none" id="passwordError">
                                    Password must be at least 8 characters, contain uppercase, lowercase, number and special character
                                </small>
                            </div>
                        </c:if>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Gender <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="genderWrapper" style="position: relative;">
                                    <i class="fas fa-venus-mars icon-left"></i>
                                    <select name="gender" id="genderSelect" class="form-select" size="1">
                                        <option value="">— Select — </option>
                                        <option value="Male" ${not empty staff && staff.gender eq 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${not empty staff && staff.gender eq 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${not empty staff && staff.gender eq 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                    <!-- Overlay to block clicks except on dropdown icon -->
                                    <div id="genderOverlay" style="position: absolute; left: 0; top: 0; right: 40px; bottom: 0; z-index: 15;"></div>
                                </div>
                                <small class="text-danger d-none" id="genderError">
                                    Gender is required.
                                </small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Address <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="addressWrapper">
                                    <i class="fas fa-location-dot icon-left"></i>
                                    <input type="text" id="addressInput" name="address" class="form-control" value="${not empty staff ? staff.address : ''}" placeholder="Street, City, ...">
                                </div>
                                <small class="text-danger d-none" id="addressError">
                                    Address is required.
                                </small>
                            </div> 

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date of Birth <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="dobWrapper">
                                    <i class="far fa-calendar icon-left"></i>
                                    <input type="date" id="dobInput" name="dateOfBirth" class="form-control" 
                                           value="${not empty staff ? staff.dateOfBirth : ''}">
                                </div>
                                <small class="text-danger d-none" id="dobError">
                                    Date of birth is required.
                                </small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone Number <span class="required">*</span></label>
                                <div class="input-icon has-left-icon" id="phoneWrapper">
                                    <i class="far fa-phone icon-left"></i>
                                    <input type="tel" id="phoneInput" name="phone" class="form-control" 
                                           value="${not empty staff ? staff.phoneNumber : ''}" 
                                           placeholder="0xxxxxxxxx or +84xxxxxxxxx">
                                </div>
                                <small class="text-danger d-none" id="phoneError">
                                    Invalid phone number. Please enter 0xxxxxxxxx (10 digits) or +84xxxxxxxxx (9 digits).
                                </small>
                            </div>


                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <a href="${pageContext.request.contextPath}/manage-staff" class="btn btn-outline-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save"></i> ${empty staff ? 'Create' : 'Update'} Staff
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Enable editing when clicking the icon
            document.addEventListener('DOMContentLoaded', function() {
                const editIcons = document.querySelectorAll('.input-icon .icon');
                
                editIcons.forEach(icon => {
                    icon.addEventListener('click', function() {
                        const inputWrapper = this.closest('.input-icon');
                        const input = inputWrapper.querySelector('input, select');
                        
                        if (input) {
                            // Toggle editable state
                            input.classList.toggle('editable');
                            
                            // Focus on input if adding editable class
                            if (input.classList.contains('editable')) {
                                input.focus();
                                input.removeAttribute('readonly');
                            } else {
                                input.setAttribute('readonly', 'readonly');
                            }
                        }
                    });
                });
            });
            
            function confirmDelete(staffId, staffName) {
                if (confirm('Are you sure you want to delete staff: ' + staffName + '?\n\nThis action cannot be undone!')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/manage-staff';

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete';
                    form.appendChild(actionInput);

                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = staffId;
                    form.appendChild(idInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Full Name validation
            document.addEventListener('DOMContentLoaded', function() {
                const nameInput = document.getElementById('nameInput');
                const nameWrapper = document.getElementById('nameWrapper');
                const nameError = document.getElementById('nameError');
                const staffForm = document.querySelector('form');

                if (nameInput && nameWrapper && nameError && staffForm) {
                    // Xóa lỗi khi user bắt đầu nhập
                    nameInput.addEventListener('input', function() {
                        if (nameInput.value.trim()) {
                            nameWrapper.classList.remove('error');
                            nameWrapper.classList.add('success');
                            nameError.classList.add('d-none');
                        } else {
                            nameWrapper.classList.remove('success');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        const value = nameInput.value.trim();
                        if (!value) {
                            e.preventDefault();
                            nameWrapper.classList.remove('success');
                            nameWrapper.classList.add('error');
                            nameError.textContent = 'Full name is required.';
                            nameError.classList.remove('d-none');
                            nameInput.focus();
                            nameInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            nameWrapper.classList.remove('error');
                            nameWrapper.classList.add('success');
                            nameError.classList.add('d-none');
                        }
                    });
                }
            });

            // Phone number validation
            document.addEventListener('DOMContentLoaded', function() {
                const phoneInput = document.getElementById('phoneInput');
                const phoneWrapper = document.getElementById('phoneWrapper');
                const phoneError = document.getElementById('phoneError');
                const staffForm = document.querySelector('form');

                console.log('Phone validation initialized:', {
                    phoneInput: phoneInput,
                    phoneWrapper: phoneWrapper,
                    phoneError: phoneError,
                    staffForm: staffForm
                });

                if (phoneInput && phoneWrapper && phoneError && staffForm) {
                    const phoneRegex = /^(\+84[0-9]{9}|0[0-9]{9})$/;
                    console.log('Phone validation attached to form');

                    // Chặn nhập ký tự không hợp lệ
                    phoneInput.addEventListener('keypress', function(e) {
                        const char = String.fromCharCode(e.which);
                        // Chỉ cho phép số 0-9 và dấu +
                        if (!/[0-9+]/.test(char)) {
                            e.preventDefault();
                            return false;
                        }
                        // Dấu + chỉ được phép ở đầu
                        if (char === '+' && this.value.length > 0) {
                            e.preventDefault();
                            return false;
                        }
                    });

                    // Chặn paste ký tự không hợp lệ
                    phoneInput.addEventListener('paste', function(e) {
                        setTimeout(() => {
                            this.value = this.value.replace(/[^0-9+]/g, '');
                        }, 10);
                    });

                    phoneInput.addEventListener('input', function() {
                        if (phoneInput.value.trim() && phoneRegex.test(phoneInput.value.trim())) {
                            phoneWrapper.classList.remove('error');
                            phoneWrapper.classList.add('success');
                            phoneError.classList.add('d-none');
                        } else {
                            phoneWrapper.classList.remove('success');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        const value = phoneInput.value.trim();
                        // Kiểm tra rỗng
                        if (!value) {
                            e.preventDefault();
                            phoneWrapper.classList.remove('success');
                            phoneWrapper.classList.add('error');
                            phoneError.textContent = 'Phone number is required.';
                            phoneError.classList.remove('d-none');
                            phoneInput.focus();
                            phoneInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        }
                        // Validate format
                        if (!phoneRegex.test(value)) {
                            e.preventDefault();
                            phoneWrapper.classList.remove('success');
                            phoneWrapper.classList.add('error');
                            phoneError.textContent = 'Invalid phone number. Please enter 0xxxxxxxxx (10 digits) or +84xxxxxxxxx (9 digits).';
                            phoneError.classList.remove('d-none');
                            phoneInput.focus();
                            phoneInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            phoneWrapper.classList.remove('error');
                            phoneWrapper.classList.add('success');
                            phoneError.classList.add('d-none');
                        }
                    });
                } else {
                    console.error('Phone validation elements not found!');
                }
            });

            // Email validation
            document.addEventListener('DOMContentLoaded', function() {
                const emailInput = document.getElementById('emailInput');
                const emailWrapper = document.getElementById('emailWrapper');
                const emailError = document.getElementById('emailError');
                const staffForm = document.querySelector('form');

                if (emailInput && emailWrapper && emailError && staffForm) {
                    // Email regex pattern - chuẩn nghiệp vụ
                    // - Phải có ít nhất 1 ký tự trước @
                    // - Phải có @ duy nhất
                    // - Domain phải có ít nhất 1 ký tự trước dấu chấm
                    // - Phải có dấu chấm
                    // - Phần sau dấu chấm phải có 2-6 ký tự (như .com, .vn, .co.uk)
                    const emailRegex = /^[a-zA-Z0-9]+([._-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.-]?[a-zA-Z0-9]+)*\.[a-zA-Z]{2,6}$/;

                    emailInput.addEventListener('input', function() {
                        if (emailInput.value.trim() && emailRegex.test(emailInput.value.trim())) {
                            emailWrapper.classList.remove('error');
                            emailWrapper.classList.add('success');
                            emailError.classList.add('d-none');
                        } else {
                            emailWrapper.classList.remove('success');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        const value = emailInput.value.trim();
                        if (!value) {
                            e.preventDefault();
                            emailWrapper.classList.remove('success');
                            emailWrapper.classList.add('error');
                            emailError.textContent = 'Email is required.';
                            emailError.classList.remove('d-none');
                            emailInput.focus();
                            emailInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        }
                        if (!emailRegex.test(value)) {
                            e.preventDefault();
                            emailWrapper.classList.remove('success');
                            emailWrapper.classList.add('error');
                            emailError.textContent = 'Invalid email format. Email must contain @ and a domain (e.g., name@example.com).';
                            emailError.classList.remove('d-none');
                            emailInput.focus();
                            emailInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            emailWrapper.classList.remove('error');
                            emailWrapper.classList.add('success');
                            emailError.classList.add('d-none');
                        }
                    });
                }
            });

            // Password validation
            document.addEventListener('DOMContentLoaded', function() {
                const passwordInput = document.getElementById('passwordInput');
                const passwordWrapper = document.getElementById('passwordWrapper');
                const passwordError = document.getElementById('passwordError');
                const staffForm = document.querySelector('form');

                if (passwordInput && passwordWrapper && passwordError && staffForm) {
                    // Password regex - Quy tắc nghiệp vụ chuẩn:
                    // - Ít nhất 8 ký tự
                    // - Có ít nhất 1 chữ hoa (A-Z)
                    // - Có ít nhất 1 chữ thường (a-z)
                    // - Có ít nhất 1 số (0-9)
                    // - Có ít nhất 1 ký tự đặc biệt (@$!%*?&)
                    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

                    // Xóa lỗi khi user bắt đầu nhập lại
                    passwordInput.addEventListener('input', function() {
                        passwordWrapper.classList.remove('error');
                        passwordError.classList.add('d-none');
                    });

                    // Validate khi submit form
                    staffForm.addEventListener('submit', function(e) {
                        const value = passwordInput.value;
                        
                        // Kiểm tra rỗng
                        if (!value) {
                            e.preventDefault();
                            passwordWrapper.classList.add('error');
                            passwordError.textContent = 'Password is required.';
                            passwordError.classList.remove('d-none');
                            passwordInput.focus();
                            passwordInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        }

                        // Kiểm tra độ dài tối thiểu
                        if (value.length < 8) {
                            e.preventDefault();
                            passwordWrapper.classList.add('error');
                            passwordError.textContent = 'Password must be at least 8 characters long.';
                            passwordError.classList.remove('d-none');
                            passwordInput.focus();
                            passwordInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        }

                        // Kiểm tra quy tắc mạnh
                        if (!passwordRegex.test(value)) {
                            e.preventDefault();
                            passwordWrapper.classList.add('error');
                            let missingRequirements = [];
                            if (!/[a-z]/.test(value)) missingRequirements.push('lowercase');
                            if (!/[A-Z]/.test(value)) missingRequirements.push('uppercase');
                            if (!/\d/.test(value)) missingRequirements.push('number');
                            if (!/[@$!%*?&]/.test(value)) missingRequirements.push('special character');
                            
                            passwordError.textContent = 'Password must be at least 8 characters, contain uppercase, lowercase, number and special character.';
                            passwordError.classList.remove('d-none');
                            passwordInput.focus();
                            passwordInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        }
                    });
                }
            });

            // Toggle password visibility
            document.addEventListener('DOMContentLoaded', function() {
                const togglePasswordIcon = document.getElementById('togglePasswordIcon');
                const passwordInput = document.getElementById('passwordInput');

                if (togglePasswordIcon && passwordInput) {
                    // Hiện/ẩn con mắt khi user nhập
                    passwordInput.addEventListener('input', function() {
                        if (passwordInput.value.length > 0) {
                            togglePasswordIcon.classList.remove('d-none');
                        } else {
                            togglePasswordIcon.classList.add('d-none');
                        }
                    });

                    togglePasswordIcon.addEventListener('click', function() {
                        // Toggle type attribute
                        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                        passwordInput.setAttribute('type', type);
                        
                        // Toggle icon - Mắt có gạch khi ẩn, mắt mở khi hiện
                        if (type === 'password') {
                            togglePasswordIcon.classList.remove('fa-eye');
                            togglePasswordIcon.classList.add('fa-eye-slash');
                        } else {
                            togglePasswordIcon.classList.remove('fa-eye-slash');
                            togglePasswordIcon.classList.add('fa-eye');
                        }
                    });
                }
            });

            // Gender dropdown - chỉ mở khi click vào icon
            document.addEventListener('DOMContentLoaded', function() {
                const genderSelect = document.getElementById('genderSelect');
                const genderOverlay = document.getElementById('genderOverlay');

                if (genderSelect && genderOverlay) {
                    // Khi click vào overlay (phần ô select) → focus select để có viền xanh
                    genderOverlay.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        genderSelect.focus(); // Focus để có viền xanh, nhưng không mở dropdown
                    });

                    // Prevent dropdown from opening when clicking on the overlay area
                    genderSelect.addEventListener('mousedown', function(e) {
                        const rect = genderSelect.getBoundingClientRect();
                        const clickX = e.clientX;
                        
                        // Nếu click vào vùng bên trái (không phải vùng dropdown arrow)
                        if (clickX < rect.right - 40) {
                            e.preventDefault();
                            e.stopPropagation();
                            genderSelect.focus(); // Chỉ focus, không mở dropdown
                            return false;
                        }
                        // Nếu click vào vùng dropdown arrow (40px bên phải) → cho phép mở
                    });

                    // Khi user chọn xong
                    genderSelect.addEventListener('change', function() {
                        genderSelect.blur(); // Bỏ focus sau khi chọn
                    });
                }
            });

            // Gender validation
            document.addEventListener('DOMContentLoaded', function() {
                const genderSelect = document.getElementById('genderSelect');
                const genderWrapper = document.getElementById('genderWrapper');
                const genderError = document.getElementById('genderError');
                const staffForm = document.querySelector('form');

                if (genderSelect && genderWrapper && genderError && staffForm) {
                    genderSelect.addEventListener('change', function() {
                        if (genderSelect.value) {
                            genderWrapper.classList.remove('error');
                            genderWrapper.classList.add('success');
                            genderError.classList.add('d-none');
                        } else {
                            genderWrapper.classList.remove('success');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        if (!genderSelect.value) {
                            e.preventDefault();
                            genderWrapper.classList.remove('success');
                            genderWrapper.classList.add('error');
                            genderError.classList.remove('d-none');
                            genderSelect.focus();
                            genderSelect.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            genderWrapper.classList.remove('error');
                            genderWrapper.classList.add('success');
                            genderError.classList.add('d-none');
                        }
                    });
                }
            });

            // Date of Birth validation
            document.addEventListener('DOMContentLoaded', function() {
                const dobInput = document.getElementById('dobInput');
                const dobWrapper = document.getElementById('dobWrapper');
                const dobError = document.getElementById('dobError');
                const staffForm = document.querySelector('form');

                if (dobInput && dobWrapper && dobError && staffForm) {
                    dobInput.addEventListener('change', function() {
                        if (dobInput.value) {
                            dobWrapper.classList.remove('error');
                            dobWrapper.classList.add('success');
                            dobError.classList.add('d-none');
                        } else {
                            dobWrapper.classList.remove('success');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        if (!dobInput.value) {
                            e.preventDefault();
                            dobWrapper.classList.remove('success');
                            dobWrapper.classList.add('error');
                            dobError.classList.remove('d-none');
                            dobInput.focus();
                            dobInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            dobWrapper.classList.remove('error');
                            dobWrapper.classList.add('success');
                            dobError.classList.add('d-none');
                        }
                    });
                }
            });

            // Address validation
            document.addEventListener('DOMContentLoaded', function() {
                const addressInput = document.getElementById('addressInput');
                const addressWrapper = document.getElementById('addressWrapper');
                const addressError = document.getElementById('addressError');
                const staffForm = document.querySelector('form');

                if (addressInput && addressWrapper && addressError && staffForm) {
                    addressInput.addEventListener('input', function() {
                        if (addressInput.value.trim()) {
                            addressWrapper.classList.remove('error');
                            addressWrapper.classList.add('success');
                            addressError.classList.add('d-none');
                        } else {
                            addressWrapper.classList.remove('success');
                            addressWrapper.classList.add('error');
                            addressError.classList.remove('d-none');
                        }
                    });

                    // Khi load trang hoặc khi input rỗng, luôn hiển thị viền đỏ
                    document.addEventListener('DOMContentLoaded', function() {
                        if (addressInput && addressWrapper && addressError) {
                            if (!addressInput.value.trim()) {
                                addressWrapper.classList.remove('success');
                                addressWrapper.classList.add('error');
                                addressError.classList.remove('d-none');
                            }
                        }
                    });

                    // Đảm bảo khi nhập lại, nếu rỗng thì chỉ có class 'error', không có 'success'
                    addressInput.addEventListener('blur', function() {
                        if (!addressInput.value.trim()) {
                            addressWrapper.classList.remove('success');
                            addressWrapper.classList.add('error');
                            addressError.classList.remove('d-none');
                        }
                    });

                    staffForm.addEventListener('submit', function(e) {
                        const value = addressInput.value.trim();
                        if (!value) {
                            e.preventDefault();
                            addressWrapper.classList.remove('success');
                            addressWrapper.classList.add('error');
                            addressError.classList.remove('d-none');
                            // Khi focus vào input address, vẫn giữ class 'error' (viền đỏ)
                            setTimeout(function() {
                                addressWrapper.classList.remove('success');
                                addressWrapper.classList.add('error');
                            }, 10);
                            addressInput.focus();
                            addressInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            return false;
                        } else {
                            addressWrapper.classList.remove('error');
                            addressWrapper.classList.add('success');
                            addressError.classList.add('d-none');
                        }
                    });
                }
            });
        </script>
    </body>
</html>
