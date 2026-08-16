USE [DB_ECOMMERCE]
GO

-- 3. LISTAR (Integrando Vista)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Stocks_List]
AS BEGIN
    SELECT 
        stockId,
        productVariableId,
        productName,
        variableValue,
        unitPrice,
        currencyISO,
        quantity,
        factoryDate,
        expirationDate,
        statusId
    FROM [SQM_GENERAL].[VW_STOCKS] (NOLOCK);
END
GO


exec  [SQM_GENERAL].[sp_Stocks_List]