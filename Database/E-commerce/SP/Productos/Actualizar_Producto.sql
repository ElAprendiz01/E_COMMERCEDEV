USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Products_Update]
(
    @productId INT,
    @productName VARCHAR(50),
    @productDescription VARCHAR(200),
    @productProductIdentificatorId INT,
    @productMarkByProviderId INT,
    @productModificatorId INT,
    @productStatusId BIT,
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
    IF @productId IS NULL OR @productId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del producto (@productId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productName IS NULL OR LTRIM(RTRIM(@productName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del producto (@productName) es obligatorio.';
        RETURN;
    END;

    IF @productDescription IS NULL OR LTRIM(RTRIM(@productDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción del producto (@productDescription) es obligatoria.';
        RETURN;
    END;

    IF @productProductIdentificatorId IS NULL OR @productProductIdentificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del identificador de producto (@productProductIdentificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productMarkByProviderId IS NULL OR @productMarkByProviderId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la marca por proveedor (@productMarkByProviderId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productModificatorId IS NULL OR @productModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@productModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del producto (@productStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del producto
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @productId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El producto especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado del identificador del producto
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] WHERE productIdentificatorId = @productProductIdentificatorId AND productIdentificatorStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El identificador de producto especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado de la marca por proveedor
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_MarkByProviders] WHERE markByProviderId = @productMarkByProviderId AND markByProviderStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La marca por proveedor especificada no existe o se encuentra inactiva.';
        RETURN;
    END;

    -- Validar estado de inactividad previa del registro
    IF @ForzarRecuperacion = 0 AND EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @productId AND productStatusId = 0)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El producto está inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otros productos activos
    IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productName = TRIM(@productName) AND productStatusId = 1 AND productId <> @productId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro producto activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_Products]
        SET productName = TRIM(@productName),
            productDescription = TRIM(@productDescription),
            productProductIdentificatorId = @productProductIdentificatorId,
            productMarkByProviderId = @productMarkByProviderId,
            productModificatorId = @productModificatorId,
            productModificationDate = GETDATE(),
            productStatusId = @productStatusId
        WHERE productId = @productId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Producto actualizado correctamente.';
        SET @o_templateId = @productId;
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

EXEC [SQM_GENERAL].[sp_Products_Update]
    @productId = 5,
    @productName = 'Laptop Dell Latitude Inspiron',
    @productDescription = 'Mega Ultra Core - Actualizado',
    @productProductIdentificatorId = 1,
    @productMarkByProviderId = 1,
    @productModificatorId = 1,
    @productStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO
