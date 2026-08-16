CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PriceHistory_Create]
(
    @priceHistoryProductVariableId INT,
    @priceHistoryOldPrice DECIMAL(18,2),
    @priceHistoryNewPrice DECIMAL(18,2),
    @priceHistoryModifierId INT = NULL,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM [SQM_GENERAL].[Tbl_ProductVariables]
            WHERE productVariableId = @priceHistoryProductVariableId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = 'ProductVariable no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @priceHistoryOldPrice < 0 OR @priceHistoryNewPrice < 0
        BEGIN
            SET @o_code = 400;
            SET @o_message = 'Los precios no pueden ser negativos.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO [SQM_GENERAL].[Tbl_PriceHistory]
        (
            priceHistoryProductVariableId,
            priceHistoryOldPrice,
            priceHistoryNewPrice,
            priceHistoryChangeDate,
            priceHistoryModifierId
        )
        VALUES
        (
            @priceHistoryProductVariableId,
            @priceHistoryOldPrice,
            @priceHistoryNewPrice,
            GETDATE(),
            @priceHistoryModifierId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Historial de precio registrado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO