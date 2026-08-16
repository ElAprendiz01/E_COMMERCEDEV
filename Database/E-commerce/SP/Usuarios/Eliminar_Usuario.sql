USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_Delete]
(
    @userId INT,
    @userModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StatusIdEliminado INT = NULL;

    -- 1. Validaciones preliminares de nulidad o valores vacíos
    IF @userId IS NULL OR @userId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del usuario a eliminar (@userId) es obligatorio.';
        RETURN;
    END;

    IF @userModificatorId IS NULL OR @userModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del usuario modificador (@userModificatorId) es obligatorio.';
        RETURN;
    END;

    -- 2. Validar que el usuario modificador exista y esté activo (Se permite ID 1 para bootstrap/sistema)
    IF @userModificatorId <> 1 AND NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userModificatorId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe.';
        RETURN;
    END;

    -- 3. Validar existencia del usuario a eliminar
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario que intenta eliminar no existe.';
        RETURN;
    END;

    -- 4. Búsqueda dinámica del estado de eliminación en [SQM_CATALOGS].[Tbl_Status]
    SELECT TOP 1 @StatusIdEliminado = statusId
    FROM [SQM_CATALOGS].[Tbl_Status]
    WHERE statusName LIKE '%eliminado%' 
       OR statusName LIKE '%inactivo%' 
       OR statusName LIKE '%desactivado%'
       OR statusName LIKE '%deleted%'
    ORDER BY statusId ASC;

    -- 5. Si no se encuentra ningún estado relacionado, lo insertamos automáticamente
    IF @StatusIdEliminado IS NULL
    BEGIN
        BEGIN TRY
            INSERT INTO [SQM_CATALOGS].[Tbl_Status] (statusName, statusCreatorId, statusCreationDate, statusStatusId)
            VALUES ('ELIMINADO', @userModificatorId, GETDATE(), 1);

            SET @StatusIdEliminado = SCOPE_IDENTITY();
        END TRY
        BEGIN CATCH
            SET @o_code = ERROR_NUMBER();
            SET @o_message = 'Error al crear dinámicamente el estado en el catálogo: ' + ERROR_MESSAGE();
            RETURN;
        END CATCH;
    END;

    -- 6. Validar si el usuario YA se encuentra en ese estado de eliminación
    IF EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userId AND userStatusId = @StatusIdEliminado)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario ya se encuentra en estado eliminado.';
        RETURN;
    END;

    -- Bloque transaccional para aplicar el borrado lógico
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_SECURITY].[Tbl_Users]
        SET 
            userStatusId = @StatusIdEliminado, 
            userModificatorId = @userModificatorId, 
            userModificationDate = GETDATE()
        WHERE userId = @userId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Usuario eliminado  correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH;
END;
GO


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);

EXEC [SQM_SECURITY].[sp_Users_Delete]
    @userId = 3,                 
    @userModificatorId = 1,      
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado;
GO

select * from [SQM_SECURITY].[Tbl_Users]