USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributesTypes_Update]
(
    @attributeTypeId INT,
    @attributeTypeName VARCHAR(50),
    @attributeTypeDescription VARCHAR(100),
    @attributeTypeModificatorId INT,
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

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_AttributesTypes]
            WHERE attributeTypeId = @attributeTypeId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_AttributesTypes]
            WHERE attributeTypeName = LTRIM(RTRIM(@attributeTypeName))
            AND attributeTypeId <> @attributeTypeId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El tipo de atributo ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[Tbl_AttributesTypes]
        SET
            attributeTypeName = LTRIM(RTRIM(@attributeTypeName)),
            attributeTypeDescription = LTRIM(RTRIM(@attributeTypeDescription)),
            attributeTypeModificatorId = @attributeTypeModificatorId,
            attributeTypeModificationDate = GETDATE(),
            attributeTypeStatusId = @attributeTypeStatusId
        WHERE attributeTypeId = @attributeTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @attributeTypeId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO