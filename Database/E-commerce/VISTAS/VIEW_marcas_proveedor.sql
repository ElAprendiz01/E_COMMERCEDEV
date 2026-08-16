USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_CATALOGS].[VW_MARKS_BY_PROVIDER]
AS
SELECT 
    [MBP].[markByProviderId],
    [MBP].[markByProviderMarkId] AS [markId],
    [M].[markName],
    [M].[markDescription],
    [MBP].[markByProviderProviderId] AS [providerId],
    [P].[providerName],
    [P].[providerDescription],
    [MBP].[markByProviderStatusId] AS [statusId]
FROM [SQM_CATALOGS].[Tbl_MarkByProviders] [MBP]
INNER JOIN [SQM_CATALOGS].[Tbl_Marks] [M] ON [MBP].[markByProviderMarkId] = [M].[markId]
INNER JOIN [SQM_CATALOGS].[Tbl_Providers] [P] ON [MBP].[markByProviderProviderId] = [P].[providerId]
WHERE [MBP].[markByProviderStatusId] = 1
  AND [M].[markStatusId] = 1
  AND [P].[providerStatusId] = 1;
GO

SELECT * FROM [SQM_CATALOGS].[VW_MARKS_BY_PROVIDER];
