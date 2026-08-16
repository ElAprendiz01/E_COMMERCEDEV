USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_Sync_Inventory]
ON [SQM_GENERAL].[Tbl_StockMovementDetails]
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET 
        s.stockQuantity = s.stockQuantity + (
            CASE 
                WHEN m.stockMovementType IN (1, 3) THEN i.stockMovementDetailQuantity
                
                WHEN m.stockMovementType IN (2, 4) THEN -i.stockMovementDetailQuantity
                
                ELSE 0 
            END
        ),
        s.stockModificationDate = GETDATE()
    FROM [SQM_GENERAL].[Tbl_Stocks] s
    INNER JOIN inserted i ON s.stockId = i.stockMovementDetailStockId
    INNER JOIN [SQM_GENERAL].[Tbl_StockMovements] m ON i.stockMovementDetailMovementId = m.stockMovementId
    WHERE i.stockMovementDetailStockId IS NOT NULL;

END
GO