<%-- 
    Document   : profile
    Created on : Sep 28, 2025, 2:48:39 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <title>My Profile</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>
    </head> 
    <style>
        /* Global Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        /* Card Styles */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        /* Button Styles */
        .btn {
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        /* Profile Page Styles */
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 1rem;
            border-radius: 0 0 15px 15px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border: 4px solid #fff;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .profile-info-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        /* Form Styles */
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #ced4da;
            transition: border-color 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
        }

        /* Validation form */
        .form-floating {
            position: relative;
            margin-bottom: 15px;
        }

        .form-floating.success input,
        .form-floating.success select {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.25);
        }

        .form-floating.error input,
        .form-floating.error select {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220,53,69,0.25);
        }

        .form-floating.error .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        /* Address form error messages */
        .address-form-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }

        .address-form-error.show {
            display: block;
        }

        /* Orders Container */
        .orders-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px 0;
        }

        /* Customer Sidebar */
        .customer-sidebar {
            max-height: 500px;
            overflow-y: auto;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .customer-sidebar {
                width: 100%;
                margin-top: 20px;
                height: auto;
                min-height: auto !important;
                max-height: none;
            }
        }
    </style>
    <body class="bg-light">

        <jsp:include page="common/header.jsp"/>
        <jsp:include page="/WEB-INF/views/common/notification.jsp" />
        <c:if test="${empty sessionScope.customer}">
            <c:redirect url="${pageContext.request.contextPath}/login"/>
        </c:if>
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
                            <!-- Profile Form -->
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h3 class="mb-3">Customer Profile</h3>
                                    <form method="post" id="profileForm" 
                                          action="${pageContext.request.contextPath}/profile" 
                                          enctype="multipart/form-data">
                                        <input type="hidden" name="id" value="${sessionScope.customer.id}"/>
                                        <input type="hidden" name="action" value="updateProfile"/>
                                        <div class="row g-3">
                                            <div class="col-md-3 text-center">
                                                <div class="avatar-upload d-flex flex-column align-items-center" id="avatarUpload">
                                                    <img src="${empty customer.avatar ? 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg' : customer.avatar}" 
                                                         id="avatarPreview" 
                                                         class="avatar-preview img-thumbnail rounded-circle mb-2" 
                                                         style="width:160px;height:160px;object-fit:cover" />
                                                    <span id="avatarText" class="text-muted">Drag and drop or click on avatar to select file</span>
                                                    <input type="file" name="avatar" id="avatarInput" accept="image/*" class="d-none">
                                                </div>
                                            </div>
                                            <div class="col-md-9">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <div class="form-floating">
                                                            <input name="name" id="name" class="form-control" value="${customer.name}" placeholder="Full name"/>
                                                            <label for="name">Full name</label>
                                                            <div class="invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-floating">
                                                            <input name="phone" id="phone" class="form-control" value="${customer.phoneNumber}" placeholder="Phone"/>
                                                            <label for="phone">Phone</label>
                                                            <div class="invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-floating">
                                                            <input name="email" id="email" class="form-control" value="${customer.email}" placeholder="Email" disabled />
                                                            <label for="email">Email (read-only)</label>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-floating">
                                                            <select class="form-select" id="gender" name="gender">
                                                                <option value="" ${empty customer.gender ? 'selected' : ''}>— Select —</option>
                                                                <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Male</option>
                                                                <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Female</option>
                                                                <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Other</option>
                                                            </select>
                                                            <label for="gender">Gender</label>
                                                            <div class="invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="mt-3 d-flex gap-2 justify-content-end">
                                                    <button type="button" id="togglePasswordForm" class="btn btn-outline-secondary">
                                                        Change Password
                                                    </button>
                                                    <button class="btn btn-primary" type="submit">Save changes</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Change password -->
                            <div class="card shadow-sm mt-3 d-none" id="passwordCard">
                                <div class="card-body">
                                    <h3 class="mb-3">Change Password</h3>
                                    <form method="post" id="passwordForm" action="${pageContext.request.contextPath}/profile">
                                        <input type="hidden" name="id" value="${sessionScope.customer.id}"/>
                                        <input type="hidden" name="action" value="changePassword"/>
                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <div class="form-floating">
                                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Current password" />
                                                    <label for="currentPassword">Current password</label>
                                                    <div class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-floating">
                                                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="New password" />
                                                    <label for="newPassword">New password</label>
                                                    <div class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-floating">
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm password"/>
                                                    <label for="confirmPassword">Confirm password</label>
                                                    <div class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mt-3 d-flex justify-content-end">
                                            <button class="btn btn-primary" type="submit">Update password</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Address Management -->                      
                            <div class="card shadow-sm mt-3 p-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h3 class="mb-0">Address</h3>
                                    <button type="button" id="toggleAddAddressForm" class="btn btn-primary btn-sm">
                                        Add New Address
                                    </button>
                                </div>

                                <!-- Add Address Form with Validation -->
                                <div class="d-none" id="addAddressCard">
                                    <div class="border rounded p-3 mb-3 bg-light">
                                        <h5 class="mb-3">Add New Address</h5>
                                        <form method="post" id="addAddressForm" action="${pageContext.request.contextPath}/address">
                                            <input type="hidden" name="addressAction" value="addAddress" />
                                            <input type="hidden" name="customerId" value="${sessionScope.customer.id}" />

                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input name="addressName" type="text" id="addAddressName" 
                                                               class="form-control" placeholder="Address Name" 
                                                               maxlength="100" required />
                                                        <label for="addAddressName">Address Name <span class="text-danger">*</span></label>
                                                        <div class="address-form-error" id="addAddressNameError"></div>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input name="recipientName" type="text" id="addRecipientName" 
                                                               class="form-control" placeholder="Recipient Name" 
                                                               maxlength="100" required />
                                                        <label for="addRecipientName">Recipient Name <span class="text-danger">*</span></label>
                                                        <div class="address-form-error" id="addRecipientNameError"></div>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input name="recipientPhone" type="tel" id="addRecipientPhone" 
                                                               class="form-control" placeholder="Phone Number" 
                                                               pattern="^0\d{9}$" maxlength="10" required />
                                                        <label for="addRecipientPhone">Phone Number <span class="text-danger">*</span></label>
                                                        <small class="text-muted">Format: 0xxxxxxxxx (10 digits)</small>
                                                        <div class="address-form-error" id="addRecipientPhoneError"></div>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input name="addressDetails" type="text" id="addAddressDetails" 
                                                               class="form-control" placeholder="Address Details" 
                                                               maxlength="500" required />
                                                        <label for="addAddressDetails">Address Details <span class="text-danger">*</span></label>
                                                        <div class="address-form-error" id="addAddressDetailsError"></div>
                                                    </div>
                                                </div>

                                                <div class="col-12">
                                                    <div class="form-check">
                                                        <input type="checkbox" class="form-check-input" 
                                                               id="addIsDefault" name="isDefault" value="true" />
                                                        <label class="form-check-label" for="addIsDefault">
                                                            Set as default address
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mt-3 d-flex gap-2 justify-content-end">
                                                <button type="button" class="btn btn-secondary" 
                                                        onclick="cancelAddAddress()">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Add Address</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Address List with Validation -->
                                <c:forEach var="addr" items="${addressList}">
                                    <div class="border rounded p-3 mb-3">
                                        <form method="post" action="${pageContext.request.contextPath}/address" 
                                              id="addressForm-${addr.addressId}">
                                            <input type="hidden" name="addressAction" value="updateAddress"/>
                                            <input type="hidden" name="addressId" value="${addr.addressId}"/>
                                            <input type="hidden" name="customerId" value="${sessionScope.customer.id}" />

                                            <div class="mb-2">
                                                <div class="form-floating">
                                                    <input type="text" class="form-control" name="addressName" 
                                                           id="addressName-${addr.addressId}" 
                                                           value="${fn:escapeXml(addr.addressName)}" 
                                                           maxlength="100" readonly required/>
                                                    <label for="addressName-${addr.addressId}">Address Name</label>
                                                    <div class="address-form-error" id="addressNameError-${addr.addressId}"></div>
                                                </div>
                                            </div>

                                            <div class="mb-2">
                                                <div class="form-floating">
                                                    <input type="text" class="form-control" name="recipientName"
                                                           id="recipientName-${addr.addressId}" 
                                                           value="${fn:escapeXml(addr.recipientName)}" 
                                                           maxlength="100" readonly required/>
                                                    <label for="recipientName-${addr.addressId}">Recipient</label>
                                                    <div class="address-form-error" id="recipientNameError-${addr.addressId}"></div>
                                                </div>
                                            </div>

                                            <div class="mb-2">
                                                <div class="form-floating">
                                                    <input type="tel" class="form-control" name="recipientPhone"
                                                           id="recipientPhone-${addr.addressId}" 
                                                           value="${fn:escapeXml(addr.recipientPhone)}" 
                                                           pattern="^0\d{9}$" maxlength="10" readonly required/>
                                                    <label for="recipientPhone-${addr.addressId}">Phone</label>
                                                    <div class="address-form-error" id="recipientPhoneError-${addr.addressId}"></div>
                                                </div>
                                            </div>

                                            <div class="mb-2">
                                                <div class="form-floating">
                                                    <input type="text" class="form-control" name="addressDetails"
                                                           id="addressDetails-${addr.addressId}" 
                                                           value="${fn:escapeXml(addr.addressDetails)}" 
                                                           maxlength="500" readonly required/>
                                                    <label for="addressDetails-${addr.addressId}">Details</label>
                                                    <div class="address-form-error" id="addressDetailsError-${addr.addressId}"></div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="isDefault" value="true"
                                                           id="isDefault-${addr.addressId}" disabled
                                                           <c:if test="${addr.isDefault}">checked</c:if>>
                                                    <label class="form-check-label" for="isDefault-${addr.addressId}">
                                                        Default Address
                                                        <c:if test="${addr.isDefault}">
                                                            <span class="badge bg-success ms-2">Current Default</span>
                                                        </c:if>
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-end gap-2">
                                                <div id="viewButtons-${addr.addressId}">
                                                    <button type="button" class="btn btn-primary btn-sm" 
                                                            onclick="enableEdit(${addr.addressId})">Edit</button>
                                                    <c:if test="${!addr.isDefault or fn:length(addressList) > 1}">
                                                        <button type="button" class="btn btn-danger btn-sm" 
                                                                onclick="deleteAddress(${addr.addressId})">Delete</button>
                                                    </c:if>
                                                </div>

                                                <div id="editButtons-${addr.addressId}" class="d-none">
                                                    <button type="button" class="btn btn-secondary btn-sm" 
                                                            data-address-id="${addr.addressId}"
                                                            data-address-name="${fn:escapeXml(addr.addressName)}"
                                                            data-recipient-name="${fn:escapeXml(addr.recipientName)}"
                                                            data-recipient-phone="${fn:escapeXml(addr.recipientPhone)}"
                                                            data-address-details="${fn:escapeXml(addr.addressDetails)}"
                                                            data-is-default="${addr.isDefault}"
                                                            onclick="cancelEditFromData(this)">Cancel</button>
                                                    <button type="submit" class="btn btn-success btn-sm">Save Changes</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </c:forEach>

                                <!-- Empty state -->
                                <c:if test="${empty addressList}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="fas fa-map-marker-alt fa-3x mb-3"></i>
                                        <p>No addresses added yet. Click "Add New Address" to get started.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/lucide@latest"></script>

        <script>
                                                                // ===== UTILITY FUNCTIONS =====
                                                                function setErrorInput(input, message) {
                                                                    const formFloating = input.closest('.form-floating');
                                                                    formFloating.classList.add('error');
                                                                    formFloating.classList.remove('success');
                                                                    const feedback = formFloating.querySelector('.invalid-feedback');
                                                                    if (feedback) {
                                                                        feedback.textContent = message;
                                                                    }
                                                                }

                                                                function setSuccessInput(input) {
                                                                    const formFloating = input.closest('.form-floating');
                                                                    formFloating.classList.add('success');
                                                                    formFloating.classList.remove('error');
                                                                    const feedback = formFloating.querySelector('.invalid-feedback');
                                                                    if (feedback) {
                                                                        feedback.textContent = '';
                                                                    }
                                                                }

                                                                function showError(input, errorElement, message) {
                                                                    input.classList.add('is-invalid');
                                                                    errorElement.textContent = message;
                                                                    errorElement.classList.add('show');
                                                                }

                                                                function clearError(input, errorElement) {
                                                                    input.classList.remove('is-invalid');
                                                                    errorElement.textContent = '';
                                                                    errorElement.classList.remove('show');
                                                                }

                                                                // ===== AVATAR UPLOAD =====
                                                                document.addEventListener("DOMContentLoaded", () => {
                                                                    const avatarUpload = document.getElementById('avatarUpload');
                                                                    const avatarInput = document.getElementById('avatarInput');
                                                                    const avatarPreview = document.getElementById('avatarPreview');

                                                                    avatarUpload.addEventListener('click', () => {
                                                                        avatarInput.click();
                                                                    });

                                                                    avatarInput.addEventListener('change', (e) => {
                                                                        if (e.target.files.length > 0) {
                                                                            const file = e.target.files[0];
                                                                            const reader = new FileReader();

                                                                            reader.onload = (e) => {
                                                                                avatarPreview.src = e.target.result;
                                                                                avatarPreview.style.display = 'block';
                                                                            };

                                                                            reader.readAsDataURL(file);
                                                                        }
                                                                    });

                                                                    // Drag and drop
                                                                    avatarUpload.addEventListener('dragover', (e) => {
                                                                        e.preventDefault();
                                                                        avatarUpload.style.borderColor = '#0d6efd';
                                                                    });

                                                                    avatarUpload.addEventListener('dragleave', () => {
                                                                        avatarUpload.style.borderColor = '#dee2e6';
                                                                    });

                                                                    avatarUpload.addEventListener('drop', (e) => {
                                                                        e.preventDefault();
                                                                        avatarUpload.style.borderColor = '#dee2e6';

                                                                        if (e.dataTransfer.files.length > 0) {
                                                                            avatarInput.files = e.dataTransfer.files;
                                                                            const file = e.dataTransfer.files[0];
                                                                            const reader = new FileReader();

                                                                            reader.onload = (e) => {
                                                                                avatarPreview.src = e.target.result;
                                                                                avatarPreview.style.display = 'block';
                                                                            };

                                                                            reader.readAsDataURL(file);
                                                                        }
                                                                    });
                                                                });

                                                                // ===== PROFILE FORM VALIDATION =====
                                                                const profileForm = document.getElementById("profileForm");
                                                                const nameInput = document.getElementById("name");
                                                                const phoneInput = document.getElementById("phone");
                                                                const genderSelect = document.getElementById("gender");

                                                                profileForm.addEventListener("submit", e => {
                                                                    e.preventDefault();
                                                                    if (checkProfileInputs()) {
                                                                        profileForm.submit();
                                                                    }
                                                                });

                                                                function checkProfileInputs() {
                                                                    let valid = true;

                                                                    const nameValue = nameInput.value.trim();
                                                                    const phoneValue = phoneInput.value.trim();
                                                                    const genderValue = genderSelect.value;

                                                                    if (nameValue === "" || nameValue.length < 3) {
                                                                        setErrorInput(nameInput, "Full name must be at least 3 characters.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(nameInput);
                                                                    }

                                                                    if (phoneValue === "" || (phoneValue !== "" && !/^(0[0-9]{9})$/.test(phoneValue))) {
                                                                        setErrorInput(phoneInput, "Phone must start with 0 and be 10 digits.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(phoneInput);
                                                                    }

                                                                    if (genderValue === "") {
                                                                        setErrorInput(genderSelect, "Please select gender.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(genderSelect);
                                                                    }

                                                                    return valid;
                                                                }

                                                                // ===== PASSWORD FORM VALIDATION =====
                                                                const passwordForm = document.getElementById("passwordForm");
                                                                const currentPassword = document.getElementById("currentPassword");
                                                                const newPassword = document.getElementById("newPassword");
                                                                const confirmPassword = document.getElementById("confirmPassword");

                                                                passwordForm.addEventListener("submit", e => {
                                                                    e.preventDefault();
                                                                    if (checkPasswordInputs()) {
                                                                        passwordForm.submit();
                                                                    }
                                                                });

                                                                function checkPasswordInputs() {
                                                                    let valid = true;

                                                                    if (currentPassword.value.trim() === "") {
                                                                        setErrorInput(currentPassword, "Current password cannot be blank.");
                                                                        valid = false;
                                                                    } else if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(currentPassword.value)) {
                                                                        setErrorInput(currentPassword, "Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(currentPassword);
                                                                    }

                                                                    if (newPassword.value.trim() === "") {
                                                                        setErrorInput(newPassword, "New password cannot be blank.");
                                                                        valid = false;
                                                                    } else if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(newPassword.value)) {
                                                                        setErrorInput(newPassword, "Password must have 8+ chars, 1 uppercase, 1 lowercase, 1 digit.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(newPassword);
                                                                    }

                                                                    if (confirmPassword.value.trim() === "") {
                                                                        setErrorInput(confirmPassword, "Confirm password cannot be blank.");
                                                                        valid = false;
                                                                    } else if (confirmPassword.value !== newPassword.value) {
                                                                        setErrorInput(confirmPassword, "Passwords do not match.");
                                                                        valid = false;
                                                                    } else {
                                                                        setSuccessInput(confirmPassword);
                                                                    }

                                                                    return valid;
                                                                }

                                                                // ===== ADD ADDRESS FORM VALIDATION =====
                                                                const addAddressForm = document.getElementById('addAddressForm');

                                                                addAddressForm.addEventListener('submit', function (e) {
                                                                    e.preventDefault();

                                                                    if (validateAddAddressForm()) {
                                                                        this.submit();
                                                                    }
                                                                });

                                                                function validateAddAddressForm() {
                                                                    let isValid = true;

                                                                    // Address Name
                                                                    const addressName = document.getElementById('addAddressName');
                                                                    const addressNameValue = addressName.value.trim();
                                                                    const addressNameError = document.getElementById('addAddressNameError');

                                                                    if (addressNameValue === '') {
                                                                        showError(addressName, addressNameError, 'Address name is required');
                                                                        isValid = false;
                                                                    } else if (addressNameValue.length < 3) {
                                                                        showError(addressName, addressNameError, 'Address name must be at least 3 characters');
                                                                        isValid = false;
                                                                    } else if (addressNameValue.length > 100) {
                                                                        showError(addressName, addressNameError, 'Address name must not exceed 100 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(addressName, addressNameError);
                                                                    }

                                                                    // Recipient Name
                                                                    const recipientName = document.getElementById('addRecipientName');
                                                                    const recipientNameValue = recipientName.value.trim();
                                                                    const recipientNameError = document.getElementById('addRecipientNameError');

                                                                    if (recipientNameValue === '') {
                                                                        showError(recipientName, recipientNameError, 'Recipient name is required');
                                                                        isValid = false;
                                                                    } else if (recipientNameValue.length < 3) {
                                                                        showError(recipientName, recipientNameError, 'Recipient name must be at least 3 characters');
                                                                        isValid = false;
                                                                    } else if (recipientNameValue.length > 100) {
                                                                        showError(recipientName, recipientNameError, 'Recipient name must not exceed 100 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(recipientName, recipientNameError);
                                                                    }

                                                                    // Phone
                                                                    const recipientPhone = document.getElementById('addRecipientPhone');
                                                                    const recipientPhoneValue = recipientPhone.value.trim();
                                                                    const recipientPhoneError = document.getElementById('addRecipientPhoneError');

                                                                    if (recipientPhoneValue === '') {
                                                                        showError(recipientPhone, recipientPhoneError, 'Phone number is required');
                                                                        isValid = false;
                                                                    } else if (!/^0\d{9}$/.test(recipientPhoneValue)) {
                                                                        showError(recipientPhone, recipientPhoneError, 'Phone must start with 0 and be exactly 10 digits');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(recipientPhone, recipientPhoneError);
                                                                    }

                                                                    // Address Details
                                                                    const addressDetails = document.getElementById('addAddressDetails');
                                                                    const addressDetailsValue = addressDetails.value.trim();
                                                                    const addressDetailsError = document.getElementById('addAddressDetailsError');

                                                                    if (addressDetailsValue === '') {
                                                                        showError(addressDetails, addressDetailsError, 'Address details are required');
                                                                        isValid = false;
                                                                    } else if (addressDetailsValue.length < 10) {
                                                                        showError(addressDetails, addressDetailsError, 'Address details must be at least 10 characters');
                                                                        isValid = false;
                                                                    } else if (addressDetailsValue.length > 500) {
                                                                        showError(addressDetails, addressDetailsError, 'Address details must not exceed 500 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(addressDetails, addressDetailsError);
                                                                    }

                                                                    return isValid;
                                                                }

                                                                function cancelAddAddress() {
                                                                    // Reset form
                                                                    addAddressForm.reset();

                                                                    // Clear all errors
                                                                    document.querySelectorAll('.address-form-error').forEach(el => {
                                                                        el.classList.remove('show');
                                                                        el.textContent = '';
                                                                    });
                                                                    document.querySelectorAll('.is-invalid').forEach(el => {
                                                                        el.classList.remove('is-invalid');
                                                                    });

                                                                    // Hide form
                                                                    document.getElementById('toggleAddAddressForm').click();
                                                                }

                                                                // ===== EDIT ADDRESS VALIDATION =====
                                                                document.querySelectorAll('form[id^="addressForm-"]').forEach(form => {
                                                                    form.addEventListener('submit', function (e) {
                                                                        e.preventDefault();

                                                                        const addressId = this.id.split('-')[1];
                                                                        if (validateEditAddressForm(addressId)) {
                                                                            this.submit();
                                                                        }
                                                                    });
                                                                });

                                                                function validateEditAddressForm(addressId) {
                                                                    let isValid = true;

                                                                    // Address Name
                                                                    const addressName = document.getElementById('addressName-' + addressId);
                                                                    const addressNameValue = addressName.value.trim();
                                                                    const addressNameError = document.getElementById('addressNameError-' + addressId);

                                                                    if (addressNameValue === '') {
                                                                        showError(addressName, addressNameError, 'Address name is required');
                                                                        isValid = false;
                                                                    } else if (addressNameValue.length < 3 || addressNameValue.length > 100) {
                                                                        showError(addressName, addressNameError, 'Address name must be 3-100 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(addressName, addressNameError);
                                                                    }

                                                                    // Recipient Name
                                                                    const recipientName = document.getElementById('recipientName-' + addressId);
                                                                    const recipientNameValue = recipientName.value.trim();
                                                                    const recipientNameError = document.getElementById('recipientNameError-' + addressId);

                                                                    if (recipientNameValue === '' || recipientNameValue.length < 3 || recipientNameValue.length > 100) {
                                                                        showError(recipientName, recipientNameError, 'Recipient name must be 3-100 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(recipientName, recipientNameError);
                                                                    }

                                                                    // Phone
                                                                    const recipientPhone = document.getElementById('recipientPhone-' + addressId);
                                                                    const recipientPhoneValue = recipientPhone.value.trim();
                                                                    const recipientPhoneError = document.getElementById('recipientPhoneError-' + addressId);

                                                                    if (!/^0\d{9}$/.test(recipientPhoneValue)) {
                                                                        showError(recipientPhone, recipientPhoneError, 'Phone must start with 0 and be exactly 10 digits');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(recipientPhone, recipientPhoneError);
                                                                    }

                                                                    // Address Details
                                                                    const addressDetails = document.getElementById('addressDetails-' + addressId);
                                                                    const addressDetailsValue = addressDetails.value.trim();
                                                                    const addressDetailsError = document.getElementById('addressDetailsError-' + addressId);

                                                                    if (addressDetailsValue === '' || addressDetailsValue.length < 10 || addressDetailsValue.length > 500) {
                                                                        showError(addressDetails, addressDetailsError, 'Address details must be 10-500 characters');
                                                                        isValid = false;
                                                                    } else {
                                                                        clearError(addressDetails, addressDetailsError);
                                                                    }

                                                                    return isValid;
                                                                }

                                                                // ===== ENABLE EDIT =====
                                                                function enableEdit(addressId) {
                                                                    document.getElementById('addressName-' + addressId).removeAttribute('readonly');
                                                                    document.getElementById('recipientName-' + addressId).removeAttribute('readonly');
                                                                    document.getElementById('recipientPhone-' + addressId).removeAttribute('readonly');
                                                                    document.getElementById('addressDetails-' + addressId).removeAttribute('readonly');

                                                                    const checkbox = document.getElementById('isDefault-' + addressId);
                                                                    if (!checkbox.checked) {
                                                                        checkbox.removeAttribute('disabled');
                                                                    }

                                                                    document.getElementById('viewButtons-' + addressId).classList.add('d-none');
                                                                    document.getElementById('editButtons-' + addressId).classList.remove('d-none');
                                                                }

                                                                // ===== CANCEL EDIT =====
                                                                function cancelEditFromData(button) {
                                                                    const addressId = button.getAttribute('data-address-id');
                                                                    const originalName = button.getAttribute('data-address-name');
                                                                    const originalRecipient = button.getAttribute('data-recipient-name');
                                                                    const originalPhone = button.getAttribute('data-recipient-phone');
                                                                    const originalDetails = button.getAttribute('data-address-details');
                                                                    const isDefault = button.getAttribute('data-is-default') === 'true';

                                                                    document.getElementById('addressName-' + addressId).value = originalName;
                                                                    document.getElementById('recipientName-' + addressId).value = originalRecipient;
                                                                    document.getElementById('recipientPhone-' + addressId).value = originalPhone;
                                                                    document.getElementById('addressDetails-' + addressId).value = originalDetails;
                                                                    document.getElementById('isDefault-' + addressId).checked = isDefault;

                                                                    document.getElementById('addressName-' + addressId).setAttribute('readonly', true);
                                                                    document.getElementById('recipientName-' + addressId).setAttribute('readonly', true);
                                                                    document.getElementById('recipientPhone-' + addressId).setAttribute('readonly', true);
                                                                    document.getElementById('addressDetails-' + addressId).setAttribute('readonly', true);
                                                                    document.getElementById('isDefault-' + addressId).setAttribute('disabled', true);

                                                                    // Clear validation errors
                                                                    clearError(document.getElementById('addressName-' + addressId),
                                                                            document.getElementById('addressNameError-' + addressId));
                                                                    clearError(document.getElementById('recipientName-' + addressId),
                                                                            document.getElementById('recipientNameError-' + addressId));
                                                                    clearError(document.getElementById('recipientPhone-' + addressId),
                                                                            document.getElementById('recipientPhoneError-' + addressId));
                                                                    clearError(document.getElementById('addressDetails-' + addressId),
                                                                            document.getElementById('addressDetailsError-' + addressId));

                                                                    document.getElementById('viewButtons-' + addressId).classList.remove('d-none');
                                                                    document.getElementById('editButtons-' + addressId).classList.add('d-none');
                                                                }

                                                                // ===== DELETE ADDRESS =====
                                                                function deleteAddress(addressId) {
                                                                    if (confirm('Are you sure you want to delete this address?')) {
                                                                        const form = document.createElement('form');
                                                                        form.method = 'POST';
                                                                        form.action = '<%= request.getContextPath()%>/address';

                                                                        const actionInput = document.createElement('input');
                                                                        actionInput.type = 'hidden';
                                                                        actionInput.name = 'addressAction';
                                                                        actionInput.value = 'deleteAddress';

                                                                        const idInput = document.createElement('input');
                                                                        idInput.type = 'hidden';
                                                                        idInput.name = 'addressId';
                                                                        idInput.value = addressId;

                                                                        const customeridInput = document.createElement('input');
                                                                        customeridInput.type = 'hidden';
                                                                        customeridInput.name = 'customerId';
                                                                        customeridInput.value = '${sessionScope.customer.id}';

                                                                        form.appendChild(actionInput);
                                                                        form.appendChild(idInput);
                                                                        form.appendChild(customeridInput);
                                                                        document.body.appendChild(form);
                                                                        form.submit();
                                                                    }
                                                                }

                                                                // ===== TOGGLE FORMS =====
                                                                document.addEventListener("DOMContentLoaded", () => {
                                                                    const btnToggle = document.getElementById("togglePasswordForm");
                                                                    const passwordCard = document.getElementById("passwordCard");

                                                                    if (btnToggle) {
                                                                        btnToggle.addEventListener("click", () => {
                                                                            passwordCard.classList.toggle("d-none");
                                                                            btnToggle.innerText = passwordCard.classList.contains("d-none")
                                                                                    ? "Change Password"
                                                                                    : "Hide Change Password";
                                                                        });
                                                                    }

                                                                    const btnToggleAddAddress = document.getElementById("toggleAddAddressForm");
                                                                    const addAddressCard = document.getElementById("addAddressCard");

                                                                    btnToggleAddAddress.addEventListener("click", () => {
                                                                        addAddressCard.classList.toggle("d-none");
                                                                        if (!addAddressCard.classList.contains("d-none")) {
                                                                            btnToggleAddAddress.innerText = "Hide Form";
                                                                            addAddressCard.scrollIntoView({behavior: 'smooth', block: 'nearest'});
                                                                        } else {
                                                                            btnToggleAddAddress.innerText = "Add New Address";
                                                                        }
                                                                    });

                                                                    // Initialize Lucide icons
                                                                    lucide.createIcons();

                                                                    // Set active menu based on current page
                                                                    const currentPath = window.location.pathname;
                                                                    const menuLinks = document.querySelectorAll('.nav-link-item');

                                                                    menuLinks.forEach(link => {
                                                                        const linkHref = link.getAttribute('href');

                                                                        // Remove active from all
                                                                        link.classList.remove('active');

                                                                        // Check if current path matches link href
                                                                        if (currentPath.includes(linkHref.split('/').pop())) {
                                                                            link.classList.add('active');
                                                                        }
                                                                    });

                                                                    // Default to profile if no match
                                                                    const hasActive = document.querySelector('.nav-link-item.active');
                                                                    if (!hasActive) {
                                                                        const profileLink = document.getElementById('profile');
                                                                        if (profileLink) {
                                                                            profileLink.classList.add('active');
                                                                        }
                                                                    }
                                                                });
        </script>
    </body>
</html>