USE [DB_ECOMMERCE]
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Segments_Delete]
(
    @segmentId INT,
    @segmentModificatorId INT,
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

    IF @segmentModificatorId IS NULL OR @segmentModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@segmentModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo del segmento
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

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El segmento ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    -- Validar existencia y estado activo del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @segmentModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional para la inactivación
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Segments]
        SET segmentStatusId = 0,
            segmentModificatorId = @segmentModificatorId,
            segmentModificationDate = GETDATE()
        WHERE segmentId = @segmentId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Segmento inactivado (eliminado) correctamente.';
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

EXEC [SQM_CATALOGS].[sp_Segments_Delete]
    @segmentId = 9,
    @segmentModificatorId = 1,
    @o_code = @o_code OUTPUT,
    @o_message = @o_message OUTPUT,
    @o_templateId = @o_templateId OUTPUT;

SELECT 
    @o_code AS [Código Respuesta], 
    @o_message AS [Mensaje del SP], 
    @o_templateId AS [ID Inactivado];
GO
