USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_List]
AS
BEGIN
    SELECT
        AttributeProductId,
        AttributeProductAttributesTypeId,
        AttributeProductName,
        AttributeProductDescription,
        AttributeProductCreatorId,
        AttributeProductStatusId
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts] (NOLOCK);
END;
GO