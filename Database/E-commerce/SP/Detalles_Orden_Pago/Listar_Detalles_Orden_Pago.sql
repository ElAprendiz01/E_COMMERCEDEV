USE [DB_ECOMMERCE]
GO

-- 2. LISTAR (Integrando Vista)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PaymentOrderDetails_List]
AS BEGIN
    SELECT 
        orderDetailId,
        orderId,
        productVariableId,
        productName,
        productDescription,
        categoryName,
        subCategoryName,
        segmentName,
        markName,
        providerName,
        variableValue,
        price,
        quantity,
        discount,
        subtotal,
        tax,
        total,
        currencyId,
        currencyISO,
        statusId
    FROM [SQM_GENERAL].[VW_PAYMENT_ORDER_DETAILS] (NOLOCK);
END
GO

exec [SQM_GENERAL].[sp_PaymentOrderDetails_List]