<%-- staff-profile.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Staff Profile</title>
        <style>
            .container {
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input, select {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            button {
                padding: 10px 20px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 4px;
            }
            .success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Staff Profile</h1>

            <c:if test="${not empty message}">
                <div class="message ${messageType}">${message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profilestaff" method="post">
                <div class="form-group">
                    <label>Staff ID:</label>
                    <input type="text" value="${staff.staffId}" readonly>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" value="${staff.email}" readonly>
                </div>

                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="${staff.name}" required>
                </div>

                <div class="form-group">
                    <label>Phone Number:</label>
                    <input type="tel" name="phoneNumber" value="${staff.phoneNumber}">
                </div>

                <div class="form-group">
                    <label>Avatar URL:</label>
                    <input type="url" name="avatar" value="${staff.avatar}">
                </div>

                <div class="form-group">
                    <label>Gender:</label>
                    <select name="gender">
                        <option value="Male"   <c:if test="${staff.gender eq 'Male'}">selected</c:if>>Male</option>
                        <option value="Female" <c:if test="${staff.gender eq 'Female'}">selected</c:if>>Female</option>
                        <option value="Other"  <c:if test="${staff.gender eq 'Other'}">selected</c:if>>Other</option>
                        </select>
                    </div>


                    <div class="form-group">
                        <label>Role:</label>
                        <input type="text" value="${staff.role ? 'Admin' : 'Staff'}" readonly>
                </div>

                <div class="form-group">
                    <label>Created At:</label>
                    <input type="text" value="${staff.createdAt}" readonly>
                </div>

                <button type="submit">Update Profile</button>
            </form>

            <br>
            <a href="change-password.jsp">Change Password</a> |
            <a href="staff-dashboard.jsp">Back to Dashboard</a>
        </div>
    </body>
    
    <input type="text" value="${staff.role ? 'Admin' : 'Staff'}" readonly>

</html>