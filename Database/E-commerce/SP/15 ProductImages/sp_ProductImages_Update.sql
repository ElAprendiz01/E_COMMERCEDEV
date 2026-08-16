USE [DB_ECOMMERCE]
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
    @ForzarRecuperacion BIT = 0,
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

    IF @productImageProductId IS NULL OR @productImageProductId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del producto es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productImageURL IS NULL OR LTRIM(RTRIM(@productImageURL)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La URL de la imagen es obligatoria.';
        RETURN;
    END;

    IF @productImageDescription IS NULL OR LTRIM(RTRIM(@productImageDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción de la imagen es obligatoria.';
        RETURN;
    END;

    IF @productImageIsPrincipal IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El indicador de imagen principal es obligatorio.';
        RETURN;
    END;

    IF @productImageModificatorId IS NULL OR @productImageModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productImageStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages] WHERE productImageId = @productImageId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro de imagen especificado no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @productImageProductId AND productStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El producto especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productImageModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF @ForzarRecuperacion = 0 AND EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages] WHERE productImageId = @productImageId AND productImageStatusId = 0)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La imagen está inactiva. Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @productImageIsPrincipal = 1
        BEGIN
            UPDATE [SQM_GENERAL].[Tbl_ProductImages]
            SET productImageIsPrincipal = 0
            WHERE productImageProductId = @productImageProductId AND productImageStatusId = 1 AND productImageId <> @productImageId;
        END

        UPDATE [SQM_GENERAL].[Tbl_ProductImages]
        SET productImageProductId = @productImageProductId,
            productImageURL = TRIM(@productImageURL),
            productImageDescription = TRIM(@productImageDescription),
            productImageIsPrincipal = @productImageIsPrincipal,
            productImageModificatorId = @productImageModificatorId,
            productImageModificationDate = GETDATE(),
            productImageStatusId = @productImageStatusId
        WHERE productImageId = @productImageId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Imagen de producto actualizada correctamente.';
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