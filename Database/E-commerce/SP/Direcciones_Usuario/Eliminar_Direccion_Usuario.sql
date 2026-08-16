USE [DB_ECOMMERCE]
GO

-- 3. ELIMINAR (BORRADO LÓGICO / INACTIVACIÓN) CON VALIDACIONES Y OUTPUTS
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_UserAddress_Delete]
(
    @userAddressId INT,
    @userAddressModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores inválidos
    IF @userAddressId IS NULL OR @userAddressId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la dirección (@userAddressId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @userAddressModificatorId IS NULL OR @userAddressModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@userAddressModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia de la dirección y que no esté ya inactivada
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = userAddressStatusId 
    FROM [SQM_GENERAL].[Tbl_UserAddress] 
    WHERE userAddressId = @userAddressId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección ya se encuentra inactiva (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userAddressModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_UserAddress]
        SET userAddressStatusId = 0, -- Inactivo / Eliminado lógicamente
            userAddressModificatorId = @userAddressModificatorId,
            userAddressModificationDate = GETDATE()
        WHERE userAddressId = @userAddressId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Dirección inactivada (eliminada lógicamente) correctamente.';
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


-- EJEMPLO DE PRUEBA / EJECUCIÓN


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_UserAddress_Delete]
    @userAddressId =55, 
    @userAddressModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS AddressIdInactivada;


select * from [SQM_GENERAL].[Tbl_UserAddress]
