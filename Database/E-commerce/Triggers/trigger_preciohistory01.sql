CREATE TRIGGER [SQM_GENERAL].[trg_ProductVariables_PriceHistory]
ON [SQM_GENERAL].[Tbl_ProductVariables]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [SQM_GENERAL].[Tbl_PriceHistory]
    (
        priceHistoryProductVariableId,
        priceHistoryOldPrice,
        priceHistoryNewPrice,
        priceHistoryChangeDate,
        priceHistoryModifierId
    )
    SELECT 
        d.productVariableId,
        d.productVariablePrice,
        i.productVariablePrice,
        GETDATE(),
        i.productVariableModificatorId
    FROM deleted d
    INNER JOIN inserted i ON d.productVariableId = i.productVariableId
    WHERE d.productVariablePrice <> i.productVariablePrice;
END;