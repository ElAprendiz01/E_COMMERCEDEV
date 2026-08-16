USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_List]
AS BEGIN
    SELECT 
        cartId, cartUserId, cartCreatorId, cartCreationDate, 
        cartModificatorId, cartModificationDate, cartStatusId
    FROM [SQM_GENERAL].[Tbl_Carts] (NOLOCK);
END
GO
exec [SQM_GENERAL].[sp_Carts_List]
