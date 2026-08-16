USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Status_Update]
(
    @statusId INT,
    @statusName VARCHAR(50),
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

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_Status]
            WHERE statusId = @statusId
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
            FROM [SQM_CATALOGS].[Tbl_Status]
            WHERE statusName = LTRIM(RTRIM(@statusName))
            AND statusId <> @statusId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El estado ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_CATALOGS].[Tbl_Status]
        SET
            statusName = LTRIM(RTRIM(@statusName)),
            statusStatusId = @statusStatusId
        WHERE statusId = @statusId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Registro actualizado exitosamente.';
        SET @o_templateId = @statusId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO