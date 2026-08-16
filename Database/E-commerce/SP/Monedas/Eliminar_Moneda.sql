USE [DB_ECOMMERCE]
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Currencies_Delete]
(
    @currencyId INT,
    @currencyModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores inválidos
    IF @currencyId IS NULL OR @currencyId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la moneda (@currencyId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @currencyModificatorId IS NULL OR @currencyModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@currencyModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia de la moneda y que no esté ya inactivada
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = currencyStatusId 
    FROM [SQM_CATALOGS].[Tbl_Currencies] 
    WHERE currencyId = @currencyId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda especificada no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda ya se encuentra inactiva (eliminada).';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @currencyModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Currencies] 
        SET currencyStatusId = 0, -- Inactivado lógicamente
            currencyModificatorId = @currencyModificatorId, 
            currencyModificationDate = GETDATE() 
        WHERE currencyId = @currencyId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda eliminada correctamente.';
        SET @o_templateId = @currencyId;
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

EXEC [SQM_CATALOGS].[sp_Currencies_Delete]
    @currencyId = 3,
    @currencyModificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdInactivada;

