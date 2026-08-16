USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Delete]
(
    @AttributeProductId INT,
    @AttributeProductModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @AttributeProductId IS NULL OR @AttributeProductId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del atributo (@AttributeProductId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @AttributeProductModificatorId IS NULL OR @AttributeProductModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@AttributeProductModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = AttributeProductStatusId
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
    WHERE AttributeProductId = @AttributeProductId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El atributo especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El atributo ya se encuentra inactivo (eliminado).';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @AttributeProductModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
        SET AttributeProductStatusId = 0,
            AttributeProductModificatorId = @AttributeProductModificatorId,
            AttributeProductModificationDate = GETDATE()
        WHERE AttributeProductId = @AttributeProductId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Atributo inactivado (eliminado) correctamente.';
        SET @o_templateId = @AttributeProductId;
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