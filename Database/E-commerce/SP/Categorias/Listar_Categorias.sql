USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Categories_List]
AS BEGIN
    SELECT categoryId, categoryName, categoryDescription, categoryCreatorId, categoryStatusId
    FROM [SQM_CATALOGS].[Tbl_Categories] (NOLOCK);
END
GO
exec [SQM_CATALOGS].[sp_Categories_List]