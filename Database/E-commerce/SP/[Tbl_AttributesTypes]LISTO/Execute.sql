USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_AttributesTypes_Create]
    @attributeTypeName = 'Especificación Técnica',
    @attributeTypeDescription = 'Atributos relacionados con hardware y software',
    @attributeTypeCreatorId = 1,
    @attributeTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_CATALOGS].[sp_AttributesTypes_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_AttributesTypes_Update]
    @attributeTypeId = 2,
    @attributeTypeName = 'Especificaciones Técnicas',
    @attributeTypeDescription = 'Atributos de hardware y software actualizados',
    @attributeTypeModificatorId = 1,
    @attributeTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_AttributesTypes_Delete]
    @attributeTypeId = 2,
    @attributeTypeModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_AttributesTypes_Filter]
    @attributeTypeName = 'Especificación';
