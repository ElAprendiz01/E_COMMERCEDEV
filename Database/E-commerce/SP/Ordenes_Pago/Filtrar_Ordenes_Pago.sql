USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PaymentOrders_Filter]
    @UserId INT = NULL,
    @SearchTerm VARCHAR(50) = NULL,
    @StatusId INT = NULL
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
    FROM [SQM_GENERAL].[VW_PAYMENT_ORDERS] (NOLOCK)
    WHERE 
        (@UserId IS NULL OR userId = @UserId) 
        AND (
            @SearchTerm IS NULL
            OR paymentMethodCardHolderName LIKE '%' + @SearchTerm + '%'
            OR currencyISO LIKE '%' + @SearchTerm + '%'
            OR statusName LIKE '%' + @SearchTerm + '%'
        )
        AND (@StatusId IS NULL OR statusId = @StatusId)
    OPTION (RECOMPILE);
END
GO

exec [SQM_GENERAL].[sp_PaymentOrders_Filter] 2
go

EXEC [SQM_GENERAL].[sp_PaymentOrders_Filter] @SearchTerm = 'usd';
GO