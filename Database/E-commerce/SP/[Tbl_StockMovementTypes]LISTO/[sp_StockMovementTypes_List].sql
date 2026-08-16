USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_StockMovementTypes_List]
AS
BEGIN
    SELECT
        stockMovementTypeId,
        stockMovementTypeName,
        stockMovementTypeDescription,
        stockMovementTypeCreatorId,
        stockMovementTypeStatusId
    FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] (NOLOCK);
END;
GO