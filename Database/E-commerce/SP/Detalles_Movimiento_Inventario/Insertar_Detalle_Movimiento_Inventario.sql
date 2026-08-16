USE [DB_ECOMMERCE]
GO


CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovementDetails_Create]
(
    @stockMovementDetailMovementId INT,
    @stockMovementDetailOrderDetailId INT = NULL,
    @stockMovementDetailStockId INT = NULL,
    @stockMovementDetailQuantity INT,
    @stockMovementDetailFactoryDate DATE = NULL,
    @stockMovementDetailExpirationDate DATE = NULL,
    @stockMovementDetailCreatorId INT,
    @stockMovementDetailStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @stockMovementDetailMovementId IS NULL OR @stockMovementDetailMovementId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del movimiento (@stockMovementDetailMovementId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockMovementDetailQuantity IS NULL OR @stockMovementDetailQuantity <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La cantidad de movimiento (@stockMovementDetailQuantity) es obligatoria y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockMovementDetailCreatorId IS NULL OR @stockMovementDetailCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@stockMovementDetailCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockMovementDetailStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del detalle (@stockMovementDetailStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado del movimiento padre
    DECLARE @MovementType INT;
    SELECT @MovementType = stockMovementType
    FROM [SQM_GENERAL].[Tbl_StockMovements]
    WHERE stockMovementId = @stockMovementDetailMovementId;

    IF @MovementType IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El movimiento de inventario especificado no existe.';
        RETURN;
    END;

    -- Validar existencia del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @stockMovementDetailCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia de la orden de pago detalle si se especifica
    IF @stockMovementDetailOrderDetailId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] WHERE orderDetailId = @stockMovementDetailOrderDetailId)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El detalle de la orden de pago especificado no existe.';
            RETURN;
        END;
    END;

    -- Validar existencia del stock/lote si se especifica
    DECLARE @CurrentStockQty INT = NULL;
    DECLARE @StockStatus BIT = NULL;
    IF @stockMovementDetailStockId IS NOT NULL
    BEGIN
        SELECT @CurrentStockQty = stockQuantity, @StockStatus = stockStatusId
        FROM [SQM_GENERAL].[Tbl_Stocks]
        WHERE stockId = @stockMovementDetailStockId;

        IF @CurrentStockQty IS NULL
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El lote de stock especificado no existe.';
            RETURN;
        END;

        IF @StockStatus = 0
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El lote de stock especificado está inactivo.';
            RETURN;
        END;
    END;

    -- Si el movimiento es de Salida o Ajuste Negativo, es obligatorio tener un lote de stock especificado
    IF @MovementType IN (2, 4) AND @stockMovementDetailStockId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Para movimientos de salida o ajuste negativo, se debe especificar un lote de stock de origen.';
        RETURN;
    END;

    -- Validar suficiente stock para Salidas (Venta = 2 o Ajuste Negativo = 4)
    IF @MovementType IN (2, 4) AND @CurrentStockQty < @stockMovementDetailQuantity
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Stock insuficiente en el lote seleccionado. Disponible: ' + CAST(@CurrentStockQty AS VARCHAR(10)) + ', Requerido: ' + CAST(@stockMovementDetailQuantity AS VARCHAR(10)) + '.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción y actualización automática de stock
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insertar el detalle de movimiento
        INSERT INTO [SQM_GENERAL].[Tbl_StockMovementDetails]
        (
            stockMovementDetailMovementId,
            stockMovementDetailOrderDetailId,
            stockMovementDetailStockId,
            stockMovementDetailQuantity,
            stockMovementDetailFactoryDate,
            stockMovementDetailExpirationDate,
            stockMovementDetailCreatorId,
            stockMovementDetailCreationDate,
            stockMovementDetailStatusId
        )
        VALUES
        (
            @stockMovementDetailMovementId,
            @stockMovementDetailOrderDetailId,
            @stockMovementDetailStockId,
            @stockMovementDetailQuantity,
            @stockMovementDetailFactoryDate,
            @stockMovementDetailExpirationDate,
            @stockMovementDetailCreatorId,
            GETDATE(),
            @stockMovementDetailStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- 2. Actualizar el stock automáticamente en Tbl_Stocks
        IF @stockMovementDetailStockId IS NOT NULL
        BEGIN
            -- Si es Entrada (1) o Ajuste Positivo (3), sumamos
            IF @MovementType IN (1, 3)
            BEGIN
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockQuantity = stockQuantity + @stockMovementDetailQuantity,
                    stockModificatorId = @stockMovementDetailCreatorId,
                    stockModificationDate = GETDATE()
                WHERE stockId = @stockMovementDetailStockId;
            END;
            -- Si es Salida (2) o Ajuste Negativo (4), restamos
            ELSE IF @MovementType IN (2, 4)
            BEGIN
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockQuantity = stockQuantity - @stockMovementDetailQuantity,
                    stockModificatorId = @stockMovementDetailCreatorId,
                    stockModificationDate = GETDATE()
                WHERE stockId = @stockMovementDetailStockId;
            END;
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Detalle de movimiento de inventario registrado y stock actualizado automáticamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO
