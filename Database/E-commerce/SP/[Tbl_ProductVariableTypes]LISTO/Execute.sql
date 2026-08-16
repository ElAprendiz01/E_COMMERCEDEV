USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductVariableTypes_Create]
    @productVariableTypeName = 'Colores',
    @productVariableTypeDescription = 'Tipo de variable para colores',
    @productVariableTypeCreatorId = 1,
    @productVariableTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_CATALOGS].[sp_ProductVariableTypes_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductVariableTypes_Update]
    @productVariableTypeId = 2,
    @productVariableTypeName = 'Tono',
    @productVariableTypeDescription = 'Variable para tonos de color',
    @productVariableTypeModificatorId = 1,
    @productVariableTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductVariableTypes_Delete]
    @productVariableTypeId = 2,
    @productVariableTypeModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_ProductVariableTypes_Filter]
    @productVariableTypeName = 'Color',
    @productVariableTypeStatusId = 1;