USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_USER_ADDRESSES]
AS
SELECT 
    [UA].[userAddressId],
    [UA].[userAddressUserId] AS [userId],
    [U].[userFullName],
    [U].[userName],
    [U].[userEmail],
    [UA].[userAddressCountryId] AS [countryId],
    [UA].[userAddressZIPCode] AS [zipCode],
    [UA].[userAddressDescription] AS [addressDescription],
    [UA].[userAddressIsPrincipal] AS [isPrincipal],
    [UA].[userAddressStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_UserAddress] [UA]
INNER JOIN [SQM_SECURITY].[Tbl_Users] [U] ON [UA].[userAddressUserId] = [U].[userId]
WHERE [UA].[userAddressStatusId] = 1;
GO

SELECT * FROM [SQM_GENERAL].[VW_USER_ADDRESSES];
