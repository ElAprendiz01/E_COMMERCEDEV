USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_List]
AS 
BEGIN
    SELECT 
        productVariableTypeId,
        productVariableTypeName,
        productVariableTypeDescription,
        productVariableTypeCreatorId,
        productVariableTypeCreationDate,
        productVariableTypeModificatorId,
        productVariableTypeModificationDate,
        productVariableTypeStatusId
    FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] (NOLOCK);
END
GO