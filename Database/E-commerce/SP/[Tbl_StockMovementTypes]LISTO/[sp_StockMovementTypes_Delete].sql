USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_StockMovementTypes_Delete]
(
    @stockMovementTypeId INT,
    @stockMovementTypeModificatorId INT,
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

        UPDATE [SQM_CATALOGS].[Tbl_StockMovementTypes]
        SET
            stockMovementTypeStatusId = 0,
            stockMovementTypeModificatorId = @stockMovementTypeModificatorId,
            stockMovementTypeModificationDate = GETDATE()
        WHERE stockMovementTypeId = @stockMovementTypeId;

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
        SET @o_templateId = @stockMovementTypeId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO