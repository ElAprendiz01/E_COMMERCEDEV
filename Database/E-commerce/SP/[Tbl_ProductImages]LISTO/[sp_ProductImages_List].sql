USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_List]
AS
BEGIN
    SELECT
        productImageId,
        productImageProductId,
        productImageURL,
        productImageDescription,
        productImageIsPrincipal,
        productImageCreatorId,
        productImageStatusId
    FROM [SQM_GENERAL].[Tbl_ProductImages] (NOLOCK);
END;
GO