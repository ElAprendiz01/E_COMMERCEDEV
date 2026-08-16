USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR (Integrando Vista y Búsqueda Múltiple)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Stocks_Filter]
    @SearchTerm VARCHAR(50) = NULL, 
	@ProductVariableId INT = null
AS BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

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
    FROM [SQM_GENERAL].[VW_STOCKS] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR stockId = @SearchId
        OR productVariableId = @SearchId
        OR productName LIKE '%' + @SearchTerm + '%'
        OR variableValue LIKE '%' + @SearchTerm + '%'
    ) AND (@ProductVariableId IS NULL OR productVariableId = @ProductVariableId)
    OPTION (RECOMPILE);
END
GO

exec [SQM_GENERAL].[sp_Stocks_Filter]

exec [SQM_GENERAL].[sp_Stocks_Filter] @ProductVariableId=6