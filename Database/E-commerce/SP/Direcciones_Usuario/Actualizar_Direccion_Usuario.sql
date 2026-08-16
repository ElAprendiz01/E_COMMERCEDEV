USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserAddress_Update]
(
    @userAddressId INT,
    @userAddressCountryId INT,
    @userAddressZIPCode INT,
    @userAddressDescription NVARCHAR(500),
    @userAddressIsPrincipal BIT,
    @userAddressModificatorId INT,
    @userAddressStatusId BIT,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @userAddressId IS NULL OR @userAddressId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la dirección (@userAddressId) es obligatorio.';
        RETURN;
    END;

    IF @userAddressCountryId IS NULL OR @userAddressCountryId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del país (@userAddressCountryId) es obligatorio.';
        RETURN;
    END;

    IF @userAddressZIPCode IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El código postal (@userAddressZIPCode) es obligatorio.';
        RETURN;
    END;

    IF @userAddressDescription IS NULL OR LTRIM(RTRIM(@userAddressDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción de la dirección (@userAddressDescription) es obligatoria.';
        RETURN;
    END;

    IF @userAddressModificatorId IS NULL OR @userAddressModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@userAddressModificatorId) es obligatorio.';
        RETURN;
    END;

    IF @userAddressStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la dirección (@userAddressStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la dirección y obtener el ID del usuario asociado
    DECLARE @UserId INT;
    DECLARE @ExistingStatus BIT;
    SELECT @UserId = userAddressUserId, 
           @ExistingStatus = userAddressStatusId 
    FROM [SQM_GENERAL].[Tbl_UserAddress] 
    WHERE userAddressId = @userAddressId;

    IF @UserId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección especificada no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userAddressModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado del registro: si está eliminado (statusId = 0) y no se fuerza la recuperación
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección está inactiva (eliminada). Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Bloque transaccional
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Si se define como principal, desactivar bandera principal de las demás direcciones del usuario
        IF @userAddressIsPrincipal = 1
        BEGIN
            UPDATE [SQM_GENERAL].[Tbl_UserAddress] 
            SET userAddressIsPrincipal = 0 
            WHERE userAddressUserId = @UserId;
        END;

        UPDATE [SQM_GENERAL].[Tbl_UserAddress]
        SET userAddressCountryId = @userAddressCountryId,
            userAddressZIPCode = @userAddressZIPCode,
            userAddressDescription = TRIM(@userAddressDescription),
            userAddressIsPrincipal = @userAddressIsPrincipal,
            userAddressModificatorId = @userAddressModificatorId,
            userAddressModificationDate = GETDATE(),
            userAddressStatusId = @userAddressStatusId
        WHERE userAddressId = @userAddressId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Dirección de usuario actualizada correctamente.';
        SET @o_templateId = @userAddressId;
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


--  PRUEBA 

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_UserAddress_Update]
    @userAddressId = 4, 
    @userAddressCountryId = 1,
    @userAddressZIPCode = 12002,
    @userAddressDescription = 'De los semáforos de la UCA 1 cuadra al este, Managua',
    @userAddressIsPrincipal = 1,
    @userAddressModificatorId = 1,
    @userAddressStatusId = 1,
    @ForzarRecuperacion = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AddressIdModificada;


select * from [SQM_GENERAL].[Tbl_UserAddress]