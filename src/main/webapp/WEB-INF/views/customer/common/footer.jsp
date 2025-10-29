<%-- 
    Document   : footer
    Created on : Oct 15, 2025, 9:14:33 PM
    Author     : Le Huu Nghia - CE181052
--%>

<style>
    body {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .footer-gradient {
        background: linear-gradient(135deg, #0f172a 0%, #020617 100%);
        border-top: 1px solid #1e293b;
        margin-top: auto;
    }

    .footer-text {
        color: #bfdbfe;
    }

    .footer-heading {
        color: #ffffff;
        font-weight: 600;
    }

    .footer-link {
        color: #bfdbfe;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .footer-link:hover {
        color: #ffffff;
    }

    .logo-icon {
        color: #fbbf24;
    }

    .copyright-text {
        color: #93c5fd;
        border-top: 1px solid #1e293b;
    }

    .tagline {
        color: #93c5fd;
    }
</style>

<!-- Footer -->
<footer class="footer-gradient py-5">
    <div class="container">
        <div class="row g-4 py-4">
            <!-- Logo & Tagline -->
            <div class="col-12 col-md-6 col-lg-4">
                <div class="d-flex align-items-center mb-3">
                    <svg class="logo-icon me-2" width="32" height="32" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                    </svg>
                    <h2 class="footer-heading h5 mb-0">Neo Shoes</h2>
                </div>
                <p class="tagline small">
                    High quality sneakers from top brands. Your style, ultimate comfort.
                </p>
            </div>

            <!-- Members -->
            <div class="col-12 col-md-6 col-lg-4 text-md-center">
                <h3 class="footer-heading h6 mb-3">Member</h3>
                <ul class="list-unstyled footer-text small mb-0">
                    <li class="mb-2">CE190386 - Chau Gia Huy</li>
                    <li class="mb-2">CE181052 - Le Huu Nghia</li>
                    <li class="mb-2">CE181532 - Tran Hien Dieu</li>
                    <li class="mb-2">CE182078 - Tang Minh Vinh Quang</li>
                    <li class="mb-2">CE190979 - Nguyen Huynh Thien An</li>
                </ul>
            </div>

            <!-- Support -->
            <div class="col-12 col-md-6 col-lg-4 text-lg-end">
                <h3 class="footer-heading h6 mb-3">Support</h3>
                <ul class="list-unstyled small mb-0">
                    <li class="mb-2">
                        <a href="#" class="footer-link">FAQ</a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="footer-link">Shipping & Returns</a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="footer-link">Terms & Conditions</a>
                    </li>
                    <li class="mb-2">
                        <a href="#" class="footer-link">Privacy Policy</a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Copyright -->
        <div class="copyright-text text-center pt-4 mt-4 small">
            © 2025 Neo Shoes. All rights reserved.
        </div>
    </div>
</footer>
