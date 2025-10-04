/* 
    Created on : Oct 2, 2025, 8:00:00 AM
    Author     : Le Huu Nghia - CE181052
*/

// Order page functionality
document.addEventListener('DOMContentLoaded', function() {
    // Set active menu based on current page
    const currentPath = window.location.pathname;
    const menuLinks = document.querySelectorAll('.nav-link-item');

    menuLinks.forEach(link => {
        const linkHref = link.getAttribute('href');
        link.classList.remove('active');

        if (currentPath.includes(linkHref.split('/').pop())) {
            link.classList.add('active');
        }
    });

    // Default to orders if no match
    const hasActive = document.querySelector('.nav-link-item.active');
    if (!hasActive) {
        const ordersLink = document.getElementById('order');
        if (ordersLink) {
            ordersLink.classList.add('active');
        }
    }
});

// Order status functions
function updateOrderStatus(orderId, newStatus) {
    if (confirm('Are you sure you want to update this order status?')) {
        // Add loading state
        const button = event.target;
        const originalText = button.innerHTML;
        button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
        button.disabled = true;

        // Simulate API call
        setTimeout(() => {
            button.innerHTML = originalText;
            button.disabled = false;
            showNotification('Order status updated successfully!', 'success');
        }, 1000);
    }
}

// Order detail functions - removed print and PDF functionality

// Utility functions
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `custom-notification notification-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'} notification-icon"></i>
        <span>${message}</span>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, 3000);
}
