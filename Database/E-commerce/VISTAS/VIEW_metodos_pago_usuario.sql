USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[VW_USER_PAYMENT_METHODS]
AS
SELECT 
    [UPM].[userPaymentMethodId],
    [UPM].[userPaymentMethodUserId] AS [userId],
    [U].[userFullName],
    [U].[userName],
    [UPM].[userPaymentMethodPaymentMethodTypeId] AS [paymentMethodTypeId],
    [PMT].[paymentMethodTypeName],
    -- Nota: La llave simétrica KEY_HASH debe abrirse antes de ejecutar el SELECT sobre esta vista
    CONVERT(VARCHAR(256), DECRYPTBYKEY([UPM].[userPaymentMethodCardNumber])) AS [cardNumberDecrypted],
    CONVERT(VARCHAR(256), DECRYPTBYKEY([UPM].[userPaymentMethodExpirationDate])) AS [expirationDateDecrypted],
    CONVERT(VARCHAR(256), DECRYPTBYKEY([UPM].[userPaymentMethodCVV])) AS [cvvDecrypted],
    [UPM].[userPaymentMethodCardHolderName] AS [cardHolderName],
    [UPM].[userPaymentMethodStatusId] AS [statusId]
FROM [SQM_GENERAL].[Tbl_UserPaymentMethods] [UPM]
INNER JOIN [SQM_SECURITY].[Tbl_Users] [U] ON [UPM].[userPaymentMethodUserId] = [U].[userId]
INNER JOIN [SQM_CATALOGS].[Tbl_PaymentMethodTypes] [PMT] ON [UPM].[userPaymentMethodPaymentMethodTypeId] = [PMT].[paymentMethodTypeId]
WHERE [UPM].[userPaymentMethodStatusId] = 1;
GO

-- Consulta de prueba con apertura de la llave de seguridad
OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;
SELECT * FROM [SQM_GENERAL].[VW_USER_PAYMENT_METHODS];
CLOSE SYMMETRIC KEY KEY_HASH;
