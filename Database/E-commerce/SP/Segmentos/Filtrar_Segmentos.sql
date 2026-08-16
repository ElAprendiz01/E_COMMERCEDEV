USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Segments_Filter]
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    SET NOCOUNT ON;

    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT 
        segmentId, 
        segmentName, 
        segmentDescription, 
        segmentStatusId
    FROM [SQM_CATALOGS].[Tbl_Segments] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR segmentId = @SearchId
        OR segmentName LIKE '%' + @SearchTerm + '%'
        OR segmentDescription LIKE '%' + @SearchTerm + '%'
    ) 
    AND segmentStatusId = 1
    OPTION (RECOMPILE);
END
GO

exec  [SQM_CATALOGS].[sp_Segments_Filter]
exec  [SQM_CATALOGS].[sp_Segments_Filter]'HOGAR'