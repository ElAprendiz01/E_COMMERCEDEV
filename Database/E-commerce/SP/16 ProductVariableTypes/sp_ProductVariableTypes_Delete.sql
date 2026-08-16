USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Delete]
(
    @productVariableTypeId INT,
    @productVariableTypeModificatorId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @productVariableTypeId IS NULL OR @productVariableTypeId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de variable es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableTypeModificatorId IS NULL OR @productVariableTypeModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    DECLARE @ExistingStatus BIT;
    SELECT @ExistingStatus = productVariableTypeStatusId
    FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
    WHERE productVariableTypeId = @productVariableTypeId;

    IF @ExistingStatus IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable especificado no existe.';
        RETURN;
    END;

    IF @ExistingStatus = 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable ya se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableTypeModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
        SET productVariableTypeStatusId = 0,
            productVariableTypeModificatorId = @productVariableTypeModificatorId,
            productVariableTypeModificationDate = GETDATE()
        WHERE productVariableTypeId = @productVariableTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de variable inactivado correctamente.';
        SET @o_templateId = @productVariableTypeId;
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