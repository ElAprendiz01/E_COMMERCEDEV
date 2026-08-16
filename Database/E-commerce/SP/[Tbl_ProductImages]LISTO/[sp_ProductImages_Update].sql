USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_Update]
(
    @productImageId INT,
    @productImageProductId INT,
    @productImageURL VARCHAR(200),
    @productImageDescription VARCHAR(100),
    @productImageIsPrincipal BIT,
    @productImageModificatorId INT,
    @productImageStatusId BIT,
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
            FROM [SQM_GENERAL].[Tbl_ProductImages]
            WHERE productImageId = @productImageId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE [SQM_GENERAL].[Tbl_ProductImages]
        SET
            productImageProductId = @productImageProductId,
            productImageURL = LTRIM(RTRIM(@productImageURL)),
            productImageDescription = LTRIM(RTRIM(@productImageDescription)),
            productImageIsPrincipal = @productImageIsPrincipal,
            productImageModificatorId = @productImageModificatorId,
            productImageModificationDate = GETDATE(),
            productImageStatusId = @productImageStatusId
        WHERE productImageId = @productImageId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Imagen actualizada exitosamente.';
        SET @o_templateId = @productImageId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO