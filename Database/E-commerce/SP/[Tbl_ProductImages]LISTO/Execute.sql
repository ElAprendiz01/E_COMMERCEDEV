USE DB_ECOMMERCE;
GO

-- Crear
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 15,
    @productImageURL = 'https://mi-cdn.com/images/laptop-gamer.jpg',
    @productImageDescription = 'Laptop Gamer con 32GB RAM y 2TB SSD',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Listar
EXEC [SQM_GENERAL].[sp_ProductImages_List];

-- Actualizar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_ProductImages_Update]
    @productImageId = 1,
    @productImageProductId = 15,
    @productImageURL = 'https://mi-cdn.com/images/laptop-gamer-v2.jpg',
    @productImageDescription = 'Laptop Gamer con pantalla 4K',
    @productImageIsPrincipal = 1,
    @productImageModificatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Eliminar
DECLARE @code INT, @msg NVARCHAR(255), @templateId INT;

EXEC [SQM_GENERAL].[sp_ProductImages_Delete]
    @productImageId = 1,
    @productImageModificatorId = 1,
    @o_code = @code OUTPUT,
    @o_message = @msg OUTPUT,
    @o_templateId = @templateId OUTPUT;

SELECT @code AS Code, @msg AS Message, @templateId AS TemplateId;

-- Filtrar
EXEC [SQM_GENERAL].[sp_ProductImages_Filter]
    @productImageProductId = 15,
    @productImageIsPrincipal = 1;
