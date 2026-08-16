USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR DIRECCIONES (Seguro para Usuario Logueado + Búsqueda por Texto)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserAddress_Filter]
    @UserId INT = NULL,           -- El ID del usuario logueado (Filtro estricto numérico)
    @SearchTerm VARCHAR(50) = NULL
AS 
BEGIN
    SELECT 
        userAddressId,
        userId,
        userFullName,
        userName,
        userEmail,
        countryId,
        zipCode,
        addressDescription,
        isPrincipal,
        statusId
    FROM [SQM_GENERAL].[VW_USER_ADDRESSES] (NOLOCK)
    WHERE 
        -- 1. Control de Usuario: Si se envía @UserId, se filtra estrictamente por ese ID exacto es para hcaer los filtro de los usarios es pesifico 
		-- bien para el usario que eat loguea se manda  llamar este paramtro 
        (@UserId IS NULL OR userId = @UserId)
        
        -- 2. Buscador Inteligente: Filtra por texto dentro de los datos permitidos
        AND (
            @SearchTerm IS NULL
            OR userName LIKE '%' + @SearchTerm + '%'
            OR userFullName LIKE '%' + @SearchTerm + '%'
            OR userEmail LIKE '%' + @SearchTerm + '%'
            OR zipCode LIKE '%' + @SearchTerm + '%'
            OR addressDescription LIKE '%' + @SearchTerm + '%'
        )
        
    OPTION (RECOMPILE);
END
GO

EXEC [SQM_GENERAL].[sp_UserAddress_Filter] 
    @UserId = 2 
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

EXEC [SQM_GENERAL].[sp_UserAddress_Filter]  
    @SearchTerm = 'lo'
GO
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

