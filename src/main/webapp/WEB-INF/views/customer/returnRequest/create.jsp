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

        <form action="returnRequest" method="post">
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
                        <td><input type="number" name="qty_${item.productVariantId}" min="1" max="${item.detailQuantity}"></td>
                    </tr>
                </c:forEach>
            </table>

            <h3>Request Info</h3>
            <label>Reason:</label><br>
            <textarea name="reason" required></textarea><br><br>

            <label>Bank Account (optional):</label><br>
            <input type="text" name="bankAccountInfo"><br><br>

            <label>Note:</label><br>
            <textarea name="note"></textarea><br><br>

            <button type="submit">Submit Request</button>
        </form>
    </body>
</html>
