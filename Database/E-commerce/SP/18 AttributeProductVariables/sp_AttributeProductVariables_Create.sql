USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_Create]
(
    @attributeProductVariableProductVariableId INT,
    @attributeProductVariableAttributeProductId INT,
    @attributeProductVariableValue VARCHAR(50),
    @attributeProductVariableCreatorId INT,
    @attributeProductVariableStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @attributeProductVariableProductVariableId IS NULL OR @attributeProductVariableProductVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variable de producto es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableAttributeProductId IS NULL OR @attributeProductVariableAttributeProductId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de variable (atributo) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableValue IS NULL OR LTRIM(RTRIM(@attributeProductVariableValue)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El valor es obligatorio.';
        RETURN;
    END;

    IF @attributeProductVariableCreatorId IS NULL OR @attributeProductVariableCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @attributeProductVariableStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @attributeProductVariableCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables] WHERE productVariableId = @attributeProductVariableProductVariableId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El registro de variable de producto padre no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes] WHERE productVariableTypeId = @attributeProductVariableAttributeProductId AND productVariableTypeStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de variable (atributo) no existe o está inactivo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId AND attributeProductVariableStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe un valor activo registrado para este tipo de variable en este producto.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_AttributeProductVariables]
        (
            attributeProductVariableProductVariableId,
            attributeProductVariableAttributeProductId,
            attributeProductVariableValue,
            attributeProductVariableCreatorId,
            attributeProductVariableCreationDate,
            attributeProductVariableStatusId
        )
        VALUES
        (
            @attributeProductVariableProductVariableId,
            @attributeProductVariableAttributeProductId,
            TRIM(@attributeProductVariableValue),
            @attributeProductVariableCreatorId,
            GETDATE(),
            @attributeProductVariableStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Atributo de variable creado correctamente.';
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

DECLARE @outCode INT;
DECLARE @outMessage VARCHAR(255);
DECLARE @outIdCreado INT;


EXEC [SQM_GENERAL].[sp_AttributeProductVariables_Create]
    @attributeProductVariableProductVariableId = 2,      
    @attributeProductVariableAttributeProductId = 2,   
    @attributeProductVariableValue = 'Rojo',            
    @attributeProductVariableCreatorId = 1,              
    @attributeProductVariableStatusId = 1,             

    -- Parámetros de salida con la palabra clave OUTPUT
    @o_code = @outCode OUTPUT,
    @o_message = @outMessage OUTPUT,
    @o_templateId = @outIdCreado OUTPUT;


	select * from [SQM_GENERAL].Tbl_Products


	select * from [SQM_GENERAL].[Tbl_AttributeProductVariables]