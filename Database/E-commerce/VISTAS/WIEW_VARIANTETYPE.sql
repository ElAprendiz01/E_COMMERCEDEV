USE [DB_ECOMMERCE]
GO


USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[Vw_AttributeProductVariablesDetails] AS 
SELECT 
	apv.attributeProductVariableId				AS IdAtributoVariable, 
	apv.attributeProductVariableValue			AS ValorAtributo, 
	apv.attributeProductVariableStatusId		AS RegistroActivo, 
	pvt.productVariableTypeId					AS IdTipoVariable, 
	pvt.productVariableTypeName					AS TipoVariable, 
	pvt.productVariableTypeDescription			AS DescripcionTipoVariable, 
	pv.productVariableId						AS IdVariante, 
	pv.productVariableValue						AS ValorVariante, 
	pv.productVariablePrice						AS PrecioVariante, 
	c.currencyISO								AS CodigoMoneda, 
	c.currencyName								AS NombreMoneda, 
	p.productId									AS IdProducto, 
	p.productName								AS NombreProducto, 
	p.productDescription						AS DescripcionProducto, 
	m.markName									AS NombreMarca, 
	prov.providerName							AS NombreProveedor, 
	apv.attributeProductVariableCreationDate	AS FechaCreacion, 
	uc.userFullName								AS CreadoPor, 
	apv.attributeProductVariableModificationDate AS FechaModificacion, 
	um.userFullName								AS ModificadoPor 
FROM [SQM_GENERAL].[Tbl_ProductVariables] pv
LEFT JOIN [SQM_GENERAL].[Tbl_AttributeProductVariables] apv 
	ON apv.attributeProductVariableProductVariableId = pv.productVariableId 
LEFT JOIN [SQM_CATALOGS].[Tbl_ProductVariableTypes] pvt 
	ON apv.attributeProductVariableAttributeProductId = pvt.productVariableTypeId 
LEFT JOIN [SQM_GENERAL].[Tbl_Products] p 
	ON pv.productVariableProductId = p.productId 
LEFT JOIN [SQM_CATALOGS].[Tbl_Currencies] c 
	ON pv.productVariableCurrencyId = c.currencyId 
LEFT JOIN [SQM_CATALOGS].[Tbl_MarkByProviders] mbp 
	ON p.productMarkByProviderId = mbp.markByProviderId 
LEFT JOIN [SQM_CATALOGS].[Tbl_Marks] m 
	ON mbp.markByProviderMarkId = m.markId 
LEFT JOIN [SQM_CATALOGS].[Tbl_Providers] prov 
	ON mbp.markByProviderProviderId = prov.providerId 
LEFT JOIN [SQM_SECURITY].[Tbl_Users] uc 
	ON apv.attributeProductVariableCreatorId = uc.userId 
LEFT JOIN [SQM_SECURITY].[Tbl_Users] um 
	ON apv.attributeProductVariableModificatorId = um.userId; 
GO


SELECT *FROM  [SQM_GENERAL].[Vw_AttributeProductVariablesDetails]
select * from [SQM_GENERAL].[Vw_AttributeProductVariablesDetails]


SELECT * FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]



SELECT * FROM  [SQM_GENERAL].[Tbl_ProductVariables]

SELECT COUNT(*) FROM [SQM_GENERAL].[Tbl_AttributeProductVariables];