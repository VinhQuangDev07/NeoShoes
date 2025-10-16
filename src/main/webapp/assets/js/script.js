/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * NeoShoes Main JavaScript File
 * This file provides UI enhancements and animations
 */

/* ==============================
     Input validation helpers
     ============================== */
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