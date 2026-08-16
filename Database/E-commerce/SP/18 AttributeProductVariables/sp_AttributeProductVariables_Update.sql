USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Update]
(
    @attributeProductVariableId INT,
    @attributeProductVariableProductVariableId INT,
    @attributeProductVariableAttributeProductId INT,
    @attributeProductVariableValue VARCHAR(50),
    @attributeProductVariableModificatorId INT,
    @attributeProductVariableStatusId BIT,
    @ForzarRecuperacion BIT = 0,
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

    IF @attributeProductVariableProductVariableId IS NULL OR @attributeProductVariableProductVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variable de producto es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableAttributeProductId IS NULL OR @attributeProductVariableAttributeProductId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de variable (atributo) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableValue IS NULL OR LTRIM(RTRIM(@attributeProductVariableValue)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El valor es obligatorio.';
        RETURN;
    END;

    IF @attributeProductVariableModificatorId IS NULL OR @attributeProductVariableModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] WHERE attributeProductVariableId = @attributeProductVariableId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro especificado no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @attributeProductVariableModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables] WHERE productVariableId = @attributeProductVariableProductVariableId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro de variable de producto padre no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeId = @attributeProductVariableAttributeProductId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable (atributo) no existe.';
        RETURN;
    END;

    IF @ForzarRecuperacion = 0 AND EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] WHERE attributeProductVariableId = @attributeProductVariableId AND attributeProductVariableStatusId = 0)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro está inactivo. Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId AND attributeProductVariableStatusId = 1 AND attributeProductVariableId <> @attributeProductVariableId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro valor activo registrado para este tipo de variable en este producto.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
        SET attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId,
            attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId,
            attributeProductVariableValue = TRIM(@attributeProductVariableValue),
            attributeProductVariableModificatorId = @attributeProductVariableModificatorId,
            attributeProductVariableModificationDate = GETDATE(),
            attributeProductVariableStatusId = @attributeProductVariableStatusId
        WHERE attributeProductVariableId = @attributeProductVariableId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Atributo de variable actualizado correctamente.';
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