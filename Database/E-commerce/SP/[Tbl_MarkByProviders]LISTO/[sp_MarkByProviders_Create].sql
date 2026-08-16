USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_MarkByProviders_Create]
(
    @markByProviderMarkId INT,
    @markByProviderProviderId INT,
    @markByProviderCreatorId INT,
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
            FROM [SQM_CATALOGS].[Tbl_Marks]
            WHERE markId = @markByProviderMarkId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'La marca no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_Providers]
            WHERE providerId = @markByProviderProviderId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'El proveedor no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_MarkByProviders]
            WHERE markByProviderMarkId = @markByProviderMarkId
            AND markByProviderProviderId = @markByProviderProviderId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'La relación marca-proveedor ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders]
        (
            markByProviderMarkId,
            markByProviderProviderId,
            markByProviderCreatorId,
            markByProviderCreationDate,
            markByProviderStatusId
        )
        VALUES
        (
            @markByProviderMarkId,
            @markByProviderProviderId,
            @markByProviderCreatorId,
            GETDATE(),
            @markByProviderStatusId
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