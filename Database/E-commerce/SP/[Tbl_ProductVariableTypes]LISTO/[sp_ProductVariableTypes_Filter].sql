USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Filter]
(
    @productVariableTypeId INT = NULL,
    @productVariableTypeName VARCHAR(50) = NULL,
    @productVariableTypeDescription VARCHAR(100) = NULL,
    @productVariableTypeCreatorId INT = NULL,
    @productVariableTypeCreationDate DATETIME = NULL,
    @productVariableTypeModificatorId INT = NULL,
    @productVariableTypeModificationDate DATETIME = NULL,
    @productVariableTypeStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        productVariableTypeId,
        productVariableTypeName,
        productVariableTypeDescription,
        productVariableTypeCreatorId,
        productVariableTypeCreationDate,
        productVariableTypeModificatorId,
        productVariableTypeModificationDate,
        productVariableTypeStatusId
    FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] (NOLOCK)
    WHERE
        (@productVariableTypeId IS NULL OR productVariableTypeId = @productVariableTypeId)
        AND (@productVariableTypeName IS NULL OR productVariableTypeName LIKE '%' + LTRIM(RTRIM(@productVariableTypeName)) + '%')
        AND (@productVariableTypeDescription IS NULL OR productVariableTypeDescription LIKE '%' + LTRIM(RTRIM(@productVariableTypeDescription)) + '%')
        AND (@productVariableTypeCreatorId IS NULL OR productVariableTypeCreatorId = @productVariableTypeCreatorId)
        AND (@productVariableTypeCreationDate IS NULL OR CAST(productVariableTypeCreationDate AS DATE) = CAST(@productVariableTypeCreationDate AS DATE))
        AND (@productVariableTypeModificatorId IS NULL OR productVariableTypeModificatorId = @productVariableTypeModificatorId)
        AND (@productVariableTypeModificationDate IS NULL OR CAST(productVariableTypeModificationDate AS DATE) = CAST(@productVariableTypeModificationDate AS DATE))
        AND (@productVariableTypeStatusId IS NULL OR productVariableTypeStatusId = @productVariableTypeStatusId)
    OPTION (RECOMPILE);
END;
GO