USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_ProductImages_GetByProduct]
(
    @ProductId INT
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
    WHERE productImageProductId = @ProductId
      AND productImageStatusId = 1
    ORDER BY productImageIsPrincipal DESC, productImageId ASC;
END
GO