USE [DB_ECOMMERCE]
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Marks_Create]
(
    @markName VARCHAR(50),
    @markDescription VARCHAR(100),
    @markCreatorId INT,
    @markStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares de nulidad o valores vacíos
    IF @markName IS NULL OR LTRIM(RTRIM(@markName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre de la marca (@markName) es obligatorio.';
        RETURN;
    END;

    IF @markCreatorId IS NULL OR @markCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@markCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @markStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la marca (@markStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @markCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar unicidad: no permitir duplicados de marcas activas
    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE markName = TRIM(@markName) AND markStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe una marca activa con este nombre.';
        RETURN;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_Marks] 
        (
            markName, 
            markDescription, 
            markCreatorId, 
            markCreationDate, 
            markStatusId
        )
        VALUES 
        (
            TRIM(@markName), 
            TRIM(@markDescription), 
            @markCreatorId, 
            GETDATE(), 
            @markStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Marca creada correctamente.';
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


-- EJECUCIÓN


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_CATALOGS].[sp_Marks_Create]
    @markName = 'puma',
    @markDescription = 'Marca de calzado y ropa deportiva Puma',
    @markCreatorId = 1,
    @markStatusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS MarcaIdGenerada;
