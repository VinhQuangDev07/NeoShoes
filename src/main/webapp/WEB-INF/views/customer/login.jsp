<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - NeoShoes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .login-container {
                background: white;
                padding: 2.5rem;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                width: 100%;
                max-width: 450px;
                animation: slideUp 0.5s ease;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .logo-section {
                text-align: center;
                margin-bottom: 2rem;
            }

            .logo-section h2 {
                color: #333;
                font-weight: 700;
                margin-bottom: 0.5rem;
                font-size: 2rem;
            }

            .logo-section p {
                color: #666;
                font-size: 0.95rem;
            }

            .form-label {
                color: #555;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .form-control {
                padding: 0.75rem 1rem;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                transition: all 0.3s;
                font-size: 0.95rem;
            }

            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            .input-group-text {
                background: white;
                border: 2px solid #e0e0e0;
                border-right: none;
                border-radius: 8px 0 0 8px;
                color: #667eea;
            }

            .input-group .form-control {
                border-left: none;
            }

            .input-group:focus-within .input-group-text {
                border-color: #667eea;
            }

            .password-toggle {
                cursor: pointer;
                background: white;
                border: 2px solid #e0e0e0;
                border-left: none;
                border-radius: 0 8px 8px 0;
                color: #667eea;
            }

            .password-toggle:hover {
                background-color: #f8f9fa;
            }

            .btn-login {
                width: 100%;
                padding: 0.875rem;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                transition: all 0.3s;
                margin-top: 1rem;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            }

            .alert {
                border-radius: 8px;
                margin-bottom: 1.5rem;
                border: none;
            }

            .alert-danger {
                background-color: #fee;
                color: #c33;
            }

            .alert-success {
                background-color: #efe;
                color: #3c3;
            }

            .remember-me {
                display: flex;
                align-items: center;
                margin: 1rem 0;
            }

            .remember-me input {
                margin-right: 0.5rem;
                cursor: pointer;
            }

            .remember-me label {
                margin: 0;
                cursor: pointer;
                font-size: 0.9rem;
                color: #666;
            }

            .links {
                text-align: center;
                margin-top: 1.5rem;
            }

            .links a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.2s;
            }

            .links a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            .divider {
                text-align: center;
                margin: 1.5rem 0;
                position: relative;
            }

            .divider::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                width: 100%;
                height: 1px;
                background: #e0e0e0;
            }

            .divider span {
                background: white;
                padding: 0 1rem;
                position: relative;
                color: #999;
                font-size: 0.85rem;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="logo-section">
                <h2><i class="fas fa-shoe-prints"></i> NeoShoes</h2>
                <p>Sign in to continue shopping</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-envelope"></i>
                        </span>
                        <input type="email" 
                               class="form-control" 
                               id="email" 
                               name="email" 
                               placeholder="your.email@example.com"
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getAttribute("rememberedEmail") != null ? request.getAttribute("rememberedEmail") : "") %>"
                               required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" 
                               class="form-control" 
                               id="password" 
                               name="password" 
                               placeholder="••••••••"
                               required>
                        <span class="input-group-text password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </span>
                    </div>
                </div>

                <div class="remember-me">
                    <input type="checkbox" 
                           id="remember" 
                           name="remember"
                           <%= request.getAttribute("rememberedEmail") != null ? "checked" : "" %>>
                    <label for="remember">Remember login</label>
                </div>

                <button type="submit" class="btn btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>

            <div class="divider">
                <span>OR</span>
            </div>

            <div class="links">
                <p class="mb-2">Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign up now</a></p>
                <div style="text-align: center; margin-top: 10px;">
                    <a href="#" 
                       onclick="goToForgotPassword(); return false;"
                       style="color: #667eea; text-decoration: none; font-size: 14px;">
                        Forgot Password?
                    </a>
                </div>
            </div>
        </div>

        <script>
            function togglePassword() {
                const passwordInput = document.getElementById('password');
                const toggleIcon = document.getElementById('toggleIcon');

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }


            // Thêm function này
    function goToForgotPassword() {
        const emailInput = document.querySelector('input[name="email"]');
        const email = emailInput ? emailInput.value : '';
        
        if (email) {
            window.location.href = '${pageContext.request.contextPath}/forget-password?email=' + encodeURIComponent(email);
        } else {
            window.location.href = '${pageContext.request.contextPath}/forget-password';
        }
    }
        </script>
    </body>
</html>