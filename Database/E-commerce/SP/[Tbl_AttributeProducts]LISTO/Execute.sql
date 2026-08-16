USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg VARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_AttributeProducts_Create]
    @AttributeProductAttributesTypeId = 2,
    @AttributeProductName = 'Color',
    @AttributeProductDescription = 'Atributo para definir colores',
    @AttributeProductCreatorId = 1,
    @AttributeProductStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;


-- Listar
EXEC [SQM_CATALOGS].[sp_AttributeProducts_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(400), @templateId INT;

EXEC SQM_CATALOGS.sp_AttributeProducts_Update
    @AttributeProductId = 7,
    @AttributeProductAttributesTypeId = 2,
    @AttributeProductName = N'Tono',
    @AttributeProductDescription = N'Tono de color para productos',
    @AttributeProductModificatorId = 1,
    @AttributeProductStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg VARCHAR(255), @templateId INT;

EXEC SQM_CATALOGS.sp_AttributeProducts_Delete
    @AttributeProductId = 7,
    @AttributeProductModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_AttributeProducts_Filter]
    @AttributeProductName = 'Color';