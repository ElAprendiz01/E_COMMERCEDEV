USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_AttributeProducts_Update]
(
    @AttributeProductId INT,
    @AttributeProductAttributesTypeId INT,
    @AttributeProductName VARCHAR(50),
    @AttributeProductDescription VARCHAR(100),
    @AttributeProductModificatorId INT,
    @AttributeProductStatusId BIT,
    @ForzarRecuperacion BIT = 0,
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

    IF @AttributeProductName IS NULL OR LTRIM(RTRIM(@AttributeProductName)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El nombre del atributo (@AttributeProductName) es obligatorio.';
        RETURN;
    END;

    IF @AttributeProductDescription IS NULL OR LTRIM(RTRIM(@AttributeProductDescription)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La descripción (@AttributeProductDescription) es obligatoria.';
        RETURN;
    END;

    IF @AttributeProductAttributesTypeId IS NULL OR @AttributeProductAttributesTypeId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del tipo de atributo (@AttributeProductAttributesTypeId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @AttributeProductModificatorId IS NULL OR @AttributeProductModificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@AttributeProductModificatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @AttributeProductStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado (@AttributeProductStatusId) es obligatorio.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts] WHERE AttributeProductId = @AttributeProductId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El atributo especificado no existe.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @AttributeProductModificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario modificador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributesTypes] WHERE attributeTypeId = @AttributeProductAttributesTypeId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de atributo especificado no existe.';
        RETURN;
    END;

    IF @ForzarRecuperacion = 0 AND EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts] WHERE AttributeProductId = @AttributeProductId AND AttributeProductStatusId = 0)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El atributo está inactivo (eliminado). Active ForzarRecuperacion = 1 si desea actualizarlo.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts] WHERE AttributeProductName = TRIM(@AttributeProductName) AND AttributeProductStatusId = 1 AND AttributeProductId <> @AttributeProductId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Ya existe otro atributo activo con este nombre.';
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
        SET AttributeProductAttributesTypeId = @AttributeProductAttributesTypeId,
            AttributeProductName = TRIM(@AttributeProductName),
            AttributeProductDescription = TRIM(@AttributeProductDescription),
            AttributeProductModificatorId = @AttributeProductModificatorId,
            AttributeProductModificationDate = GETDATE(),
            AttributeProductStatusId = @AttributeProductStatusId
        WHERE AttributeProductId = @AttributeProductId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Atributo actualizado correctamente.';
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