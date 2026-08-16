USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserPaymentMethods_Delete]
(
    @userPaymentMethodId INT,
    @userPaymentMethodModificatorId INT,
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

    IF @userPaymentMethodModificatorId IS NULL OR @userPaymentMethodModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@userPaymentMethodModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo del método de pago
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = userPaymentMethodStatusId
    FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
    WHERE userPaymentMethodId = @userPaymentMethodId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userPaymentMethodModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_UserPaymentMethods]
        SET userPaymentMethodStatusId = 0,
            userPaymentMethodModificatorId = @userPaymentMethodModificatorId,
            userPaymentMethodModificationDate = GETDATE()
        WHERE userPaymentMethodId = @userPaymentMethodId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Método de pago inactivado (eliminado) correctamente.';
        SET @o_templateId = @userPaymentMethodId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO

DECLARE @o_code INT;
DECLARE @o_message VARCHAR(255);
DECLARE @o_templateId INT;

EXEC [SQM_GENERAL].[sp_UserPaymentMethods_Delete]
    @userPaymentMethodId = 35,
    @userPaymentMethodModificatorId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Inactivado];
GO
