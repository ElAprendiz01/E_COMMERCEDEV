USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Update]
(
    @attributeProductVariableId INT,
    @attributeProductVariableProductVariableId INT,
    @attributeProductVariableAttributeProductId INT,
    @attributeProductVariableValue VARCHAR(50),
    @attributeProductVariableModificatorId INT,
    @attributeProductVariableStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
            WHERE attributeProductVariableId = @attributeProductVariableId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
        SET
            attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId,
            attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId,
            attributeProductVariableValue = LTRIM(RTRIM(@attributeProductVariableValue)),
            attributeProductVariableModificatorId = @attributeProductVariableModificatorId,
            attributeProductVariableModificationDate = GETDATE(),
            attributeProductVariableStatusId = @attributeProductVariableStatusId
        WHERE attributeProductVariableId = @attributeProductVariableId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @attributeProductVariableId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO