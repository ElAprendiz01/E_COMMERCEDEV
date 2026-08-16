USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Filter]
    @SearchTerm VARCHAR(50) = NULL, 
    @StatusId BIT = NULL
AS 
BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

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
    WHERE (
        @SearchTerm IS NULL
        OR productVariableTypeId = @SearchId
        OR productVariableTypeName LIKE '%' + @SearchTerm + '%'
        OR productVariableTypeDescription LIKE '%' + @SearchTerm + '%'
    ) AND (@StatusId IS NULL OR productVariableTypeStatusId = @StatusId)
    OPTION (RECOMPILE);
END
GO