USE [DB_ECOMMERCE]
GO

-- 2. EDITAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Segments_Update]
(
    @segmentId INT,
    @segmentName VARCHAR(50),
    @segmentDescription VARCHAR(100),
    @segmentModificatorId INT,
    @segmentStatusId BIT,
    @ForzarRecuperacion BIT = 0,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @segmentId IS NULL OR @segmentId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del segmento (@segmentId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @segmentName IS NULL OR LTRIM(RTRIM(@segmentName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del segmento (@segmentName) es obligatorio.';
        RETURN;
    END;

    IF @segmentModificatorId IS NULL OR @segmentModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@segmentModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @segmentStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del segmento (@segmentStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia del segmento
    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = segmentStatusId
    FROM [SQM_CATALOGS].[Tbl_Segments]
    WHERE segmentId = @segmentId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El segmento especificado no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo del usuario modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @segmentModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado de inactividad previa del registro
    IF @ForzarRecuperacion = 0 AND @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El segmento está inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otros segmentos activos
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments]
        WHERE segmentName = TRIM(@segmentName)
          AND segmentStatusId = 1
          AND segmentId <> @segmentId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro segmento activo con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Segments]
        SET segmentName = TRIM(@segmentName),
            segmentDescription = TRIM(@segmentDescription),
            segmentModificatorId = @segmentModificatorId,
            segmentModificationDate = GETDATE(),
            segmentStatusId = @segmentStatusId
        WHERE segmentId = @segmentId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Segmento actualizado correctamente.';
        SET @o_templateId = @segmentId;
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

EXEC [SQM_CATALOGS].[sp_Segments_Update]
    @segmentId = 9,
    @segmentName = 'Tecnología Premium Plus',
    @segmentDescription = 'Segmento enfocado en productos de alta gama, corporativos y servidores.',
    @segmentModificatorId = 1,
    @segmentStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Modificado];
GO
