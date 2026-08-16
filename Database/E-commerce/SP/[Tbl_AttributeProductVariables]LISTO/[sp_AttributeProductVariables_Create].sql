USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Create]
(
    @attributeProductVariableProductVariableId INT,
    @attributeProductVariableAttributeProductId INT,
    @attributeProductVariableValue NVARCHAR(50),
    @attributeProductVariableCreatorId INT,
    @attributeProductVariableStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message NVARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Valida la existencia de variable de producto
        IF NOT EXISTS (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_ProductVariables]
            WHERE productVariableId = @attributeProductVariableProductVariableId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = N'La variable de producto no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Valida la existencia de tipo de variable del producto
        IF NOT EXISTS (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
            WHERE productVariableTypeId = @attributeProductVariableAttributeProductId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = N'Tipo de variable no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Evita duplicados
        IF EXISTS (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
            WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId
              AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId
              AND attributeProductVariableValue = LTRIM(RTRIM(@attributeProductVariableValue))
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = N'El atributo ya existe para esta variable.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inserta registro
        INSERT INTO [SQM_GENERAL].[Tbl_AttributeProductVariables]
        (
            attributeProductVariableProductVariableId,
            attributeProductVariableAttributeProductId,
            attributeProductVariableValue,
            attributeProductVariableCreatorId,
            attributeProductVariableCreationDate,
            attributeProductVariableStatusId
        )
        VALUES
        (
            @attributeProductVariableProductVariableId,
            @attributeProductVariableAttributeProductId,
            LTRIM(RTRIM(@attributeProductVariableValue)),
            @attributeProductVariableCreatorId,
            GETDATE(),
            @attributeProductVariableStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = N'Registro creado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO