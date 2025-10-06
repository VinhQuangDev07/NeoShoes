<%-- 
    Document   : profile
    Created on : Sep 28, 2025, 2:48:39 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>My Profile</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis()%>"></script>

    </head> 
    <style>
        /* Validation form */
        .form-floating {
            position: relative;
            margin-bottom: 15px;
        }      

        .customer-sidebar {
            height: 326px;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            margin-top: 48px;
            margin-right: 12px;
            overflow: hidden;
        }

        .profile-section {
            padding: 1.5rem 2rem;
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
            padding: 1.5rem 0;
        }

        .nav-link-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1.25rem;
            margin-bottom: 0.5rem;
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

        /* Responsive */
        @media (max-width: 768px) {
            .customer-sidebar {
                width: 100%;
                margin-top: 20px;
                height: auto;
            }
        }
    </style>
    <body class="bg-light">
        <c:if test="${not empty sessionScope.flash}">
            <script>
                showNotification("${sessionScope.flash}", "success");
            </script>
            <c:remove var="flash" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_info}">
            <script>
                showNotification("${sessionScope.flash_info}", "info");
            </script>
            <c:remove var="flash_info" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_error}">
            <script>
                showNotification("${sessionScope.flash_error}", "error");
            </script>
            <c:remove var="flash_error" scope="session"/>
        </c:if>

        <div class="d-flex justify-content-center">
            <div class="container">
                <div class="d-flex profile-layout">
                    <!-- Sidebar -->
                    <jsp:include page="common/customer-sidebar.jsp"/>
                    <!-- Main Content -->
                    <div id="main-content" class="main-content-wrapper mt-5 mb-5">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h3 class="mb-3">Customer Profile</h3>
                                <form method="post" id="profileForm" 
                                      action="${pageContext.request.contextPath}/profile" 
                                      enctype="multipart/form-data">
                                    <input type="hidden" name="id" value="${customer.id}"/>
                                    <input type="hidden" name="action" value="updateProfile"/>
                                    <div class="row g-3">
                                        <div class="col-md-3 text-center">
                                            <div class="avatar-upload d-flex flex-column align-items-center" id="avatarUpload">
                                                <img src="${empty customer.avatar ? 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg' : customer.avatar}" id="avatarPreview" 
                                                     class="avatar-preview img-thumbnail rounded-circle mb-2 " 
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
                                    <input type="hidden" name="id" value="${customer.id}"/>
                                    <input type="hidden" name="action" value="changePassword"/>
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="form-floating">
                                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Current password"  />
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
                            <!-- Add Address Form -->
                            <div class="d-none" id="addAddressCard">
                                <div class="border rounded p-3 mb-3 bg-light">
                                    <h5 class="mb-3">Add New Address</h5>
                                    <form method="post" id="addAddressForm" action="${pageContext.request.contextPath}/address">
                                        <input type="hidden" name="addressAction" value="addAddress" />
                                        <input type="hidden" name="customerId" value="${customer.id}" />
                                        <input type="hidden" name="isDeleted" value="false" />

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input name="addressName" type="text" id="addressName" class="form-control" placeholder="Address Name" required />
                                                    <label for="addressName">Address Name</label>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input name="recipientName" type="text" id="recipientName" class="form-control" placeholder="Recipient Name" required />
                                                    <label for="recipientName">Recipient Name</label>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input name="recipientPhone" type="tel" id="recipientPhone" class="form-control" placeholder="Phone Number" pattern="[\d+\- ]{7,15}" required />
                                                    <label for="recipientPhone">Phone Number</label>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input name="addressDetails" type="text" id="addressDetails" class="form-control" placeholder="Address Details" required />
                                                    <label for="addressDetails">Address Details</label>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <div class="form-check">
                                                    <input type="checkbox" class="form-check-input" id="isDefault" name="isDefault" value="true" />
                                                    <label class="form-check-label" for="isDefault">Set as default address</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-3 d-flex gap-2 justify-content-end">
                                            <button type="button" class="btn btn-secondary" onclick="document.getElementById('toggleAddAddressForm').click()">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Add Address</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <!--Address List-->
                            <c:forEach var="addr" items="${addressList}">
                                <div class="border rounded p-3 mb-3">
                                    <form method="post" action="${pageContext.request.contextPath}/address" id="addressForm-${addr.addressId}">
                                        <input type="hidden" name="addressAction" value="updateAddress"/>
                                        <input type="hidden" name="addressId" value="${addr.addressId}"/>

                                        <div class="mb-2">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="addressName" 
                                                       id="addressName-${addr.addressId}" value="${addr.addressName}" readonly/>
                                                <label for="addressName-${addr.addressId}">Address Name</label>
                                            </div>
                                        </div>

                                        <div class="mb-2">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="recipientName"
                                                       id="recipientName-${addr.addressId}" value="${addr.recipientName}" readonly/>
                                                <label for="recipientName-${addr.addressId}">Recipient</label>
                                            </div>
                                        </div>

                                        <div class="mb-2">
                                            <div class="form-floating">
                                                <input type="tel" class="form-control" name="recipientPhone"
                                                       id="recipientPhone-${addr.addressId}" value="${addr.recipientPhone}" 
                                                       pattern="[\d+\- ]{7,15}" readonly/>
                                                <label for="recipientPhone-${addr.addressId}">Phone</label>
                                            </div>
                                        </div>

                                        <div class="mb-2">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" name="addressDetails"
                                                       id="addressDetails-${addr.addressId}" value="${addr.addressDetails}" readonly/>
                                                <label for="addressDetails-${addr.addressId}">Details</label>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="isDefault" value="true"
                                                       id="isDefault-${addr.addressId}" disabled
                                                       <c:if test="${addr.isDefault}">checked</c:if>>
                                                <label class="form-check-label" for="isDefault-${addr.addressId}">Default</label>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end gap-2">
                                            <div id="viewButtons-${addr.addressId}">
                                                <button type="button" class="btn btn-primary btn-sm" 
                                                        onclick="enableEdit(${addr.addressId})">Edit</button>
                                                <button type="button" class="btn btn-danger btn-sm" 
                                                        onclick="deleteAddress(${addr.addressId})">Delete</button>
                                            </div>

                                            <div id="editButtons-${addr.addressId}" class="d-none">
                                                <button type="button" class="btn btn-secondary btn-sm" 
                                                        onclick="cancelEdit(${addr.addressId}, '${addr.addressName}', '${addr.recipientName}', '${addr.recipientPhone}', '${addr.addressDetails}')">Cancel</button>
                                                <button type="submit" class="btn btn-success btn-sm">Save Changes</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
 </div>

        </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://unpkg.com/lucide@latest"></script>

                <script>
                                                            document.addEventListener("DOMContentLoaded", () => {
                                                                const btnToggle = document.getElementById("togglePasswordForm");
                                                                const passwordCard = document.getElementById("passwordCard");

                                                                btnToggle.addEventListener("click", () => {
                                                                    passwordCard.classList.toggle("d-none");
                                                                    if (!passwordCard.classList.contains("d-none")) {
                                                                        btnToggle.innerText = "Hide Change Password";
                                                                    } else {
                                                                        btnToggle.innerText = "Change Password";
                                                                    }
                                                                });

                                                                // Toggle Add Address Form
                                                                const btnToggleAddAddress = document.getElementById("toggleAddAddressForm");
                                                                const addAddressCard = document.getElementById("addAddressCard");

                                                                btnToggleAddAddress.addEventListener("click", () => {
                                                                    addAddressCard.classList.toggle("d-none");
                                                                    if (!addAddressCard.classList.contains("d-none")) {
                                                                        btnToggleAddAddress.innerText = "Hide Form";
                                                                        // Scroll to form
                                                                        addAddressCard.scrollIntoView({behavior: 'smooth', block: 'nearest'});
                                                                    } else {
                                                                        btnToggleAddAddress.innerText = "Add New Address";
                                                                    }
                                                                });
                                                            });

                                                            // PROFILE FORM
                                                            const profileForm = document.getElementById("profileForm");
                                                            const nameInput = document.getElementById("name");
                                                            const phoneInput = document.getElementById("phone");
                                                            const avatarInput = document.getElementById("avatar");
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
                                                                const avatarValue = avatarInput.value.trim();
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

                                                                if (avatarValue !== "" && !/^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$/i.test(avatarValue)) {
                                                                    setErrorInput(avatarInput, "Avatar must be a valid image URL.");
                                                                    valid = false;
                                                                } else {
                                                                    setSuccessInput(avatarInput);
                                                                }

                                                                if (genderValue === "") {
                                                                    setErrorInput(genderSelect, "Please select gender.");
                                                                    valid = false;
                                                                } else {
                                                                    setSuccessInput(genderSelect);
                                                                }

                                                                return valid;
                                                            }

                                                            // PASSWORD FORM
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

                                                            // Initialize Lucide icons
                                                            lucide.createIcons();

                                                            // Set active menu based on current page
                                                            document.addEventListener("DOMContentLoaded", () => {
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
                                                                    document.getElementById('profile').classList.add('active');
                                                                }
                                                            });
