USE [DB_ECOMMERCE]
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Marks_Update]
(
    @markId INT,
    @markName VARCHAR(50),
    @markDescription VARCHAR(100),
    @markModificatorId INT,
    @markStatusId BIT,
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
    IF @markId IS NULL OR @markId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la marca (@markId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @markName IS NULL OR LTRIM(RTRIM(@markName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la marca (@markName) es obligatorio.';
        RETURN;
    END;

    IF @markModificatorId IS NULL OR @markModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@markModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @markStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la marca (@markStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia de la marca
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE markId = @markId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La marca especificada no existe.';
        RETURN;
    END;

    -- Validar existencia y estado activo (userStatusId = 1) del modificador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @markModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado del registro: si está inactiva y no se fuerza la recuperación
    IF @ForzarRecuperacion = 0 AND EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] 
        WHERE markId = @markId AND markStatusId = 0
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La marca está inactiva (eliminada). Active ForzarRecuperacion = 1 si desea actualizarla.';
        RETURN;
    END;

    -- Validar unicidad del nombre con otras marcas activas
    IF EXISTS (
        SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] 
        WHERE markName = TRIM(@markName) AND markStatusId = 1 AND markId <> @markId
    )
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otra marca activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la actualización
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_Marks] 
        SET markName = TRIM(@markName), 
            markDescription = TRIM(@markDescription), 
            markModificatorId = @markModificatorId, 
            markModificationDate = GETDATE(), 
            markStatusId = @markStatusId
        WHERE markId = @markId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Marca actualizada correctamente.';
        SET @o_templateId = @markId;
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


-- EJEMPLO 


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_Marks_Update]
    @markId = 69,
    @markName = 'ADIDAS ORIGINALS',
    @markDescription = 'Línea clásica de calzado y ropa deportiva Adidas',
    @markModificatorId = 1,
    @markStatusId = 1,
    @ForzarRecuperacion = 0,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MarcaIdModificada;


select * from [SQM_CATALOGS].[Tbl_Marks] 