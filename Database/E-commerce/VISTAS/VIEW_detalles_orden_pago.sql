USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_PAYMENT_ORDER_DETAILS]
AS
SELECT 
    [OD].[orderDetailId],
    [OD].[orderDetailOrderId] AS [orderId],
    [OD].[orderDetailProductVariableId] AS [productVariableId],
    [P].[productName],
    [P].[productDescription],
    [P].[categoryName],
    [P].[subCategoryName],
    [P].[segmentName],
    [P].[markName],
    [P].[providerName],
    [PV].[productVariableValue] AS [variableValue],
    [OD].[orderDetailPrice] AS [price],
    [OD].[orderDetailQuantity] AS [quantity],
    [OD].[orderDetailDiscount] AS [discount],
    [OD].[orderDetailSubTotal] AS [subtotal],
    [OD].[orderDetailTAX] AS [tax],
    [OD].[orderDetailTotal] AS [total],
    [OD].[orderDetailCurrencyId] AS [currencyId],
    [C].[currencyISO] AS [currencyISO],
    [OD].[orderDetailStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] [OD]
INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] [PV] ON [OD].[orderDetailProductVariableId] = [PV].[productVariableId]
INNER JOIN [SQM_GENERAL].[VW_PRODUCTS] [P] ON [PV].[productVariableProductId] = [P].[productId]
INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] [C] ON [OD].[orderDetailCurrencyId] = [C].[currencyId]
WHERE [OD].[orderDetailStatusId] = 1;
GO

SELECT * FROM [SQM_GENERAL].[VW_PAYMENT_ORDER_DETAILS];
