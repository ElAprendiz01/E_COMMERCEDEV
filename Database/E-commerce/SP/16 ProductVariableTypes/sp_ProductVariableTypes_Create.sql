USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_ProductVariableTypes_Create]
(
    @productVariableTypeName VARCHAR(50),
    @productVariableTypeDescription VARCHAR(100),
    @productVariableTypeCreatorId INT,
    @productVariableTypeStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

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

    IF @productVariableTypeCreatorId IS NULL OR @productVariableTypeCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @productVariableTypeStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @productVariableTypeCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeName = TRIM(@productVariableTypeName) AND productVariableTypeStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un tipo de variable activo con este nombre.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_CATALOGS].[Tbl_ProductVariableTypes]
        (
            productVariableTypeName,
            productVariableTypeDescription,
            productVariableTypeCreatorId,
            productVariableTypeCreationDate,
            productVariableTypeStatusId
        )
        VALUES
        (
            TRIM(@productVariableTypeName),
            TRIM(@productVariableTypeDescription),
            @productVariableTypeCreatorId,
            GETDATE(),
            @productVariableTypeStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Tipo de variable creado correctamente.';
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