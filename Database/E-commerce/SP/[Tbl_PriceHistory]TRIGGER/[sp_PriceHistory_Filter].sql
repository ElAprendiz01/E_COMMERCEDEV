CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PriceHistory_Filter]
(
    @priceHistoryId INT = NULL,
    @priceHistoryProductVariableId INT = NULL,
    @priceHistoryOldPrice DECIMAL(18,2) = NULL,
    @priceHistoryNewPrice DECIMAL(18,2) = NULL,
    @priceHistoryModifierId INT = NULL,
    @priceHistoryChangeDate DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        priceHistoryId,
        priceHistoryProductVariableId,
        priceHistoryOldPrice,
        priceHistoryNewPrice,
        priceHistoryChangeDate,
        priceHistoryModifierId
    FROM [SQM_GENERAL].[Tbl_PriceHistory] (NOLOCK)
    WHERE
        (@priceHistoryId IS NULL OR priceHistoryId = @priceHistoryId)
        AND (@priceHistoryProductVariableId IS NULL OR priceHistoryProductVariableId = @priceHistoryProductVariableId)
        AND (@priceHistoryOldPrice IS NULL OR priceHistoryOldPrice = @priceHistoryOldPrice)
        AND (@priceHistoryNewPrice IS NULL OR priceHistoryNewPrice = @priceHistoryNewPrice)
        AND (@priceHistoryModifierId IS NULL OR priceHistoryModifierId = @priceHistoryModifierId)
        AND (@priceHistoryChangeDate IS NULL OR CAST(priceHistoryChangeDate AS DATE) = CAST(@priceHistoryChangeDate AS DATE))
    OPTION (RECOMPILE);
END;
GO