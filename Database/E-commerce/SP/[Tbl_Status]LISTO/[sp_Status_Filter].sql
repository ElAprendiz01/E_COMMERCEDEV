USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Status_Filter]
(
    @statusId INT = NULL,
    @statusName VARCHAR(50) = NULL,
    @statusCreatorId INT = NULL,
    @statusCreationDate DATETIME = NULL,
    @statusStatusId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        statusId,
        statusName,
        statusCreatorId,
        statusCreationDate,
        statusStatusId
    FROM [SQM_CATALOGS].[Tbl_Status] (NOLOCK)
    WHERE
        (@statusId IS NULL OR statusId = @statusId)
        AND (@statusName IS NULL OR statusName LIKE '%' + LTRIM(RTRIM(@statusName)) + '%')
        AND (@statusCreatorId IS NULL OR statusCreatorId = @statusCreatorId)
        AND (@statusCreationDate IS NULL OR CAST(statusCreationDate AS DATE) = CAST(@statusCreationDate AS DATE))
        AND (@statusStatusId IS NULL OR statusStatusId = @statusStatusId)
    OPTION (RECOMPILE);
END;
GO