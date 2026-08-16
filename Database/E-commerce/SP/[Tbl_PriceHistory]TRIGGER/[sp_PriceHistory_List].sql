CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PriceHistory_List]
AS
BEGIN
    SELECT
        priceHistoryId,
        priceHistoryProductVariableId,
        priceHistoryOldPrice,
        priceHistoryNewPrice,
        priceHistoryChangeDate,
        priceHistoryModifierId
    FROM [SQM_GENERAL].[Tbl_PriceHistory] (NOLOCK);
END;
GO

EXEC [SQM_GENERAL].[sp_PriceHistory_List];