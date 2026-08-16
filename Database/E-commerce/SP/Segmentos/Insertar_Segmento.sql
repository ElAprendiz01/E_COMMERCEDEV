USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Segments_Create]
(
    @segmentName VARCHAR(50),
    @segmentDescription VARCHAR(100),
    @segmentCreatorId INT,
    @segmentStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @segmentName IS NULL OR LTRIM(RTRIM(@segmentName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del segmento (@segmentName) es obligatorio.';
        RETURN;
    END;

    IF @segmentCreatorId IS NULL OR @segmentCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@segmentCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @segmentStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del segmento (@segmentStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @segmentCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad (evitar duplicados de segmentos activos con el mismo nombre)
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] WHERE segmentName = TRIM(@segmentName) AND segmentStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un segmento activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_Segments]
        (
            segmentName,
            segmentDescription,
            segmentCreatorId,
            segmentCreationDate,
            segmentStatusId
        )
        VALUES
        (
            TRIM(@segmentName),
            TRIM(@segmentDescription),
            @segmentCreatorId,
            GETDATE(),
            @segmentStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Segmento creado correctamente.';
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

EXEC [SQM_CATALOGS].[sp_Segments_Create]
    @segmentName = 'Tecnología Premium',
    @segmentDescription = 'Segmento enfocado en productos de gama alta y corporativos.',
    @segmentCreatorId = 1,
    @segmentStatusId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Generado];
GO
select * from [SQM_CATALOGS].[Tbl_Segments]