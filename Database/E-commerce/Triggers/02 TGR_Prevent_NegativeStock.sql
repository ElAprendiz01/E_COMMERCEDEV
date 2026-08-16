USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_Prevent_NegativeStock]
ON [SQM_GENERAL].[Tbl_PaymentOrderDetails]
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT i.orderDetailProductVariableId
        FROM inserted i
        OUTER APPLY (
            SELECT ISNULL(SUM(s.stockQuantity), 0) AS TotalStock
            FROM [SQM_GENERAL].[Tbl_Stocks] s
            WHERE s.stockProductVariableId = i.orderDetailProductVariableId
              AND s.stockStatusId = 1
        ) AS StockDisponible
        WHERE i.orderDetailQuantity > StockDisponible.TotalStock
    )
    BEGIN
        ROLLBACK TRANSACTION;
        
        RAISERROR ('Transacción rechazada: No hay suficiente stock activo en bodega para uno o más productos de la orden.', 16, 1);
        RETURN;
    END
END
GO