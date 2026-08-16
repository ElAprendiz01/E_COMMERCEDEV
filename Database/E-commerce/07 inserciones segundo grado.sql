USE [DB_ECOMMERCE]
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- Declaramos variables para capturar los IDs dinámicamente y no fallar con las FK
    DECLARE @CurrentProductId INT;
    DECLARE @CurrentVariableId INT;
    -- Moneda USD por defecto (currencyId = 1)
    -- Creador por defecto (userId = 1)

    -- =========================================================================
    -- PRODUCTO 1: Laptop Dell XPS 15 (Tecnología / Computadoras / Laptops)
    -- =========================================================================
    PRINT 'Insertando Producto 1: Dell XPS 15...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Dell XPS 15', 'Laptop premium de alto rendimiento con chasis de aluminio', 13, 5, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    -- Variable (Versión/Precio)
    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '32GB RAM - 1TB SSD - Intel Core i7', 1850.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    -- Stock
    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 15, '2025-10-01', '2035-10-01', 1, GETDATE(), 1);

    -- Imagen Principal
    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/dell_xps15_front.jpg', 'Vista frontal XPS 15', 1, 1, GETDATE(), 1);


    -- =========================================================================
    -- PRODUCTO 2: Laptop Dell Alienware m15 R7 (Tecnología / Computadoras / Gaming)
    -- =========================================================================
    PRINT 'Insertando Producto 2: Dell Alienware...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Dell Alienware m15', 'Equipo especializado para Gaming competitivo y streaming', 12, 5, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '16GB RAM - 512GB SSD - RTX 3070', 2100.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 8, '2025-11-15', '2035-11-15', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/alienware_m15.jpg', 'Vista completa Alienware', 1, 1, GETDATE(), 1);


    -- =========================================================================
    -- PRODUCTO 3: Zapatillas Adidas Ultraboost 22 (Calzado / Masculino / Deportivo)
    -- =========================================================================
    PRINT 'Insertando Producto 3: Adidas Ultraboost...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Zapatillas Adidas Ultraboost 22', 'Calzado de running con máximo retorno de energía', 1, 1, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, 'TALLA 42 (9 US) - Negro/Blanco', 190.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 30, '2026-01-10', '2031-01-10', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/adidas_ultraboost22.jpg', 'Lateral Ultraboost Negro', 1, 1, GETDATE(), 1);


    -- =========================================================================
    -- PRODUCTO 4: Nike Air Zoom Pegasus 40 (Calzado / Femenino / Deportivo)
    -- =========================================================================
    PRINT 'Insertando Producto 4: Nike Air Zoom Pegasus...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Nike Air Zoom Pegasus 40 Mujer', 'Zapatillas de asfalto fiables y ligeras para mujer', 2, 2, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, 'TALLA 38 (7 US) - Rosa/Blanco', 130.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 25, '2026-02-20', '2031-02-20', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/nike_pegasus40_w.jpg', 'Nike Pegasus Rosa', 1, 1, GETDATE(), 1);


    -- =========================================================================
    -- PRODUCTO 5: Camiseta Adidas Entrada 22 (Ropa / Masculino / Deportivo)
    -- =========================================================================
    PRINT 'Insertando Producto 5: Camiseta Adidas...';
    -- Usamos el identificador 5 (Ropa/Masculino/Deportivo) y la marca 1 (Adidas)
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Camiseta Deportiva Adidas Entrada 22', 'Camiseta de entrenamiento de poliéster reciclado AEROREADY', 5, 1, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, 'TALLA L - Azul Marino', 35.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 50, '2026-03-01', '2031-03-01', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/adidas_entrada22.jpg', 'Camiseta Entrenamiento Azul', 1, 1, GETDATE(), 1);

    -- Si todo sale bien, guardamos los cambios
    COMMIT TRANSACTION;
    PRINT '¡Todos los productos han sido insertados con éxito en cascada!';

END TRY
BEGIN CATCH
    -- Si ocurre un error, revertimos todo para no dejar registros huérfanos
    ROLLBACK TRANSACTION;
    
    PRINT 'Ocurrió un error en la inserción:';
    PRINT ERROR_MESSAGE();
