USE [DB_ECOMMERCE]
GO

INSERT INTO [SQM_CATALOGS].[Tbl_Status](statusName,statusCreatorId,statusCreationDate,statusStatusId)
VALUES
('ACTIVO', 1, GETDATE(), 1),
('INACTIVO', 1, GETDATE(), 1),
('BLOQUEADO', 1, GETDATE(), 1),
('PROCESADO', 1, GETDATE(), 1),
('ENTREGADO', 1, GETDATE(), 1),
('ANULADO', 1, GETDATE(), 1);

OPEN SYMMETRIC KEY KEY_HASH
DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

  DECLARE
	@UserPassword VARCHAR(256),
	@UserPasswordEncrypted VARBINARY(256)
  
  SET @UserPassword = '12345'
  SET @UserPasswordEncrypted = SQM_SECURITY.Fn_EncryptByKey(@UserPassword)
  


INSERT INTO [SQM_SECURITY].[Tbl_Users](userFullName,userName,userPassword,userEmail,userPhoneNumber,userCountryId,userGenderId,userBirthDay,userCreatorId,userCreationDate,userStatusId)
VALUES
('HECTOR JOSE CALERO ALANIZ', 'HCALERO', @UserPasswordEncrypted, 'hcalero@dominio.local','88888888', 1, 2,'2000-05-12', 1, GETDATE(), 1),
('DAVID JOSHUA JIMENEZ URBINA', 'DURBINA', @UserPasswordEncrypted, 'durbina@dominio.local','99999999', 1, 2,'1995-10-21', 1, GETDATE(), 1);

CLOSE SYMMETRIC KEY KEY_HASH;
GO

INSERT INTO [SQM_GENERAL].[Tbl_UserAddress](userAddressUserId,userAddressCountryId,userAddressZIPCode,userAddressDescription,userAddressIsPrincipal,userAddressCreatorId,userAddressCreationDate,userAddressStatusId)
VALUES 
(1,1,'1001','Ciudad el Doral, Mateare', 1, 1, GETDATE(), 1),
(2,1,'1002','Ciudad Sandino, Managua', 1, 1, GETDATE(), 1);

INSERT INTO [SQM_CATALOGS].[Tbl_Categories](categoryName,categoryDescription,categoryCreatorId,categoryCreationDate,categoryStatusId)
VALUES
('CALZADO', 'CALZADO EN GENERAL', 1, GETDATE(), 1),
('ROPA', 'ROPA EN GENERAL', 1, GETDATE(), 1),
('TECNOLOGIA', 'TECNOLOGIA EN GENERAL', 1, GETDATE(), 1),
('ACCESORIOS', 'ACCESORIOS EN GENERAL', 1, GETDATE(), 1);

INSERT INTO [SQM_CATALOGS].[Tbl_SubCategories](subCategoryName,subCategoryDescription,subCategoryCreatorId,subCategoryCreationDate,subCategoryStatusId)
VALUES
('MASCULINO', 'ROPA MASCULINA', 1, GETDATE(), 1),
('FEMENINO', 'ROPA FEMENINA', 1, GETDATE(), 1),
('NIÑOS', 'ROPA PARA NIÑOS', 1, GETDATE(), 1),
('NIÑAS', 'ROPA PARA NIÑAS', 1, GETDATE(), 1),
('CELULARES', 'CELULARES EN GENERAL', 1, GETDATE(), 1),
('COMPUTADORAS', 'COMPUTADORAS EN GENERAL', 1, GETDATE(), 1);

