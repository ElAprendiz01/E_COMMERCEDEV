USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_StockMovementTypes_Create]
    @stockMovementTypeName = 'Entrada por compra',
    @stockMovementTypeDescription = 'Movimiento de stock por adquisición de productos',
    @stockMovementTypeCreatorId = 1,
    @stockMovementTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXECUTE [SQM_CATALOGS].[sp_StockMovementTypes_List]

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_StockMovementTypes_Update]
    @stockMovementTypeId = 2,
    @stockMovementTypeName = 'ENTRADA POR DEVOLUCIÓN',
    @stockMovementTypeDescription = 'Movimiento de stock por devolución de productos',
    @stockMovementTypeModificatorId = 1,
    @stockMovementTypeStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_CATALOGS].[sp_StockMovementTypes_Delete]
    @stockMovementTypeId = 4,
    @stockMovementTypeModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_CATALOGS].[sp_StockMovementTypes_Filter]
    @stockMovementTypeName = 'Entrada',
    @stockMovementTypeStatusId = 1;