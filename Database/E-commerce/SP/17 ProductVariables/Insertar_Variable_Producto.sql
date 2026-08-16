USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductVariables_Create]
(
    @productVariableProductId INT,
    @productVariableValue VARCHAR(50),
    @productVariablePrice DECIMAL(18,2),
    @productVariableCurrencyId INT,
    @productVariableCreatorId INT,
    @productVariableStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
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

    IF @productVariableCreatorId IS NULL OR @productVariableCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@productVariableCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la variable de producto (@productVariableStatusId) es obligatorio.';
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

    -- Validar existencia y estado activo del usuario creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad (evitar duplicados activos del mismo valor para el mismo producto)
    IF EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables]
        WHERE productVariableProductId = @productVariableProductId
          AND productVariableValue = TRIM(@productVariableValue)
          AND productVariableStatusId = 1
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una variable de producto activa con este mismo valor para el producto especificado.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables]
        (
            productVariableProductId,
            productVariableValue,
            productVariablePrice,
            productVariableCurrencyId,
            productVariableCreatorId,
            productVariableCreationDate,
            productVariableStatusId
        )
        VALUES
        (
            @productVariableProductId,
            TRIM(@productVariableValue),
            @productVariablePrice,
            @productVariableCurrencyId,
            @productVariableCreatorId,
            GETDATE(),
            @productVariableStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Variable de producto creada correctamente.';
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

EXEC [SQM_GENERAL].[sp_ProductVariables_Create]
    @productVariableProductId = 2,
    @productVariableValue = 'Color Negro',
    @productVariablePrice = 150.00,
    @productVariableCurrencyId = 1,
    @productVariableCreatorId = 1,
    @productVariableStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Generado];
GO

select * from [SQM_GENERAL].[Tbl_ProductVariables]