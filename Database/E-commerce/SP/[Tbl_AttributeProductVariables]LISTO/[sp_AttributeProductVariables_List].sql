USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_List]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        attributeProductVariableId,
        attributeProductVariableProductVariableId,
        attributeProductVariableAttributeProductId,
        attributeProductVariableValue,
        attributeProductVariableCreatorId,
        attributeProductVariableStatusId
    FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
    ORDER BY attributeProductVariableId;
END;
GO  