USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES, ENCRIPTACIÓN Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserPaymentMethods_Update]
(
    @userPaymentMethodId INT,
    @userPaymentMethodPaymentMethodTypeId INT,
    @CardNumberPlain VARCHAR(256),
    @ExpirationDatePlain VARCHAR(256),
    @CVVPlain VARCHAR(256),
    @userPaymentMethodCardHolderName VARCHAR(100),
    @userPaymentMethodModificatorId INT,
    @userPaymentMethodStatusId BIT,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @userPaymentMethodId IS NULL OR @userPaymentMethodId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del método de pago (@userPaymentMethodId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @userPaymentMethodPaymentMethodTypeId IS NULL OR @userPaymentMethodPaymentMethodTypeId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de método de pago (@userPaymentMethodPaymentMethodTypeId) es obligatorio y debe ser mayor a cero.';
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

    IF @userPaymentMethodModificatorId IS NULL OR @userPaymentMethodModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@userPaymentMethodModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @userPaymentMethodStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del método de pago (@userPaymentMethodStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del método de pago
    DECLARE @ExistingUserId INT;
    DECLARE @ExistingStatus BIT;
    SELECT 
        @ExistingUserId = userPaymentMethodUserId,
        @ExistingStatus = userPaymentMethodStatusId
    FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
    WHERE userPaymentMethodId = @userPaymentMethodId;

    IF @ExistingUserId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userPaymentMethodModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo del tipo de método de pago
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeId = @userPaymentMethodPaymentMethodTypeId AND paymentMethodTypeStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado de inactividad previa del registro
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago está inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    -- Abrir clave simétrica para encriptación y desencriptación
    BEGIN TRY
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;
    END TRY
    BEGIN CATCH
        SET @o_code = ERROR_NUMBER();
        SET @o_message = 'Error al abrir clave de encriptación: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH;

    -- Validar unicidad de la tarjeta para el mismo usuario
    IF EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
        WHERE userPaymentMethodUserId = @ExistingUserId
          AND userPaymentMethodStatusId = 1
          AND userPaymentMethodId <> @userPaymentMethodId
          AND [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodCardNumber) = TRIM(@CardNumberPlain)
    )
    BEGIN
        CLOSE SYMMETRIC KEY KEY_HASH;
        SET @o_code = -1;
        SET @o_message = 'Ya existe un método de pago activo registrado con esta misma tarjeta para este usuario.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Encriptar nuevos valores
        DECLARE @CardNumberEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@CardNumberPlain));
        DECLARE @ExpirationDateEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@ExpirationDatePlain));
        DECLARE @CVVEncrypted VARBINARY(256) = SQM_SECURITY.Fn_EncryptByKey(TRIM(@CVVPlain));

        UPDATE [SQM_GENERAL].[Tbl_UserPaymentMethods]
        SET userPaymentMethodPaymentMethodTypeId = @userPaymentMethodPaymentMethodTypeId,
            userPaymentMethodCardNumber = @CardNumberEncrypted,
            userPaymentMethodExpirationDate = @ExpirationDateEncrypted,
            userPaymentMethodCVV = @CVVEncrypted,
            userPaymentMethodCardHolderName = TRIM(@userPaymentMethodCardHolderName),
            userPaymentMethodModificatorId = @userPaymentMethodModificatorId,
            userPaymentMethodModificationDate = GETDATE(),
            userPaymentMethodStatusId = @userPaymentMethodStatusId
        WHERE userPaymentMethodId = @userPaymentMethodId;

        COMMIT TRANSACTION;

        CLOSE SYMMETRIC KEY KEY_HASH;

        SET @o_code = 200;
        SET @o_message = 'Método de pago actualizado correctamente.';
        SET @o_templateId = @userPaymentMethodId;
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

EXEC [SQM_GENERAL].[sp_UserPaymentMethods_Update]
    @userPaymentMethodId = 3,
    @userPaymentMethodPaymentMethodTypeId = 1,
    @CardNumberPlain = '4111111111111111',
    @ExpirationDatePlain = '12/31',
    @CVVPlain = '007',
    @userPaymentMethodCardHolderName = 'Hector Calero',
    @userPaymentMethodModificatorId = 1,
    @userPaymentMethodStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO



OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

SELECT 
    userPaymentMethodId AS [ID],
    userPaymentMethodUserId AS [UsuarioID],
    [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodCardNumber) AS [Tarjeta Desencriptada],
    userPaymentMethodStatusId AS [Estado Activo]
FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
WHERE userPaymentMethodUserId = 1;

CLOSE SYMMETRIC KEY KEY_HASH;