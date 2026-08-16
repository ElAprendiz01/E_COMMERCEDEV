USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductIdentificators_Filter]
(
    @productIdentificatorId INT = NULL,
    @productIdentificatorCategoryId INT = NULL,
    @productIdentificatorSubCategoryId INT = NULL,
    @productIdentificatorSegmentId INT = NULL,
    @productIdentificatorCreatorId INT = NULL,
    @productIdentificatorCreationDate DATETIME = NULL,
    @productIdentificatorModificatorId INT = NULL,
    @productIdentificatorModificationDate DATETIME = NULL,
    @productIdentificatorStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        productIdentificatorId,
        productIdentificatorCategoryId,
        productIdentificatorSubCategoryId,
        productIdentificatorSegmentId,
        productIdentificatorCreatorId,
        productIdentificatorCreationDate,
        productIdentificatorModificatorId,
        productIdentificatorModificationDate,
        productIdentificatorStatusId
    FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] (NOLOCK)
    WHERE
        (@productIdentificatorId IS NULL OR productIdentificatorId = @productIdentificatorId)
        AND (@productIdentificatorCategoryId IS NULL OR productIdentificatorCategoryId = @productIdentificatorCategoryId)
        AND (@productIdentificatorSubCategoryId IS NULL OR productIdentificatorSubCategoryId = @productIdentificatorSubCategoryId)
        AND (@productIdentificatorSegmentId IS NULL OR productIdentificatorSegmentId = @productIdentificatorSegmentId)
        AND (@productIdentificatorCreatorId IS NULL OR productIdentificatorCreatorId = @productIdentificatorCreatorId)
        AND (@productIdentificatorCreationDate IS NULL OR CAST(productIdentificatorCreationDate AS DATE) = CAST(@productIdentificatorCreationDate AS DATE))
        AND (@productIdentificatorModificatorId IS NULL OR productIdentificatorModificatorId = @productIdentificatorModificatorId)
        AND (@productIdentificatorModificationDate IS NULL OR CAST(productIdentificatorModificationDate AS DATE) = CAST(@productIdentificatorModificationDate AS DATE))
        AND (@productIdentificatorStatusId IS NULL OR productIdentificatorStatusId = @productIdentificatorStatusId)
    OPTION (RECOMPILE);
END;
GO