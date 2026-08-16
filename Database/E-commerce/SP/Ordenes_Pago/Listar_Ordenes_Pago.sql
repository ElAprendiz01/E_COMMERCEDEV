USE [DB_ECOMMERCE]
GO

-- 2. LISTAR (Integrando Vista)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PaymentOrders_List]
AS BEGIN
    SELECT 
        orderId,
        userId,
        userFullName,
        userName,
        deliveryAddressId,
        deliveryAddressDescription,
        paymentMethodId,
        paymentMethodCardHolderName,
        subtotal,
        discount,
        shipping,
        tax,
        total,
        currencyId,
        currencyISO,
        creationDate,
        statusId,
        statusName
    FROM [SQM_GENERAL].[VW_PAYMENT_ORDERS] (NOLOCK);
END
GO

exec [SQM_GENERAL].[sp_PaymentOrders_List]
