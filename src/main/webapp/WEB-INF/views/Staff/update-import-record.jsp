<%-- 
    Document   : update-import-record
    Created on : Oct 20, 2025, 9:48:09 PM
    Author     : Le Huu Nghia - CE181052
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Import Record - Admin Dashboard</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest"></script>

        <style>
            body {
                background-color: #f8f9fa;
                padding: 2rem;
            }

            .page-header {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .form-card {
                background: white;
                border-radius: 12px;
                padding: 2rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .table-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .table > :not(caption) > * > * {
                padding: 0.75rem;
                vertical-align: middle;
            }

            .table thead th {
                background-color: #f8f9fa;
                font-weight: 600;
                font-size: 0.875rem;
                color: #6c757d;
                border-bottom: 2px solid #dee2e6;
            }

            .variant-selector {
                cursor: pointer;
                padding: 0.5rem;
                border-radius: 6px;
                border: 1px solid #dee2e6;
                transition: all 0.2s;
                min-height: 40px;
                display: flex;
                align-items: center;
            }

            .variant-selector:hover {
                background-color: #f8f9fa;
                border-color: #0d6efd;
            }

            .variant-selector.selected {
                background-color: #e7f1ff;
                border-color: #0d6efd;
            }

            .total-section {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 1.5rem;
                margin-top: 1rem;
            }

            .form-floating.error input,
            .form-floating.error textarea {
                border-color: #dc3545;
            }

            .form-floating small {
                color: #dc3545;
                font-size: 0.875rem;
                display: none;
            }

            .form-floating.error small {
                display: block;
            }

            .product-item, .variant-option {
                padding: 0.75rem;
                cursor: pointer;
                border-bottom: 1px solid #f0f0f0;
                transition: background-color 0.2s;
            }

            .product-item:hover, .variant-option:hover {
                background-color: #f8f9fa;
            }

            .product-info {
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .product-image {
                width: 50px;
                height: 50px;
                border-radius: 6px;
                object-fit: cover;
                border: 1px solid #dee2e6;
            }

            .status-badge {
                display: inline-block;
                padding: 0.35rem 0.65rem;
                border-radius: 4px;
                font-size: 0.875rem;
                font-weight: 500;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #664d03;
            }

            .status-completed {
                background-color: #d1e7dd;
                color: #0f5132;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 0.5rem 0;
                border-bottom: 1px solid #f0f0f0;
            }

            .info-row strong {
                color: #495057;
            }

            .info-row span {
                color: #212529;
            }
        </style>
    </head>
    <body>
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">Update Import Record</h2>
                    <p class="text-muted mb-0">Edit import record #${importRecord.importProductId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/staff/import-records" 
                   class="btn btn-outline-secondary">
                    <i data-lucide="arrow-left" style="width: 18px; height: 18px;"></i>
                    Back to List
                </a>
            </div>
        </div>

        <!-- Update Form -->
        <form method="post" id="updateForm" action="${pageContext.request.contextPath}/staff/update-import-record">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="importProductId" value="${importRecord.importProductId}"/>

            <!-- Record Information -->
            <div class="form-card">
                <h5 class="mb-3">Record Information</h5>
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="importId" value="#${importRecord.importProductId}" disabled>
                            <label for="importId">Import ID</label>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="createdBy" value="${importRecord.staffName}" disabled>
                            <label for="createdBy">Created By</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Import Information -->
            <div class="form-card">
                <h5 class="mb-3">Import Information</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="supplierName" name="supplierName" 
                                   value="${fn:escapeXml(importRecord.supplierName)}" placeholder="Supplier Name">
                            <label for="supplierName">Supplier Name (Optional)</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="importDate" name="importDate" 
                                   value="${importRecord.formattedImportDate}" placeholder="Import Date" disabled>
                            <label for="importDate">Import Date</label>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-floating">
                            <textarea class="form-control" id="note" name="note" placeholder="Note" 
                                      style="height: 100px">${fn:escapeXml(importRecord.note)}</textarea>
                            <label for="note">Note (Optional)</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Import Details Table -->
            <div class="table-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">Import Details</h5>
                    <button type="button" id="addLineBtn" class="btn btn-sm btn-primary">
                        <i data-lucide="plus" style="width: 16px; height: 16px;"></i>
                        Add Line
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle mb-0" id="linesTable">
                        <thead>
                            <tr>
                                <th style="width: 40%">Product & Variant</th>
                                <th style="width: 15%">Quantity</th>
                                <th style="width: 20%">Cost Price ($)</th>
                                <th style="width: 20%">Subtotal ($)</th>
                                <th style="width: 5%">Action</th>
                            </tr>
                        </thead>
                        <tbody id="linesTableBody">
                            <c:forEach var="line" items="${importRecord.importProductDetails}">
                                <tr data-line-id="${line.importProductDetailId}">
                                    <td>
                                        <input type="hidden" name="lineIds[]" value="${line.importProductDetailId}">
                                        <input type="hidden" name="productIds[]" value="${line.productId}">
                                        <input type="hidden" name="variantIds[]" value="${line.productVariantId}">
                                        <input type="hidden" name="colors[]" value="${fn:escapeXml(line.color)}">
                                        <input type="hidden" name="sizes[]" value="${fn:escapeXml(line.size)}">
                                        <div class="variant-selector selected" style="cursor: pointer;">
                                            ${line.productName} - ${line.color} - ${line.size}
                                        </div>
                                    </td>
                                    <td>
                                        <input type="number" name="quantities[]" class="form-control quantity-input" 
                                               min="1" value="${line.quantity}" required>
                                    </td>
                                    <td>
                                        <input type="hidden" name="costPrices[]" class="cost-price-hidden" value="${line.costPrice}">
                                        <strong class="cost-price-display">${line.costPrice}</strong>
                                    </td>
                                    <td class="text-end">
                                        <strong class="subtotal">${line.costPrice * line.quantity}</strong>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-danger btn-remove">
                                            <i data-lucide="trash-2" style="width: 14px; height: 14px;"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Total Section -->
                <div class="total-section">
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Total Items:</strong> <span id="totalItems">0</span></p>
                            <p class="mb-0"><strong>Total Quantity:</strong> <span id="totalQuantity">0</span></p>
                        </div>
                        <div class="col-md-6 text-end">
                            <h4 class="mb-0">
                                <strong>Total Cost:</strong> 
                                <span class="text-primary" id="totalCost">0$</span>
                            </h4>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/staff/import-records" class="btn btn-outline-secondary">
                    Cancel
                </a>
                <button type="submit" class="btn btn-primary">
                    <i data-lucide="save" style="width: 18px; height: 18px;"></i>
                    Update Import
                </button>
            </div>
        </form>

        <!-- Product Selection Modal -->
        <div class="modal fade" id="productModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <input type="text" id="productSearch" class="form-control" placeholder="Search products...">
                        </div>
                        <div id="productList" style="max-height: 400px; overflow-y: auto;">
                            <c:forEach var="product" items="${products}">
                                <div class="product-item" 
                                     data-product-id="${product.productId}"
                                     data-product-name="${fn:escapeXml(product.name)}"
                                     data-product-image="${fn:escapeXml(product.defaultImageUrl)}">
                                    <div class="product-info">
                                        <img src="${product.defaultImageUrl}" alt="Product" class="product-image"
                                             onerror="this.src='https://nftcalendar.io/storage/uploads/2022/02/21/image-not-found_0221202211372462137974b6c1a.png'">
                                        <div>
                                            <div><strong>#${product.productId} - ${product.name}</strong></div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Variant Selection Modal -->
        <div class="modal fade" id="variantModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Select Variant for <strong id="selectedProductName"></strong></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <h6 class="mb-3">Existing Variants</h6>
                        <div id="variantList" style="max-height: 250px; overflow-y: auto; margin-bottom: 1.5rem; border: 1px solid #dee2e6; border-radius: 6px;">
                            <!-- Variants will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap & Script -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            lucide.createIcons();
            
            // Product variants grouped by product ID
            const productVariantsData = {
            <c:forEach var="product" items="${products}" varStatus="status">
            "${product.productId}": [
                <c:forEach var="variant" items="${product.variants}" varStatus="vStatus">
            {
            variantId: ${variant.productVariantId},
                    color: "${fn:escapeXml(variant.color)}",
                    size: "${fn:escapeXml(variant.size)}",
                    image: "${fn:escapeXml(variant.image)}",
                    price: ${variant.price}
            }${!vStatus.last ? ',' : ''}
                </c:forEach>
            ]${!status.last ? ',' : ''}
            </c:forEach>
            };

            let currentLineRow = null;
            let selectedProduct = null;
            let lineCount = 0;

            const productModal = new bootstrap.Modal(document.getElementById('productModal'));
            const variantModal = new bootstrap.Modal(document.getElementById('variantModal'));

            // Initialize on page load
            document.addEventListener('DOMContentLoaded', function() {
            calculateTotals();
            });

            // Add Line Button
            document.getElementById('addLineBtn').addEventListener('click', function() {
            currentLineRow = null;
            lineCount++;
            addEmptyLine();
            });

            // Add empty row to table
            function addEmptyLine() {
            const tbody = document.getElementById('linesTableBody');
            const row = document.createElement('tr');
            row.dataset.lineNumber = lineCount;
            row.innerHTML = `
                    <td>
                        <input type="hidden" name="productIds[]" value="">
                        <input type="hidden" name="variantIds[]" value="">
                        <input type="hidden" name="colors[]" value="">
                        <input type="hidden" name="sizes[]" value="">
                        <div class="variant-selector" style="cursor: pointer; color: #6b7280;">
                            <em>Click to select variant...</em>
                        </div>
                    </td>
                    <td>
                        <input type="number" name="quantities[]" class="form-control quantity-input" min="1" value="1" required>
                    </td>
                    <td>
                        <input type="hidden" name="costPrices[]" class="cost-price-hidden" value="0">
                        <strong class="cost-price-display">0$</strong>
                    </td>
                    <td class="text-end">
                        <strong class="subtotal">0$</strong>
                    </td>
                    <td class="text-center">
                        <button type="button" class="btn btn-sm btn-danger btn-remove">
                            <i data-lucide="trash-2" style="width: 14px; height: 14px;"></i>
                        </button>
                    </td>
                `;
            tbody.appendChild(row);
            lucide.createIcons();

            // Event listeners
            const variantSelector = row.querySelector('.variant-selector');
            variantSelector.addEventListener('click', function() {
            currentLineRow = row;
            productModal.show();
            });

            const quantityInput = row.querySelector('.quantity-input');
            quantityInput.addEventListener('input', calculateTotals);
            quantityInput.addEventListener('change', calculateTotals);

            row.querySelector('.btn-remove').addEventListener('click', function() {
            row.remove();
            calculateTotals();
            });
            }

            // Product selection
            document.querySelectorAll('.product-item').forEach(item => {
            item.addEventListener('click', function() {
            selectedProduct = {
            id: this.dataset.productId,
                    name: this.dataset.productName,
                    image: this.dataset.productImage
            };
            productModal.hide();
            showVariantModal();
            });
            });

            // Show variant modal
            function showVariantModal() {
            document.getElementById('selectedProductName').textContent = selectedProduct.name;
            const variantList = document.getElementById('variantList');
            variantList.innerHTML = '';
            const variants = productVariantsData[selectedProduct.id] || [];

            if (variants.length === 0) {
            variantList.innerHTML = '<p class="text-muted text-center py-3">No existing variants</p>';
            } else {
            variants.forEach(variant => {
            const div = document.createElement('div');
            div.className = 'variant-option';
            div.innerHTML = '<strong>' + selectedProduct.name + ' - ' + variant.color + ' - ' + variant.size + '</strong>';
            div.addEventListener('click', function() {
            selectVariant(variant.variantId, variant.color, variant.size);
            });
            variantList.appendChild(div);
            });
            }

            variantModal.show();
            }

            // Select variant
            function selectVariant(variantId, color, size) {
            const displayText = selectedProduct.name + ' - ' + color + ' - ' + size;
            let costPrice = 0;
            const variants = productVariantsData[selectedProduct.id] || [];
            const variant = variants.find(v => v.variantId == variantId);

            if (variant) {
            costPrice = variant.price || 0;
            }

            currentLineRow.querySelector('.variant-selector').innerHTML = displayText;
            currentLineRow.querySelector('.variant-selector').classList.add('selected');
            currentLineRow.querySelector('input[name="productIds[]"]').value = selectedProduct.id;
            currentLineRow.querySelector('input[name="variantIds[]"]').value = variantId || '';
            currentLineRow.querySelector('input[name="colors[]"]').value = color;
            currentLineRow.querySelector('input[name="sizes[]"]').value = size;
            currentLineRow.querySelector('.cost-price-hidden').value = costPrice;
            currentLineRow.querySelector('.cost-price-display').textContent = costPrice.toLocaleString('en-US', {style: 'currency', currency: 'USD'});

            variantModal.hide();
            calculateTotals();
            }

            // Product search
            document.getElementById('productSearch').addEventListener('input', function(e) {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.product-item').forEach(item => {
            item.style.display = item.textContent.toLowerCase().includes(term) ? 'block' : 'none';
            });
            });

            // Calculate totals
            function calculateTotals() {
            let totalItems = 0;
            let totalQty = 0;
            let totalCost = 0;

            document.querySelectorAll('#linesTableBody tr').forEach(row => {
            const qty = parseInt(row.querySelector('.quantity-input').value) || 0;
            const cost = parseFloat(row.querySelector('.cost-price-hidden').value) || 0;
            const subtotal = qty * cost;

            row.querySelector('.cost-price-display').textContent = cost.toLocaleString('en-US', {style: 'currency', currency: 'USD'});
            row.querySelector('.subtotal').textContent = subtotal.toLocaleString('en-US', {style: 'currency', currency: 'USD'});

            if (row.querySelector('input[name="productIds[]"]').value) {
            totalItems++;
            totalQty += qty;
            totalCost += subtotal;
            }
            });

            document.getElementById('totalItems').textContent = totalItems;
            document.getElementById('totalQuantity').textContent = totalQty;
            document.getElementById('totalCost').textContent = totalCost.toLocaleString('en-US', {style: 'currency', currency: 'USD'});
            }

            // Form validation
            document.getElementById('updateForm').addEventListener('submit', function(e) {
            e.preventDefault();

            if (!document.getElementById('importDate').value) {
            alert('Import date is required');
            return;
            }

            const lines = document.querySelectorAll('#linesTableBody tr');
            if (lines.length === 0) {
            alert('Please add at least one line');
            return;
            }

            let valid = true;
            lines.forEach(row => {
            if (!row.querySelector('input[name="productIds[]"]').value) {
            alert('Please select a variant for all lines');
            valid = false;
            }
            });

            if (valid) this.submit();
            });

            // Attach event listeners to existing remove buttons
            document.querySelectorAll('.btn-remove').forEach(btn => {
            btn.addEventListener('click', function() {
            this.closest('tr').remove();
            calculateTotals();
            });
            });

            // Attach event listeners to existing quantity inputs
            document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('input', calculateTotals);
            input.addEventListener('change', calculateTotals);
            });

            // Attach event listeners to existing variant selectors (for editing)
            document.querySelectorAll('.variant-selector').forEach(selector => {
            if (selector.classList.contains('selected')) {
            selector.style.cursor = 'pointer';
            selector.addEventListener('click', function() {
            currentLineRow = this.closest('tr');
            productModal.show();
            });
            }
            });
        </script>
    </body>
</html>
