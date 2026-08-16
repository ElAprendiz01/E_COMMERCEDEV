USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Products_Filter]
(
    @SearchTerm VARCHAR(50) = NULL,
    @i_pageNumber INT = 1,            
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_pageNumber INT = NULL OUTPUT,
    @o_pageSize INT = NULL OUTPUT,
    @o_totalRows INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PageSize INT = 5;
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    -- Aseguramos que la página no venga NULL ni menor a 1
    SET @i_pageNumber = ISNULL(@i_pageNumber, 1);
    IF @i_pageNumber < 1 SET @i_pageNumber = 1;

    BEGIN TRY
      
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
        INTO #FilteredProducts
        FROM [SQM_GENERAL].[VW_GENERAL_PRODUCTS] (NOLOCK)
        WHERE (
            @SearchTerm IS NULL
            OR ProductID = @SearchId
            OR ProductName LIKE '%' + @SearchTerm + '%'
            OR ProductVariableName LIKE '%' + @SearchTerm + '%'
            OR CategoryName LIKE '%' + @SearchTerm + '%'
            OR SubcategoryName LIKE '%' + @SearchTerm + '%'
            OR SegmentName LIKE '%' + @SearchTerm + '%'
            OR MarkName LIKE '%' + @SearchTerm + '%'
            OR ProviderName LIKE '%' + @SearchTerm + '%'
        );

      
        SELECT @o_totalRows = COUNT(1) FROM #FilteredProducts;
        SET @o_pageNumber = @i_pageNumber;
        SET @o_pageSize = @PageSize;

        IF @o_totalRows > 0
        BEGIN
            SELECT *
            FROM #FilteredProducts
            ORDER BY ProductID ASC, ProviderID DESC
            OFFSET ((@i_pageNumber - 1) * @PageSize) ROWS
            FETCH NEXT @PageSize ROWS ONLY;

            SET @o_code = 200;
            SET @o_message = 'Búsqueda de productos satisfactoria';
        END
        ELSE
        BEGIN
            -- Si no hay resultados, enviamos un Select vacío con la misma estructura
            SELECT TOP 0 * FROM #FilteredProducts;

            SET @o_code = 204;
            SET @o_message = 'No se encontraron resultados para el filtro especificado';
        END

        DROP TABLE #FilteredProducts;

    END TRY
    BEGIN CATCH
        IF OBJECT_ID('tempdb..#FilteredProducts') IS NOT NULL
            DROP TABLE #FilteredProducts;

        SET @o_code = 500;
        SET @o_message = CONCAT_WS(' ', 'Error interno:', ERROR_MESSAGE());
    END CATCH
END
GO













-- Caso 1: Sin parámetros (Debería traer todo el universo de productos sin restricciones)
EXEC [SQM_GENERAL].[sp_Products_Filter];
GO

-- Caso 2: Filtrar solo por ID de producto (El SP convertirá internamente el texto a INT)
EXEC [SQM_GENERAL].[sp_Products_Filter] 
    @SearchTerm = '1';
GO

-- Caso 3: Filtrar solo por coincidencia de texto (Aplica para Nombre, Categoría, Marca, Proveedor, etc.)
EXEC [SQM_GENERAL].[sp_Products_Filter] 
    @SearchTerm = 'Laptop';
GO





-- Caso 1: Sin filtro, página 1
DECLARE @Code INT, @Message VARCHAR(255), @PageNumber INT, @PageSize INT, @TotalRows INT;

EXEC [SQM_GENERAL].[sp_Products_Filter]
    @SearchTerm = NULL,
    @i_pageNumber = 5,
    @o_code = @Code OUT,
    @o_message = @Message OUT,
    @o_pageNumber = @PageNumber OUT,
    @o_pageSize = @PageSize OUT,
    @o_totalRows = @TotalRows OUT;

PRINT 'CODIGO - ' + TRY_CAST(@Code AS VARCHAR);
PRINT 'MENSAJE - ' + TRY_CAST(@Message AS VARCHAR);
PRINT 'NUMERO DE PAGINA - ' + TRY_CAST(@PageNumber AS VARCHAR);
PRINT 'TOTAL REGISTROS - ' + TRY_CAST(@TotalRows AS VARCHAR);
GO

-- Caso 2: Filtrar por ID de producto con paginación
DECLARE @Code INT, @Message VARCHAR(255), @PageNumber INT, @PageSize INT, @TotalRows INT;

EXEC [SQM_GENERAL].[sp_Products_Filter]
    @SearchTerm = '5',
    @i_pageNumber = 5,
    @o_code = @Code OUT,
    @o_message = @Message OUT,
    @o_pageNumber = @PageNumber OUT,
    @o_pageSize = @PageSize OUT,
    @o_totalRows = @TotalRows OUT;
PRINT 'CODIGO - ' + TRY_CAST(@Code AS VARCHAR);
PRINT 'MENSAJE - ' + TRY_CAST(@Message AS VARCHAR);
PRINT 'TOTAL REGISTROS - ' + TRY_CAST(@TotalRows AS VARCHAR);
GO

-- Caso 3: Filtrar por texto (Categoría, Nombre, Marca, Proveedor, etc.)
DECLARE @Code INT, @Message VARCHAR(255), @PageNumber INT, @PageSize INT, @TotalRows INT;

EXEC [SQM_GENERAL].[sp_Products_Filter]
    @SearchTerm = 'Laptop',
    @i_pageNumber = 1,
    @o_code = @Code OUT,
    @o_message = @Message OUT,
    @o_pageNumber = @PageNumber OUT,
    @o_pageSize = @PageSize OUT,
    @o_totalRows = @TotalRows OUT;
GO