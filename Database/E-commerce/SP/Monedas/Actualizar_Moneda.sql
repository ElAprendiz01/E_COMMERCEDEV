USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Currencies_Update]
(
    @currencyId INT,
    @currencyName VARCHAR(50),
    @currencyISO CHAR(5),
    @currencyCode INT,
    @currencyDescription VARCHAR(100),
    @currencyModificatorId INT,
    @currencyStatusId BIT,
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
    IF @currencyId IS NULL OR @currencyId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la moneda (@currencyId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @currencyName IS NULL OR LTRIM(RTRIM(@currencyName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la moneda (@currencyName) es obligatorio.';
        RETURN;
    END;

    IF @currencyISO IS NULL OR LTRIM(RTRIM(@currencyISO)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El código ISO (@currencyISO) es obligatorio.';
        RETURN;
    END;

    IF @currencyCode IS NULL OR @currencyCode <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El código numérico (@currencyCode) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @currencyModificatorId IS NULL OR @currencyModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@currencyModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @currencyStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la moneda (@currencyStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la moneda
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

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @currencyModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado del registro: si está inactiva y no se fuerza la recuperación
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La moneda está inactiva (eliminada). Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Validar unicidad de Nombre, ISO y Código entre otras monedas activas
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] 
        WHERE currencyName = TRIM(@currencyName) AND currencyStatusId = 1 AND currencyId <> @currencyId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra moneda activa con este nombre.';
        RETURN;
    END;

    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] 
        WHERE currencyISO = TRIM(@currencyISO) AND currencyStatusId = 1 AND currencyId <> @currencyId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra moneda activa con este código ISO.';
        RETURN;
    END;

    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] 
        WHERE currencyCode = @currencyCode AND currencyStatusId = 1 AND currencyId <> @currencyId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra moneda activa con este código numérico.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Currencies] 
        SET currencyName = TRIM(@currencyName), 
            currencyISO = UPPER(TRIM(@currencyISO)), 
            currencyCode = @currencyCode, 
            currencyDescription = TRIM(@currencyDescription), 
            currencyModificatorId = @currencyModificatorId, 
            currencyModificationDate = GETDATE(), 
            currencyStatusId = @currencyStatusId
        WHERE currencyId = @currencyId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda actualizada correctamente.';
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


-- EJEMPLO DE PRUEBA


declare @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_Currencies_Update]
    @currencyId = 2, -- Asegúrese de usar un ID existente en Tbl_Currencies
    @currencyName = 'Córdoba Oro',
    @currencyISO = 'NIO',
    @currencyCode = 558,
    @currencyDescription = 'Moneda nacional de Nicaragua',
    @currencyModificatorId = 1,
    @currencyStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdModificada;