INSERT INTO [SQM_CATALOGS].[Tbl_Segments](segmentName,segmentDescription,segmentCreatorId,segmentCreationDate,segmentStatusId)
VALUES
('DEPORTIVO', 'SEGMENTO DEPORTIVO', 1, GETDATE(), 1),
('CASUAL', 'SEGMENTO CASUAL', 1, GETDATE(), 1),
('ELEGANTE', 'SEGMENTO ELEGANTE', 1, GETDATE(), 1),
('OFICINA', 'SEGMENTO OFICINA', 1, GETDATE(), 1),
('GAMING', 'SEGMENTO GAMING', 1, GETDATE(), 1),
('HOGAR', 'SEGMENTO HOGAR', 1, GETDATE(), 1),
('LAPTOS', 'SEGMENTO LAPTOS', 1, GETDATE(), 1),
('REPUESTOS', 'SEGMENTO REPUESTOS', 1, GETDATE(), 1);

INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators](productIdentificatorCategoryId,productIdentificatorSubCategoryId,productIdentificatorSegmentId,productIdentificatorCreatorId,productIdentificatorCreationDate,productIdentificatorStatusId)
VALUES
(1,1,1,1,GETDATE(),1),
(1,2,1,1,GETDATE(),1),
(1,3,1,1,GETDATE(),1),
(1,4,1,1,GETDATE(),1),
(2,1,1,1,GETDATE(),1),
(2,2,1,1,GETDATE(),1),
(2,3,1,1,GETDATE(),1),
(2,4,1,1,GETDATE(),1),
(3,5,4,1,GETDATE(),1),
(3,5,5,1,GETDATE(),1),
(3,6,4,1,GETDATE(),1),
(3,6,5,1,GETDATE(),1),
(3,6,7,1,GETDATE(),1);
GO

INSERT INTO [SQM_CATALOGS].[Tbl_StockMovementTypes] 
(stockMovementTypeName, stockMovementTypeDescription, stockMovementTypeCreatorId, stockMovementTypeCreationDate, stockMovementTypeStatusId)
VALUES 
('ENTRADA POR COMPRA', 'Ingreso de mercadería de un proveedor', 1, GETDATE(), 1),
('SALIDA POR VENTA', 'Despacho de mercadería por orden de cliente', 1, GETDATE(), 1),
('AJUSTE POSITIVO', 'Suma al inventario por descuadre o devolución', 1, GETDATE(), 1),
('AJUSTE NEGATIVO', 'Resta al inventario por merma, daño o pérdida', 1, GETDATE(), 1);
GO

-----------------------------------------
-- --------- NUEVAS INSERCIONES ---------
-----------------------------------------

