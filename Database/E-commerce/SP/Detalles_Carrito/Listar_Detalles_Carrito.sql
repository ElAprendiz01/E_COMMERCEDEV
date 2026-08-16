USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_CartDetails_List]
AS 
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cartDetailId, 
        cartDetailCartId, 
        cartDetailProductVariableId, 
        cartDetailPrice, 
        cartDetailQuantity, 
        cartDetailDiscount, 
        cartDetailSubTotal, 
        cartDetailTAX, 
        cartDetailTotal, 
        cartDetailCurrencyId, 
        cartDetailCreatorId, 
        cartDetailCreationDate, 
        cartDetailModificatorId, 
        cartDetailModificationDate, 
        cartDetailStatusId
    FROM [SQM_GENERAL].[Tbl_CartDetails] WITH (NOLOCK)
    WHERE cartDetailStatusId = 1; -- 👈 Excluye registros inactivos (eliminados/vacíos)
END
GO