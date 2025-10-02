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
        <script src="${pageContext.request.contextPath}/assets/js/script.js?v=<%= System.currentTimeMillis() %>"></script>

    </head>
    <style>
        /* Validation form */
        .form-floating {
            position: relative;
            margin-bottom: 15px;
        }

        .form-floating.success input,
        .form-floating.success select {
            border-color: #28a745;
        }

        .form-floating.error input,
        .form-floating.error select {
            border-color: #dc3545;
        }
        /*
                .form-floating small {
                    color: #dc3545;
                    position: absolute;
                    bottom: -18px;
                    left: 0;
                    visibility: hidden;
                }*/

        .form-floating.error small {
            visibility: visible;
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
                                <form method="post" id="profileForm" action="${pageContext.request.contextPath}/profile">
                                    <input type="hidden" name="id" value="${customer.id}"/>
                                    <input type="hidden" name="action" value="updateProfile"/>
                                    <div class="row g-3">
                                        <div class="col-md-3 text-center">
                                            <img src="${empty customer.avatar ? 'https://i.pinimg.com/originals/24/bd/d9/24bdd9ec59a9f8966722063fe7791183.jpg' : customer.avatar}"
                                                 class="img-thumbnail rounded-circle mb-2" style="width:160px;height:160px;object-fit:cover"/>
                                            <div class="form-floating">
                                                <input name="avatar" id="avatar" class="form-control" placeholder="Avatar URL" value="${customer.avatar}"/>
                                                <label for="avatar">Avatar URL</label>
                                                <div class="invalid-feedback"></div>
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
        </script>
    </body>
</html>
