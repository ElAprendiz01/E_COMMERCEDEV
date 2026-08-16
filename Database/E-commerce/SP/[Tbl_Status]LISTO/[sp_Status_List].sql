USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Status_List]
AS
BEGIN
    SELECT
        statusId,
        statusName,
        statusCreatorId,
        statusCreationDate,
        statusStatusId
    FROM [SQM_CATALOGS].[Tbl_Status] (NOLOCK);
END;
GO