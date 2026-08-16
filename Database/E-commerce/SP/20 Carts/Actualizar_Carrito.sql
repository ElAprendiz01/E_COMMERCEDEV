USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_Update]
(
    @cartId INT,
    @cartUserId INT,
    @cartModificatorId INT,
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
    IF @cartId IS NULL OR @cartId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del carrito (@cartId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @cartUserId IS NULL OR @cartUserId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario (@cartUserId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @cartModificatorId IS NULL OR @cartModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@cartModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @cartStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del carrito (@cartStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del carrito
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Carts] WHERE cartId = @cartId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El carrito especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @cartUserId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @cartModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Regla de Negocio: Si se activa este carrito, verificar que el usuario no tenga OTRO carrito activo
    IF @cartStatusId = 1 AND EXISTS (
        SELECT 1 FROM [SQM_GENERAL].[Tbl_Carts] 
        WHERE cartUserId = @cartUserId AND cartStatusId = 1 AND cartId <> @cartId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario ya cuenta con otro carrito activo en el sistema.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_Carts] 
        SET cartUserId = @cartUserId, 
            cartModificatorId = @cartModificatorId, 
            cartModificationDate = GETDATE(), 
            cartStatusId = @cartStatusId
        WHERE cartId = @cartId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Carrito actualizado correctamente.';
        SET @o_templateId = @cartId;
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


-- EJEMPLO DE PRUEBA / EJECUCIÓN

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_Carts_Update]
    @cartId = 1, 
    @cartUserId = 1,
    @cartModificatorId = 1,
    @cartStatusId = 1, -- Inactivando el carrito1
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CartIdModificado;


select * from [SQM_GENERAL].[Tbl_Carts]