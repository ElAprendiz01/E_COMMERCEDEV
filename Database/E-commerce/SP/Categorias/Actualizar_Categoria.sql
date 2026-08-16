USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Categories_Update]
(
    @categoryId INT,
    @categoryName VARCHAR(50),
    @categoryDescription VARCHAR(100),
    @categoryModificatorId INT,
    @categoryStatusId BIT,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @categoryId IS NULL OR @categoryId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la categoría (@categoryId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @categoryName IS NULL OR LTRIM(RTRIM(@categoryName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la categoría (@categoryName) es obligatorio.';
        RETURN;
    END;

    IF @categoryModificatorId IS NULL OR @categoryModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@categoryModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @categoryStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la categoría (@categoryStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la categoría
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories] WHERE categoryId = @categoryId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoría especificada no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @categoryModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado del registro: si está eliminado (statusId = 0) y no se fuerza la recuperación
    IF @ForzarRecuperacion = 0 AND EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories] 
        WHERE categoryId = @categoryId AND categoryStatusId = 0
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoría está inactiva (eliminada). Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otras categorías activas
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories] 
        WHERE categoryName = TRIM(@categoryName) AND categoryStatusId = 1 AND categoryId <> @categoryId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra categoría activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Categories] 
        SET categoryName = TRIM(@categoryName), 
            categoryDescription = TRIM(@categoryDescription), 
            categoryModificatorId = @categoryModificatorId, 
            categoryModificationDate = GETDATE(), 
            categoryStatusId = @categoryStatusId
        WHERE categoryId = @categoryId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Categoría actualizada correctamente.';
        SET @o_templateId = @categoryId;
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

EXEC [SQM_CATALOGS].[sp_Categories_Update]
    @categoryId = 6, 
    @categoryName = 'CALZADOS DEPORTIVOS',
    @categoryDescription = 'Calzado deportivo en general',
    @categoryModificatorId = 1,
    @categoryStatusId = 1,
    @ForzarRecuperacion = 1, --nota 1 es para activarlo y poder actuazlizar una eliminada y en 0 o null se actualizan las que estan vigentes 
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CategoriaIdModificada;


	select * from [SQM_CATALOGS].[Tbl_Categories] 
