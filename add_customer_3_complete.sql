-- =============================================
-- Script: Thêm Customer ID = 3 hoàn chỉnh
-- Mục đích: Test với customer có đầy đủ address và cart items
-- =============================================

-- 1. Thêm Customer ID = 3
SET IDENTITY_INSERT [dbo].[Customer] ON;
INSERT [dbo].[Customer] ([CustomerId], [Email], [PasswordHash], [Name], [PhoneNumber], [Avatar], [Gender], [CreatedAt], [UpdatedAt], [IsBlock], [IsDeleted]) 
VALUES (3, N'customer3@example.com', N'd847f5bbe427010efbf1e27934b8efcb', N'Test Customer', N'0911111111', NULL, N'Male', 
        CAST(N'2025-01-01T00:00:00.0000000' AS DateTime2), CAST(N'2025-01-01T00:00:00.0000000' AS DateTime2), 0, 0);
SET IDENTITY_INSERT [dbo].[Customer] OFF;

-- 2. Thêm Address cho Customer ID = 3
SET IDENTITY_INSERT [dbo].[Address] ON;
INSERT [dbo].[Address] ([AddressId], [CustomerId], [AddressName], [AddressDetails], [RecipientName], [RecipientPhone], [IsDefault], [IsDeleted]) 
VALUES (3, 3, N'Home Address', N'123 Test Street, District 1, HCMC', N'Test Customer', N'0911111111', 1, 0);

INSERT [dbo].[Address] ([AddressId], [CustomerId], [AddressName], [AddressDetails], [RecipientName], [RecipientPhone], [IsDefault], [IsDeleted]) 
VALUES (4, 3, N'Office Address', N'456 Business District, District 3, HCMC', N'Test Customer', N'0911111111', 0, 0);
SET IDENTITY_INSERT [dbo].[Address] OFF;

-- 3. Thêm Cart Items cho Customer ID = 3
SET IDENTITY_INSERT [dbo].[CartItem] ON;
INSERT [dbo].[CartItem] ([CartItemId], [CustomerId], [ProductVariantId], [Quantity], [CreatedAt]) 
VALUES (7, 3, 1, 2, CAST(N'2025-01-01T10:00:00.0000000' AS DateTime2)); -- Nike Air Max 90

INSERT [dbo].[CartItem] ([CartItemId], [CustomerId], [ProductVariantId], [Quantity], [CreatedAt]) 
VALUES (8, 3, 10, 1, CAST(N'2025-01-01T10:30:00.0000000' AS DateTime2)); -- Adidas Ultraboost 22

INSERT [dbo].[CartItem] ([CartItemId], [CustomerId], [ProductVariantId], [Quantity], [CreatedAt]) 
VALUES (9, 3, 28, 3, CAST(N'2025-01-01T11:00:00.0000000' AS DateTime2)); -- Converse Chuck Taylor
SET IDENTITY_INSERT [dbo].[CartItem] OFF;

-- 4. Thêm một Order test cho Customer ID = 3 (optional)
SET IDENTITY_INSERT [dbo].[Order] ON;
INSERT [dbo].[Order] ([OrderId], [CustomerId], [AddressId], [PaymentMethodId], [PaymentStatusId], [VoucherId], [TotalAmount], [ShippingFee], [PlacedAt], [UpdatedAt]) 
VALUES (3, 3, 3, 1, 1, NULL, CAST(150.00 AS Decimal(18, 2)), CAST(10.00 AS Decimal(18, 2)), 
        CAST(N'2025-01-01T12:00:00.0000000' AS DateTime2), CAST(N'2025-01-01T12:00:00.0000000' AS DateTime2));
SET IDENTITY_INSERT [dbo].[Order] OFF;

-- 5. Thêm Order Details cho Order ID = 3
SET IDENTITY_INSERT [dbo].[OrderDetail] ON;
INSERT [dbo].[OrderDetail] ([OrderDetailId], [OrderId], [ProductVariantId], [DetailQuantity], [DetailPrice], [AddressDetail]) 
VALUES (3, 3, 1, 1, CAST(120.00 AS Decimal(18, 2)), N'123 Test Street, District 1, HCMC');

INSERT [dbo].[OrderDetail] ([OrderDetailId], [OrderId], [ProductVariantId], [DetailQuantity], [DetailPrice], [AddressDetail]) 
VALUES (4, 3, 10, 1, CAST(140.00 AS Decimal(18, 2)), N'123 Test Street, District 1, HCMC');
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF;

-- =============================================
-- Kiểm tra dữ liệu sau khi insert
-- =============================================

PRINT '=== Customer ID = 3 Information ===';
SELECT 'Customer' as TableName, CustomerId, Name, Email FROM Customer WHERE CustomerId = 3;
SELECT 'Address' as TableName, AddressId, CustomerId, AddressName, AddressDetails, RecipientName FROM Address WHERE CustomerId = 3;
SELECT 'CartItem' as TableName, CartItemId, CustomerId, ProductVariantId, Quantity FROM CartItem WHERE CustomerId = 3;
SELECT 'Order' as TableName, OrderId, CustomerId, AddressId, TotalAmount, PlacedAt FROM [Order] WHERE CustomerId = 3;
SELECT 'OrderDetail' as TableName, OrderDetailId, OrderId, ProductVariantId, DetailQuantity, DetailPrice FROM OrderDetail WHERE OrderId = 3;

PRINT '=== Summary ===';
PRINT 'Customer ID = 3 has been created with:';
PRINT '- 2 Addresses (Home + Office)';
PRINT '- 3 Cart Items (Nike, Adidas, Converse)';
PRINT '- 1 Test Order with 2 items';
PRINT 'Ready for complete testing!';
