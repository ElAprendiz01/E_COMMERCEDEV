USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_SubCategories_Create]
(
    @subCategoryName VARCHAR(50),
    @subCategoryDescription VARCHAR(100),
    @subCategoryCreatorId INT,
    @subCategoryStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @subCategoryName IS NULL OR LTRIM(RTRIM(@subCategoryName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la subcategoría (@subCategoryName) es obligatorio.';
        RETURN;
    END;

    IF @subCategoryCreatorId IS NULL OR @subCategoryCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@subCategoryCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @subCategoryStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la subcategoría (@subCategoryStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @subCategoryCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad (evitar duplicados de subcategorías activas con el mismo nombre)
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_SubCategories] WHERE subCategoryName = TRIM(@subCategoryName) AND subCategoryStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una subcategoría activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_SubCategories]
        (
            subCategoryName,
            subCategoryDescription,
            subCategoryCreatorId,
            subCategoryCreationDate,
            subCategoryStatusId
        )
        VALUES
        (
            TRIM(@subCategoryName),
            TRIM(@subCategoryDescription),
            @subCategoryCreatorId,
            GETDATE(),
            @subCategoryStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Subcategoría creada correctamente.';
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

EXEC [SQM_CATALOGS].[sp_SubCategories_Create]
    @subCategoryName = 'Componentes de Laptop',
    @subCategoryDescription = 'Memorias RAM, discos sólidos, pantallas y teclados.',
    @subCategoryCreatorId = 1,
    @subCategoryStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Generado];
GO

select * from [SQM_CATALOGS].[Tbl_SubCategories]