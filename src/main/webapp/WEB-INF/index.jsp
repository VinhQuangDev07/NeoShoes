<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>NeoShoes - Home</title>
</head>
<body>
    <h1>🚀 NeoShoes Application</h1>
    <p>Application is running successfully!</p>
    
    <h2>Test Links:</h2>
    <ul>
        <li><a href="managebrands?role=admin">Brand Management (Admin Role)</a></li>
        <li><a href="managebrands?role=staff">Brand Management (Staff Role)</a></li>
    </ul>
    
    <p><strong>Build Time:</strong> <%= new java.util.Date() %></p>
</body>
</html>