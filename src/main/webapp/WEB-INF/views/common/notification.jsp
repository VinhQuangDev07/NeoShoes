<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .custom-notification{
        position:fixed;
        top:20px;
        right:-400px;
        min-width:250px;
        padding:12px 16px;
        display:flex;
        align-items:center;
        border-radius:6px;
        font-size:14px;
        color:#fff;
        background:#333;
        box-shadow:0 2px 8px rgba(0,0,0,0.2);
        transition:right .3s ease;
        z-index:9999
    }
    .custom-notification.show{
        right:20px
    }
    .notification-success{
        background:#28a745
    }
    .notification-error{
        background:#dc3545
    }
    .notification-info{
        background:#007bff
    }
    .notification-icon{
        margin-right:10px;
        font-size:18px
    }
</style>

<script>
    function showNotification(message, type = 'info') {
        if (!message)
            return;
        const notification = document.createElement('div');
        notification.classList.add('custom-notification', 'notification-' + type);
        let icon = '';
        if (type === 'success')
            icon = '<i class="fas fa-check-circle"></i>';
        else if (type === 'error')
            icon = '<i class="fas fa-exclamation-circle"></i>';
        else
            icon = '<i class="fas fa-info-circle"></i>';
        notification.innerHTML = '<div class="notification-icon">' + icon + '</div><div class="notification-message"></div>';
        notification.querySelector('.notification-message').textContent = message;
        document.body.appendChild(notification);
        setTimeout(() => notification.classList.add('show'), 10);
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    function showIfPresent(id, type) {
        const el = document.getElementById(id);
        if (el && el.textContent && el.textContent.trim() !== '') {
            showNotification(el.textContent.trim(), type);
        }
    }
</script>

<!-- Request scope (forward) -->
<c:if test="${not empty requestScope.flash}">
    <div id="flash-request-success" style="display:none">${fn:escapeXml(requestScope.flash)}</div>
    <script>showIfPresent('flash-request-success', 'success');</script>
    <c:remove var="flash" scope="request"/>
</c:if>

<c:if test="${not empty requestScope.flash_info}">
    <div id="flash-request-info" style="display:none">${fn:escapeXml(requestScope.flash_info)}</div>
    <script>showIfPresent('flash-request-info', 'info');</script>
    <c:remove var="flash_info" scope="request"/>
</c:if>

<c:if test="${not empty requestScope.flash_error}">
    <div id="flash-request-error" style="display:none">${fn:escapeXml(requestScope.flash_error)}</div>
    <script>showIfPresent('flash-request-error', 'error');</script>
    <c:remove var="flash_error" scope="request"/>
</c:if>

<!-- Session scope (redirect) -->
<c:if test="${not empty sessionScope.flash}">
    <div id="flash-session-success" style="display:none">${fn:escapeXml(sessionScope.flash)}</div>
    <script>showIfPresent('flash-session-success', 'success');</script>
    <c:remove var="flash" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_info}">
    <div id="flash-session-info" style="display:none">${fn:escapeXml(sessionScope.flash_info)}</div>
    <script>showIfPresent('flash-session-info', 'info');</script>
    <c:remove var="flash_info" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
    <div id="flash-session-error" style="display:none">${fn:escapeXml(sessionScope.flash_error)}</div>
    <script>showIfPresent('flash-session-error', 'error');</script>
    <c:remove var="flash_error" scope="session"/>
</c:if>