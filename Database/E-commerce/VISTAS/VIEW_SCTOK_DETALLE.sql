USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[v_StockMovementDetails_Complete]
AS
SELECT 
    -- 1. DETALLES DEL MOVIMIENTO ESPECÍFICO (Kardex Fila)
    SMD.stockMovementDetailId AS DetalleMovimientoId,
    SMD.stockMovementDetailQuantity AS CantidadMovida,
    SMD.stockMovementDetailFactoryDate AS FechaFabricacionLote,
    SMD.stockMovementDetailExpirationDate AS FechaExpiracionLote,
    SMD.stockMovementDetailCreationDate AS FechaRegistroDetalle,
    SMD.stockMovementDetailStatusId AS DetalleActivo,

    -- 2. CABECERA DEL MOVIMIENTO DE STOCK
    SM.stockMovementId AS MovimientoId,
    SMT.stockMovementTypeName AS TipoMovimiento,
    SMT.stockMovementTypeDescription AS TipoMovimientoDescripcion,
    SM.stockMovementReference AS ReferenciaMovimiento,
    SM.stockMovementDate AS FechaMovimiento,
    SMS.statusName AS EstadoMovimiento,

    -- 3. DETALLE DEL PRODUCTO Y SU VARIANTE
    PV.productVariableId AS VarianteId,
    P.productName AS ProductoNombre,
    PV.productVariableValue AS VarianteEspecificacion, -- Ej: Talla M, Color Azul
    PV.productVariablePrice AS VariantePrecioUnitario,
    C.currencyISO AS VarianteMoneda,
    P.productDescription AS ProductoDescripcion,

    -- 4. CLASIFICACIÓN DEL PRODUCTO Y MARCAS
    CAT.categoryName AS Categoria,
    SUBCAT.subCategoryName AS SubCategoria,
    SEG.segmentName AS Segmento,
    M.markName AS Marca,
    PROV.providerName AS Proveedor,

    -- 5. INFORMACIÓN DEL PEDIDO (Si aplica / Left Join)
    PO.orderId AS PedidoId,
    POD.orderDetailQuantity AS PedidoCantidadSolicitada,
    POD.orderDetailTotal AS PedidoSubtotalFila,
    PO.orderCreationDate AS PedidoFechaCreacion,
    POS.statusName AS PedidoEstado,

    -- 6. CLIENTE QUE COMPRÓ (Si aplica / Left Join)
    U_CLIENT.userId AS ClienteId,
    U_CLIENT.userFullName AS ClienteNombreCompleto,
    U_CLIENT.userEmail AS ClienteEmail,
    UA.userAddressZIPCode AS DireccionEnvioZIP,
    UA.userAddressDescription AS DireccionEnvioDetalle,

    -- 7. AUDITORÍA (Quién hizo cada acción)
    U_CREATOR_D.userFullName AS RegistradoPorNombre,
    U_MODIFIER_D.userFullName AS ModificadoPorNombre,
    SMD.stockMovementDetailModificationDate AS FechaUltimaModificacion

FROM [SQM_GENERAL].[Tbl_StockMovementDetails] SMD

-- Conexión con Cabecera de Movimiento y su Tipo/Estado
INNER JOIN [SQM_GENERAL].[Tbl_StockMovements] SM 
    ON SMD.stockMovementDetailMovementId = SM.stockMovementId
INNER JOIN [SQM_CATALOGS].[Tbl_StockMovementTypes] SMT 
    ON SM.stockMovementType = SMT.stockMovementTypeId
INNER JOIN [SQM_CATALOGS].[Tbl_Status] SMS 
    ON SM.stockMovementStatusId = SMS.statusId

-- Conexión con Tbl_Stocks (de donde sale el producto real)
LEFT JOIN [SQM_GENERAL].[Tbl_Stocks] ST 
    ON SMD.stockMovementDetailStockId = ST.stockId

-- Conexión con la Variante de Producto e Información del Producto Base
INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] PV 
    ON ST.stockProductVariableId = PV.productVariableId OR PV.productVariableId = (
        -- Fallback por si la relación es por detalle de orden
        SELECT TOP 1 orderDetailProductVariableId 
        FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] 
        WHERE orderDetailId = SMD.stockMovementDetailOrderDetailId
    )
INNER JOIN [SQM_GENERAL].[Tbl_Products] P 
    ON PV.productVariableProductId = P.productId
INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] C 
    ON PV.productVariableCurrencyId = C.currencyId

-- Clasificación, Marcas y Proveedores
INNER JOIN [SQM_CATALOGS].[Tbl_ProductIdentificators] PI 
    ON P.productProductIdentificatorId = PI.productIdentificatorId
INNER JOIN [SQM_CATALOGS].[Tbl_Categories] CAT 
    ON PI.productIdentificatorCategoryId = CAT.categoryId
INNER JOIN [SQM_CATALOGS].[Tbl_SubCategories] SUBCAT 
    ON PI.productIdentificatorSubCategoryId = SUBCAT.subCategoryId
INNER JOIN [SQM_CATALOGS].[Tbl_Segments] SEG 
    ON PI.productIdentificatorSegmentId = SEG.segmentId
INNER JOIN [SQM_CATALOGS].[Tbl_MarkByProviders] MBP 
    ON P.productMarkByProviderId = MBP.markByProviderId
INNER JOIN [SQM_CATALOGS].[Tbl_Marks] M 
    ON MBP.markByProviderMarkId = M.markId
INNER JOIN [SQM_CATALOGS].[Tbl_Providers] PROV 
    ON MBP.markByProviderProviderId = PROV.providerId

-- Conexión opcional con Detalles de Orden de Pago y Pedidos
LEFT JOIN [SQM_GENERAL].[Tbl_PaymentOrderDetails] POD 
    ON SMD.stockMovementDetailOrderDetailId = POD.orderDetailId
LEFT JOIN [SQM_GENERAL].[Tbl_PaymentOrders] PO 
    ON POD.orderDetailOrderId = PO.orderId
LEFT JOIN [SQM_CATALOGS].[Tbl_Status] POS 
    ON PO.orderStatusId = POS.statusId

-- Conexión opcional con el Cliente comprador y su dirección utilizada
LEFT JOIN [SQM_SECURITY].[Tbl_Users] U_CLIENT 
    ON PO.orderUserId = U_CLIENT.userId
LEFT JOIN [SQM_GENERAL].[Tbl_UserAddress] UA 
    ON PO.orderDeliveryAddress = UA.userAddressId

-- Usuarios de Auditoría (Creadores y Modificadores del Detalle del Movimiento)
INNER JOIN [SQM_SECURITY].[Tbl_Users] U_CREATOR_D 
    ON SMD.stockMovementDetailCreatorId = U_CREATOR_D.userId
LEFT JOIN [SQM_SECURITY].[Tbl_Users] U_MODIFIER_D 
    ON SMD.stockMovementDetailModifierId = U_MODIFIER_D.userId;
GO



select * from  [SQM_GENERAL].[v_StockMovementDetails_Complete]


select * from  [SQM_GENERAL].[v_StockMovementDetails_Complete]

SELECT * FROM [SQM_GENERAL].[v_StockMovementDetails_Complete] 
WHERE MovimientoId = 3;