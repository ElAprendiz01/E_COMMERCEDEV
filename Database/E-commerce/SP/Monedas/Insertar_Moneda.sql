USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Currencies_Create]
(
    @currencyName VARCHAR(50),
    @currencyISO CHAR(5),
    @currencyCode INT,
    @currencyDescription VARCHAR(100),
    @currencyCreatorId INT,
    @currencyStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
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

    IF @currencyCreatorId IS NULL OR @currencyCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@currencyCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @currencyStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la moneda (@currencyStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @currencyCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad de Nombre, ISO y Código entre monedas activas
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] WHERE currencyName = TRIM(@currencyName) AND currencyStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una moneda activa con este nombre.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] WHERE currencyISO = TRIM(@currencyISO) AND currencyStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una moneda activa con este código ISO.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies] WHERE currencyCode = @currencyCode AND currencyStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una moneda activa con este código numérico.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_Currencies] 
        (
            currencyName, 
            currencyISO, 
            currencyCode, 
            currencyDescription, 
            currencyCreatorId, 
            currencyCreationDate, 
            currencyStatusId
        )
        VALUES 
        (
            TRIM(@currencyName), 
            UPPER(TRIM(@currencyISO)), 
            @currencyCode, 
            TRIM(@currencyDescription), 
            @currencyCreatorId, 
            GETDATE(), 
            @currencyStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Moneda creada correctamente.';
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

EXEC [SQM_CATALOGS].[sp_Currencies_Create]
    @currencyName = 'Euro',
    @currencyISO = 'EUR',
    @currencyCode = 978,
    @currencyDescription = 'Moneda oficial de Europa',
    @currencyCreatorId = 1,
    @currencyStatusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MonedaIdGenerada;


	select * from  [SQM_CATALOGS].[Tbl_Currencies]