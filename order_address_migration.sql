-- Migration script to add OrderAddress table
-- This ensures order delivery information is preserved as snapshot

-- Create OrderAddress table
CREATE TABLE OrderAddress (
    OrderId INT NOT NULL,
    RecipientName VARCHAR(255) NOT NULL,
    RecipientPhone VARCHAR(50) NOT NULL,
    AddressName VARCHAR(255),
    AddressDetails TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (OrderId),
    FOREIGN KEY (OrderId) REFERENCES [Order](OrderId) ON DELETE CASCADE
);

-- Create index for better performance
CREATE INDEX IX_OrderAddress_OrderId ON OrderAddress(OrderId);

-- Migrate existing data (if any)
-- This will populate OrderAddress with current address data from existing orders
INSERT INTO OrderAddress (OrderId, RecipientName, RecipientPhone, AddressName, AddressDetails, CreatedAt, UpdatedAt)
SELECT 
    o.OrderId,
    ISNULL(a.RecipientName, 'Unknown') as RecipientName,
    ISNULL(a.RecipientPhone, 'Unknown') as RecipientPhone,
    a.AddressName,
    ISNULL(a.AddressDetails, 'Address not available') as AddressDetails,
    o.PlacedAt as CreatedAt,
    o.UpdatedAt as UpdatedAt
FROM [Order] o
LEFT JOIN Address a ON o.AddressId = a.AddressId
WHERE o.AddressId IS NOT NULL;

-- Add comments for documentation
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Stores snapshot of delivery address information at the time of order placement. This ensures order delivery details are preserved even if customer changes their address later.', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'OrderAddress';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Name of the person who will receive the order', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'OrderAddress', 
    @level2type = N'COLUMN', @level2name = N'RecipientName';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Phone number of the recipient for delivery contact', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'OrderAddress', 
    @level2type = N'COLUMN', @level2name = N'RecipientPhone';
