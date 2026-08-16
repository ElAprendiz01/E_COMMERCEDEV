USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_SECURITY].[trg_AutoCreate_Cart_OnRegister]
ON [SQM_SECURITY].[Tbl_Users]
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[Tbl_Carts] 
    (
        cartUserId, 
        cartCreatorId, 
        cartCreationDate, 
        cartStatusId
    )
    SELECT 
        i.userId,
        i.userId,
        GETDATE(),
        1
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM [SQM_GENERAL].[Tbl_Carts] c 
        WHERE c.cartUserId = i.userId
    );

END
GO