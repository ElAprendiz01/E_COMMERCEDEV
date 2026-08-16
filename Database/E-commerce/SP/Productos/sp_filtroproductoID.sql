USE [DB_ECOMMERCE];
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Products_Filter_Id]
(
    @ProductId INT = NULL,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar si el producto existe en la base de datos
        IF EXISTS (
            SELECT 1 
            FROM [SQM_GENERAL].[Tbl_Products] (NOLOCK) 
            WHERE productId = @ProductId AND productStatusId = 1
        )
        BEGIN
            -- Retornar TODAS las variantes registradas en Tbl_ProductVariables para ese producto
            SELECT 
                P.productId AS ProductID,
                P.productName AS ProductName,
                PV.productVariableId AS ProductVariableID,
                PV.productVariableValue AS ProductVariableName,
                PV.productVariablePrice AS ProductVariablePrice,
                C.currencyId AS CurrencyID,
                C.currencyISO AS CurrencyISO,
                GP.categoryId AS CategoryID,
                GP.categoryName AS CategoryName,
                GP.subCategoryId AS SubcategoryID,
                GP.subCategoryName AS SubcategoryName,
                GP.segmentId AS SegmentID,
                GP.segmentName AS SegmentName,
                M.markId AS MarkID,
                M.markName AS MarkName,
                PR.providerId AS ProviderID,
                PR.providerName AS ProviderName,
                ST.stockId AS StockID,
                ISNULL(ST.stockQuantity, 0) AS StockAvilable,
                ST.stockFactoryDate AS StockFactoryDate,
                ST.stockExpirationDate AS StockExpirationDate,
                IMG.productImageURL AS ProductImageURL
            FROM [SQM_GENERAL].[Tbl_Products] (NOLOCK) P
            INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] (NOLOCK) PV
                ON P.productId = PV.productVariableProductId AND PV.productVariableStatusId = 1
            INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] (NOLOCK) C
                ON PV.productVariableCurrencyId = C.currencyId
            LEFT JOIN [SQM_CATALOGS].[VW_PRODUCT_IDENTIFICATORS] (NOLOCK) GP
                ON P.productProductIdentificatorId = GP.productIdentificatorId
            LEFT JOIN [SQM_CATALOGS].[Tbl_MarkByProviders] (NOLOCK) MxP
                ON P.productMarkByProviderId = MxP.markByProviderId
            LEFT JOIN [SQM_CATALOGS].[Tbl_Marks] (NOLOCK) M
                ON MxP.markByProviderMarkId = M.markId
            LEFT JOIN [SQM_CATALOGS].[Tbl_Providers] (NOLOCK) PR
                ON MxP.markByProviderProviderId = PR.providerId
            LEFT JOIN [SQM_GENERAL].[Tbl_Stocks] (NOLOCK) ST
                ON PV.productVariableId = ST.stockProductVariableId AND ST.stockStatusId = 1
            LEFT JOIN [SQM_GENERAL].[Tbl_ProductImages] (NOLOCK) IMG
                ON P.productId = IMG.productImageProductId AND IMG.productImageIsPrincipal = 1 AND IMG.productImageStatusId = 1
            WHERE P.productId = @ProductId AND P.productStatusId = 1;

            SET @o_code = 200;
            SET @o_message = 'Búsqueda de producto satisfactoria';
        END
        ELSE
        BEGIN
            SET @o_code = 204;
            SET @o_message = 'No se encontró el producto especificado';
        END

    END TRY
    BEGIN CATCH
        SET @o_code = 500;
        SET @o_message = CONCAT_WS(' ', 'Error interno:', ERROR_MESSAGE());
    END CATCH
END
GO

-- Prueba en SSMS para comprobar que ahora trae todas las variantes de AIR MAX 90 CASUAL:
EXEC [SQM_GENERAL].[sp_Products_Filter_Id] @ProductId = 7;
GO