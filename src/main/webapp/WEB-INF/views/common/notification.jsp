<%-- 
    Document   : notification
    Created on : Oct 11, 2025, 12:36:12 PM
    Author     : Le Huu Nghia - CE181052
--%>

<c:if test="${not empty sessionScope.flash}">
    <script>
                showNotification("${sessionScope.flash}", "success");
    </script>
    <c:remove var="flash" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_info}">
    <script>
                showNotification("${sessionScope.flash_info}", "info");
    </script>
    <c:remove var="flash_info" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
    <script>
                showNotification("${sessionScope.flash_error}", "error");
    </script>
    <c:remove var="flash_error" scope="session"/>
</c:if>
