USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Providers_List]
AS BEGIN
    SELECT providerId, providerName, providerDescription, providerCreatorId, providerStatusId
    FROM [SQM_CATALOGS].[Tbl_Providers] (NOLOCK)
	WHERE providerStatusId = 1;
END
GO

EXEC  [SQM_CATALOGS].[sp_Providers_List]