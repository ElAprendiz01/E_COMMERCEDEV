USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_Filter]
(
    @productImageId INT = NULL,
    @productImageProductId INT = NULL,
    @productImageURL VARCHAR(200) = NULL,
    @productImageIsPrincipal BIT = NULL,
    @productImageCreatorId INT = NULL,
    @productImageCreationDate DATETIME = NULL,
    @productImageModificatorId INT = NULL,
    @productImageModificationDate DATETIME = NULL,
    @productImageStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        productImageId,
        productImageProductId,
        productImageURL,
        productImageDescription,
        productImageIsPrincipal,
        productImageCreatorId,
        productImageCreationDate,
        productImageModificatorId,
        productImageModificationDate,
        productImageStatusId
    FROM [SQM_GENERAL].[Tbl_ProductImages] (NOLOCK)
    WHERE
        (@productImageId IS NULL OR productImageId = @productImageId)
        AND (@productImageProductId IS NULL OR productImageProductId = @productImageProductId)
        AND (@productImageURL IS NULL OR productImageURL LIKE '%' + LTRIM(RTRIM(@productImageURL)) + '%')
        AND (@productImageIsPrincipal IS NULL OR productImageIsPrincipal = @productImageIsPrincipal)
        AND (@productImageCreatorId IS NULL OR productImageCreatorId = @productImageCreatorId)
        AND (@productImageCreationDate IS NULL OR CAST(productImageCreationDate AS DATE) = CAST(@productImageCreationDate AS DATE))
        AND (@productImageModificatorId IS NULL OR productImageModificatorId = @productImageModificatorId)
        AND (@productImageModificationDate IS NULL OR CAST(productImageModificationDate AS DATE) = CAST(@productImageModificationDate AS DATE))
        AND (@productImageStatusId IS NULL OR productImageStatusId = @productImageStatusId)
    OPTION (RECOMPILE);
END;
GO