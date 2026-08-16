USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR CON PARÁMETRO ÚNICO MULTICOLUMNA Y APERTURA SEGURA DE LLAVE
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserPaymentMethods_Filter]
(
    @SearchTerm VARCHAR(100) = NUll
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    BEGIN TRY
        -- Abrir clave simétrica para que la vista VW_USER_PAYMENT_METHODS pueda desencriptar
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
        FROM [SQM_GENERAL].[VW_USER_PAYMENT_METHODS] (NOLOCK)
        WHERE (
            @SearchTerm IS NULL
            OR userPaymentMethodId = @SearchId
            OR userId = @SearchId
            OR userFullName LIKE '%' + @SearchTerm + '%'
            OR userName LIKE '%' + @SearchTerm + '%'
            OR paymentMethodTypeName LIKE '%' + @SearchTerm + '%'
            OR cardHolderName LIKE '%' + @SearchTerm + '%'
            OR cardNumberDecrypted LIKE '%' + @SearchTerm + '%'
            OR RIGHT(cardNumberDecrypted, 4) = @SearchTerm
        )
        OPTION (RECOMPILE);

        CLOSE SYMMETRIC KEY KEY_HASH;
    END TRY
    BEGIN CATCH
        -- Asegurar el cierre de la clave simétrica ante cualquier fallo
        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE KEY_NAME = 'KEY_HASH')
            CLOSE SYMMETRIC KEY KEY_HASH;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC [SQM_GENERAL].[sp_UserPaymentMethods_Filter]
    @SearchTerm = 'Hector'

	EXEC [SQM_GENERAL].[sp_UserPaymentMethods_Filter]
    @SearchTerm = '5678'
