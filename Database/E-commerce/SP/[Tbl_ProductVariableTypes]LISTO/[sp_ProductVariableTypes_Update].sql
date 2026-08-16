USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Update]
(
    @productVariableTypeId INT,
    @productVariableTypeName VARCHAR(50),
    @productVariableTypeDescription VARCHAR(100),
    @productVariableTypeModificatorId INT,
    @productVariableTypeStatusId BIT,
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
            FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
            WHERE productVariableTypeId = @productVariableTypeId
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
            FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
            WHERE productVariableTypeName = LTRIM(RTRIM(@productVariableTypeName))
            AND productVariableTypeId <> @productVariableTypeId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El tipo de variable ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
        SET
            productVariableTypeName = LTRIM(RTRIM(@productVariableTypeName)),
            productVariableTypeDescription = LTRIM(RTRIM(@productVariableTypeDescription)),
            productVariableTypeModificatorId = @productVariableTypeModificatorId,
            productVariableTypeModificationDate = GETDATE(),
            productVariableTypeStatusId = @productVariableTypeStatusId
        WHERE productVariableTypeId = @productVariableTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @productVariableTypeId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO