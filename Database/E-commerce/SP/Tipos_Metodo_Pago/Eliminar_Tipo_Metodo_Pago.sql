USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_PaymentMethodTypes_Delete]
(
    @paymentMethodTypeId INT, 
    @paymentMethodTypeModificatorId INT,
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

    DECLARE @CurrentStatus BIT;

    SELECT @CurrentStatus = paymentMethodTypeStatusId 
    FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 
    WHERE paymentMethodTypeId = @paymentMethodTypeId;

    IF @CurrentStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago especificado no existe.';
        RETURN;
    END;

    IF @CurrentStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @paymentMethodTypeModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 
        SET paymentMethodTypeStatusId = 0, 
            paymentMethodTypeModificatorId = @paymentMethodTypeModificatorId, 
            paymentMethodTypeModificationDate = GETDATE() 
        WHERE paymentMethodTypeId = @paymentMethodTypeId;

        SET @o_templateId = @paymentMethodTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de método de pago eliminado (desactivado) correctamente.';
        
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

EXEC [SQM_CATALOGS].[sp_PaymentMethodTypes_Delete]
    @paymentMethodTypeId = 3,
    @paymentMethodTypeModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

	
SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MetodoPagoTypeIdGenerado;