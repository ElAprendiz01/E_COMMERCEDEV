

USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarGeneralProducts_Filtro
    @01_FilterText VARCHAR(100) = NULL -- Permitimos que por defecto sea NULL si no mandan filtro
AS
BEGIN
    SET NOCOUNT ON;

    -- Si el parámetro viene vacío o con espacios, lo tratamos como NULL
    SET @01_FilterText = NULLIF(TRIM(@01_FilterText), '');

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
        OR ProductName LIKE '%' + @01_FilterText + '%'
        OR ProductVariableName LIKE '%' + @01_FilterText + '%'
        OR CategoryName LIKE '%' + @01_FilterText + '%'
        OR SubcategoryName LIKE '%' + @01_FilterText + '%'
        OR SegmentName LIKE '%' + @01_FilterText + '%'
        OR MarkName LIKE '%' + @01_FilterText + '%'
        OR ProviderName LIKE '%' + @01_FilterText + '%'
        OR CurrencyISO LIKE '%' + @01_FilterText + '%';
END
GO


EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = 'air negro';



EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = 'NIKE';