END CATCH
GO



USE [DB_ECOMMERCE]
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @CurrentProductId INT;
    DECLARE @CurrentVariableId INT;
    DECLARE @SonyMarkByProviderId INT;

    -- =========================================================================
    -- PASO PREVIO: Validar y crear el enlace Marca-Proveedor para Sony
    -- Marca: 6 (Sony) | Proveedor: 6 (Sony Latam Corp)
    -- =========================================================================
    SELECT @SonyMarkByProviderId = markByProviderId 
    FROM [SQM_CATALOGS].[Tbl_MarkByProviders] 
    WHERE markByProviderMarkId = 6 AND markByProviderProviderId = 6 AND markByProviderStatusId = 1;

    IF @SonyMarkByProviderId IS NULL
    BEGIN
        PRINT 'Creando enlace Marca-Proveedor para Sony...';
        INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] 
            (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
        VALUES 
            (6, 6, 1, GETDATE(), 1);
        
        SET @SonyMarkByProviderId = SCOPE_IDENTITY();
    END

    -- =========================================================================
    -- PRODUCTO 1: Smartphone Sony Xperia 1 V (Tecnología / Celulares / Casual - ID 18)
    -- =========================================================================
    PRINT 'Insertando Producto 1: Sony Xperia 1 V...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Sony Xperia 1 V', 'Smartphone insignia con cámara desarrollada en colaboración con Alpha', 18, @SonyMarkByProviderId, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '256GB ROM - 12GB RAM - Negro', 1199.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 25, '2025-08-01', '2030-08-01', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/sony_xperia1v.jpg', 'Vista frontal y trasera Xperia 1 V', 1, 1, GETDATE(), 1);

    -- =========================================================================
    -- PRODUCTO 2: Smartphone Sony Xperia PRO-I (Tecnología / Celulares / Oficina - ID 9)
    -- =========================================================================
    PRINT 'Insertando Producto 2: Sony Xperia PRO-I...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Sony Xperia PRO-I', 'El teléfono inteligente con sensor de imagen tipo 1.0 para creadores', 9, @SonyMarkByProviderId, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '512GB ROM - 12GB RAM - Frosted Black', 1799.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 10, '2025-05-15', '2030-05-15', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/sony_xperiaproi.jpg', 'Xperia PRO-I cámara principal', 1, 1, GETDATE(), 1);

    -- =========================================================================
    -- PRODUCTO 3: Monitor Gaming Sony INZONE M9 (Tecnología / Computadoras / Gaming - ID 17)
    -- =========================================================================
    PRINT 'Insertando Producto 3: Monitor Sony INZONE M9...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Monitor Gaming Sony INZONE M9', 'Monitor de 27 pulgadas 4K HDR con frecuencia de actualización de 144Hz', 17, @SonyMarkByProviderId, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '27" 4K - Blanco/Negro', 899.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 15, '2026-01-20', '2036-01-20', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/sony_inzonem9.jpg', 'Monitor INZONE M9 frontal', 1, 1, GETDATE(), 1);

    -- =========================================================================
    -- PRODUCTO 4: Auriculares Gaming Sony INZONE H9 (Tecnología / Computadoras / Gaming - ID 12)
    -- =========================================================================
    PRINT 'Insertando Producto 4: Auriculares Sony INZONE H9...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Auriculares Gaming Sony INZONE H9', 'Auriculares inalámbricos con Noise Cancelling y sonido espacial 360', 12, @SonyMarkByProviderId, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, 'Inalámbrico - Color Blanco', 299.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 40, '2026-02-10', '2031-02-10', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/sony_inzoneh9.jpg', 'Auriculares H9 perfil', 1, 1, GETDATE(), 1);

    -- =========================================================================
    -- PRODUCTO 5: Laptop Sony VAIO Z (Tecnología / Computadoras / Laptops - ID 13)
    -- =========================================================================
    PRINT 'Insertando Producto 5: Laptop Sony VAIO Z...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Sony VAIO Z', 'Portátil ultraligero de fibra de carbono para máxima movilidad y rendimiento', 13, @SonyMarkByProviderId, 1, GETDATE(), 1);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '16GB RAM - 1TB SSD - Intel Core i7', 1450.00, 1, 1, GETDATE(), 1);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 12, '2025-11-05', '2035-11-05', 1, GETDATE(), 1);

    INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] 
        (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId)
    VALUES 
        (@CurrentProductId, '/assets/img/products/sony_vaioz.jpg', 'Laptop VAIO Z abierta', 1, 1, GETDATE(), 1);

    COMMIT TRANSACTION;
    PRINT '¡Los 5 productos de tecnología Sony han sido insertados con éxito!';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error en la inserción:';
    PRINT ERROR_MESSAGE();
