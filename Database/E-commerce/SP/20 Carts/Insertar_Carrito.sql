USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_Create]
(
    @cartUserId INT,
    @cartCreatorId INT,
    @cartStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores inválidos
    IF @cartUserId IS NULL OR @cartUserId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario (@cartUserId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @cartCreatorId IS NULL OR @cartCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@cartCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @cartStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del carrito (@cartStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del usuario
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @cartUserId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @cartCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Regla de Negocio: Un usuario solo puede tener un carrito activo en el sistema
    DECLARE @ExistingCartId INT;
    SELECT @ExistingCartId = cartId 
    FROM [SQM_GENERAL].[Tbl_Carts] 
    WHERE cartUserId = @cartUserId AND cartStatusId = 1;

    IF @ExistingCartId IS NOT NULL AND @cartStatusId = 1
    BEGIN
        SET @o_code = 200;
        SET @o_message = 'El usuario ya cuenta con un carrito activo.';
        SET @o_templateId = @ExistingCartId; -- Devolvemos el ID del carrito existente
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_Carts] 
        (
            cartUserId, 
            cartCreatorId, 
            cartCreationDate, 
            cartStatusId
        )
        VALUES 
        (
            @cartUserId, 
            @cartCreatorId, 
            GETDATE(), 
            @cartStatusId
        );

        -- Obtener el ID del carrito recién creado
        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Carrito creado correctamente.';
    END TRY
    BEGIN CATCH
        -- Si hay una transacción activa, revertirla
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO

-- EJEMPLO DE PRUEBA / EJECUCIÓN

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_Carts_Create]
    @cartUserId = 1, 
    @cartCreatorId = 1,
    @cartStatusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CartIdGenerado;
