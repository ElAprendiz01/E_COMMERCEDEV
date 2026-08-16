USE DB_ECOMMERCE
GO

-- CREAR
USE DB_ECOMMERCE
GO

DECLARE @code INT, @msg NVARCHAR(255), @newId INT;

EXEC [SQM_GENERAL].[sp_AttributeProductVariables_Create]
    @attributeProductVariableProductVariableId = 33,
    @attributeProductVariableAttributeProductId = 1,
    @attributeProductVariableValue = N'Pantalla Táctil',
    @attributeProductVariableCreatorId = 1,
    @attributeProductVariableStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @newId OUTPUT;

SELECT @code AS Code, @msg AS Message, @newId AS NewId;

--LISTAR
EXEC [SQM_GENERAL].[sp_AttributeProductVariables_List];
GO

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_AttributeProductVariables_Update]
    @attributeProductVariableId = 1,
    @attributeProductVariableProductVariableId = 33,
    @attributeProductVariableAttributeProductId = 1,
    @attributeProductVariableValue = N'Pantalla Táctil - Full HD',
    @attributeProductVariableModificatorId = 1,
    @attributeProductVariableStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_AttributeProductVariables_Delete]
    @attributeProductVariableId = 1,
    @attributeProductVariableModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_GENERAL].[sp_AttributeProductVariables_Filter]
    @attributeProductVariableValue = 'Pantalla';