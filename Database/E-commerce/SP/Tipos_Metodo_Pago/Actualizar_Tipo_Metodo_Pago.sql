USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_PaymentMethodTypes_Update]
(
    @paymentMethodTypeId INT, 
    @paymentMethodTypeName VARCHAR(50) = NULL, 
    @paymentMethodTypeDescription VARCHAR(100) = NULL, 
    @paymentMethodTypeModificatorId INT, 
    @paymentMethodTypeStatusId BIT = NULL,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @paymentMethodTypeId IS NULL OR @paymentMethodTypeId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de método de pago (@paymentMethodTypeId) es obligatorio.';
        RETURN;
    END;

    IF @paymentMethodTypeModificatorId IS NULL OR @paymentMethodTypeModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@paymentMethodTypeModificatorId) es obligatorio.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = paymentMethodTypeStatusId 
    FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 
    WHERE paymentMethodTypeId = @paymentMethodTypeId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago especificado no existe.';
        RETURN;
    END;

    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro se encuentra inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @paymentMethodTypeModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF @paymentMethodTypeName IS NOT NULL AND LTRIM(RTRIM(@paymentMethodTypeName)) <> ''
    BEGIN
        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeName = TRIM(@paymentMethodTypeName) AND paymentMethodTypeId <> @paymentMethodTypeId)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'El nombre del tipo de método de pago ya se encuentra registrado por otro registro.';
            RETURN;
        END;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 
        SET paymentMethodTypeName = COALESCE(NULLIF(TRIM(@paymentMethodTypeName), ''), paymentMethodTypeName), 
            paymentMethodTypeDescription = COALESCE(NULLIF(TRIM(@paymentMethodTypeDescription), ''), paymentMethodTypeDescription), 
            paymentMethodTypeModificatorId = @paymentMethodTypeModificatorId, 
            paymentMethodTypeModificationDate = GETDATE(), 
            paymentMethodTypeStatusId = COALESCE(@paymentMethodTypeStatusId, paymentMethodTypeStatusId)
        WHERE paymentMethodTypeId = @paymentMethodTypeId;

        SET @o_templateId = @paymentMethodTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de método de pago actualizado correctamente.';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END
GO

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_PaymentMethodTypes_Update]
    @paymentMethodTypeId = 3,
    @paymentMethodTypeName = 'TARJETA DE CREDITO ALTERNA',
    @paymentMethodTypeDescription = 'Nueva descripcion para la pasarela de pagos',
    @paymentMethodTypeModificatorId = 1,
    @paymentMethodTypeStatusId = 1,
	@o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MetodoPagoTypeIdGenerado;


	SELECT * FROM  [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 