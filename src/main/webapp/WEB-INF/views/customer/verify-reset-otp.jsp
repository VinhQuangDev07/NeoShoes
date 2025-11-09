<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> OTP - NeoShoes</title>
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
        
        .message {
            background: #d1fae5;
            color: #065f46;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        form div {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            color: #374151;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        input:focus {
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
        
        .info {
            margin-top: 20px;
            padding: 15px;
            background: #f3f4f6;
            border-radius: 10px;
            font-size: 14px;
            color: #6b7280;
        }
        
        .info p {
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>OTP authentication</h2>
        <p class="subtitle">Enter your OTP code and new password</p>
        
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <form action="reset-password" method="post">
            <input type="hidden" name="email" value="${email}">
            
            <div>
                <label>OTP code (6 digits):</label>
                <input type="text" name="otp" required maxlength="6" pattern="\d{6}" 
                       placeholder="Enter OTP" autofocus>
            </div>
            
            <div>
                <label>New password:</label>
                <input type="password" name="newPassword" required minlength="6" 
                       placeholder="Minimum 6 characters">
            </div>
            
            <div>
                <label>Confirm password:</label>
                <input type="password" name="confirmPassword" required minlength="6" 
                       placeholder="Re-enter password">
            </div>
            
            <button type="submit">Reset Password</button>
        </form>
        
        <div class="info">
            <p>OTP code will expire after 10 minutes</p>
            <p>You can enter the wrong password up to 5 times.</p>
        </div>
    </div>
</body>
</html>