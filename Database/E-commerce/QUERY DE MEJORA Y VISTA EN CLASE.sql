USE [DB_ECOMMERCE]
GO


select * from [SQM_GENERAL].[Tbl_Products]

select * from [SQM_GENERAL].[VW_PRODUCTS]


SELECT 
    [P].[productId],
    [P].[productName],
    [P].[productDescription],
    [P].[productProductIdentificatorId] AS [productIdentificatorId],
    [PI].[categoryId],
    [PI].[categoryName],
    [PI].[subCategoryId],
    [PI].[subCategoryName],
    [PI].[segmentId],
    [PI].[segmentName],
    [P].[productMarkByProviderId] AS [markByProviderId],
    [MP].[markId],
    [MP].[markName],
    [MP].[providerId],
    [MP].[providerName],
    [P].[productStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_Products] [P]
LEFT JOIN [SQM_CATALOGS].[VW_PRODUCT_IDENTIFICATORS] [PI] ON [P].[productProductIdentificatorId] = [PI].[productIdentificatorId]
LEFT JOIN [SQM_CATALOGS].[VW_MARKS_BY_PROVIDER] [MP] ON [P].[productMarkByProviderId] = [MP].[markByProviderId]
WHERE [P].[productStatusId] = 1;

SELECT * FROM [SQM_CATALOGS].[Tbl_Marks]
SELECT * FROM [SQM_CATALOGS].[Tbl_Categories]
SELECT * FROM [SQM_CATALOGS].[Tbl_SubCategories]
SELECT * FROM [SQM_CATALOGS].[Tbl_Segments]
SELECT * FROM [SQM_CATALOGS].[Tbl_Providers]
SELECT * FROM [SQM_CATALOGS].[Tbl_MarkByProviders]

---------------

BEGIN TRANSACTION;

-- 1. Eliminar imágenes del producto
DELETE FROM [SQM_GENERAL].[Tbl_ProductImages]
WHERE productImageProductId = 14;

-- 2. Eliminar atributos asociados a sus variables
DELETE FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
WHERE attributeProductVariableProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId = 14
);

-- 3. Eliminar historial de precios
DELETE FROM [SQM_GENERAL].[Tbl_PriceHistory]
WHERE priceHistoryProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId = 14
);

-- 4. Eliminar detalles de órdenes de pago
DELETE FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails]
WHERE orderDetailProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId = 14
);

-- 5. Eliminar detalles de carrito
DELETE FROM [SQM_GENERAL].[Tbl_CartDetails]
WHERE cartDetailProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId = 14
);

-- 6. Eliminar movimientos de stock
DELETE FROM [SQM_GENERAL].[Tbl_StockMovementDetails]
WHERE stockMovementDetailStockId IN (
    SELECT stockId
    FROM [SQM_GENERAL].[Tbl_Stocks] s
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] v
        ON s.stockProductVariableId = v.productVariableId
    WHERE v.productVariableProductId = 14
);

-- 7. Eliminar stocks
DELETE FROM [SQM_GENERAL].[Tbl_Stocks]
WHERE stockProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId = 14
);

-- 8. Eliminar variables del producto
DELETE FROM [SQM_GENERAL].[Tbl_ProductVariables]
WHERE productVariableProductId = 14;

-- 9. Finalmente eliminar el producto
DELETE FROM [SQM_GENERAL].[Tbl_Products]
WHERE productId = 14;

COMMIT TRANSACTION;




---------

SELECT DISTINCT productVariableProductId
FROM [SQM_GENERAL].[Tbl_ProductVariables]
WHERE productVariableProductId IN (8, 15, 16, 17, 18, 19, 20, 21, 9, 3, 4, 1, 24, 25, 26, 27, 29);

DELETE FROM [SQM_GENERAL].[Tbl_ProductVariables]
WHERE productVariableProductId IN (1, 3, 8, 9, 15, 16, 17, 18, 19, 20, 21, 24, 25);


DELETE FROM [SQM_GENERAL].[Tbl_ProductImages]
WHERE productImageProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25);



DELETE FROM [SQM_GENERAL].[Tbl_ProductVariables]
WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25);

DELETE FROM [SQM_GENERAL].[Tbl_Products]
WHERE productId IN (1,3,8,9,15,16,17,18,19,20,21,24,25);


DELETE FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
WHERE attributeProductVariableProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);



DELETE FROM [SQM_GENERAL].[Tbl_PriceHistory]
WHERE priceHistoryProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);


DELETE FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails]
WHERE orderDetailProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);


DELETE FROM [SQM_GENERAL].[Tbl_CartDetails]
WHERE cartDetailProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);


DELETE FROM [SQM_GENERAL].[Tbl_Stocks]
WHERE stockProductVariableId IN (
    SELECT productVariableId
    FROM [SQM_GENERAL].[Tbl_ProductVariables]
    WHERE productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);

DELETE FROM [SQM_GENERAL].[Tbl_StockMovementDetails]
WHERE stockMovementDetailStockId IN (
    SELECT stockId
    FROM [SQM_GENERAL].[Tbl_Stocks] s
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] v
        ON s.stockProductVariableId = v.productVariableId
    WHERE v.productVariableProductId IN (1,3,8,9,15,16,17,18,19,20,21,24,25)
);



  BEGIN TRANSACTION;

DELETE FROM [SQM_GENERAL].[Tbl_Products]
WHERE productId IN (4, 26, 27, 29);

COMMIT TRANSACTION;





--NOTA NO TENEMOS LA VISTA DE PRODIUTO GENERAL QUE EL DOCENTE DIO ASEGURARSE SOBRE ESO  Y HACER LA MODIFICACION 
--MODIFICACIONES DE VSTA EN CLASES DE VIEW PRODUCT 


DECLARE @NUMEROPAGINA INT,
        @CANTIDADREGISTROPORPAGINA INT

         SET @NUMEROPAGINA = 5
         SET @CANTIDADREGISTROPORPAGINA= 6

SELECT * FROM [SQM_GENERAL].[VW_PRODUCTS] AS GP
ORDER BY GP.productId, GP.providerId DESC
OFFSET (@NUMEROPAGINA -1) * @CANTIDADREGISTROPORPAGINA ROWS 
FETCH NEXT @CANTIDADREGISTROPORPAGINA ROWS ONLY;
