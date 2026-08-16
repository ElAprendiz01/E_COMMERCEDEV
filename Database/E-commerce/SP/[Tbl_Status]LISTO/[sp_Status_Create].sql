USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Status_Create]
(
    @statusName VARCHAR(50),
    @statusCreatorId INT = NULL,
    @statusStatusId INT = NULL,
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
            FROM [SQM_CATALOGS].[Tbl_Status]
            WHERE statusName = LTRIM(RTRIM(@statusName))
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El estado ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_CATALOGS].[Tbl_Status]
        (
            statusName,
            statusCreatorId,
            statusCreationDate,
            statusStatusId
        )
        VALUES
        (
            LTRIM(RTRIM(@statusName)),
            @statusCreatorId,
            GETDATE(),
            @statusStatusId
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