USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarGeneralProducts_Filtro
    @01_FilterText VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiamos el texto de entrada
    SET @01_FilterText = NULLIF(TRIM(@01_FilterText), '');

    -- Si no hay filtro, listamos todo
    IF @01_FilterText IS NULL
    BEGIN
        SELECT * FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS;
        RETURN;
    END

    -- Creamos una tabla en memoria para guardar las palabras sueltas (Tokens)
    -- Filtramos palabras muy cortas como "de", "me", "un", "el" (menores a 3 letras) para no saturar la búsqueda
    DECLARE @Tokens TABLE (Palabra VARCHAR(100));
    
    INSERT INTO @Tokens (Palabra)
    SELECT LOWER(value)
    FROM STRING_SPLIT(@01_FilterText, ' ')
    WHERE LEN(TRIM(value)) >= 3;

    -- Si después de filtrar conectores no quedan tokens, usamos la frase completa original limpia
    IF NOT EXISTS (SELECT 1 FROM @Tokens)
    BEGIN
        INSERT INTO @Tokens (Palabra) VALUES (LOWER(@01_FilterText));
    END

    -- Ejecutamos la consulta validando si los campos contienen AL MENOS UNO de los tokens importantes
    SELECT DISTINCT
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
        StockExpirationDate
    FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS P
    WHERE EXISTS (
        SELECT 1 
        FROM @Tokens T 
        WHERE LOWER(P.ProductName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.ProductVariableName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.CategoryName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.SubcategoryName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.SegmentName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.MarkName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.ProviderName) LIKE '%' + T.Palabra + '%'
           OR LOWER(P.CurrencyISO) LIKE '%' + T.Palabra + '%'
    );
END
GO

EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = 'Dell para variar NIKE';



EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = 'Zapatillas negro';
