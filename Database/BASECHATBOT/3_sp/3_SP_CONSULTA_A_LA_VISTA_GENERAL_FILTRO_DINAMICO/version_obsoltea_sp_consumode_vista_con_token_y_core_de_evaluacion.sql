USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarGeneralProducts_Filtro
    @01_FilterText VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @01_FilterText = NULLIF(TRIM(@01_FilterText), '');

    -- Si no se envía filtro, retornamos la vista completa
    IF @01_FilterText IS NULL
    BEGIN
        SELECT * FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS;
        RETURN;
    END

    -- A. CREACIÓN DE TABLA DE STOP WORDS (Palabras de Ruido Comunes)
    DECLARE @StopWords TABLE (Word VARCHAR(50));
    INSERT INTO @StopWords (Word) VALUES 
    ('quiero'),('buscar'),('necesito'),('tienen'),('precio'),('costo'),('stock'),('ver'),('comprar'),
    ('disponible'),('producto'),('catalogo'),('por'),('favor'),('una'),('uno'),('los'),('las'),('con'),('para');

    -- B. TABLA EN MEMORIA PARA EXTRAER TOKENS LIMPIOS
    DECLARE @Tokens TABLE (Palabra VARCHAR(100));
    
    INSERT INTO @Tokens (Palabra)
    SELECT LOWER(value)
    FROM STRING_SPLIT(@01_FilterText, ' ')
    WHERE LEN(TRIM(value)) >= 2 -- Ignora conectores de 1 sola letra como 'y', 'e', 'o'
      AND LOWER(value) NOT IN (SELECT Word FROM @StopWords);

    -- Si después de la limpieza la frase quedó vacía, forzamos el uso de la cadena original completa
    IF NOT EXISTS (SELECT 1 FROM @Tokens)
    BEGIN
        INSERT INTO @Tokens (Palabra) VALUES (LOWER(@01_FilterText));
    END

    -- C. CONSULTA CON SISTEMA DE RATING (SCORING)
    -- Cada coincidencia con un campo clave añade peso al registro
    ;WITH ProductsScored AS (
        SELECT 
            P.*,
            (
                SELECT COUNT(*) 
                FROM @Tokens T 
                WHERE LOWER(P.ProductName) LIKE '%' + T.Palabra + '%'
                   OR LOWER(P.ProductVariableName) LIKE '%' + T.Palabra + '%'
                   OR LOWER(P.CategoryName) LIKE '%' + T.Palabra + '%'
                   OR LOWER(P.SubcategoryName) LIKE '%' + T.Palabra + '%'
                   OR LOWER(P.MarkName) LIKE '%' + T.Palabra + '%'
            ) AS CoincidenceScore
        FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS P
    )
    -- Seleccionamos solo aquellos registros que tengan un Score mayor a 0, 
    -- ordenados de manera descendente por relevancia (Mayor coincidencia arriba)
    SELECT 
        ProductID, ProductName, ProductVariableID, ProductVariableName, ProductVariablePrice,
        CurrencyID, CurrencyISO, CategoryID, CategoryName, SubcategoryID, SubcategoryName,
        SegmentID, SegmentName, MarkID, MarkName, ProviderID, ProviderName, StockID,
        StockAvilable, StockFactoryDate, StockExpirationDate
    FROM ProductsScored
    WHERE CoincidenceScore > 0
    ORDER BY CoincidenceScore DESC;

END
GO