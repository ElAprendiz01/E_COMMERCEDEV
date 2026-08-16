USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_MarkByProviders_Create]
    @markByProviderMarkId = 1,
    @markByProviderProviderId = 2,
    @markByProviderCreatorId = 1,
    @markByProviderStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_CATALOGS].[sp_MarkByProviders_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_MarkByProviders_Update]
    @markByProviderId = 3,
    @markByProviderMarkId = 1,
    @markByProviderProviderId = 5,
    @markByProviderModificatorId = 1,
    @markByProviderStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_MarkByProviders_Delete]
    @markByProviderId = 3,
    @markByProviderModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_MarkByProviders_Filter]
    @markByProviderMarkId = 1;
