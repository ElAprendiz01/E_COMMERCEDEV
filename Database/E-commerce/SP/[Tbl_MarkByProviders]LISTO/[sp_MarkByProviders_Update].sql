USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_MarkByProviders_Update]
(
    @markByProviderId INT,
    @markByProviderMarkId INT,
    @markByProviderProviderId INT,
    @markByProviderModificatorId INT,
    @markByProviderStatusId BIT,
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
            FROM [SQM_CATALOGS].[Tbl_MarkByProviders]
            WHERE markByProviderId = @markByProviderId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[Tbl_MarkByProviders]
        SET
            markByProviderMarkId = @markByProviderMarkId,
            markByProviderProviderId = @markByProviderProviderId,
            markByProviderModificatorId = @markByProviderModificatorId,
            markByProviderModificationDate = GETDATE(),
            markByProviderStatusId = @markByProviderStatusId
        WHERE markByProviderId = @markByProviderId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @markByProviderId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO