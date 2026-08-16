USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_STOCKS]
AS
SELECT 
    [S].[stockId],
    [S].[stockProductVariableId] AS [productVariableId],
    [P].[productName],
    [PV].[productVariableValue] AS [variableValue],
    [P].[price] AS [unitPrice],
    [P].[currencyISO],
    [S].[stockQuantity] AS [quantity],
    [S].[stockFactoryDate] AS [factoryDate],
    [S].[stockExpirationDate] AS [expirationDate],
    [S].[stockStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_Stocks] [S]
INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] [PV] ON [S].[stockProductVariableId] = [PV].[productVariableId]
INNER JOIN [SQM_GENERAL].[VW_PRODUCT_VARIABLES] [P] ON [PV].[productVariableId] = [P].[productVariableId]
WHERE [S].[stockStatusId] = 1;
GO

SELECT * FROM [SQM_GENERAL].[VW_STOCKS];
