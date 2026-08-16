USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Products_List]
(
    @i_pageNumber INT = NULL,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_pageNumber INT = NULL OUTPUT,
    @o_pageSize INT = NULL OUTPUT,
    @o_totalRows INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PageSize INT = 10;

    BEGIN TRY
        -- Obtener el conteo total de filas desde la  vista
       SET @o_pageNumber = ISNULL(@i_pageNumber, 1);
        SET @o_pageSize = @PageSize;

        SELECT @o_totalRows = COUNT(1)
        FROM [SQM_GENERAL].[VW_GENERAL_PRODUCTS] (NOLOCK);
        -- Consultar los datos con la estructura de la nueva vista
        SELECT
            ProductID,
            ProductName,
            ProductVariableID,
            ProductVariableName,
            ProductVariablePrice,
            CurrencyID,
            CurrencyISO,
            CategoryID,
            CategoryName,
            SubcategoryID,
            SubcategoryName,
            SegmentID,
            SegmentName,
            MarkID,
            MarkName,
            ProviderID,
            ProviderName,
            StockID,
            StockAvilable,
            StockFactoryDate,
            StockExpirationDate,
            ProductImageURL
        FROM [SQM_GENERAL].[VW_GENERAL_PRODUCTS] (NOLOCK)
        ORDER BY ProductID ASC, ProviderID DESC
        OFFSET ((ISNULL(@i_pageNumber, 1) - 1) * @PageSize) ROWS
        FETCH NEXT @PageSize ROWS ONLY;

        IF @@ROWCOUNT > 0
        BEGIN
            SET @o_code = 200;
            SET @o_message = 'Carga de productos satisfactoria';
        END
        ELSE
        BEGIN
            SET @o_code = 204;
            SET @o_message = 'No hay más filas disponibles';
        END
    END TRY
    BEGIN CATCH
        SET @o_code = 500;
        SET @o_message = CONCAT_WS(' ', 'Error interno:', ERROR_MESSAGE());
    END CATCH
END
GO



exec [SQM_GENERAL].[sp_Products_List] @i_pageNumber = 1


SELECT * FROM [SQM_GENERAL].[Tbl_Products]

DECLARE
	@Code INT,
	@Message VARCHAR(255),
	@PageNumber INT,
	@PageSize INT,
	@TotalRows INT

EXEC [SQM_GENERAL].[sp_Products_List]
@i_pageNumber = 1,
@o_code = @Code OUT,
@o_message = @Message OUT,
@o_pageNumber = @PageNumber OUT,
@o_pageSize = @PageSize OUT,
@o_totalRows = @TotalRows OUT

PRINT 'CODIGO - ' +  TRY_CAST(@Code AS VARCHAR)
PRINT 'MENSAJE - ' + TRY_CAST(@Message AS VARCHAR)
PRINT 'NUMERO PAGINA - ' + TRY_CAST(@PageNumber AS VARCHAR)
PRINT 'TAMAÑO DE PAGINA - ' + TRY_CAST(@PageSize AS VARCHAR)
PRINT 'TOTAL REGISTROS - ' + TRY_CAST(@TotalRows AS VARCHAR)



select * from [SQM_GENERAL].[VW_GENERAL_PRODUCTS]
