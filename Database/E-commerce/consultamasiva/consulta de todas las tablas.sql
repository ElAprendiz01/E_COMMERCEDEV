USE [DB_ECOMMERCE]
GO

-- ==========================================
-- 1. ESQUEMA: SQM_CATALOGS (Catálogos Base)
-- ==========================================

SELECT '--- [SQM_CATALOGS].[Tbl_Status] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Status];

SELECT '--- [SQM_CATALOGS].[Tbl_Categories] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Categories];

SELECT '--- [SQM_CATALOGS].[Tbl_SubCategories] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_SubCategories];

SELECT '--- [SQM_CATALOGS].[Tbl_Segments] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Segments];

SELECT '--- [SQM_CATALOGS].[Tbl_ProductIdentificators] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_ProductIdentificators];

SELECT '--- [SQM_CATALOGS].[Tbl_Providers] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Providers];

SELECT '--- [SQM_CATALOGS].[Tbl_Marks] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Marks];

SELECT '--- [SQM_CATALOGS].[Tbl_MarkByProviders] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_MarkByProviders];

SELECT '--- [SQM_CATALOGS].[Tbl_AttributesTypes] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_AttributesTypes];

SELECT '--- [SQM_CATALOGS].[Tbl_AttributeProducts] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_AttributeProducts];

SELECT '--- [SQM_CATALOGS].[Tbl_ProductVariableTypes] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes];

SELECT '--- [SQM_CATALOGS].[Tbl_Currencies] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_Currencies];

SELECT '--- [SQM_CATALOGS].[Tbl_PaymentMethodTypes] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes];

SELECT '--- [SQM_CATALOGS].[Tbl_StockMovementTypes] ---' AS [TABLA];
SELECT * FROM [SQM_CATALOGS].[Tbl_StockMovementTypes];


-- ==========================================
-- 2. ESQUEMA: SQM_SECURITY (Usuarios y Seguridad)
-- ==========================================

SELECT '--- [SQM_SECURITY].[Tbl_Users] ---' AS [TABLA];
SELECT * FROM [SQM_SECURITY].[Tbl_Users];


-- ==========================================
-- 3. ESQUEMA: SQM_GENERAL (Entidades y Transacciones)
-- ==========================================

SELECT '--- [SQM_GENERAL].[Tbl_UserAddress] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_UserAddress];

SELECT '--- [SQM_GENERAL].[Tbl_UserPaymentMethods] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_UserPaymentMethods];

SELECT '--- [SQM_GENERAL].[Tbl_Products] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_Products];

SELECT '--- [SQM_GENERAL].[Tbl_ProductImages] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_ProductImages];

SELECT '--- [SQM_GENERAL].[Tbl_ProductVariables] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_ProductVariables];

SELECT '--- [SQM_GENERAL].[Tbl_AttributeProductVariables] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_AttributeProductVariables];

SELECT '--- [SQM_GENERAL].[Tbl_Stocks] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_Stocks];

SELECT '--- [SQM_GENERAL].[Tbl_Carts] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_Carts];

SELECT '--- [SQM_GENERAL].[Tbl_CartDetails] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_CartDetails];

SELECT '--- [SQM_GENERAL].[Tbl_PaymentOrders] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_PaymentOrders];

SELECT '--- [SQM_GENERAL].[Tbl_PaymentOrderDetails] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails];

SELECT '--- [SQM_GENERAL].[Tbl_StockMovements] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_StockMovements];

SELECT '--- [SQM_GENERAL].[Tbl_StockMovementDetails] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_StockMovementDetails];

SELECT '--- [SQM_GENERAL].[Tbl_PriceHistory] ---' AS [TABLA];
SELECT * FROM [SQM_GENERAL].[Tbl_PriceHistory];
GO