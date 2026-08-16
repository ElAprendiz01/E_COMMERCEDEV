
USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Providers_Delete]
(
    @providerId INT,
    @providerModificatorId INT,
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

    IF @providerModificatorId IS NULL OR @providerModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@providerModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo del proveedor
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

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El proveedor ya se encuentra (eliminado).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @providerModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Providers]
        SET providerStatusId = 0,
            providerModificatorId = @providerModificatorId,
            providerModificationDate = GETDATE()
        WHERE providerId = @providerId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Proveedor eliminado correctamente.';
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

EXEC [SQM_CATALOGS].[sp_Providers_Delete]
    @providerId = 4,
    @providerModificatorId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Inactivado];
GO
