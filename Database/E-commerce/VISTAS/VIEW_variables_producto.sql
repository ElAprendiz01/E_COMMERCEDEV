USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_PRODUCT_VARIABLES]
AS
SELECT 
    [PV].[productVariableId],
    [PV].[productVariableProductId] AS [productId],
    [P].[productName],
    [P].[productDescription],
    [P].[categoryId],
    [P].[categoryName],
    [P].[subCategoryId],
    [P].[subCategoryName],
    [P].[segmentId],
    [P].[segmentName],
    [P].[markId],
    [P].[markName],
    [P].[providerId],
    [P].[providerName],
    [PV].[productVariableValue] AS [variableValue],
    [PV].[productVariablePrice] AS [price],
    [PV].[productVariableCurrencyId] AS [currencyId],
    [C].[currencyName],
    [C].[currencyISO],
    [PV].[productVariableStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_ProductVariables] [PV]
INNER JOIN [SQM_GENERAL].[VW_PRODUCTS] [P] ON [PV].[productVariableProductId] = [P].[productId]
INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] [C] ON [PV].[productVariableCurrencyId] = [C].[currencyId]
WHERE [PV].[productVariableStatusId] = 1;
GO

SELECT * FROM [SQM_GENERAL].[VW_PRODUCT_VARIABLES];
