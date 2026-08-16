USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Providers_Filter]
    @SearchTerm VARCHAR(50) = NULL, 
    @providerId INT = NULL
AS BEGIN
    SELECT 
        providerId, 
        providerName, 
        providerDescription, 
        providerStatusId
    FROM [SQM_CATALOGS].[Tbl_Providers] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR providerName LIKE '%' + @SearchTerm + '%'
        OR providerDescription LIKE '%' + @SearchTerm + '%'
    ) AND (@providerId IS NULL OR providerId = @providerId)
	and providerStatusId =1
    OPTION (RECOMPILE);
END
GO

EXEC [SQM_CATALOGS].[sp_Providers_Filter]

EXEC [SQM_CATALOGS].[sp_Providers_Filter] @providerId=2

EXEC [SQM_CATALOGS].[sp_Providers_Filter]
    @SearchTerm = 'a'
GO
