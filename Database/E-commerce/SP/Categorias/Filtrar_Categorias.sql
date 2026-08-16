USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR (Optimizado)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Categories_Filter]
    @SearchTerm VARCHAR(50) = NULL, @StatusId BIT = NULL
AS BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT categoryId, categoryName, categoryDescription, categoryStatusId
    FROM [SQM_CATALOGS].[Tbl_Categories] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR categoryId = @SearchId
        OR categoryName LIKE '%' + @SearchTerm + '%'
        OR categoryDescription LIKE '%' + @SearchTerm + '%'
    ) AND (@StatusId IS NULL OR categoryStatusId = @StatusId)
    OPTION (RECOMPILE);
END
GO

exec [SQM_CATALOGS].[sp_Categories_Filter] '2'
select * from  [SQM_CATALOGS].[Tbl_Categories] 