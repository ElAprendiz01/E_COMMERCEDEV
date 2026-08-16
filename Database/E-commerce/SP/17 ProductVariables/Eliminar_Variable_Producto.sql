USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductVariables_Delete]
(
    @productVariableId INT,
    @productVariableModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @productVariableId IS NULL OR @productVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variante de producto (@productVariableId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableModificatorId IS NULL OR @productVariableModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@productVariableModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo de la variable
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = productVariableStatusId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableId = @productVariableId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variante de producto especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variante de producto ya se encuentra (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_ProductVariables]
        SET productVariableStatusId = 0,
            productVariableModificatorId = @productVariableModificatorId,
            productVariableModificationDate = GETDATE()
        WHERE productVariableId = @productVariableId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Variante de producto (eliminada) correctamente.';
        SET @o_templateId = @productVariableId;
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

EXEC [SQM_GENERAL].[sp_ProductVariables_Delete]
    @productVariableId = 5,
    @productVariableModificatorId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Inactivado];
GO
