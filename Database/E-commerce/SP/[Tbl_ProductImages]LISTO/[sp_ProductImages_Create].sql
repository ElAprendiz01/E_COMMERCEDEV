USE DB_ECOMMERCE;
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

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_Products]
            WHERE productId = @productImageProductId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'El producto no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_ProductImages]
            WHERE productImageProductId = @productImageProductId
            AND productImageURL = LTRIM(RTRIM(@productImageURL))
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'La imagen ya existe para este producto.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Desmarcar la imagen principal anterior si la nueva se marca como principal (1)
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
            LTRIM(RTRIM(@productImageURL)),
            LTRIM(RTRIM(@productImageDescription)),
            @productImageIsPrincipal,
            @productImageCreatorId,
            GETDATE(),
            @productImageStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Imagen registrada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO



--------------------------------------

DECLARE @code INT, @message VARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 11,
    @productImageURL = '/uploads/products/Zapatillas_Nike_Air_Max_SYSTM.png',
    @productImageDescription = 'Vista principal Zapatillas Nike DefyAllDay Casual',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @message OUTPUT,
    @o_templateId = @templateId OUTPUT;

PRINT @message;