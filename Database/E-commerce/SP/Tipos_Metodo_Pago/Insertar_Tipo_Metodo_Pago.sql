USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_PaymentMethodTypes_Create]
(
    @paymentMethodTypeName VARCHAR(50), 
    @paymentMethodTypeDescription VARCHAR(100), 
    @paymentMethodTypeCreatorId INT, 
    @paymentMethodTypeStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @paymentMethodTypeName IS NULL OR LTRIM(RTRIM(@paymentMethodTypeName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del tipo de método de pago (@paymentMethodTypeName) es obligatorio.';
        RETURN;
    END;

    IF @paymentMethodTypeDescription IS NULL OR LTRIM(RTRIM(@paymentMethodTypeDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción (@paymentMethodTypeDescription) es obligatoria.';
        RETURN;
    END;

    IF @paymentMethodTypeCreatorId IS NULL OR @paymentMethodTypeCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@paymentMethodTypeCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @paymentMethodTypeStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado (@paymentMethodTypeStatusId) es obligatorio (0 o 1).';
        RETURN;
    END;

    IF @paymentMethodTypeCreatorId <> 1 
       AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @paymentMethodTypeCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeName = TRIM(@paymentMethodTypeName))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de método de pago ya se encuentra registrado.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_PaymentMethodTypes] 
        (
            paymentMethodTypeName, 
            paymentMethodTypeDescription, 
            paymentMethodTypeCreatorId, 
            paymentMethodTypeCreationDate, 
            paymentMethodTypeStatusId
        )
        VALUES 
        (
            TRIM(@paymentMethodTypeName), 
            TRIM(@paymentMethodTypeDescription), 
            @paymentMethodTypeCreatorId, 
            GETDATE(), 
            @paymentMethodTypeStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de método de pago registrado correctamente.';
        
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

EXEC [SQM_CATALOGS].[sp_PaymentMethodTypes_Create]
    @paymentMethodTypeName = 'TARJETA REGALO',
    @paymentMethodTypeDescription = 'Pagos en línea mediante pasarela segura Visa/Mastercard',
    @paymentMethodTypeCreatorId = 1, 
    @paymentMethodTypeStatusId = 1,  
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MetodoPagoTypeIdGenerado;