-- 1. PROVEEDORES (Providers)
INSERT INTO [SQM_CATALOGS].[Tbl_Providers](providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
VALUES 
('DISTRIBUIDORA ADIDAS', 'Proveedor mayorista de calzado y ropa Adidas', 1, GETDATE(), 1),
('DISTRIBUIDORA NIKE', 'Proveedor oficial de productos Nike', 1, GETDATE(), 1),
('COMPU SOLUCIONES', 'Proveedor de hardware y laptops', 1, GETDATE(), 1);
GO

-- 2. MARCAS (Marks)
INSERT INTO [SQM_CATALOGS].[Tbl_Marks](markName, markDescription, markCreatorId, markCreationDate, markStatusId)
VALUES 
('ADIDAS', 'Marca Adidas global', 1, GETDATE(), 1),
('NIKE', 'Marca Nike global', 1, GETDATE(), 1),
('DELL', 'Marca de computadoras Dell', 1, GETDATE(), 1);
GO

-- 3. RELACION MARCA Y PROVEEDOR (MarkByProviders)
INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders](markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
VALUES 
(1, 1, 1, GETDATE(), 1), -- Adidas con Adidas Distribuidora
(2, 2, 1, GETDATE(), 1), -- Nike con Nike Distribuidora
(3, 3, 1, GETDATE(), 1); -- Dell con Compu Soluciones
GO

-- 4. MONEDAS (Currencies)
INSERT INTO [SQM_CATALOGS].[Tbl_Currencies](currencyName, currencyISO, currencyCode, currencyDescription, currencyCreatorId, currencyCreationDate, currencyStatusId)
VALUES 
('DOLAR ESTADOUNIDENSE', 'USD', 840, 'Dólar de los Estados Unidos', 1, GETDATE(), 1),
('CORDOBA NICARAGUENSE', 'NIO', 558, 'Córdoba Oro de Nicaragua', 1, GETDATE(), 1);
GO

-- 5. PRODUCTOS (Products)
INSERT INTO [SQM_GENERAL].[Tbl_Products](productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES 
('RUNNING ULTRABOOST 22', 'Zapatos para correr Ultraboost 22', 1, 1, 1, GETDATE(), 1), 
('AIR MAX 90 CASUAL', 'Zapatos Nike Air Max 90', 2, 2, 1, GETDATE(), 1), 
('DELL INSPIRON 15', 'Laptop Dell Inspiron 15 Core i5', 13, 3, 1, GETDATE(), 1); 
GO

-- 6. VARIANTES DE PRODUCTO (ProductVariables)
INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables](productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES 
(1, 'TALLA 42 (9.5 US)', 180.00, 1, 1, GETDATE(), 1), 
(1, 'TALLA 43 (10 US)', 180.00, 1, 1, GETDATE(), 1),  
(2, 'TALLA 38 (7 US)', 140.00, 1, 1, GETDATE(), 1),   
(3, '8GB RAM - 512GB SSD', 650.00, 1, 1, GETDATE(), 1); 
GO

-- 7. STOCK DE INVENTARIO (Stocks)
INSERT INTO [SQM_GENERAL].[Tbl_Stocks](stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES 
(1, 25, '2025-01-01', '2030-01-01', 1, GETDATE(), 1),
(2, 30, '2025-01-01', '2030-01-01', 1, GETDATE(), 1),
(3, 15, '2025-02-01', '2030-02-01', 1, GETDATE(), 1),
(4, 10, '2025-03-01', '2030-03-01', 1, GETDATE(), 1);
GO

-- 8. TIPOS DE METODOS DE PAGO (PaymentMethodTypes)
INSERT INTO [SQM_CATALOGS].[Tbl_PaymentMethodTypes](paymentMethodTypeName, paymentMethodTypeDescription, paymentMethodTypeCreatorId, paymentMethodTypeCreationDate, paymentMethodTypeStatusId)
VALUES 
('TARJETA DE CREDITO', 'Visa/Mastercard de crédito', 1, GETDATE(), 1),
('TARJETA DE DEBITO', 'Visa/Mastercard de débito', 1, GETDATE(), 1);
GO

-- 9. METODOS DE PAGO DE USUARIO (UserPaymentMethods)
OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

INSERT INTO [SQM_GENERAL].[Tbl_UserPaymentMethods](userPaymentMethodUserId, userPaymentMethodPaymentMethodTypeId, userPaymentMethodCardNumber, userPaymentMethodExpirationDate, userPaymentMethodCVV, userPaymentMethodCardHolderName, userPaymentMethodCreatorId, userPaymentMethodCreationDate, userPaymentMethodStatusId)
VALUES 
(1, 1, SQM_SECURITY.Fn_EncryptByKey('1234567812345678'), SQM_SECURITY.Fn_EncryptByKey('12/28'), SQM_SECURITY.Fn_EncryptByKey('123'), 'HECTOR JOSE CALERO ALANIZ', 1, GETDATE(), 1),
(2, 2, SQM_SECURITY.Fn_EncryptByKey('8765432187654321'), SQM_SECURITY.Fn_EncryptByKey('06/29'), SQM_SECURITY.Fn_EncryptByKey('456'), 'DAVID JOSHUA JIMENEZ URBINA', 1, GETDATE(), 1);

CLOSE SYMMETRIC KEY KEY_HASH;
GO

-- 10. ORDENES DE PAGO (PaymentOrders)
INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrders](orderUserId, orderDeliveryAddress, orderPaymentMethodId, orderSubtotal, orderDiscount, orderShipping, orderTAX, orderTotal, orderCurrencyId, orderCreatorId, orderCreationDate, orderStatusId)
VALUES 
(1, 1, 1, 360.00, 10.00, 5.00, 52.50, 407.50, 1, 1, GETDATE(), 4), 
(2, 2, 2, 650.00, 00.00, 10.00, 97.50, 757.50, 1, 1, GETDATE(), 4); 
GO

-- 11. DETALLES DE ORDEN (PaymentOrderDetails)
INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrderDetails](orderDetailOrderId, orderDetailProductVariableId, orderDetailPrice, orderDetailQuantity, orderDetailDiscount, orderDetailSubTotal, orderDetailTAX, orderDetailTotal, orderDetailCurrencyId, orderDetailCreatorId, orderDetailCreationDate, orderDetailStatusId)
VALUES 
(1, 1, 180.00, 2, 10.00, 350.00, 52.50, 402.50, 1, 1, GETDATE(), 1), 
(2, 4, 650.00, 1, 00.00, 650.00, 97.50, 747.50, 1, 1, GETDATE(), 1); 
GO




-- 1. Nuevas Marcas
INSERT INTO [SQM_CATALOGS].[Tbl_Marks] 
(markName, markDescription, markCreatorId, markCreationDate, markStatusId)
VALUES 
('Nike', 'Marca deportiva global', 1, GETDATE(), 1),
('Sony', 'Electrónica y entretenimiento', 1, GETDATE(), 1);

-- 2. Nuevos Proveedores
INSERT INTO [SQM_CATALOGS].[Tbl_Providers] 
(providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId)
VALUES 
('Distribuidora Intermex S.A.', 'Proveedor de ropa y calzado premium', 1, GETDATE(), 1),
('Sony Latam Corp', 'Proveedor directo de tecnología japonesa', 1, GETDATE(), 1);

-- 3. Nuevas Subcategorías y Segmentos (Si aplica)
INSERT INTO [SQM_CATALOGS].[Tbl_SubCategories] 
(subCategoryName, subCategoryDescription, subCategoryCreatorId, subCategoryCreationDate, subCategoryStatusId)
VALUES 
('Calzado Deportivo', 'Zapatillas para correr y entrenamiento', 1, GETDATE(), 1),
('Consolas de Videojuegos', 'Sistemas de entretenimiento interactivo', 1, GETDATE(), 1);

INSERT INTO [SQM_CATALOGS].[Tbl_Segments] 
(segmentName, segmentDescription, segmentCreatorId, segmentCreationDate, segmentStatusId)
VALUES 
('Premium', 'Productos de gama alta y ediciones especiales', 1, GETDATE(), 1);
GO


INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] 
(markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId)
VALUES 
(2, 2, 1, GETDATE(), 1), -- Nike con Intermex
(3, 3, 1, GETDATE(), 1); -- Sony con Sony Latam ( IDs 3)


INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators] 
(productIdentificatorCategoryId, productIdentificatorSubCategoryId, productIdentificatorSegmentId, productIdentificatorCreatorId, productIdentificatorCreationDate, productIdentificatorStatusId)
VALUES 
(2, 2, 2, 1, GETDATE(), 1); 
GO


INSERT INTO [SQM_GENERAL].[Tbl_Products] 
(productName, productDescription, productProductIdentificatorId,    , productCreatorId, productCreationDate, productStatusId)
VALUES 
('Zapatillas Nike Air Max 2026', 'Calzado deportivo con amortiguación máxima', 2, 2, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
(productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES 
(2, 'Talla 9.5 US - Color Negro', 180.00, 1, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
(stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES 
(2, 50, '2026-01-10', '2031-01-10', 1, GETDATE(), 1);
GO


INSERT INTO [SQM_GENERAL].[Tbl_Products] 
(productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES 
('Zapatillas Nike Air Max 90 Casual v2', 'Calzado urbano con amortiguación mejorada', 2, 2, 1, GETDATE(), 1),
('Laptop Dell Vostro 3500 Office', 'Laptop enfocada en productividad de oficina', 11, 3, 1, GETDATE(), 1),
('Zapatillas Adidas Originals Forum', 'Zapatillas de perfil clásico retro urbano', 1, 1, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
(productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES 
(6, 'TALLA 40 (7.5 US) - Blanco/Negro', 145.00, 1, 1, GETDATE(), 1),
(6, 'TALLA 41 (8.5 US) - Total Negro', 145.00, 1, 1, GETDATE(), 1),
(7, '16GB RAM - 512GB SSD - Intel i5', 720.00, 1, 1, GETDATE(), 1),
(8, 'TALLA 42 (9.5 US) - Azul Clásico', 120.00, 1, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
(stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES 
(6, 40, '2026-02-15', '2031-02-15', 1, GETDATE(), 1),
(7, 35, '2026-02-15', '2031-02-15', 1, GETDATE(), 1),
(8, 15, '2026-01-20', '2031-01-20', 1, GETDATE(), 1),
(9, 25, '2026-03-10', '2031-03-10', 1, GETDATE(), 1);
GO


INSERT INTO [SQM_GENERAL].[Tbl_Products] 
(productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId)
VALUES 
('Zapatillas Nike DefyAllDay Casual', 'Calzado urbano de cuero cómodo para uso diario', 2, 2, 1, GETDATE(), 1),
('Zapatillas Nike Air Max SYSTM', 'Estilo retro de los 80 con amortiguación Air visible', 2, 2, 1, GETDATE(), 1),
('Zapatillas Nike Court Vision Low', 'Diseño clásico de baloncesto adaptado para el día a día', 2, 2, 1, GETDATE(), 1),
('Zapatillas Nike Downshifter 12', 'Calzado ligero para iniciación al running y entrenamientos', 1, 2, 1, GETDATE(), 1),
('Zapatillas Adidas Runfalcon 3.0', 'Zapatillas para correr con mediasuela Cloudfoam suave', 1, 1, 1, GETDATE(), 1),
('Zapatillas Adidas Grand Court TD', 'Diseño clásico con las 3 franjas icónicas en los costados', 1, 1, 1, GETDATE(), 1),
('Zapatillas Adidas Duramo RC', 'Zapatillas de running duraderas para entrenamientos diarios', 1, 1, 1, GETDATE(), 1),
('Zapatillas Adidas Galaxy 6', 'Calzado con máxima ventilación para caminatas largas', 1, 1, 1, GETDATE(), 1),
('Laptop Dell Vostro 3400 Intel i3', 'Laptop eficiente para tareas básicas de oficina y estudio', 11, 3, 1, GETDATE(), 1),
('Laptop Dell Inspiron 3520 120Hz', 'Pantalla fluida con procesador Core i5 para multitarea', 11, 3, 1, GETDATE(), 1),
('Laptop Dell Latitude 3420 Pro', 'Equipo corporativo con seguridad avanzada y chasis robusto', 11, 3, 1, GETDATE(), 1),
('Laptop Dell G15 Gaming Edition', 'Potencia gráfica con refrigeración avanzada para jugadores', 12, 3, 1, GETDATE(), 1),
('Zapatillas Nike Revolution 6 Flyease', 'Sistema de cierre fácil sin cordones para mayor comodidad', 1, 2, 1, GETDATE(), 1),
('Zapatillas Nike Pegasus 40 Premium', 'Calzado de running de alto rendimiento con espuma React', 1, 2, 1, GETDATE(), 1),
('Zapatillas Adidas Superstar Classic', 'El ícono urbano con puntera de caucho estriada', 1, 1, 1, GETDATE(), 1),
('Zapatillas Adidas Stan Smith Eco', 'Estilo minimalista fabricado con materiales reciclados', 1, 1, 1, GETDATE(), 1),
('Laptop Dell Inspiron 16 Ryzen 5', 'Pantalla grande con procesador AMD para creadores de contenido', 11, 3, 1, GETDATE(), 1),
('Laptop Dell Precision 3580 Workstation', 'Estación de trabajo optimizada para diseño CAD y arquitectura', 11, 3, 1, GETDATE(), 1),
('Zapatillas Nike Air Max Excee', 'Homenaje al Air Max 90 con líneas de diseño modernas', 2, 2, 1, GETDATE(), 1),
('Laptop Dell XPS 13 Ultrabook', 'Diseño ultradelgado premium con pantalla InfinityEdge', 11, 3, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] 
(productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId)
VALUES 
(6, 'TALLA 40 (7.5 US) - Blanco', 85.00, 1, 1, GETDATE(), 1),
(7, 'TALLA 41 (8.5 US) - Negro/Gris', 110.00, 1, 1, GETDATE(), 1),
(8, 'TALLA 42 (9.5 US) - Blanco Total', 90.00, 1, 1, GETDATE(), 1),
(9, 'TALLA 43 (10 US) - Azul Marino', 95.00, 1, 1, GETDATE(), 1),
(10, 'TALLA 40 (7.5 US) - Negro', 75.00, 1, 1, GETDATE(), 1),
(11, 'TALLA 41 (8.5 US) - Blanco/Negro', 80.00, 1, 1, GETDATE(), 1),
(12, 'TALLA 42 (9.5 US) - Gris', 70.00, 1, 1, GETDATE(), 1),
(13, 'TALLA 43 (10 US) - Negro/Azul', 65.00, 1, 1, GETDATE(), 1),
(14, '8GB RAM - 256GB SSD - Core i3', 420.00, 1, 1, GETDATE(), 1),
(15, '16GB RAM - 512GB SSD - Core i5', 680.00, 1, 1, GETDATE(), 1),
(16, '16GB RAM - 512GB SSD - Windows Pro', 790.00, 1, 1, GETDATE(), 1),
(17, '16GB RAM - 512GB SSD - RTX 3050', 1150.00, 1, 1, GETDATE(), 1),
(18, 'TALLA 41 (8.5 US) - Rojo Deportivo', 85.00, 1, 1, GETDATE(), 1),
(19, 'TALLA 42 (9.5 US) - Edición Pegasus', 160.00, 1, 1, GETDATE(), 1),
(20, 'TALLA 42 (9.5 US) - Blanco Original', 100.00, 1, 1, GETDATE(), 1),
(21, 'TALLA 40 (7.5 US) - Verde/Blanco', 95.00, 1, 1, GETDATE(), 1),
(22, '16GB RAM - 512GB SSD - Ryzen 5', 750.00, 1, 1, GETDATE(), 1),
(23, '32GB RAM - 1TB SSD - T550 Video', 1450.00, 1, 1, GETDATE(), 1),
(24, 'TALLA 41 (8.5 US) - Negro/Blanco', 105.00, 1, 1, GETDATE(), 1),
(25, '16GB RAM - 1TB SSD - Pantalla Tactil', 1350.00, 1, 1, GETDATE(), 1);

INSERT INTO [SQM_GENERAL].[Tbl_Stocks] 
(stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId)
VALUES 
(6, 15, '2026-01-10', '2031-01-10', 1, GETDATE(), 1),
(7, 20, '2026-02-12', '2031-02-12', 1, GETDATE(), 1),
(8, 25, '2026-01-15', '2031-01-15', 1, GETDATE(), 1),
(9, 18, '2026-03-01', '2031-03-01', 1, GETDATE(), 1),
(10, 30, '2026-02-20', '2031-02-20', 1, GETDATE(), 1),
(11, 22, '2026-01-18', '2031-01-18', 1, GETDATE(), 1),
(12, 14, '2026-02-05', '2031-02-05', 1, GETDATE(), 1),
(13, 19, '2026-03-10', '2031-03-10', 1, GETDATE(), 1),
(14, 8, '2026-01-22', '2031-01-22', 1, GETDATE(), 1),
(15, 12, '2026-02-15', '2031-02-15', 1, GETDATE(), 1),
(16, 10, '2026-02-28', '2031-02-28', 1, GETDATE(), 1),
(17, 6, '2026-03-05', '2031-03-05', 1, GETDATE(), 1),
(18, 16, '2026-01-30', '2031-01-30', 1, GETDATE(), 1),
(19, 11, '2026-02-14', '2031-02-14', 1, GETDATE(), 1),
(20, 24, '2026-01-25', '2031-01-25', 1, GETDATE(), 1),
(21, 17, '2026-02-11', '2031-02-11', 1, GETDATE(), 1),
(22, 7, '2026-03-02', '2031-03-02', 1, GETDATE(), 1),
(23, 5, '2026-02-25', '2031-02-25', 1, GETDATE(), 1),
(24, 13, '2026-01-29', '2031-01-29', 1, GETDATE(), 1),
(25, 4, '2026-03-12', '2031-03-12', 1, GETDATE(), 1);
GO





-- 1. Insertar Tipos de Variables en Catalogo
INSERT INTO [SQM_CATALOGS].[Tbl_ProductVariableTypes]
    (productVariableTypeName, productVariableTypeDescription, productVariableTypeCreatorId, productVariableTypeCreationDate, productVariableTypeStatusId)
VALUES 
    ('Talla', 'Talla o número de calzado', 1, GETDATE(), 1),         -- ID: 1
    ('Color', 'Color principal del producto', 1, GETDATE(), 1),       -- ID: 2
    ('Memoria RAM', 'Capacidad de Memoria RAM', 1, GETDATE(), 1),    -- ID: 3
    ('Almacenamiento', 'Capacidad de Disco Duro / SSD', 1, GETDATE(), 1),-- ID: 4
    ('Procesador', 'Modelo o serie de Procesador', 1, GETDATE(), 1); -- ID: 5
GO

-- 2. Insertar Atributos para las 29 Variantes Registradas
INSERT INTO [SQM_GENERAL].[Tbl_AttributeProductVariables]
    (attributeProductVariableProductVariableId, attributeProductVariableAttributeProductId, attributeProductVariableValue, attributeProductVariableCreatorId, attributeProductVariableCreationDate, attributeProductVariableStatusId)
VALUES
    -- Variante 1: Ultraboost Talla 42
    (1, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    
    -- Variante 2: Ultraboost Talla 43
    (2, 1, '43 (10 US)', 1, GETDATE(), 1),

    -- Variante 3: Air Max 90 Talla 38
    (3, 1, '38 (7 US)', 1, GETDATE(), 1),

    -- Variante 4: Dell Inspiron 15 (Hardware)
    (4, 3, '8GB', 1, GETDATE(), 1),
    (4, 4, '512GB SSD', 1, GETDATE(), 1),

    -- Variante 5: Nike Air Max 2026
    (5, 1, '9.5 US', 1, GETDATE(), 1),
    (5, 2, 'Negro', 1, GETDATE(), 1),

    -- Variantes 6 y 7: Nike Air Max 90 Casual v2
    (6, 1, '40 (7.5 US)', 1, GETDATE(), 1),
    (6, 2, 'Blanco/Negro', 1, GETDATE(), 1),
    (7, 1, '41 (8.5 US)', 1, GETDATE(), 1),
    (7, 2, 'Total Negro', 1, GETDATE(), 1),

    -- Variante 8: Dell Vostro 3500 Office
    (8, 3, '16GB', 1, GETDATE(), 1),
    (8, 4, '512GB SSD', 1, GETDATE(), 1),
    (8, 5, 'Intel i5', 1, GETDATE(), 1),

    -- Variante 9: Adidas Originals Forum
    (9, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    (9, 2, 'Azul Clásico', 1, GETDATE(), 1),

    -- Variante 10: Nike DefyAllDay
    (10, 1, '40 (7.5 US)', 1, GETDATE(), 1),
    (10, 2, 'Blanco', 1, GETDATE(), 1),

    -- Variante 11: Nike Air Max SYSTM
    (11, 1, '41 (8.5 US)', 1, GETDATE(), 1),
    (11, 2, 'Negro/Gris', 1, GETDATE(), 1),

    -- Variante 12: Nike Court Vision Low
    (12, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    (12, 2, 'Blanco Total', 1, GETDATE(), 1),

    -- Variante 13: Nike Downshifter 12
    (13, 1, '43 (10 US)', 1, GETDATE(), 1),
    (13, 2, 'Azul Marino', 1, GETDATE(), 1),

    -- Variante 14: Adidas Runfalcon 3.0
    (14, 1, '40 (7.5 US)', 1, GETDATE(), 1),
    (14, 2, 'Negro', 1, GETDATE(), 1),

    -- Variante 15: Adidas Grand Court TD
    (15, 1, '41 (8.5 US)', 1, GETDATE(), 1),
    (15, 2, 'Blanco/Negro', 1, GETDATE(), 1),

    -- Variante 16: Adidas Duramo RC
    (16, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    (16, 2, 'Gris', 1, GETDATE(), 1),

    -- Variante 17: Adidas Galaxy 6
    (17, 1, '43 (10 US)', 1, GETDATE(), 1),
    (17, 2, 'Negro/Azul', 1, GETDATE(), 1),

    -- Variante 18: Dell Vostro 3400
    (18, 3, '8GB', 1, GETDATE(), 1),
    (18, 4, '256GB SSD', 1, GETDATE(), 1),
    (18, 5, 'Intel i3', 1, GETDATE(), 1),

    -- Variante 19: Dell Inspiron 3520
    (19, 3, '16GB', 1, GETDATE(), 1),
    (19, 4, '512GB SSD', 1, GETDATE(), 1),
    (19, 5, 'Intel i5', 1, GETDATE(), 1),

    -- Variante 20: Dell Latitude 3420 Pro
    (20, 3, '16GB', 1, GETDATE(), 1),
    (20, 4, '512GB SSD', 1, GETDATE(), 1),

    -- Variante 21: Dell G15 Gaming
    (21, 3, '16GB', 1, GETDATE(), 1),
    (21, 4, '512GB SSD', 1, GETDATE(), 1),

    -- Variante 22: Nike Revolution 6 Flyease
    (22, 1, '41 (8.5 US)', 1, GETDATE(), 1),
    (22, 2, 'Rojo Deportivo', 1, GETDATE(), 1),

    -- Variante 23: Nike Pegasus 40 Premium
    (23, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    (23, 2, 'Edición Pegasus', 1, GETDATE(), 1),

    -- Variante 24: Adidas Superstar Classic
    (24, 1, '42 (9.5 US)', 1, GETDATE(), 1),
    (24, 2, 'Blanco Original', 1, GETDATE(), 1),

    -- Variante 25: Adidas Stan Smith Eco
    (25, 1, '40 (7.5 US)', 1, GETDATE(), 1),
    (25, 2, 'Verde/Blanco', 1, GETDATE(), 1),

    -- Variante 26: Dell Inspiron 16 Ryzen 5
    (26, 3, '16GB', 1, GETDATE(), 1),
    (26, 4, '512GB SSD', 1, GETDATE(), 1),
    (26, 5, 'AMD Ryzen 5', 1, GETDATE(), 1),

    -- Variante 27: Dell Precision 3580 Workstation
    (27, 3, '32GB', 1, GETDATE(), 1),
    (27, 4, '1TB SSD', 1, GETDATE(), 1),

    -- Variante 28: Nike Air Max Excee
    (28, 1, '41 (8.5 US)', 1, GETDATE(), 1),
    (28, 2, 'Negro/Blanco', 1, GETDATE(), 1),

    -- Variante 29: Dell XPS 13 Ultrabook
    (29, 3, '16GB', 1, GETDATE(), 1),
    (29, 4, '1TB SSD', 1, GETDATE(), 1);
GO