END CATCH
GO


------------------------------------------------------------------


USE [DB_ECOMMERCE]
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @CurrentProductId INT;
    DECLARE @CurrentVariableId INT;
    
    -- Variables con las FK exactas validadas de los catálogos
    DECLARE @DellMarkByProviderId INT = 5; -- Marca: DELL, Proveedor: COMPU SOLUCIONES
    DECLARE @LaptopIdentificatorId INT = 13; -- Cat: TECNOLOGIA, SubCat: COMPUTADORAS, Seg: LAPTOS
    DECLARE @CurrencyUSD INT = 1; -- Dólares
    DECLARE @CreatorId INT = 1; -- HCALERO
    DECLARE @StatusActive INT = 1; -- ACTIVO

    -- =========================================================================
    -- PRODUCTO 1: Laptop Dell XPS 13
    -- =========================================================================
    PRINT 'Insertando Producto 1: Dell XPS 13...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Dell XPS 13', 'Portátil premium ultra compacto, ideal para ejecutivos y viajeros', @LaptopIdentificatorId, @DellMarkByProviderId, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '16GB RAM - 512GB SSD - Color Plata', 1299.00, @CurrencyUSD, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 15, '2026-03-01', '2031-03-01', @CreatorId, GETDATE(), @StatusActive);

    -- =========================================================================
    -- PRODUCTO 2: Laptop Dell Alienware m15 R7
    -- =========================================================================
    PRINT 'Insertando Producto 2: Dell Alienware m15...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Dell Alienware m15 R7', 'Potencia extrema para Gaming con tarjeta gráfica serie RTX 30', @LaptopIdentificatorId, @DellMarkByProviderId, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '32GB RAM - 1TB SSD - Dark Side of the Moon', 2150.00, @CurrencyUSD, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 8, '2026-04-10', '2031-04-10', @CreatorId, GETDATE(), @StatusActive);

    -- =========================================================================
    -- PRODUCTO 3: Laptop Dell Inspiron 15
    -- =========================================================================
    PRINT 'Insertando Producto 3: Dell Inspiron 15...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop Dell Inspiron 15', 'Equipo balanceado para el hogar, estudiantes y trabajo de oficina', @LaptopIdentificatorId, @DellMarkByProviderId, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '8GB RAM - 256GB SSD - Negro Mate', 599.00, @CurrencyUSD, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 30, '2026-05-20', '2031-05-20', @CreatorId, GETDATE(), @StatusActive);

    COMMIT TRANSACTION;
    PRINT '¡Se insertaron los 3 productos DELL respetando todas las llaves foráneas!';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error en la inserción. Detalle:';
    PRINT ERROR_MESSAGE();
END CATCH
GO



------------------------------------

