USE [DB_EcommerceAgent]
GO

-- Pruebas de Reemplazo de Etiquetas de Texto
DECLARE @TEXTO1 VARCHAR(200) = '¡Buenas noticias! Sí tenemos disponible. Puedes ver los detalles, precio y fotos directamente aquí [ENLACE]'
DECLARE @TEXTO2 VARCHAR(50) = 'https://amazon.com'

SELECT REPLACE(@TEXTO1, '[ENLACE]', @TEXTO2) AS TextoProcesado;


-- Simulación de captura de procedimientos almacenados remotos
DECLARE @Code INT, @Message VARCHAR(255), @TemplateId INT

DECLARE @TABLA AS TABLE(
	categoryId INT,
	categoryName VARCHAR(50),
	categoryDescription VARCHAR(100)
)

-- Intenta capturar el listado ejecutado en la otra base de datos
-- (este esta en la carpeta de sp de cahtbot pero pertence a  USP_CATEGORIES  en DB_ECOMMERCE)

INSERT INTO @TABLA (categoryId, categoryName, categoryDescription)
EXEC DB_ECOMMERCE..USP_CATEGORIES
    @w_methodType = 'LIST',
    @o_code = @Code OUT,
    @o_message = @Message OUT,
    @o_templateId = @TemplateId OUT

SELECT categoryName FROM @TABLA
PRINT 'Code: ' + CAST(@Code AS VARCHAR)
PRINT 'Message: ' + @Message

GO