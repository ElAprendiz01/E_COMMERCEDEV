USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_Create]
(
    @userFullName VARCHAR(100),
    @userName VARCHAR(50),
    @userPasswordPlain VARCHAR(256),
    @userEmail VARCHAR(80),
    @userPhoneNumber VARCHAR(20),
    @userCountryId INT,
    @userGenderId INT,
    @userBirthDay DATE,
    @userCreatorId INT,
    @userStatusId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @userFullName IS NULL OR LTRIM(RTRIM(@userFullName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre completo (@userFullName) es obligatorio.';
        RETURN;
    END;

    IF @userName IS NULL OR LTRIM(RTRIM(@userName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de usuario (@userName) es obligatorio.';
        RETURN;
    END;

    IF @userPasswordPlain IS NULL OR LTRIM(RTRIM(@userPasswordPlain)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La contraseña (@userPasswordPlain) es obligatoria.';
        RETURN;
    END;

    IF @userEmail IS NULL OR LTRIM(RTRIM(@userEmail)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El correo electrónico (@userEmail) es obligatorio.';
        RETURN;
    END;

    IF @userBirthDay IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La fecha de nacimiento (@userBirthDay) es obligatoria.';
        RETURN;
    END;

    IF @userCreatorId IS NULL OR @userCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@userCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @userStatusId IS NULL OR @userStatusId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del usuario (@userStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar fecha de nacimiento: año > 1925
    IF YEAR(@userBirthDay) <= 1925
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La fecha de nacimiento no es válida. El año debe ser mayor a 1925.';
        RETURN;
    END;

    -- Validar que el usuario tenga al menos 12 años de edad
    IF @userBirthDay > DATEADD(YEAR, -12, GETDATE())
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario debe tener al menos 12 años de edad para registrarse.';
        RETURN;
    END;

    -- Validar existencia del creador (ID 1 se permite para el bootstrap inicial)
    IF @userCreatorId <> 1 AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia del estado del usuario en Tbl_Status
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Status] WHERE statusId = @userStatusId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de usuario especificado no existe.';
        RETURN;
    END;

    -- Validar unicidad del nombre de usuario (userName)
    IF EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userName = TRIM(@userName))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de usuario ya se encuentra registrado.';
        RETURN;
    END;

    -- Validar unicidad del correo electrónico (userEmail)
    IF EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userEmail = TRIM(@userEmail))
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El correo electrónico ya se encuentra registrado.';
        RETURN;
    END;

    -- Bloque transaccional con cifrado de contraseña
    DECLARE @UserPasswordEncrypted VARBINARY(256);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Abrir la llave simétrica para cifrar la contraseña
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

        SET @UserPasswordEncrypted = SQM_SECURITY.Fn_EncryptByKey(@userPasswordPlain);

        INSERT INTO [SQM_SECURITY].[Tbl_Users] 
        (
            userFullName, 
            userName, 
            userPassword, 
            userEmail, 
            userPhoneNumber, 
            userCountryId, 
            userGenderId, 
            userBirthDay, 
            userCreatorId, 
            userCreationDate, 
            userStatusId
        )
        VALUES 
        (
            TRIM(@userFullName), 
            TRIM(@userName), 
            @UserPasswordEncrypted, 
            TRIM(@userEmail), 
            TRIM(@userPhoneNumber), 
            @userCountryId, 
            @userGenderId, 
            @userBirthDay, 
            @userCreatorId, 
            GETDATE(), 
            @userStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        -- Cerrar la llave simétrica
        CLOSE SYMMETRIC KEY KEY_HASH;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Usuario creado correctamente.';
    END TRY
    BEGIN CATCH
        -- Asegurar el cierre de la llave y el rollback ante fallas
        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE key_name = 'KEY_HASH')
            CLOSE SYMMETRIC KEY KEY_HASH;

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO

-- Declaración y ejecución de ejemplo para pruebas

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_SECURITY].[sp_Users_Create]
    @userFullName = 'Duclis RAMON Zamora LOPEZ',
    @userName = 'Rduc',
    @userPasswordPlain = 'notedirelaclave',
    @userEmail = 'Dperez@dominio.local',
    @userPhoneNumber = '88889999',
    @userCountryId = 1,
    @userGenderId = 2,
    @userBirthDay = '1998-06-15',
    @userCreatorId = 1,
    @userStatusId = 1, -- ACTIVO
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS UsuarioIdGenerado;
