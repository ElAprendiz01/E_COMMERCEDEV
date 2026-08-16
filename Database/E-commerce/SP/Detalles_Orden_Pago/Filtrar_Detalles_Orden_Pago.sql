USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PaymentOrderDetails_Filter]
    @OrderId INT = NULL,
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

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
    FROM [SQM_GENERAL].[VW_PAYMENT_ORDER_DETAILS] (NOLOCK)
    WHERE 
        (@OrderId IS NULL OR orderId = @OrderId) 
        AND (
            @SearchTerm IS NULL
            OR productVariableId = @SearchId
            OR productName LIKE '%' + @SearchTerm + '%'
            OR categoryName LIKE '%' + @SearchTerm + '%'
            OR markName LIKE '%' + @SearchTerm + '%'
            OR providerName LIKE '%' + @SearchTerm + '%'
            OR variableValue LIKE '%' + @SearchTerm + '%'
            OR currencyISO LIKE '%' + @SearchTerm + '%'
        )
    OPTION (RECOMPILE);
END
GO


exec  [SQM_GENERAL].[sp_PaymentOrderDetails_Filter] @SearchTerm='compu'

exec  [SQM_GENERAL].[sp_PaymentOrderDetails_Filter] 2