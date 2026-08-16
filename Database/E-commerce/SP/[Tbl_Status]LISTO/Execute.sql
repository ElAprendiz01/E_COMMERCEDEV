USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_Status_Create]
    @statusName = 'ACTIVO',
    @statusCreatorId = 1,
    @statusStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_CATALOGS].[sp_Status_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_Status_Update]
    @statusId = 3,
    @statusName = 'SUSPENDIDO',
    @statusStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_Status_Delete]
    @statusId = 3,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_Status_Filter]
    @statusId = 3;