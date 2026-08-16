USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES, HISTORIAL DE PRECIOS Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductVariables_Update]
(
    @productVariableId INT,
    @productVariableProductId INT,
    @productVariableValue VARCHAR(50),
    @productVariablePrice DECIMAL(18,2),
    @productVariableCurrencyId INT,
    @productVariableModificatorId INT,
    @productVariableStatusId BIT,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @productVariableId IS NULL OR @productVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variable de producto (@productVariableId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableProductId IS NULL OR @productVariableProductId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del producto (@productVariableProductId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableValue IS NULL OR LTRIM(RTRIM(@productVariableValue)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El valor de la variable (@productVariableValue) es obligatorio.';
        RETURN;
    END;

    IF @productVariablePrice IS NULL OR @productVariablePrice < 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El precio de la variable (@productVariablePrice) es obligatorio y no puede ser negativo.';
        RETURN;
    END;

    IF @productVariableCurrencyId IS NULL OR @productVariableCurrencyId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la moneda (@productVariableCurrencyId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableModificatorId IS NULL OR @productVariableModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@productVariableModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la variable de producto (@productVariableStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la variable de producto
    DECLARE @ExistingProductId INT;
    DECLARE @ExistingPrice DECIMAL(18,2);
    DECLARE @ExistingStatus BIT;

    SELECT 
        @ExistingProductId = productVariableProductId,
        @ExistingPrice = productVariablePrice,
        @ExistingStatus = productVariableStatusId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableId = @productVariableId;

    IF @ExistingProductId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variable de producto especificada no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo del producto
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @productVariableProductId AND productStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El producto especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo de la moneda
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] WHERE currencyId = @productVariableCurrencyId AND currencyStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda especificada no existe o se encuentra inactiva.';
        RETURN;
    END;

    -- Validar estado del registro y ForzarRecuperacion
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variable de producto está inactiva. Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Validar unicidad (evitar duplicar valores activos para el mismo producto)
    IF EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables]
        WHERE productVariableProductId = @productVariableProductId
          AND productVariableValue = TRIM(@productVariableValue)
          AND productVariableStatusId = 1
          AND productVariableId <> @productVariableId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra variable de producto activa con este mismo valor para el producto especificado.';
        RETURN;
    END;

    -- Bloque transaccional
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Actualizar variable de producto
        UPDATE [SQM_GENERAL].[Tbl_ProductVariables]
        SET productVariableProductId = @productVariableProductId,
            productVariableValue = TRIM(@productVariableValue),
            productVariablePrice = @productVariablePrice,
            productVariableCurrencyId = @productVariableCurrencyId,
            productVariableModificatorId = @productVariableModificatorId,
            productVariableModificationDate = GETDATE(),
            productVariableStatusId = @productVariableStatusId
        WHERE productVariableId = @productVariableId;

        -- Registrar cambio en historial de precios si el precio cambió
        IF @ExistingPrice <> @productVariablePrice
        BEGIN
            INSERT INTO [SQM_GENERAL].[Tbl_PriceHistory]
            (
                priceHistoryProductVariableId,
                priceHistoryOldPrice,
                priceHistoryNewPrice,
                priceHistoryChangeDate,
                priceHistoryModifierId
            )
            VALUES
            (
                @productVariableId,
                @ExistingPrice,
                @productVariablePrice,
                GETDATE(),
                @productVariableModificatorId
            );
        END;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Variable de producto actualizada correctamente.';
        SET @o_templateId = @productVariableId;
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


DECLARE @o_code INT;
DECLARE @o_message VARCHAR(255);
DECLARE @o_templateId INT;

EXEC [SQM_GENERAL].[sp_ProductVariables_Update]
    @productVariableId = 5,
    @productVariableProductId = 1,
    @productVariableValue = '8GB RAM - 256GB SSD',
    @productVariablePrice = 450.00,
    @productVariableCurrencyId = 1,
    @productVariableModificatorId = 1,
    @productVariableStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO

select * from [SQM_GENERAL].[Tbl_ProductVariables]