USE [DB_ECOMMERCE]
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- Variables para almacenar los IDs generados
    DECLARE @NewProviderId INT;
    DECLARE @NewMarkId INT;
    DECLARE @NewMarkByProviderId INT;
    DECLARE @CurrentProductId INT;
    DECLARE @CurrentVariableId INT;
    
    -- Variables de configuración basadas en tu catálogo
    DECLARE @GamingIdentificatorId INT = 12; -- Cat: TECNOLOGIA, SubCat: COMPUTADORAS, Seg: GAMING
    DECLARE @CurrencyUSD INT = 1; -- Dólares
    DECLARE @CreatorId INT = 1; -- Usuario HCALERO
    DECLARE @StatusActive INT = 1; -- ACTIVO

    -- =========================================================================
    -- 1. INSERTAR NUEVO PROVEEDOR
    -- =========================================================================
    PRINT 'Insertando Nuevo Proveedor...';
    INSERT INTO [SQM_CATALOGS].[Tbl_Providers] 
        (providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
    VALUES 
        ('ASUS LATAM S.A.', 'Proveedor oficial y directo de equipos de alto rendimiento ASUS', @CreatorId, GETDATE(), @StatusActive);
    
    SET @NewProviderId = SCOPE_IDENTITY();

    -- =========================================================================
    -- 2. INSERTAR NUEVA MARCA
    -- =========================================================================
    PRINT 'Insertando Nueva Marca...';
    INSERT INTO [SQM_CATALOGS].[Tbl_Marks] 
        (markName, markDescription, markCreatorId, markCreationDate, markStatusId)
    VALUES 
        ('ASUS ROG', 'Republic of Gamers - Línea premium para videojuegos y esports', @CreatorId, GETDATE(), @StatusActive);
    
    SET @NewMarkId = SCOPE_IDENTITY();

    -- =========================================================================
    -- 3. ENLAZAR MARCA CON PROVEEDOR (Tbl_MarkByProviders)
    -- =========================================================================
    PRINT 'Enlazando Marca y Proveedor...';
    INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] 
        (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
    VALUES 
        (@NewMarkId, @NewProviderId, @CreatorId, GETDATE(), @StatusActive);
    
    SET @NewMarkByProviderId = SCOPE_IDENTITY();

    -- =========================================================================
    -- 4. INSERTAR EL NUEVO PRODUCTO
    -- =========================================================================
    PRINT 'Insertando Nuevo Producto...';
    INSERT INTO [SQM_GENERAL].[Tbl_Products] 
        (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
    VALUES 
        ('Laptop ASUS ROG Strix G16', 'Laptop gaming extrema con pantalla Nebula de 165Hz y refrigeración de metal líquido', @GamingIdentificatorId, @NewMarkByProviderId, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentProductId = SCOPE_IDENTITY();

    -- =========================================================================
    -- 5. INSERTAR LA VARIABLE DEL PRODUCTO (Precio y Especificaciones)
    -- =========================================================================
    PRINT 'Insertando Especificaciones y Precio...';
    INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
        (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
    VALUES 
        (@CurrentProductId, '32GB RAM - 1TB SSD - NVIDIA RTX 4070 - Eclipse Gray', 1850.00, @CurrencyUSD, @CreatorId, GETDATE(), @StatusActive);
    
    SET @CurrentVariableId = SCOPE_IDENTITY();

    -- =========================================================================
    -- 6. INSERTAR INVENTARIO (Stock)
    -- =========================================================================
    PRINT 'Insertando Inventario...';
    INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
        (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
    VALUES 
        (@CurrentVariableId, 12, '2026-06-01', '2031-06-01', @CreatorId, GETDATE(), @StatusActive);

    COMMIT TRANSACTION;
    PRINT '¡Se insertó correctamente el Proveedor, la Marca, el enlace y el Producto Gaming!';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error en la inserción. Detalle:';
    PRINT ERROR_MESSAGE();
END CATCH
GO



-----------------------------------------------




-- =========================================================
-- DECLARACIÓN DE VARIABLES PARA CAPTURAR IDs
-- =========================================================
-- Proveedores
DECLARE @IdProvApple INT, @IdProvSamsung INT, @IdProvInfinix INT;
-- Marcas
DECLARE @IdMarkApple INT, @IdMarkSamsung INT, @IdMarkInfinix INT;
-- Relación Marca-Proveedor
DECLARE @IdMBPApple INT, @IdMBPSamsung INT, @IdMBPInfinix INT;
-- Identificadores
DECLARE @IdIdentPremium INT;
-- Productos
DECLARE @IdProd1 INT, @IdProd2 INT, @IdProd3 INT, @IdProd4 INT, @IdProd5 INT, @IdProd6 INT, @IdProd7 INT, @IdProd8 INT, @IdProd9 INT;
-- Variables (Specs)
DECLARE @IdVar1 INT, @IdVar2 INT, @IdVar3 INT, @IdVar4 INT, @IdVar5 INT, @IdVar6 INT, @IdVar7 INT, @IdVar8 INT, @IdVar9 INT;

-- =========================================================
-- 1. CREACIÓN DE PROVEEDORES Y CAPTURA DE IDs
-- =========================================================
INSERT INTO [SQM_CATALOGS].[Tbl_Providers] (providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
VALUES ('APPLE LATAM', 'Proveedor oficial de productos Apple', 1, GETDATE(), 1);
SET @IdProvApple = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_Providers] (providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
VALUES ('SAMSUNG ELECTRONICS', 'Distribuidor mayorista de Samsung', 1, GETDATE(), 1);
SET @IdProvSamsung = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_Providers] (providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
VALUES ('INFINIX DIRECT', 'Distribuidor regional de Infinix Mobile', 1, GETDATE(), 1);
SET @IdProvInfinix = SCOPE_IDENTITY();

-- =========================================================
-- 2. CREACIÓN DE MARCAS Y CAPTURA DE IDs
-- =========================================================
INSERT INTO [SQM_CATALOGS].[Tbl_Marks] (markName, markDescription, markCreatorId, markCreationDate, markStatusId)
VALUES ('Apple', 'Smartphones y ecosistema iOS', 1, GETDATE(), 1);
SET @IdMarkApple = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_Marks] (markName, markDescription, markCreatorId, markCreationDate, markStatusId)
VALUES ('Samsung', 'Línea Galaxy y tecnología móvil', 1, GETDATE(), 1);
SET @IdMarkSamsung = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_Marks] (markName, markDescription, markCreatorId, markCreationDate, markStatusId)
VALUES ('Infinix', 'Smartphones de gama media y de entrada', 1, GETDATE(), 1);
SET @IdMarkInfinix = SCOPE_IDENTITY();

-- =========================================================
-- 3. VINCULACIÓN MARCA - PROVEEDOR
-- =========================================================
INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
VALUES (@IdMarkApple, @IdProvApple, 1, GETDATE(), 1);
SET @IdMBPApple = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
VALUES (@IdMarkSamsung, @IdProvSamsung, 1, GETDATE(), 1);
SET @IdMBPSamsung = SCOPE_IDENTITY();

INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
VALUES (@IdMarkInfinix, @IdProvInfinix, 1, GETDATE(), 1);
SET @IdMBPInfinix = SCOPE_IDENTITY();

-- =========================================================
-- 4. NUEVO IDENTIFICADOR (Celulares Premium)
-- =========================================================
INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators] (productIdentificatorCategoryId, productIdentificatorSubCategoryId, productIdentificatorSegmentId, productIdentificatorCreatorId, productIdentificatorCreationDate, productIdentificatorStatusId)
VALUES (3, 5, 10, 1, GETDATE(), 1); -- 3=Tecnología, 5=Celulares, 10=Premium
SET @IdIdentPremium = SCOPE_IDENTITY();

-- =========================================================
-- 5. CREACIÓN DE PRODUCTOS, VARIABLES Y STOCK
-- =========================================================

-- ---------- APPLE (Usa @IdIdentPremium y @IdMBPApple) ----------
-- iPhone 13
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('iPhone 13', 'Pantalla Super Retina XDR de 6.1 pulgadas, Chip A15 Bionic', @IdIdentPremium, @IdMBPApple, 1, GETDATE(), 1);
SET @IdProd1 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd1, '128GB ROM - 4GB RAM - Midnight', 599.00, 1, 1, GETDATE(), 1);
SET @IdVar1 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar1, 25, '2025-10-01', '2030-10-01', 1, GETDATE(), 1);

-- iPhone 14
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('iPhone 14', 'Pantalla Super Retina XDR, Ceramic Shield', @IdIdentPremium, @IdMBPApple, 1, GETDATE(), 1);
SET @IdProd2 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd2, '128GB ROM - 6GB RAM - Starlight', 699.00, 1, 1, GETDATE(), 1);
SET @IdVar2 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar2, 30, '2026-01-15', '2031-01-15', 1, GETDATE(), 1);

