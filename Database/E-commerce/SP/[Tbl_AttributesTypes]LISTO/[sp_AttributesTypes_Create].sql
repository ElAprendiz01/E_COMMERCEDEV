USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributesTypes_Create]
(
    @attributeTypeName VARCHAR(50),
    @attributeTypeDescription VARCHAR(100),
    @attributeTypeCreatorId INT,
    @attributeTypeStatusId BIT,
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

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_AttributesTypes]
            WHERE attributeTypeName = LTRIM(RTRIM(@attributeTypeName))
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El tipo de atributo ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_CATALOGS].[Tbl_AttributesTypes]
        (
            attributeTypeName,
            attributeTypeDescription,
            attributeTypeCreatorId,
            attributeTypeCreationDate,
            attributeTypeStatusId
        )
        VALUES
        (
            LTRIM(RTRIM(@attributeTypeName)),
            LTRIM(RTRIM(@attributeTypeDescription)),
            @attributeTypeCreatorId,
            GETDATE(),
            @attributeTypeStatusId
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