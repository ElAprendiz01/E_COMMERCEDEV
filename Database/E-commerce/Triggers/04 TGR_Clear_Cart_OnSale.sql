USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_Clear_Cart_OnSale]
ON [SQM_GENERAL].[Tbl_PaymentOrders] 
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    DELETE cd
    FROM [SQM_GENERAL].[Tbl_CartDetails] cd
    INNER JOIN [SQM_GENERAL].[Tbl_Carts] c ON cd.cartDetailCartId = c.cartId
    INNER JOIN inserted i ON c.cartUserId = i.orderUserId;

END
GO