<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Staff Portal • NeoShoes</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
            body {
                min-height: 100vh;
                background: radial-gradient(1250px circle at 10% 10%, #f0f4ff 10%, #e9ecff 35%, #f7f8ff 65%, #ffffff 80%),
                    linear-gradient(120deg, #ece9ff 0%, #fbfbff 60%, #ffffff 100%);
            }
            .auth-card {
                border: 1px solid rgba(111, 66, 193, 0.1);
                box-shadow: 0 10px 30px rgba(111, 66, 193, 0.08);
                border-radius: 14px;
                overflow: hidden;
                background: #fff;
            }
            .brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 6px;
            }
            .brand-badge {
                width: 44px;
                height: 44px;
                border-radius: 50%;
                background: #6f42c1;
                color: #fff;
                display: grid;
                place-items: center;
                font-weight: 700;
                letter-spacing: 0.5px;
                box-shadow: 0 6px 16px rgba(111, 66, 193, 0.3);
            }
            .title {
                font-weight: 700;
                margin: 0;
            }
            .subtitle {
                color: #6c757d;
                font-size: 0.95rem;
                margin-bottom: 1rem;
            }
            .form-control {
                padding: 10px 12px;
                border-radius: 10px;
            }
            .btn-primary {
                background: #6f42c1;
                border-color: #6f42c1;
                border-radius: 10px;
                font-weight: 600;
                box-shadow: 0 8px 16px rgba(111, 66, 193, 0.25);
            }
            .btn-primary:hover {
                background: #5b34a4;
                border-color: #5b34a4;
            }
            .floating-footer {
                text-align: center;
                color: #8b8f99;
                font-size: 0.9rem;
                margin-top: 18px;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="row justify-content-center align-items-center" style="min-height: 88vh;">
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="auth-card p-4 p-md-4">
                        <div class="brand">
                            <div class="brand-badge">NS</div>
                            <div>
                                <h4 class="title">NeoShoes Staff Portal</h4>
                                <div class="subtitle">Sign in to manage orders, products and more</div>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mb-3"><i class="fa-solid fa-triangle-exclamation me-2"></i>${error}</div>
                            </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/staff/login" novalidate>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                                    <input type="email" class="form-control" name="email" value="${email}" placeholder="name@company.com" required />
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                    <input type="password" class="form-control" name="password" placeholder="••••••••" required />
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mt-2">Sign in</button>

                        </form>
                        <div style="text-align: center; margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/forget-password?type=staff" 
                               style="color: #667eea; text-decoration: none; font-size: 14px;">
                                Forgot Password?
                            </a>
                        </div>
<!--                        <div class="floating-footer">
                            <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">← Back to Storefront</a>
                        </div>-->
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>