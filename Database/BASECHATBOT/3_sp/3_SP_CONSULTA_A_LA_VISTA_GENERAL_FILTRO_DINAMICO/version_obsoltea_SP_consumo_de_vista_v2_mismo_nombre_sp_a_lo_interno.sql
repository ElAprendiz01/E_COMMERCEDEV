USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarGeneralProducts_Filtro
    @01_FilterText VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpiamos y convertimos todo el filtro de entrada a minúsculas
    SET @01_FilterText = LOWER(NULLIF(TRIM(@01_FilterText), ''));

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
        StockExpirationDate
    FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS
    WHERE 
        @01_FilterText IS NULL
        OR LOWER(ProductName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(ProductVariableName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(CategoryName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(SubcategoryName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(SegmentName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(MarkName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(ProviderName) LIKE '%' + @01_FilterText + '%'
        OR LOWER(CurrencyISO) LIKE '%' + @01_FilterText + '%';
END
GO