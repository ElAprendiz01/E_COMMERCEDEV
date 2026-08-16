USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributesTypes_Filter]
(
    @attributeTypeId INT = NULL,
    @attributeTypeName VARCHAR(50) = NULL,
    @attributeTypeDescription VARCHAR(100) = NULL,
    @attributeTypeCreatorId INT = NULL,
    @attributeTypeCreationDate DATETIME = NULL,
    @attributeTypeModificatorId INT = NULL,
    @attributeTypeModificationDate DATETIME = NULL,
    @attributeTypeStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        attributeTypeId,
        attributeTypeName,
        attributeTypeDescription,
        attributeTypeCreatorId,
        attributeTypeCreationDate,
        attributeTypeModificatorId,
        attributeTypeModificationDate,
        attributeTypeStatusId
    FROM [SQM_CATALOGS].[Tbl_AttributesTypes] (NOLOCK)
    WHERE
        (@attributeTypeId IS NULL OR attributeTypeId = @attributeTypeId)
        AND (@attributeTypeName IS NULL OR attributeTypeName LIKE '%' + LTRIM(RTRIM(@attributeTypeName)) + '%')
        AND (@attributeTypeDescription IS NULL OR attributeTypeDescription LIKE '%' + LTRIM(RTRIM(@attributeTypeDescription)) + '%')
        AND (@attributeTypeCreatorId IS NULL OR attributeTypeCreatorId = @attributeTypeCreatorId)
        AND (@attributeTypeCreationDate IS NULL OR CAST(attributeTypeCreationDate AS DATE) = CAST(@attributeTypeCreationDate AS DATE))
        AND (@attributeTypeModificatorId IS NULL OR attributeTypeModificatorId = @attributeTypeModificatorId)
        AND (@attributeTypeModificationDate IS NULL OR CAST(attributeTypeModificationDate AS DATE) = CAST(@attributeTypeModificationDate AS DATE))
        AND (@attributeTypeStatusId IS NULL OR attributeTypeStatusId = @attributeTypeStatusId)
    OPTION (RECOMPILE);
END;
GO