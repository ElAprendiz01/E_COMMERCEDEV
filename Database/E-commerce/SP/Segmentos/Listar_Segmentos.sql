USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Segments_List]
AS BEGIN
    SELECT segmentId, segmentName, segmentDescription, segmentCreatorId, segmentStatusId, segmentCreationDate,segmentModificationDate
    FROM [SQM_CATALOGS].[Tbl_Segments] (NOLOCK)
	WHERE segmentStatusId=1;
END
GO

EXEC [SQM_CATALOGS].[sp_Segments_List]
