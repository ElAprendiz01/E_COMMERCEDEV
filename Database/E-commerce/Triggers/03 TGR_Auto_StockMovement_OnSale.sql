USE [DB_ECOMMERCE]
GO

CREATE OR ALTER TRIGGER [SQM_GENERAL].[trg_Auto_StockMovement_OnSale]
ON [SQM_GENERAL].[Tbl_PaymentOrderDetails]
AFTER INSERT
AS 
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[Tbl_StockMovements] 
    (stockMovementType, stockMovementOrderId, stockMovementReference, stockMovementDate, stockMovementCreatorId, stockMovementCreationDate, stockMovementStatusId)
    SELECT DISTINCT
        2, 
        i.orderDetailOrderId,
        'Venta Automática (Lotes) - Orden #' + CAST(i.orderDetailOrderId AS VARCHAR),
        GETDATE(),
        i.orderDetailCreatorId,
        GETDATE(),
        1
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovements] m 
        WHERE m.stockMovementOrderId = i.orderDetailOrderId AND m.stockMovementType = 2
    );

    DECLARE @orderDetailId INT, @productId INT, @qtyRequired INT, @creatorId INT, @movementId INT;

    DECLARE cur_Items CURSOR LOCAL FAST_FORWARD FOR
    SELECT i.orderDetailId, i.orderDetailProductVariableId, i.orderDetailQuantity, i.orderDetailCreatorId, m.stockMovementId
    FROM inserted i
    INNER JOIN [SQM_GENERAL].[Tbl_StockMovements] m 
        ON i.orderDetailOrderId = m.stockMovementOrderId AND m.stockMovementType = 2;

    OPEN cur_Items;
    FETCH NEXT FROM cur_Items INTO @orderDetailId, @productId, @qtyRequired, @creatorId, @movementId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @lotId INT, @lotQty INT, @lotFactoryDate DATE, @lotExpirationDate DATE, @qtyToTake INT;

        WHILE @qtyRequired > 0
        BEGIN
            SELECT TOP 1 
                @lotId = stockId, 
                @lotQty = stockQuantity, 
                @lotFactoryDate = stockFactoryDate, 
                @lotExpirationDate = stockExpirationDate
            FROM [SQM_GENERAL].[Tbl_Stocks]
            WHERE stockProductVariableId = @productId
              AND stockQuantity > 0
              AND stockStatusId = 1
            ORDER BY stockExpirationDate ASC, stockCreationDate ASC;

            IF @qtyRequired >= @lotQty
                SET @qtyToTake = @lotQty;
            ELSE
                SET @qtyToTake = @qtyRequired;

            INSERT INTO [SQM_GENERAL].[Tbl_StockMovementDetails]
            (stockMovementDetailMovementId, stockMovementDetailOrderDetailId, stockMovementDetailStockId, stockMovementDetailQuantity, stockMovementDetailFactoryDate, stockMovementDetailExpirationDate, stockMovementDetailCreatorId, stockMovementDetailCreationDate, stockMovementDetailStatusId)
            VALUES 
            (@movementId, @orderDetailId, @lotId, @qtyToTake, @lotFactoryDate, @lotExpirationDate, @creatorId, GETDATE(), 1);

            SET @qtyRequired = @qtyRequired - @qtyToTake;
        END

        FETCH NEXT FROM cur_Items INTO @orderDetailId, @productId, @qtyRequired, @creatorId, @movementId;
    END

    CLOSE cur_Items;
    DEALLOCATE cur_Items;
END
GO