// Enable/Cancel/Delete Address Functions
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

                                                            function cancelEdit(addressId, originalName, originalRecipient, originalPhone, originalDetails) {
                                                                document.getElementById('addressName-' + addressId).value = originalName;
                                                                document.getElementById('recipientName-' + addressId).value = originalRecipient;
                                                                document.getElementById('recipientPhone-' + addressId).value = originalPhone;
                                                                document.getElementById('addressDetails-' + addressId).value = originalDetails;

                                                                document.getElementById('addressName-' + addressId).setAttribute('readonly', true);
                                                                document.getElementById('recipientName-' + addressId).setAttribute('readonly', true);
                                                                document.getElementById('recipientPhone-' + addressId).setAttribute('readonly', true);
                                                                document.getElementById('addressDetails-' + addressId).setAttribute('readonly', true);
                                                                document.getElementById('isDefault-' + addressId).setAttribute('disabled', true);

                                                                document.getElementById('viewButtons-' + addressId).classList.remove('d-none');
                                                                document.getElementById('editButtons-' + addressId).classList.add('d-none');
                                                            }

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

                                                                    form.appendChild(actionInput);
                                                                    form.appendChild(idInput);
                                                                    document.body.appendChild(form);
                                                                    form.submit();
                                                                }
                                                            }
                </script>
                </body>
                </html>
