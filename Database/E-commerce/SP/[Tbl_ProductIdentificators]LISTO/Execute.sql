USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductIdentificators_Create]
    @productIdentificatorCategoryId = 1,
    @productIdentificatorSubCategoryId = 3,
    @productIdentificatorSegmentId = 2,
    @productIdentificatorCreatorId = 1,
    @productIdentificatorStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_CATALOGS].[sp_ProductIdentificators_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductIdentificators_Update]
    @productIdentificatorId = 10,
    @productIdentificatorCategoryId = 1,
    @productIdentificatorSubCategoryId = 3,
    @productIdentificatorSegmentId = 4,
    @productIdentificatorModificatorId = 1,
    @productIdentificatorStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_ProductIdentificators_Delete]
    @productIdentificatorId = 10,
    @productIdentificatorModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_ProductIdentificators_Filter]
    @productIdentificatorCategoryId = 1,
    @productIdentificatorStatusId = 1;