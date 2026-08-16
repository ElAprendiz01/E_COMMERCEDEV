USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_MarkByProviders_List]
AS
BEGIN
    SELECT
        markByProviderId,
        markByProviderMarkId,
        markByProviderProviderId,
        markByProviderCreatorId,
        markByProviderStatusId
    FROM [SQM_CATALOGS].[Tbl_MarkByProviders] (NOLOCK);
END;
GO