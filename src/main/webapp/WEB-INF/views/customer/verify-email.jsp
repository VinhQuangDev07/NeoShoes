<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Email - NeoShoes</title>
    
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
        
        .verify-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 2.5rem;
            max-width: 500px;
            width: 100%;
            margin: 0 auto;
        }
        
        .verify-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .verify-header i {
            font-size: 60px;
            color: #667eea;
            margin-bottom: 1rem;
        }
        
        .verify-header h2 {
            color: #667eea;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .email-display {
            background: #f3f4f6;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .email-display i {
            color: #667eea;
            margin-right: 8px;
        }
        
        .code-input {
            text-align: center;
            font-size: 32px;
            letter-spacing: 10px;
            font-weight: bold;
            padding: 20px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
        }
        
        .code-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn-verify {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            color: white;
        }
        
        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .resend-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #6b7280;
        }
        
        .resend-link a {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
        }
        
        .resend-link a:hover {
            text-decoration: underline;
        }
        
        .timer {
            text-align: center;
            margin-top: 1rem;
            color: #ef4444;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <!-- Notification -->
    <jsp:include page="/WEB-INF/views/common/notification.jsp"/>

    <div class="container">
        <div class="verify-card">
            
            <!-- Header -->
            <div class="verify-header">
                <i class="fas fa-envelope-open-text"></i>
                <h2>Verify Your Email</h2>
                <p class="text-muted">Enter the 6-digit code we sent to your email</p>
            </div>

            <!-- Email Display -->
            <div class="email-display">
                <i class="fas fa-envelope"></i>
                <strong>${email}</strong>
            </div>

            <!-- Verify Form -->
            <form method="post" action="${pageContext.request.contextPath}/verify-email" id="verifyForm">
                
                <div class="mb-4">
                    <label class="form-label fw-semibold">Verification Code</label>
                    <input type="text" 
                           name="code" 
                           class="form-control code-input" 
                           placeholder="000000"
                           maxlength="6" 
                           pattern="[0-9]{6}"
                           required
                           autofocus
                           id="codeInput">
                    <small class="text-muted">Enter the 6-digit code from your email</small>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-verify">
                        <i class="fas fa-check-circle"></i> Verify Email
                    </button>
                </div>
            </form>

            <!-- Timer -->
            <div class="timer">
                <i class="fas fa-clock"></i>
                Code expires in: <span id="timer">10:00</span>
            </div>

            <!-- Resend Link -->
            <div class="resend-link">
                Didn't receive the code? 
                <form method="post" action="${pageContext.request.contextPath}/verify-email" style="display: inline;">
                    <input type="hidden" name="action" value="resend">
                    <button type="submit" class="btn btn-link p-0" style="color: #667eea; font-weight: 600; text-decoration: none;">
                        <i class="fas fa-redo"></i> Resend Code
                    </button>
                </form>
            </div>

            <!-- Back to Register -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/register" class="text-muted">
                    <i class="fas fa-arrow-left"></i> Back to Register
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-format code input (chỉ cho phép số)
        document.getElementById('codeInput').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        // Auto-submit khi nhập đủ 6 số
        document.getElementById('codeInput').addEventListener('input', function(e) {
            if (this.value.length === 6) {
                // Auto submit after 500ms
                setTimeout(() => {
                    document.getElementById('verifyForm').submit();
                }, 500);
            }
        });

        // Countdown timer (10 minutes)
        let timeLeft = 600; // 10 minutes in seconds
        
        function updateTimer() {
            let minutes = Math.floor(timeLeft / 60);
            let seconds = timeLeft % 60;
            
            document.getElementById('timer').textContent = 
                minutes.toString().padStart(2, '0') + ':' + 
                seconds.toString().padStart(2, '0');
            
            if (timeLeft > 0) {
                timeLeft--;
            } else {
                document.getElementById('timer').textContent = 'EXPIRED';
                document.getElementById('timer').style.color = '#ef4444';
            }
        }
        
        // Update timer every second
        setInterval(updateTimer, 1000);
        updateTimer();
    </script>
</body>
</html>