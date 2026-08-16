USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Filter]
    @SearchTerm VARCHAR(50) = NULL, 
    @StatusId BIT = NULL
AS 
BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT 
        AttributeProductId,
        AttributeProductAttributesTypeId,
        AttributeProductName,
        AttributeProductDescription,
        AttributeProductCreatorId,
        AttributeProductCreationDate,
        AttributeProductModificatorId,
        AttributeProductModificationDate,
        AttributeProductStatusId
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR AttributeProductId = @SearchId
        OR AttributeProductName LIKE '%' + @SearchTerm + '%'
        OR AttributeProductDescription LIKE '%' + @SearchTerm + '%'
    ) AND (@StatusId IS NULL OR AttributeProductStatusId = @StatusId)
    OPTION (RECOMPILE);
END
GO