USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Marks_Delete]
(
    @markId INT,
    @markModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores inválidos
    IF @markId IS NULL OR @markId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la marca (@markId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @markModificatorId IS NULL OR @markModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@markModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia de la marca y que no esté ya inactivada
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = markStatusId 
    FROM [SQM_CATALOGS].[Tbl_Marks] 
    WHERE markId = @markId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La marca especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La marca ya se encuentra  (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @markModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Marks] 
        SET markStatusId = 0, -- Inactivado lógicamente
            markModificatorId = @markModificatorId, 
            markModificationDate = GETDATE() 
        WHERE markId = @markId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Marca  eliminada correctamente.';
        SET @o_templateId = @markId;
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

--ejecucion de prueba 


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_Marks_Delete]
    @markId = 16, 
    @markModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MarcaIdInactivada;
