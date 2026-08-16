USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductIdentificators_List]
AS
BEGIN
    SELECT
        productIdentificatorId,
        productIdentificatorCategoryId,
        productIdentificatorSubCategoryId,
        productIdentificatorSegmentId,
        productIdentificatorCreatorId,
        productIdentificatorStatusId
    FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] (NOLOCK);
END;
GO