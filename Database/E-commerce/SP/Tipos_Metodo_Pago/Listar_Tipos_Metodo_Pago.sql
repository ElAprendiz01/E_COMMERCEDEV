USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_PaymentMethodTypes_List]
AS BEGIN
    SELECT paymentMethodTypeId, paymentMethodTypeName, paymentMethodTypeDescription, paymentMethodTypeCreatorId, paymentMethodTypeCreationDate, paymentMethodTypeModificatorId, paymentMethodTypeModificationDate, paymentMethodTypeStatusId
    
	
	FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] (NOLOCK)
	where paymentMethodTypeStatusId = 1;
	
END
GO

exec [SQM_CATALOGS].[sp_PaymentMethodTypes_List]