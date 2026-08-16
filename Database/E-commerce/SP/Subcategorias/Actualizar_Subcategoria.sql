USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_SubCategories_Update]
(
    @subCategoryId INT,
    @subCategoryName VARCHAR(50),
    @subCategoryDescription VARCHAR(100),
    @subCategoryModificatorId INT,
    @subCategoryStatusId BIT,
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
    IF @subCategoryId IS NULL OR @subCategoryId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la subcategoría (@subCategoryId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @subCategoryName IS NULL OR LTRIM(RTRIM(@subCategoryName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la subcategoría (@subCategoryName) es obligatorio.';
        RETURN;
    END;

    IF @subCategoryModificatorId IS NULL OR @subCategoryModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@subCategoryModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @subCategoryStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la subcategoría (@subCategoryStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la subcategoría
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

    -- Validar existencia y estado activo del usuario modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @subCategoryModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado de inactividad previa del registro
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La subcategoría está inactiva (eliminada). Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otras subcategorías activas
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_SubCategories]
        WHERE subCategoryName = TRIM(@subCategoryName)
          AND subCategoryStatusId = 1
          AND subCategoryId <> @subCategoryId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra subcategoría activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_SubCategories]
        SET subCategoryName = TRIM(@subCategoryName),
            subCategoryDescription = TRIM(@subCategoryDescription),
            subCategoryModificatorId = @subCategoryModificatorId,
            subCategoryModificationDate = GETDATE(),
            subCategoryStatusId = @subCategoryStatusId
        WHERE subCategoryId = @subCategoryId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Subcategoría actualizada correctamente.';
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

EXEC [SQM_CATALOGS].[sp_SubCategories_Update]
    @subCategoryId = 7,
    @subCategoryName = 'Hardware y Periféricos',
    @subCategoryDescription = 'Componentes internos y dispositivos externos actualizados.',
    @subCategoryModificatorId = 1,
    @subCategoryStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO

select * from [SQM_CATALOGS].[Tbl_SubCategories]