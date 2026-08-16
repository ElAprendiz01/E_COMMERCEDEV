USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_GetActiveByUserId]
(
    @cartUserId INT
)
AS 
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cartId, 
        cartUserId, 
        cartCreatorId, 
        cartCreationDate, 
        cartModificatorId, 
        cartModificationDate, 
        cartStatusId
    FROM [SQM_GENERAL].[Tbl_Carts] (NOLOCK)
    WHERE cartUserId = @cartUserId
      AND cartStatusId = 1
    ORDER BY cartId DESC;
END
GO

exec  [SQM_GENERAL].[sp_Carts_GetActiveByUserId] @cartUserId =2