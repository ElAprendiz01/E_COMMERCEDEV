USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Categories_Create]
(
    @categoryName VARCHAR(50),
    @categoryDescription VARCHAR(100),
    @categoryCreatorId INT,
    @categoryStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @categoryName IS NULL OR LTRIM(RTRIM(@categoryName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la categoría (@categoryName) es obligatorio.';
        RETURN;
    END;

    IF @categoryCreatorId IS NULL OR @categoryCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@categoryCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @categoryStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la categoría (@categoryStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @categoryCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad: no permitir duplicados de categorías activas
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories] WHERE categoryName = TRIM(@categoryName) AND categoryStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una categoría activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_Categories] 
        (
            categoryName, 
            categoryDescription, 
            categoryCreatorId, 
            categoryCreationDate, 
            categoryStatusId
        )
        VALUES 
        (
            TRIM(@categoryName), 
            TRIM(@categoryDescription), 
            @categoryCreatorId, 
            GETDATE(), 
            @categoryStatusId
        );

        -- Obtener el ID de la categoría recién creada
        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Categoría creada correctamente.';
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


-- EJEMPLO DE PRUEBA / EJECUCIÓN

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_Categories_Create]
    @categoryName = 'computadoras_gamers',
    @categoryDescription = 'lo mejor en GPU',
    @categoryCreatorId = 1,
    @categoryStatusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CategoriaIdGenerada;
