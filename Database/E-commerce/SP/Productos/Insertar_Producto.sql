USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Products_Create]
(
    @productName VARCHAR(50),
    @productDescription VARCHAR(200),
    @productProductIdentificatorId INT,
    @productMarkByProviderId INT,
    @productCreatorId INT,
    @productStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
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

    IF @productCreatorId IS NULL OR @productCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@productCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del producto (@productStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
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

    -- Validar unicidad del nombre del producto (evitar duplicados activos)
    IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productName = TRIM(@productName) AND productStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un producto activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_Products]
        (
            productName,
            productDescription,
            productProductIdentificatorId,
            productMarkByProviderId,
            productCreatorId,
            productCreationDate,
            productStatusId
        )
        VALUES
        (
            TRIM(@productName),
            TRIM(@productDescription),
            @productProductIdentificatorId,
            @productMarkByProviderId,
            @productCreatorId,
            GETDATE(),
            @productStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Producto creado correctamente.';
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


--- prueba
DECLARE @o_code INT;
DECLARE @o_message VARCHAR(255);
DECLARE @o_templateId INT;

-- 2. Ejecutamos directamente pasando los valores duros (Hardcoded)
EXEC [SQM_GENERAL].[sp_Products_Create]
    @productName = 'Lapto latitud insp',
    @productDescription = 'megaultracore',
    @productProductIdentificatorId = 1, 
    @productMarkByProviderId = 1,       
    @productCreatorId = 1,             
    @productStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;


	select * from [SQM_GENERAL].[Tbl_Products]