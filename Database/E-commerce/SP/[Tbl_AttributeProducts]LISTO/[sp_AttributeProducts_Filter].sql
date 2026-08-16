USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Filter]
(
    @AttributeProductId INT = NULL,
    @AttributeProductAttributesTypeId INT = NULL,
    @AttributeProductName VARCHAR(50) = NULL,
    @AttributeProductDescription VARCHAR(100) = NULL,
    @AttributeProductCreatorId INT = NULL,
    @AttributeProductCreationDate DATETIME = NULL,
    @AttributeProductModificatorId INT = NULL,
    @AttributeProductModificationDate DATETIME = NULL,
    @AttributeProductStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

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
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
    WHERE
        (@AttributeProductId IS NULL OR AttributeProductId = @AttributeProductId)
        AND (@AttributeProductAttributesTypeId IS NULL OR AttributeProductAttributesTypeId = @AttributeProductAttributesTypeId)
        AND (@AttributeProductName IS NULL OR AttributeProductName LIKE '%' + LTRIM(RTRIM(@AttributeProductName)) + '%')
        AND (@AttributeProductDescription IS NULL OR AttributeProductDescription LIKE '%' + LTRIM(RTRIM(@AttributeProductDescription)) + '%')
        AND (@AttributeProductCreatorId IS NULL OR AttributeProductCreatorId = @AttributeProductCreatorId)
        AND (
              @AttributeProductCreationDate IS NULL
              OR (
                    AttributeProductCreationDate >= CONVERT(DATETIME, CONVERT(DATE, @AttributeProductCreationDate))
                    AND AttributeProductCreationDate < DATEADD(day, 1, CONVERT(DATETIME, CONVERT(DATE, @AttributeProductCreationDate)))
                 )
            )
        AND (@AttributeProductModificatorId IS NULL OR AttributeProductModificatorId = @AttributeProductModificatorId)
        AND (
              @AttributeProductModificationDate IS NULL
              OR (
                    AttributeProductModificationDate >= CONVERT(DATETIME, CONVERT(DATE, @AttributeProductModificationDate))
                    AND AttributeProductModificationDate < DATEADD(day, 1, CONVERT(DATETIME, CONVERT(DATE, @AttributeProductModificationDate)))
                 )
            )
        AND (@AttributeProductStatusId IS NULL OR AttributeProductStatusId = @AttributeProductStatusId);
END;
GO