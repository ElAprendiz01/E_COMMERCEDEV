USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_PAYMENT_ORDERS]
AS
SELECT 
    [O].[orderId],
    [O].[orderUserId] AS [userId],
    [U].[userFullName] AS [userFullName],
    [U].[userName] AS [userName],
    [O].[orderDeliveryAddress] AS [deliveryAddressId],
    [UA].[userAddressDescription] AS [deliveryAddressDescription],
    [O].[orderPaymentMethodId] AS [paymentMethodId],
    [UPM].[userPaymentMethodCardHolderName] AS [paymentMethodCardHolderName],
    [O].[orderSubtotal] AS [subtotal],
    [O].[orderDiscount] AS [discount],
    [O].[orderShipping] AS [shipping],
    [O].[orderTAX] AS [tax],
    [O].[orderTotal] AS [total],
    [O].[orderCurrencyId] AS [currencyId],
    [C].[currencyISO] AS [currencyISO],
    [O].[orderCreationDate] AS [creationDate],
    [O].[orderStatusId] AS [statusId],
    [S].[statusName] AS [statusName]
FROM [SQM_GENERAL].[Tbl_PaymentOrders] [O]
INNER JOIN [SQM_SECURITY].[Tbl_Users] [U] ON [O].[orderUserId] = [U].[userId]
INNER JOIN [SQM_GENERAL].[Tbl_UserAddress] [UA] ON [O].[orderDeliveryAddress] = [UA].[userAddressId]
INNER JOIN [SQM_GENERAL].[Tbl_UserPaymentMethods] [UPM] ON [O].[orderPaymentMethodId] = [UPM].[userPaymentMethodId]
INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] [C] ON [O].[orderCurrencyId] = [C].[currencyId]
INNER JOIN [SQM_CATALOGS].[Tbl_Status] [S] ON [O].[orderStatusId] = [S].[statusId];
GO

SELECT * FROM [SQM_GENERAL].[VW_PAYMENT_ORDERS];
