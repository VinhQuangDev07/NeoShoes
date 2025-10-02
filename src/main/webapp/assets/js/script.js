/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * NeoShoes Main JavaScript File
 * This file provides UI enhancements and animations
 */

/**
 * Show notification
 * @param {string} message - The message to display
 * @param {string} type - The type of notification (success, error, info)
 */
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.classList.add('custom-notification', `notification-${type}`);
    notification.innerHTML = `
        <div class="notification-icon">
            ${type === 'success' ? '<i class="fas fa-check-circle"></i>' :
            type === 'error' ? '<i class="fas fa-exclamation-circle"></i>' :
            '<i class="fas fa-info-circle"></i>'}
        </div>
        <div class="notification-message">${message}</div>
    `;

    document.body.appendChild(notification);

    // Animate in
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);

    // Automatically remove after delay
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}


// Common helpers
function setErrorInput(input, errorMessage) {
    input.classList.remove("is-valid");
    input.classList.add("is-invalid");

    let feedback = input.parentElement.querySelector(".invalid-feedback");
    if (!feedback) {
        feedback = document.createElement("div");
        feedback.className = "invalid-feedback";
        input.parentElement.appendChild(feedback);
    }
    feedback.innerText = errorMessage;
}

function setSuccessInput(input) {
    input.classList.remove("is-invalid");
    input.classList.add("is-valid");

    let feedback = input.parentElement.querySelector(".invalid-feedback");
    if (feedback) {
        feedback.innerText = "";
    }
}

