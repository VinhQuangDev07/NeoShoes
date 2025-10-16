<%-- 
    Document   : notification
    Created on : Oct 11, 2025, 12:36:12 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Font Awesome (icons for notifications) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* ==============================
       Notification system
    ============================== */
    .custom-notification {
        position: fixed;
        top: 20px;
        right: -400px;
        min-width: 250px;
        padding: 12px 16px;
        display: flex;
        align-items: center;
        border-radius: 6px;
        font-size: 14px;
        color: #fff;
        background: #333;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        transition: right 0.3s ease;
        z-index: 9999;
    }

    .custom-notification.show {
        right: 20px;
    }

    .notification-success {
        background-color: #28a745;
    }

    .notification-error {
        background-color: #dc3545;
    }

    .notification-info {
        background-color: #007bff;
    }

    .notification-icon {
        margin-right: 10px;
        font-size: 18px;
    }
</style>

<script>
    /**
     * Show notification
     * @param {string} message - The message to display
     * @param {string} type - The type of notification (success, error, info)
     */
    function showNotification(message, type = 'info') {
        if (!message)
            return;

        const notification = document.createElement('div');
        notification.classList.add('custom-notification', 'notification-' + type);

        let iconHtml = '';
        if (type === 'success')
            iconHtml = '<i class="fas fa-check-circle"></i>';
        else if (type === 'error')
            iconHtml = '<i class="fas fa-exclamation-circle"></i>';
        else
            iconHtml = '<i class="fas fa-info-circle"></i>';

        notification.innerHTML =
                '<div class="notification-icon">' + iconHtml + '</div>' +
                '<div class="notification-message">' + message + '</div>';

        document.body.appendChild(notification);

        // Animate in
        setTimeout(() => notification.classList.add('show'), 10);

        // Auto remove after delay
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

</script>

<!-- ==============================
     Flash messages from session
============================== -->
<c:if test="${not empty sessionScope.flash}">
    <script> showNotification("${sessionScope.flash}", "success");</script>
    <c:remove var="flash" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_info}">
    <script> showNotification("${sessionScope.flash_info}", "info");</script>
    <c:remove var="flash_info" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.flash_error}">
    <script> showNotification("${sessionScope.flash_error}", "error");</script>
    <c:remove var="flash_error" scope="session"/>
</c:if>
