USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Create]
(
    @AttributeProductAttributesTypeId INT,
    @AttributeProductName VARCHAR(50),
    @AttributeProductDescription VARCHAR(100),
    @AttributeProductCreatorId INT,
    @AttributeProductStatusId BIT,
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
            FROM [SQM_CATALOGS].[Tbl_AttributesTypes]
            WHERE attributeTypeId = @AttributeProductAttributesTypeId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'El tipo de atributo no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
            WHERE AttributeProductName = LTRIM(RTRIM(@AttributeProductName))
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El atributo de producto ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_CATALOGS].[Tbl_AttributeProducts]
        (
            AttributeProductAttributesTypeId,
            AttributeProductName,
            AttributeProductDescription,
            AttributeProductCreatorId,
            AttributeProductCreationDate,
            AttributeProductStatusId
        )
        VALUES
        (
            @AttributeProductAttributesTypeId,
            LTRIM(RTRIM(@AttributeProductName)),
            LTRIM(RTRIM(@AttributeProductDescription)),
            @AttributeProductCreatorId,
            GETDATE(),
            @AttributeProductStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro creado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO