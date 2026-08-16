USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES, ENCRIPTACIÓN SEGURA Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserPaymentMethods_Create]
(
    @userPaymentMethodUserId INT,
    @userPaymentMethodPaymentMethodTypeId INT,
    @CardNumberPlain VARCHAR(256),
    @ExpirationDatePlain VARCHAR(256),
    @CVVPlain VARCHAR(256),
    @userPaymentMethodCardHolderName VARCHAR(100),
    @userPaymentMethodCreatorId INT,
    @userPaymentMethodStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @userPaymentMethodUserId IS NULL OR @userPaymentMethodUserId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del usuario (@userPaymentMethodUserId) es obligatorio.';
        RETURN;
    END;

    IF @userPaymentMethodPaymentMethodTypeId IS NULL OR @userPaymentMethodPaymentMethodTypeId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de método de pago (@userPaymentMethodPaymentMethodTypeId) es obligatorio.';
        RETURN;
    END;

    IF @CardNumberPlain IS NULL OR LTRIM(RTRIM(@CardNumberPlain)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El número de tarjeta es obligatorio.';
        RETURN;
    END;

    IF @ExpirationDatePlain IS NULL OR LTRIM(RTRIM(@ExpirationDatePlain)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La fecha de expiración es obligatoria.';
        RETURN;
    END;

    IF @CVVPlain IS NULL OR LTRIM(RTRIM(@CVVPlain)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El código CVV es obligatorio.';
        RETURN;
    END;

    IF @userPaymentMethodCardHolderName IS NULL OR LTRIM(RTRIM(@userPaymentMethodCardHolderName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del titular de la tarjeta es obligatorio.';
        RETURN;
    END;

    IF @userPaymentMethodCreatorId IS NULL OR @userPaymentMethodCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@userPaymentMethodCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @userPaymentMethodStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del método de pago (@userPaymentMethodStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado del usuario, del creador y del tipo de método de pago
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userPaymentMethodUserId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario comprador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userPaymentMethodCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeId = @userPaymentMethodPaymentMethodTypeId AND paymentMethodTypeStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Abrir clave simétrica para encriptación y validación de duplicados
    BEGIN TRY
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;
    END TRY
    BEGIN CATCH
        SET @o_code = ERROR_NUMBER();
        SET @o_message = 'Error al abrir clave de encriptación: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH;

    -- Validar unicidad de la tarjeta para el usuario (evitar agregar la misma tarjeta activa dos veces)
    IF EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
        WHERE userPaymentMethodUserId = @userPaymentMethodUserId
          AND userPaymentMethodStatusId = 1
          AND [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodCardNumber) = TRIM(@CardNumberPlain)
    )
    BEGIN
        CLOSE SYMMETRIC KEY KEY_HASH;
        SET @o_code = -1;
        SET @o_message = 'Ya existe un método de pago activo registrado con esta misma tarjeta para este usuario.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Encriptar valores
        DECLARE @CardNumberEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@CardNumberPlain));
        DECLARE @ExpirationDateEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@ExpirationDatePlain));
        DECLARE @CVVEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@CVVPlain));

        INSERT INTO [SQM_GENERAL].[Tbl_UserPaymentMethods]
        (
            userPaymentMethodUserId,
            userPaymentMethodPaymentMethodTypeId,
            userPaymentMethodCardNumber,
            userPaymentMethodExpirationDate,
            userPaymentMethodCVV,
            userPaymentMethodCardHolderName,
            userPaymentMethodCreatorId,
            userPaymentMethodCreationDate,
            userPaymentMethodStatusId
        )
        VALUES
        (
            @userPaymentMethodUserId,
            @userPaymentMethodPaymentMethodTypeId,
            @CardNumberEncrypted,
            @ExpirationDateEncrypted,
            @CVVEncrypted,
            TRIM(@userPaymentMethodCardHolderName),
            @userPaymentMethodCreatorId,
            GETDATE(),
            @userPaymentMethodStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        CLOSE SYMMETRIC KEY KEY_HASH;

        SET @o_code = 200;
        SET @o_message = 'Método de pago registrado correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE key_name = 'KEY_HASH')
            CLOSE SYMMETRIC KEY KEY_HASH;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO


DECLARE @o_code INT;
DECLARE @o_message VARCHAR(255);
DECLARE @o_templateId INT;

EXEC [SQM_GENERAL].[sp_UserPaymentMethods_Create]
    @userPaymentMethodUserId = 1,
    @userPaymentMethodPaymentMethodTypeId = 1,
    @CardNumberPlain = '4111111111111111',
    @ExpirationDatePlain = '12/30',
    @CVVPlain = '892',
    @userPaymentMethodCardHolderName = 'Hector calero',
    @userPaymentMethodCreatorId = 1,
    @userPaymentMethodStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Generado];
GO

select * from [SQM_SECURITY].[Tbl_Users]

select * from [SQM_GENERAL].[Tbl_UserPaymentMethods]