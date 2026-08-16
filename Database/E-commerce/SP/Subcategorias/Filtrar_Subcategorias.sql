USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR (Optimizado)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_SubCategories_Filter]
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    SELECT subCategoryId, subCategoryName, subCategoryDescription, subCategoryStatusId
    FROM [SQM_CATALOGS].[Tbl_SubCategories] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR subCategoryName LIKE '%' + @SearchTerm + '%'
        OR subCategoryDescription LIKE '%' + @SearchTerm + '%'
    ) and subCategoryStatusId =1

    OPTION (RECOMPILE);
END
GO

exec  [SQM_CATALOGS].[sp_SubCategories_Filter] 'ropa'

exec  [SQM_CATALOGS].[sp_SubCategories_Filter] 