USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_Create]
(
    @productImageProductId INT,
    @productImageURL VARCHAR(200),
    @productImageDescription VARCHAR(100),
    @productImageIsPrincipal BIT,
    @productImageCreatorId INT,
    @productImageStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

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

    IF @productImageCreatorId IS NULL OR @productImageCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productImageStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @productImageProductId AND productStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El producto especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productImageCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages] WHERE productImageProductId = @productImageProductId AND productImageURL = TRIM(@productImageURL) AND productImageStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Esta URL de imagen ya está registrada para este producto.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @productImageIsPrincipal = 1
        BEGIN
            UPDATE [SQM_GENERAL].[Tbl_ProductImages]
            SET productImageIsPrincipal = 0
            WHERE productImageProductId = @productImageProductId AND productImageStatusId = 1;
        END

        INSERT INTO [SQM_GENERAL].[Tbl_ProductImages]
        (
            productImageProductId,
            productImageURL,
            productImageDescription,
            productImageIsPrincipal,
            productImageCreatorId,
            productImageCreationDate,
            productImageStatusId
        )
        VALUES
        (
            @productImageProductId,
            TRIM(@productImageURL),
            TRIM(@productImageDescription),
            @productImageIsPrincipal,
            @productImageCreatorId,
            GETDATE(),
            @productImageStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Imagen de producto creada correctamente.';
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