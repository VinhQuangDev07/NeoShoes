<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Forget Password</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                padding: 40px;
                max-width: 450px;
                width: 100%;
            }

            h2 {
                color: #667eea;
                margin-bottom: 10px;
                text-align: center;
            }

            .subtitle {
                color: #6b7280;
                text-align: center;
                margin-bottom: 30px;
                font-size: 14px;
            }

            .error {
                background: #fee2e2;
                color: #991b1b;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                text-align: center;
            }

            .success {
                background: #d1fae5;
                color: #065f46;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                text-align: center;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                color: #374151;
                font-weight: 600;
                margin-bottom: 8px;
            }

            input[type="email"] {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s;
            }

            input[type="email"]:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            button {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s;
            }

            button:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            .back-link {
                text-align: center;
                margin-top: 20px;
            }

            .back-link a {
                color: #667eea;
                text-decoration: none;
                font-size: 14px;
            }

            .back-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Staff - Forget Password</h2>
            <p class="subtitle">Confirm your email to receive OTP code</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <% if (request.getAttribute("message") != null) { %>
            <div class="success">
                <%= request.getAttribute("message") %>
            </div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/forget-password">
                <input type="hidden" name="userType" value="staff">

                <div class="form-group">
                    <label for="email">Staff Email Address</label>
                    <p style="font-weight: bold; color:#4f46e5;"><%= request.getAttribute("email") %></p>

                    <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
                    <input type="hidden" name="userType" value="staff">
                    <small style="display: block; margin-top: 5px; color: #6b7280; font-size: 13px;">
                        OTP code will be sent to your staff email
                    </small>
                </div>

                <button type="submit">Send OTP Code</button>
            </form>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/staff/login">← Back to Staff Login</a>
            </div>
        </div>
    </body>
</html>