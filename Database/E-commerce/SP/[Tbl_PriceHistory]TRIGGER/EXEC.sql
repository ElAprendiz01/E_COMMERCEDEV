DECLARE @o_code INT,
        @o_message VARCHAR(255),
        @o_templateId INT;


-- CREATE

EXEC [SQM_GENERAL].[sp_PriceHistory_Create]
    @priceHistoryProductVariableId = 1,
    @priceHistoryOldPrice = 25.00,
    @priceHistoryNewPrice = 30.00,
    @priceHistoryModifierId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT
    @o_code AS Code,
    @o_message AS Message,
    @o_templateId AS TemplateId;


-- FILTER

EXEC [SQM_GENERAL].[sp_PriceHistory_Filter]
    @priceHistoryId = 1;

EXEC [SQM_GENERAL].[sp_PriceHistory_Filter]
    @priceHistoryProductVariableId = 1;


-- LIST

EXEC [SQM_GENERAL].[sp_PriceHistory_List];
GO