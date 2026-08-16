USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Providers_Create]
(
    @providerName VARCHAR(50),
    @providerDescription VARCHAR(100),
    @providerCreatorId INT,
    @providerStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @providerName IS NULL OR LTRIM(RTRIM(@providerName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del proveedor (@providerName) es obligatorio.';
        RETURN;
    END;

    IF @providerCreatorId IS NULL OR @providerCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@providerCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @providerStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del proveedor (@providerStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @providerCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad (evitar duplicados de proveedores activos con el mismo nombre)
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers] WHERE providerName = TRIM(@providerName) AND providerStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un proveedor activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_Providers]
        (
            providerName,
            providerDescription,
            providerCreatorId,
            providerCreationDate,
            providerStatusId
        )
        VALUES
        (
            TRIM(@providerName),
            TRIM(@providerDescription),
            @providerCreatorId,
            GETDATE(),
            @providerStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Proveedor creado correctamente.';
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


DECLARE @o_code INT;
DECLARE @o_message VARCHAR(255);
DECLARE @o_templateId INT;

EXEC [SQM_CATALOGS].[sp_Providers_Create]
    @providerName = 'Proveedor Global Tech',
    @providerDescription = 'Distribuidor mayorista de tecnología y componentes de hardware.',
    @providerCreatorId = 1,
    @providerStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Generado];
GO


select * from [SQM_CATALOGS].[Tbl_Providers]