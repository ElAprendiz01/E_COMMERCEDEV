USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Filter]
(
    @attributeProductVariableId INT = NULL,
    @attributeProductVariableProductVariableId INT = NULL,
    @attributeProductVariableAttributeProductId INT = NULL,
    @attributeProductVariableValue VARCHAR(50) = NULL,
    @attributeProductVariableCreatorId INT = NULL,
    @attributeProductVariableCreationDate DATETIME = NULL,
    @attributeProductVariableModificatorId INT = NULL,
    @attributeProductVariableModificationDate DATETIME = NULL,
    @attributeProductVariableStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        attributeProductVariableId,
        attributeProductVariableProductVariableId,
        attributeProductVariableAttributeProductId,
        attributeProductVariableValue,
        attributeProductVariableCreatorId,
        attributeProductVariableCreationDate,
        attributeProductVariableModificatorId,
        attributeProductVariableModificationDate,
        attributeProductVariableStatusId
    FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] (NOLOCK)
    WHERE
        (@attributeProductVariableId IS NULL OR attributeProductVariableId = @attributeProductVariableId)
        AND (@attributeProductVariableProductVariableId IS NULL OR attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId)
        AND (@attributeProductVariableAttributeProductId IS NULL OR attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId)
        AND (@attributeProductVariableValue IS NULL OR attributeProductVariableValue LIKE '%' + LTRIM(RTRIM(@attributeProductVariableValue)) + '%')
        AND (@attributeProductVariableCreatorId IS NULL OR attributeProductVariableCreatorId = @attributeProductVariableCreatorId)
        AND (@attributeProductVariableCreationDate IS NULL OR CAST(attributeProductVariableCreationDate AS DATE) = CAST(@attributeProductVariableCreationDate AS DATE))
        AND (@attributeProductVariableModificatorId IS NULL OR attributeProductVariableModificatorId = @attributeProductVariableModificatorId)
        AND (@attributeProductVariableModificationDate IS NULL OR CAST(attributeProductVariableModificationDate AS DATE) = CAST(@attributeProductVariableModificationDate AS DATE))
        AND (@attributeProductVariableStatusId IS NULL OR attributeProductVariableStatusId = @attributeProductVariableStatusId)
    OPTION (RECOMPILE);
END;
GO