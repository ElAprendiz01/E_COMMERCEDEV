USE [DB_ECOMMERCE]
GO

-- 4. LISTAR (Integrando Vista)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserPaymentMethods_List]
AS
BEGIN
    OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

    SELECT 
        userPaymentMethodId,
        userId,
        userFullName,
        userName,
        paymentMethodTypeId,
        paymentMethodTypeName,
        cardNumberDecrypted,
        expirationDateDecrypted,
        cvvDecrypted,
        cardHolderName,
        statusId
    FROM [SQM_GENERAL].[VW_USER_PAYMENT_METHODS] (NOLOCK);

    CLOSE SYMMETRIC KEY KEY_HASH;
END
GO
