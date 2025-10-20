<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head><title>Create Return Request</title></head>
    <body>
        <h2>Create Return Request</h2>

        <!-- Order Summary -->
        <h3>Order Summary</h3>
        <p>Order ID: ${order.orderId}</p>
        <p>Total: ${order.totalAmount}</p>
        <p>Status: ${order.status}</p>

        <form action="return-request" method="post">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="customerId" value="1">


            <h3>Select Items to Return</h3>
            <table border="1">
                <tr>
                    <th>Select</th>
                    <th>Product</th>
                    <th>Qty</th>
                    <th>Price</th>
                    <th>Return Qty</th>
                </tr>
                <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td><input type="checkbox" name="productId" value="${item.productVariantId}"></td>
                        <td>${item.productName}</td>
                        <td>${item.detailQuantity}</td>
                        <td>${item.detailPrice}</td>
                        <td>
                            <input type="number" name="qty_${item.productVariantId}" value="${item.detailQuantity}" readonly>
                        </td>

                    </tr>
                </c:forEach>
            </table>

            <h3>Request Info</h3>
            <div class="form-group">
                <label for="reason">Return Reason <span class="required">*</span></label>
                <select id="reason" name="reason" required>
                    <option value="">-- Select a reason --</option>
                    <option value="Defective Product" ${returnRequest.reason == 'Defective Product' ? 'selected' : ''}>Defective Product</option>
                    <option value="Wrong Item" ${returnRequest.reason == 'Wrong Item' ? 'selected' : ''}>Wrong Item</option>
                    <option value="Not as Described" ${returnRequest.reason == 'Not as Described' ? 'selected' : ''}>Not as Described</option>
                    <option value="Changed Mind" ${returnRequest.reason == 'Changed Mind' ? 'selected' : ''}>Changed Mind</option>
                    <option value="Better Price Found" ${returnRequest.reason == 'Better Price Found' ? 'selected' : ''}>Better Price Found</option>
                    <option value="Other" ${returnRequest.reason == 'Other' ? 'selected' : ''}>Other</option>
                </select>
            </div>

            <label>Bank:</label><br>
            <select name="bankName" required>
                <option value="">-- Select Bank --</option>
                <option value="VCB">Vietcombank</option>
                <option value="ACB">ACB</option>
                <option value="VTB">VietinBank</option>
                <option value="TCB">Techcombank</option>
                <option value="MB">MB Bank</option>
                <option value="BIDV">BIDV</option>
                <option value="AGR">Agribank</option>
            </select>
            <br><br>

            <label>Account Number:</label><br>
            <input type="text" name="accountNumber" required placeholder="Enter account number">
            <br><br>

            <label>Account Holder Name:</label><br>
            <input type="text" name="accountHolder" required placeholder="Enter account holder name">
            <br><br>

            <label>Note:</label><br>
            <textarea name="note"></textarea><br><br>

            <button type="submit">Submit Request</button>
        </form>
    </body>
</html>
