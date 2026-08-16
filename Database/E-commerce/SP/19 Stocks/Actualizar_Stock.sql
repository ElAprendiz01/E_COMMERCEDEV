USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Stocks_Update]
(
    @stockId INT,
    @stockQuantityAdjustment INT, -- Positivo para sumar, negativo para restar
    @stockModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @stockId IS NULL OR @stockId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de stock (@stockId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockQuantityAdjustment IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ajuste de cantidad (@stockQuantityAdjustment) es obligatorio.';
        RETURN;
    END;

    IF @stockModificatorId IS NULL OR @stockModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@stockModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia del lote de stock
    DECLARE @CurrentQuantity INT;
    DECLARE @StockStatus BIT;
    SELECT @CurrentQuantity = stockQuantity, @StockStatus = stockStatusId
    FROM [SQM_GENERAL].[Tbl_Stocks]
    WHERE stockId = @stockId;

    IF @CurrentQuantity IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El lote de stock especificado no existe.';
        RETURN;
    END;

    IF @StockStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El lote de stock especificado se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @stockModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar que el ajuste no resulte en stock negativo
    IF (@CurrentQuantity + @stockQuantityAdjustment) < 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Operación denegada. El ajuste solicitado resultaría en stock negativo (' + CAST((@CurrentQuantity + @stockQuantityAdjustment) AS VARCHAR(10)) + ').';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_Stocks]
        SET stockQuantity = stockQuantity + @stockQuantityAdjustment,
            stockModificatorId = @stockModificatorId,
            stockModificationDate = GETDATE()
        WHERE stockId = @stockId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Ajuste de stock realizado correctamente.';
        SET @o_templateId = @stockId;
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
