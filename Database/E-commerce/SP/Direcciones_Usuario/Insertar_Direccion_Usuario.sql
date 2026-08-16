USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserAddress_Create]
(
    @userAddressUserId INT,
    @userAddressCountryId INT,
    @userAddressZIPCode INT,
    @userAddressDescription NVARCHAR(500),
    @userAddressIsPrincipal BIT,
    @userAddressCreatorId INT,
    @userAddressStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @userAddressUserId IS NULL OR @userAddressUserId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del usuario (@userAddressUserId) es obligatorio.';
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

    IF @userAddressCreatorId IS NULL OR @userAddressCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@userAddressCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @userAddressStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la dirección (@userAddressStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del usuario y creador activos (userStatusId = 1)
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userAddressUserId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userAddressCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
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
            WHERE userAddressUserId = @userAddressUserId;
        END;

        INSERT INTO [SQM_GENERAL].[Tbl_UserAddress]
        (
            userAddressUserId, 
            userAddressCountryId, 
            userAddressZIPCode, 
            userAddressDescription, 
            userAddressIsPrincipal, 
            userAddressCreatorId, 
            userAddressCreationDate, 
            userAddressStatusId
        )
        VALUES
        (
            @userAddressUserId, 
            @userAddressCountryId, 
            @userAddressZIPCode, 
            TRIM(@userAddressDescription), 
            @userAddressIsPrincipal, 
            @userAddressCreatorId, 
            GETDATE(), 
            @userAddressStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Dirección de usuario creada correctamente.';
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


-- prueba

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_UserAddress_Create]
    @userAddressUserId = 1,
    @userAddressCountryId = 1,
    @userAddressZIPCode = 12001,
    @userAddressDescription = 'De la rotonda Centroamérica 2 cuadras al norte, Managua',
    @userAddressIsPrincipal = 1,
    @userAddressCreatorId = 1,
    @userAddressStatusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AddressIdGenerada;


	select * from [SQM_GENERAL].[Tbl_UserAddress]
