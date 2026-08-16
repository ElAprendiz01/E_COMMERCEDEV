USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_SubCategories_List]
AS BEGIN
    SET NOCOUNT ON;

    SELECT 
        subCategoryId, 
        subCategoryName, 
        subCategoryDescription, 
        subCategoryCreatorId, 
        subCategoryStatusId
    FROM [SQM_CATALOGS].[Tbl_SubCategories] (NOLOCK)
    WHERE subCategoryStatusId = 1;
END
GO

EXEC [SQM_CATALOGS].[sp_SubCategories_List];