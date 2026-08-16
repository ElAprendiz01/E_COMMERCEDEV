USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Delete]
(
    @attributeProductVariableId INT,
    @attributeProductVariableModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @attributeProductVariableId IS NULL OR @attributeProductVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del registro es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableModificatorId IS NULL OR @attributeProductVariableModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = attributeProductVariableStatusId
    FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
    WHERE attributeProductVariableId = @attributeProductVariableId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro ya se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @attributeProductVariableModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
        SET attributeProductVariableStatusId = 0,
            attributeProductVariableModificatorId = @attributeProductVariableModificatorId,
            attributeProductVariableModificationDate = GETDATE()
        WHERE attributeProductVariableId = @attributeProductVariableId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro inactivado correctamente.';
        SET @o_templateId = @attributeProductVariableId;
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