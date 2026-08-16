USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_Delete]
(
    @productImageId INT,
    @productImageModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @productImageId IS NULL OR @productImageId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la imagen es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productImageModificatorId IS NULL OR @productImageModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = productImageStatusId
    FROM [SQM_GENERAL].[Tbl_ProductImages]
    WHERE productImageId = @productImageId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La imagen especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La imagen ya se encuentra inactiva.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productImageModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_ProductImages]
        SET productImageStatusId = 0,
            productImageModificatorId = @productImageModificatorId,
            productImageModificationDate = GETDATE()
        WHERE productImageId = @productImageId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Imagen inactivada correctamente.';
        SET @o_templateId = @productImageId;
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