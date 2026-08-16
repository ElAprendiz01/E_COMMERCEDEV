USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Delete]
(
    @AttributeProductId INT,
    @AttributeProductModificatorId INT,
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

        UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
        SET
            AttributeProductStatusId = 0,
            AttributeProductModificatorId = @AttributeProductModificatorId,
            AttributeProductModificationDate = GETDATE()
        WHERE AttributeProductId = @AttributeProductId;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro deshabilitado exitosamente.';
        SET @o_templateId = @AttributeProductId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO