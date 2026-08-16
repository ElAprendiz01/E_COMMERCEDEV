USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR 
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_PaymentMethodTypes_Filter]
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT paymentMethodTypeId, paymentMethodTypeName, paymentMethodTypeDescription, paymentMethodTypeStatusId
   
   FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR paymentMethodTypeName LIKE '%' + @SearchTerm + '%'
        OR paymentMethodTypeDescription LIKE '%' + @SearchTerm + '%'
		or paymentMethodTypeDescription LIKE '%' + @SearchTerm + '%'
    ) 
	and paymentMethodTypeStatusId =1
    OPTION (RECOMPILE);
END
GO


  exec [SQM_CATALOGS].[sp_PaymentMethodTypes_Filter] 'VISA'
 go