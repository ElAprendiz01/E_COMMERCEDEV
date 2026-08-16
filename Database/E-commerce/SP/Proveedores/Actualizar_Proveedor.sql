USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Providers_Update]
(
    @providerId INT,
    @providerName VARCHAR(50),
    @providerDescription VARCHAR(100),
    @providerModificatorId INT,
    @providerStatusId BIT,
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
    IF @providerId IS NULL OR @providerId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del proveedor (@providerId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @providerName IS NULL OR LTRIM(RTRIM(@providerName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del proveedor (@providerName) es obligatorio.';
        RETURN;
    END;

    IF @providerModificatorId IS NULL OR @providerModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@providerModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @providerStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del proveedor (@providerStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del proveedor
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = providerStatusId
    FROM [SQM_CATALOGS].[Tbl_Providers]
    WHERE providerId = @providerId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El proveedor especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @providerModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado de inactividad previa del registro
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El proveedor está inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otros proveedores activos
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers]
        WHERE providerName = TRIM(@providerName)
          AND providerStatusId = 1
          AND providerId <> @providerId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro proveedor activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Providers]
        SET providerName = TRIM(@providerName),
            providerDescription = TRIM(@providerDescription),
            providerModificatorId = @providerModificatorId,
            providerModificationDate = GETDATE(),
            providerStatusId = @providerStatusId
        WHERE providerId = @providerId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Proveedor actualizado correctamente.';
        SET @o_templateId = @providerId;
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

EXEC [SQM_CATALOGS].[sp_Providers_Update]
    @providerId = 4,
    @providerName = 'Proveedor Global Tech Internacional',
    @providerDescription = 'Distribuidor mayorista oficial con cobertura regional.',
    @providerModificatorId = 1,
    @providerStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO
