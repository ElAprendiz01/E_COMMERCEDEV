USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarGeneralProducts_Filtro
    @01_FilterText VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @01_FilterText = NULLIF(TRIM(@01_FilterText), '');

    -- Si no hay filtro, listamos el catálogo plano
    IF @01_FilterText IS NULL
    BEGIN
        SELECT *, CAST(0 AS INT) AS CoincidenceScore 
        FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS;
        RETURN;
    END

    -- 1. Diccionario expandido de Stop Words
    DECLARE @StopWords TABLE (Word VARCHAR(50));
    INSERT INTO @StopWords (Word) VALUES 
    ('quiero'),('buscar'),('necesito'),('tienen'),('precio'),('costo'),('stock'),('ver'),('comprar'),
    ('disponible'),('producto'),('catalogo'),('por'),('favor'),('una'),('uno'),('los'),('las'),
    ('con'),('para'),('gustaria'),('me'),('de'),('del'),('en'),('que'),('un');

    -- 2. Extracción de tokens limpios
    DECLARE @Tokens TABLE (Palabra VARCHAR(100));
    INSERT INTO @Tokens (Palabra)
    SELECT LOWER(value)
    FROM STRING_SPLIT(@01_FilterText, ' ')
    WHERE LEN(TRIM(value)) >= 2 
      AND LOWER(value) NOT IN (SELECT Word FROM @StopWords);

    IF NOT EXISTS (SELECT 1 FROM @Tokens)
    BEGIN
        INSERT INTO @Tokens (Palabra) VALUES (LOWER(@01_FilterText));
    END;

    -- Contamos cuántos tokens de búsqueda válidos tenemos en total (Ej: "zapatillas blanco" = 2)
    DECLARE @TotalTokensBuscados INT;
    SELECT @TotalTokensBuscados = COUNT(*) FROM @Tokens;

    -- 3. Consulta con Matriz de Coincidencias Ponderada y Multiplicador de Intersección
    SELECT 
        P.ProductID, 
        P.ProductName, 
        P.ProductVariableID, 
        P.ProductVariableName, 
        P.ProductVariablePrice,
        P.CurrencyID, 
        P.CurrencyISO, 
        P.CategoryID, 
        P.CategoryName, 
        P.SubcategoryID, 
        P.SubcategoryName,
        P.SegmentID, 
        P.SegmentName, 
        P.MarkID, 
        P.MarkName, 
        P.ProviderID, 
        P.ProviderName, 
        P.StockID,
        P.StockAvilable, 
        P.StockFactoryDate, 
        P.StockExpirationDate,
		p.ProductImageURL,
        -- LOGICA CORE: Suma base de prioridades multiplicado por la cantidad de tokens únicos acertados
        SUM(
            CASE 
                WHEN LOWER(P.MarkName) LIKE '%' + T.Palabra + '%' THEN 5
                WHEN LOWER(P.ProductName) LIKE '%' + T.Palabra + '%' THEN 4
                WHEN LOWER(P.ProductVariableName) LIKE '%' + T.Palabra + '%' THEN 3
                WHEN LOWER(P.CategoryName) LIKE '%' + T.Palabra + '%' THEN 2
                WHEN LOWER(P.SubcategoryName) LIKE '%' + T.Palabra + '%' THEN 2
                WHEN LOWER(P.SegmentName) LIKE '%' + T.Palabra + '%' THEN 2
                WHEN LOWER(P.ProviderName) LIKE '%' + T.Palabra + '%' THEN 1
                WHEN LOWER(P.CurrencyISO) LIKE '%' + T.Palabra + '%' THEN 1
                ELSE 0 
            END
        ) * COUNT(DISTINCT T.Palabra) AS CoincidenceScore
    FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS P
    INNER JOIN @Tokens T 
        ON LOWER(P.ProductName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.ProductVariableName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.CategoryName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.SubcategoryName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.SegmentName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.MarkName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.ProviderName) LIKE '%' + T.Palabra + '%'
        OR LOWER(P.CurrencyISO) LIKE '%' + T.Palabra + '%'
    GROUP BY 
        P.ProductID, P.ProductName, P.ProductVariableID, P.ProductVariableName, P.ProductVariablePrice,
        P.CurrencyID, P.CurrencyISO, P.CategoryID, P.CategoryName, P.SubcategoryID, P.SubcategoryName,
        P.SegmentID, P.SegmentName, P.MarkID, P.MarkName, P.ProviderID, P.ProviderName, P.StockID,
        P.StockAvilable, P.StockFactoryDate, P.StockExpirationDate, p.ProductImageURL
    HAVING 
        -- FILTRO EXIGENTE: Si el usuario escribe múltiples palabras, exigimos que el producto 
        -- contenga al menos más de un token coincidente para evitar cruces basura (como laptops en calzado)
        COUNT(DISTINCT T.Palabra) >= CASE WHEN @TotalTokensBuscados > 1 THEN 2 ELSE 1 END
    ORDER BY 
        CoincidenceScore DESC, 
        P.ProductVariablePrice ASC;
END
GO


select *   FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS

EXEC dbo.SP_ListarGeneralProducts_Filtro 'dell';