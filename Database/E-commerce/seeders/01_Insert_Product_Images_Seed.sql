USE [DB_ECOMMERCE]
GO

-- ============================================================================
-- SCRIPT DE INSERCIÓN DE IMÁGENES SEMILLA PARA PRODUCTOS (ENTORNO DE DESARROLLO)
-- Ejecuta el Stored Procedure [SQM_GENERAL].[sp_ProductImages_Create]
-- ============================================================================

DECLARE @code INT, @message VARCHAR(255), @templateId INT;


-- 2. Producto ID 6: Zapatillas Nike Air Max 2026
EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 6,
    @productImageURL = '/uploads/products/prod_6_airmax2026.jpg',
    @productImageDescription = 'Vista deportiva principal de Nike Air Max 2026',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @message OUTPUT,
    @o_templateId = @templateId OUTPUT;

PRINT 'Producto 6 -> Código: ' + CAST(@code AS VARCHAR) + ' | Mensaje: ' + @message + ' | ImageID: ' + ISNULL(CAST(@templateId AS VARCHAR), 'N/A');

-- 3. Producto ID 7: Zapatillas Nike Air Max 90 Casual v2
EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 7,
    @productImageURL = '/uploads/products/prod_7_airmax90v2.jpg',
    @productImageDescription = 'Vista urbana principal de Nike Air Max 90 Casual v2',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @message OUTPUT,
    @o_templateId = @templateId OUTPUT;

PRINT 'Producto 7 -> Código: ' + CAST(@code AS VARCHAR) + ' | Mensaje: ' + @message + ' | ImageID: ' + ISNULL(CAST(@templateId AS VARCHAR), 'N/A');

-- 4. Producto ID 53: Sony Xperia PRO-I
EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 53,
    @productImageURL = '/uploads/products/prod_53_xperiaproi.jpg',
    @productImageDescription = 'Vista frontal y posterior del Smartphone Sony Xperia PRO-I',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @message OUTPUT,
    @o_templateId = @templateId OUTPUT;

PRINT 'Producto 53 -> Código: ' + CAST(@code AS VARCHAR) + ' | Mensaje: ' + @message + ' | ImageID: ' + ISNULL(CAST(@templateId AS VARCHAR), 'N/A');

-- 5. Producto ID 54: Monitor Gaming Sony INZONE M9
EXEC [SQM_GENERAL].[sp_ProductImages_Create]
    @productImageProductId = 54,
    @productImageURL = '/uploads/products/prod_54_inzonem9.jpg',
    @productImageDescription = 'Vista frontal en alta resolución del Monitor Gaming Sony INZONE M9 4K',
    @productImageIsPrincipal = 1,
    @productImageCreatorId = 1,
    @productImageStatusId = 1,
    @o_code = @code OUTPUT,
    @o_message = @message OUTPUT,
    @o_templateId = @templateId OUTPUT;

PRINT 'Producto 54 -> Código: ' + CAST(@code AS VARCHAR) + ' | Mensaje: ' + @message + ' | ImageID: ' + ISNULL(CAST(@templateId AS VARCHAR), 'N/A');
GO


-------------------
--actualizar las que tan malas 

UPDATE [SQM_GENERAL].[Tbl_ProductImages]
SET productImageURL = '/uploads/products/Zapatillas_Nike_DefyAllDay_Casual_negra.png'
WHERE productImageProductId = 10;