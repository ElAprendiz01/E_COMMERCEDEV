USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_Update]
(
    @userId INT,
    @userFullName VARCHAR(100),
    @userEmail VARCHAR(80),
    @userPhoneNumber VARCHAR(20),
    @userModificatorId INT,
    @userStatusId INT,
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
    IF @userId IS NULL OR @userId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario (@userId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @userFullName IS NULL OR LTRIM(RTRIM(@userFullName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre completo (@userFullName) es obligatorio.';
        RETURN;
    END;

    IF @userEmail IS NULL OR LTRIM(RTRIM(@userEmail)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El correo electrónico (@userEmail) es obligatorio.';
        RETURN;
    END;

    IF @userModificatorId IS NULL OR @userModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@userModificatorId) es obligatorio.';
        RETURN;
    END;

    IF @userStatusId IS NULL OR @userStatusId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado (@userStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del usuario a editar y obtener su estado actual
    DECLARE @ExistingStatusId INT;
    SELECT @ExistingStatusId = userStatusId 
    FROM [SQM_SECURITY].[Tbl_Users] 
    WHERE userId = @userId;

    IF @ExistingStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado del registro: si está inactivo (userStatusId = 2) y no se fuerza la recuperación
    IF @ForzarRecuperacion = 0 AND @ExistingStatusId = 2
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario se encuentra inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    -- Validar existencia del estado en Tbl_Status
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Status] WHERE statusId = @userStatusId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado especificado no existe.';
        RETURN;
    END;

    -- Validar unicidad del correo electrónico excluyendo al usuario actual
    IF EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userEmail = TRIM(@userEmail) AND userId <> @userId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El correo electrónico ya se encuentra registrado por otro usuario.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_SECURITY].[Tbl_Users]
        SET userFullName = TRIM(@userFullName),
            userEmail = TRIM(@userEmail),
            userPhoneNumber = TRIM(@userPhoneNumber),
            userModificatorId = @userModificatorId,
            userModificationDate = GETDATE(),
            userStatusId = @userStatusId
        WHERE userId = @userId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Usuario actualizado correctamente.';
        SET @o_templateId = @userId;
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
--prueba

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_SECURITY].[sp_Users_Update]
    @userId = 1, 
    @userFullName = 'HECTOR JOSE CALERO ALANIZ',
    @userEmail = 'hcalero@udem.edu.ni',
    @userPhoneNumber = '88887777',
    @userModificatorId = 1,
    @userStatusId = 1, -- ACTIVO
    @ForzarRecuperacion = 0,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS UsuarioIdModificado;


	select * from [SQM_SECURITY].[Tbl_Users]