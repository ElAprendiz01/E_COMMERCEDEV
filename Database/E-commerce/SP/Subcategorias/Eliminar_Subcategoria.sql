USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_SubCategories_Delete]
(
    @subCategoryId INT,
    @subCategoryModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @subCategoryId IS NULL OR @subCategoryId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la subcategoría (@subCategoryId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @subCategoryModificatorId IS NULL OR @subCategoryModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@subCategoryModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo de la subcategoría
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = subCategoryStatusId
    FROM [SQM_CATALOGS].[Tbl_SubCategories]
    WHERE subCategoryId = @subCategoryId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La subcategoría especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La subcategoría ya se encuentra inactiva (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @subCategoryModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_SubCategories]
        SET subCategoryStatusId = 0,
            subCategoryModificatorId = @subCategoryModificatorId,
            subCategoryModificationDate = GETDATE()
        WHERE subCategoryId = @subCategoryId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Subcategoría eliminada correctamente.';
        SET @o_templateId = @subCategoryId;
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

EXEC [SQM_CATALOGS].[sp_SubCategories_Delete]
    @subCategoryId = 96,
    @subCategoryModificatorId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Inactivado];
GO