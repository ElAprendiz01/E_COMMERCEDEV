USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Categories_Delete]
(
    @categoryId INT,
    @categoryModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores inválidos
    IF @categoryId IS NULL OR @categoryId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la categoría (@categoryId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @categoryModificatorId IS NULL OR @categoryModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@categoryModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia de la categoría y que no esté ya inactivada
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = categoryStatusId 
    FROM [SQM_CATALOGS].[Tbl_Categories] 
    WHERE categoryId = @categoryId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoría especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La categoría ya se encuentra inactiva (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @categoryModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Categories] 
        SET categoryStatusId = 0, -- Inactivado lógicamente
            categoryModificatorId = @categoryModificatorId, 
            categoryModificationDate = GETDATE() 
        WHERE categoryId = @categoryId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Categoría  (eliminada ) correctamente.';
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

EXEC [SQM_CATALOGS].[sp_Categories_Delete]
    @categoryId = 6, 
    @categoryModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CategoriaIdInactivada;
