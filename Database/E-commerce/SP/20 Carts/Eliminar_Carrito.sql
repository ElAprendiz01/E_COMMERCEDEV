USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_Delete]
(
    @cartId INT,
    @cartModificatorId INT,
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

    IF @cartModificatorId IS NULL OR @cartModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@cartModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia del carrito y que no esté ya inactivado
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = cartStatusId 
    FROM [SQM_GENERAL].[Tbl_Carts] 
    WHERE cartId = @cartId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El carrito especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El carrito ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @cartModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para el borrado lógico
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_Carts]
        SET cartStatusId = 0, -- Inactivo / Eliminado lógicamente
            cartModificatorId = @cartModificatorId,
            cartModificationDate = GETDATE()
        WHERE cartId = @cartId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Carrito inactivado (eliminado lógicamente) correctamente.';
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

EXEC [SQM_GENERAL].[sp_Carts_Delete]
    @cartId = 1, -- Asegúrese de usar un ID existente en Tbl_Carts
    @cartModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CartIdInactivado;


SELECT * FROM [SQM_GENERAL].[Tbl_Carts]