-- iPhone 15 Pro
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('iPhone 15 Pro', 'Diseño de titanio, Chip A17 Pro', @IdIdentPremium, @IdMBPApple, 1, GETDATE(), 1);
SET @IdProd3 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd3, '256GB ROM - 8GB RAM - Natural Titanium', 1099.00, 1, 1, GETDATE(), 1);
SET @IdVar3 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar3, 15, '2026-03-20', '2031-03-20', 1, GETDATE(), 1);


-- ---------- SAMSUNG (Usa @IdIdentPremium, ID Casual(18) y @IdMBPSamsung) ----------
-- Galaxy A54 (Usa Identificador 18 - Casual)
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Samsung Galaxy A54 5G', 'Pantalla Super AMOLED 120Hz', 18, @IdMBPSamsung, 1, GETDATE(), 1);
SET @IdProd4 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd4, '256GB ROM - 8GB RAM - Awesome Graphite', 349.00, 1, 1, GETDATE(), 1);
SET @IdVar4 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar4, 40, '2026-01-10', '2031-01-10', 1, GETDATE(), 1);

-- Galaxy S23
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Samsung Galaxy S23', 'Snapdragon 8 Gen 2, Dynamic AMOLED 2X', @IdIdentPremium, @IdMBPSamsung, 1, GETDATE(), 1);
SET @IdProd5 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd5, '256GB ROM - 8GB RAM - Phantom Black', 799.00, 1, 1, GETDATE(), 1);
SET @IdVar5 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar5, 20, '2026-02-05', '2031-02-05', 1, GETDATE(), 1);

