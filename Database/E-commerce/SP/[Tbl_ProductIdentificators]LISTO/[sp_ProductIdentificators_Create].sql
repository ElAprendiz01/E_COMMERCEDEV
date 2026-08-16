USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductIdentificators_Create]
(
    @productIdentificatorCategoryId INT,
    @productIdentificatorSubCategoryId INT,
    @productIdentificatorSegmentId INT,
    @productIdentificatorCreatorId INT,
    @productIdentificatorStatusId BIT,
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
            FROM [SQM_CATALOGS].[Tbl_Categories]
            WHERE categoryId = @productIdentificatorCategoryId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'La categoría no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_SubCategories]
            WHERE subCategoryId = @productIdentificatorSubCategoryId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'La subcategoría no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_Segments]
            WHERE segmentId = @productIdentificatorSegmentId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'El segmento no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS
        (
            SELECT 1
            FROM [SQM_CATALOGS].[Tbl_ProductIdentificators]
            WHERE productIdentificatorCategoryId = @productIdentificatorCategoryId
            AND productIdentificatorSubCategoryId = @productIdentificatorSubCategoryId
            AND productIdentificatorSegmentId = @productIdentificatorSegmentId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = 'El identificador de producto ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators]
        (
            productIdentificatorCategoryId,
            productIdentificatorSubCategoryId,
            productIdentificatorSegmentId,
            productIdentificatorCreatorId,
            productIdentificatorCreationDate,
            productIdentificatorStatusId
        )
        VALUES
        (
            @productIdentificatorCategoryId,
            @productIdentificatorSubCategoryId,
            @productIdentificatorSegmentId,
            @productIdentificatorCreatorId,
            GETDATE(),
            @productIdentificatorStatusId
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