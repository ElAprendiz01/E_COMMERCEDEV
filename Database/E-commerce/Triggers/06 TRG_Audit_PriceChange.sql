USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_Audit_PriceChange]
ON [SQM_GENERAL].[Tbl_ProductVariables]
AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(productVariablePrice)
    BEGIN
        INSERT INTO [SQM_GENERAL].[Tbl_PriceHistory] 
        (
            priceHistoryProductVariableId, 
            priceHistoryOldPrice, 
            priceHistoryNewPrice, 
            priceHistoryChangeDate, 
            priceHistoryModifierId
        )
        SELECT 
            i.productVariableId,
            d.productVariablePrice,
            i.productVariablePrice,
            GETDATE(),
            i.productVariableModificatorId
        FROM inserted i
        INNER JOIN deleted d ON i.productVariableId = d.productVariableId
        WHERE i.productVariablePrice <> d.productVariablePrice; 
    END
END
GO