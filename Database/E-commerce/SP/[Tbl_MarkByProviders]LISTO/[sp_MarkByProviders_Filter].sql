USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_MarkByProviders_Filter]
(
    @markByProviderId INT = NULL,
    @markByProviderMarkId INT = NULL,
    @markByProviderProviderId INT = NULL,
    @markByProviderCreatorId INT = NULL,
    @markByProviderCreationDate DATETIME = NULL,
    @markByProviderModificatorId INT = NULL,
    @markByProviderModificationDate DATETIME = NULL,
    @markByProviderStatusId BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        markByProviderId,
        markByProviderMarkId,
        markByProviderProviderId,
        markByProviderCreatorId,
        markByProviderCreationDate,
        markByProviderModificatorId,
        markByProviderModificationDate,
        markByProviderStatusId
    FROM [SQM_CATALOGS].[Tbl_MarkByProviders] (NOLOCK)
    WHERE
        (@markByProviderId IS NULL OR markByProviderId = @markByProviderId)
        AND (@markByProviderMarkId IS NULL OR markByProviderMarkId = @markByProviderMarkId)
        AND (@markByProviderProviderId IS NULL OR markByProviderProviderId = @markByProviderProviderId)
        AND (@markByProviderCreatorId IS NULL OR markByProviderCreatorId = @markByProviderCreatorId)
        AND (@markByProviderCreationDate IS NULL OR CAST(markByProviderCreationDate AS DATE) = CAST(@markByProviderCreationDate AS DATE))
        AND (@markByProviderModificatorId IS NULL OR markByProviderModificatorId = @markByProviderModificatorId)
        AND (@markByProviderModificationDate IS NULL OR CAST(markByProviderModificationDate AS DATE) = CAST(@markByProviderModificationDate AS DATE))
        AND (@markByProviderStatusId IS NULL OR markByProviderStatusId = @markByProviderStatusId)
    OPTION (RECOMPILE);
END;
GO