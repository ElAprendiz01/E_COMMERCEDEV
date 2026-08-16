USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_StockMovementTypes_Update]
(
    @stockMovementTypeId INT,
    @stockMovementTypeName VARCHAR(50),
    @stockMovementTypeDescription VARCHAR(100),
    @stockMovementTypeModificatorId INT,
    @stockMovementTypeStatusId BIT,
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

        IF NOT EXISTS (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_StockMovementTypes]
            WHERE stockMovementTypeId = @stockMovementTypeId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[Tbl_StockMovementTypes]
        SET
            stockMovementTypeName = LTRIM(RTRIM(@stockMovementTypeName)),
            stockMovementTypeDescription = LTRIM(RTRIM(@stockMovementTypeDescription)),
            stockMovementTypeModificatorId = @stockMovementTypeModificatorId,
            stockMovementTypeModificationDate = GETDATE(),
            stockMovementTypeStatusId = @stockMovementTypeStatusId
        WHERE stockMovementTypeId = @stockMovementTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @stockMovementTypeId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO