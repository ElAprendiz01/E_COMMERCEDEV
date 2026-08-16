USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Update]
(
    @productVariableTypeId INT,
    @productVariableTypeName VARCHAR(50),
    @productVariableTypeDescription VARCHAR(100),
    @productVariableTypeModificatorId INT,
    @productVariableTypeStatusId BIT,
    @ForzarRecuperacion BIT = 0,
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

    IF @productVariableTypeName IS NULL OR LTRIM(RTRIM(@productVariableTypeName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre es obligatorio.';
        RETURN;
    END;

    IF @productVariableTypeDescription IS NULL OR LTRIM(RTRIM(@productVariableTypeDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción es obligatoria.';
        RETURN;
    END;

    IF @productVariableTypeModificatorId IS NULL OR @productVariableTypeModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableTypeStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeId = @productVariableTypeId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable especificado no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableTypeModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF @ForzarRecuperacion = 0 AND EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeId = @productVariableTypeId AND productVariableTypeStatusId = 0)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable está inactivo. Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeName = TRIM(@productVariableTypeName) AND productVariableTypeStatusId = 1 AND productVariableTypeId <> @productVariableTypeId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro tipo de variable activo con este nombre.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
        SET productVariableTypeName = TRIM(@productVariableTypeName),
            productVariableTypeDescription = TRIM(@productVariableTypeDescription),
            productVariableTypeModificatorId = @productVariableTypeModificatorId,
            productVariableTypeModificationDate = GETDATE(),
            productVariableTypeStatusId = @productVariableTypeStatusId
        WHERE productVariableTypeId = @productVariableTypeId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de variable actualizado correctamente.';
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