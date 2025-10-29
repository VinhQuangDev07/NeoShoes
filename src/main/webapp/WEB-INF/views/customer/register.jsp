<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - NeoShoes</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                padding: 40px 0;
            }

            .register-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                padding: 2.5rem;
                max-width: 700px;
                width: 100%;
                margin: 0 auto;
            }

            .register-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .register-header h2 {
                color: #667eea;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .register-header p {
                color: #6b7280;
                margin: 0;
            }

            .form-section {
                margin-bottom: 1.5rem;
                padding-bottom: 1.5rem;
                border-bottom: 1px solid #e5e7eb;
            }

            .form-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .form-section h5 {
                color: #374151;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .form-label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 0.5rem;
            }

            .required {
                color: #ef4444;
            }

            .btn-register {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 12px;
                font-weight: 600;
                color: white;
                transition: all 0.3s;
            }

            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                color: white;
            }

            .login-link {
                text-align: center;
                margin-top: 1.5rem;
                color: #6b7280;
            }

            .login-link a {
                color: #667eea;
                font-weight: 600;
                text-decoration: none;
            }

            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <!-- Notification -->
        <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

        <div class="container">
            <div class="register-card">

                <!-- Header -->
                <div class="register-header">
                    <h2><i class="fas fa-user-plus"></i> Create Account</h2>
                    <p>Join NeoShoes and start shopping!</p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">

                    <!-- Account Information -->
                    <div class="form-section">
                        <h5><i class="fas fa-lock"></i> Account Information</h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    Email <span class="required">*</span>
                                </label>
                                <input type="email" name="email" class="form-control" required 
                                       placeholder="your@email.com"
                                       value="${formData.email[0]}">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    Full Name <span class="required">*</span>
                                </label>
                                <input type="text" name="name" class="form-control" required 
                                       placeholder="Enter your full name"
                                       value="${formData.name[0]}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    Password <span class="required">*</span>
                                </label>
                                <input type="password" name="password" class="form-control" required 
                                       minlength="8" placeholder="Minimum 8 characters" id="password">
                                <small class="text-muted">At least 8 characters</small>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    Confirm Password <span class="required">*</span>
                                </label>
                                <input type="password" name="confirmPassword" class="form-control" required 
                                       minlength="8" placeholder="Re-enter password" id="confirmPassword">
                            </div>
                        </div>
                    </div>

                    <!-- Personal Information -->
                    <div class="form-section">
                        <h5><i class="fas fa-user"></i> Personal Information</h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" name="phone" class="form-control" 
                                       placeholder="0123456789"
                                       value="${formData.phone[0]}">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Gender</label>
                                <select name="gender" class="form-select">
                                    <option value="">-- Select Gender --</option>
                                    <option value="Male" ${formData.gender[0] == 'Male' ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${formData.gender[0] == 'Female' ? 'selected' : ''}>Female</option>
                                    <option value="Other" ${formData.gender[0] == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-register">
                            <i class="fas fa-user-plus"></i> Create Account
                        </button>
                    </div>
                </form>

                <!-- Login Link -->
                <div class="login-link">
                    Already have an account? 
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt"></i> Login here
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Validate password match before submit
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    document.getElementById('confirmPassword').focus();
                    return false;
                }

                if (password.length < 6) {
                    e.preventDefault();
                    alert('Password must be at least 6 characters!');
                    document.getElementById('password').focus();
                    return false;
                }

                return true;
            });

            // Show/hide password toggle
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');

            // Add eye icon to toggle password visibility (optional)
            password.addEventListener('input', function () {
                if (this.value.length > 0) {
                    document.getElementById('confirmPassword').disabled = false;
                }
            });
        </script>
    </body>
</html>