USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Stocks_Delete]
(
    @stockId INT,
    @stockModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @stockId IS NULL OR @stockId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de stock (@stockId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockModificatorId IS NULL OR @stockModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@stockModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = stockStatusId
    FROM [SQM_GENERAL].[Tbl_Stocks]
    WHERE stockId = @stockId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El lote de stock especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El lote de stock ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @stockModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_Stocks]
        SET stockStatusId = 0,
            stockModificatorId = @stockModificatorId,
            stockModificationDate = GETDATE()
        WHERE stockId = @stockId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Lote de stock inactivado (eliminado lógicamente) correctamente.';
        SET @o_templateId = @stockId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO