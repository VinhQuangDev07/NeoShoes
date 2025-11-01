<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - NeoShoes</title>
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
            font-size: 14px;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
        }
        
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        button {
            width: 100%;
            padding: 14px;
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
        
        button:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
        }
        
        .error {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .success {
            background: #d1fae5;
            color: #059669;
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #6b7280;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Reset Password</h2>
        <p class="subtitle">Enter your new password below</p>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">
                ❌<%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("tokenExpired") != null) { %>
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/forget-password" 
                   style="color: #667eea; text-decoration: none; font-weight: 500;">
                    Request a new reset link →
                </a>
            </div>
        <% } else { %>
            <form method="post" action="${pageContext.request.contextPath}/reset-password">
                <input type="hidden" name="token" value="${token}">
                
                <div class="form-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password" 
                           placeholder="Enter new password" required minlength="6">
                    <div class="password-requirements">
                        Minimum 6 characters
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="Confirm new password" required minlength="6">
                </div>
                
                <button type="submit">Reset Password</button>
            </form>
        <% } %>
    </div>
</body>
</html>