-- Galaxy S24 Ultra
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Samsung Galaxy S24 Ultra', 'Cámara de 200MP, Galaxy AI', @IdIdentPremium, @IdMBPSamsung, 1, GETDATE(), 1);
SET @IdProd6 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd6, '512GB ROM - 12GB RAM - Titanium Gray', 1299.00, 1, 1, GETDATE(), 1);
SET @IdVar6 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar6, 10, '2026-04-01', '2031-04-01', 1, GETDATE(), 1);


-- ---------- INFINIX (Usa ID Casual(18) y @IdMBPInfinix) ----------
-- Infinix Smart 8
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Infinix Smart 8', 'Pantalla fluida de 90Hz, Batería de 5000 mAh', 18, @IdMBPInfinix, 1, GETDATE(), 1);
SET @IdProd7 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd7, '64GB ROM - 3GB RAM - Timber Black', 109.00, 1, 1, GETDATE(), 1);
SET @IdVar7 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar7, 50, '2026-02-28', '2031-02-28', 1, GETDATE(), 1);

-- Infinix Note 30 Pro
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Infinix Note 30 Pro', 'Carga rápida 68W, Pantalla AMOLED', 18, @IdMBPInfinix, 1, GETDATE(), 1);
SET @IdProd8 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd8, '256GB ROM - 8GB RAM - Magic Black', 219.00, 1, 1, GETDATE(), 1);
SET @IdVar8 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar8, 35, '2026-03-15', '2031-03-15', 1, GETDATE(), 1);

-- Infinix Zero 30 5G
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES ('Infinix Zero 30 5G', 'Cámara frontal 50MP para Vlogs', 18, @IdMBPInfinix, 1, GETDATE(), 1);
SET @IdProd9 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES (@IdProd9, '256GB ROM - 12GB RAM - Rome Green', 329.00, 1, 1, GETDATE(), 1);
SET @IdVar9 = SCOPE_IDENTITY();

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES (@IdVar9, 20, '2026-05-10', '2031-05-10', 1, GETDATE(), 1);