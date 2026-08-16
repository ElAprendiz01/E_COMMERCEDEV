USE [DB_ECOMMERCE]
GO

-- 4. LISTAR (Integrando Vista)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserAddress_List]
AS
BEGIN
    SELECT 
        userAddressId,
        userId,
        userFullName,
        userName,
        userEmail,
        countryId,
        zipCode,
        addressDescription,
        isPrincipal,
        statusId
    FROM [SQM_GENERAL].[VW_USER_ADDRESSES] (NOLOCK);
END
GO

exec [SQM_GENERAL].[sp_UserAddress_List]
