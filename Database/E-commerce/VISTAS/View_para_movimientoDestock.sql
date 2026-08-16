USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[vw_StockMovements_Detailed]
AS
SELECT 
    -- 1. Datos Principales del Movimiento
    SM.stockMovementId AS [MovimientoID],
    SM.stockMovementReference AS [Referencia],
    SM.stockMovementDate AS [FechaMovimiento],
    SM.stockMovementCreationDate AS [FechaRegistro],

    -- 2. Tipo de Movimiento
    SM.stockMovementType AS [TipoMovimientoID],
    SMT.stockMovementTypeName AS [TipoMovimiento],
    SMT.stockMovementTypeDescription AS [DescripcionTipo],

    -- 3. Orden de Pago Asociada (Puede ser NULL)
    SM.stockMovementOrderId AS [OrdenPagoID],
    CONCAT('Orden #', SM.stockMovementOrderId, ' - Total: ', O.orderTotal, ' ', C.currencyISO) AS [DetalleOrden],

    -- 4. Datos del Usuario Creador
    SM.stockMovementCreatorId AS [CreadorID],
    UC.userFullName AS [CreadorNombre],
    UC.userName AS [CreadorUsuario],

    -- 5. Datos del Usuario Modificador (Puede ser NULL)
    SM.stockMovementModifierId AS [ModificadorID],
    UM.userFullName AS [ModificadorNombre],
    SM.stockMovementModificationDate AS [FechaModificacion],

    -- 6. Estado del Movimiento
    SM.stockMovementStatusId AS [EstadoID],
    S.statusName AS [Estado]

FROM [SQM_GENERAL].[Tbl_StockMovements] SM

-- Unión con Tipo de Movimiento
INNER JOIN [SQM_CATALOGS].[Tbl_StockMovementTypes] SMT 
    ON SM.stockMovementType = SMT.stockMovementTypeId

-- Unión con Usuarios (Creador)
INNER JOIN [SQM_SECURITY].[Tbl_Users] UC 
    ON SM.stockMovementCreatorId = UC.userId

-- Unión con Catálogo de Estados generales
INNER JOIN [SQM_CATALOGS].[Tbl_Status] S 
    ON SM.stockMovementStatusId = S.statusId

-- Unión con Órdenes de Pago (LEFT JOIN porque es opcional) asi el inner join no se quiebra 
LEFT JOIN [SQM_GENERAL].[Tbl_PaymentOrders] O 
    ON SM.stockMovementOrderId = O.orderId

-- Unión con Monedas de la Orden para armar el detalle descriptivo
LEFT JOIN [SQM_CATALOGS].[Tbl_Currencies] C 
    ON O.orderCurrencyId = C.currencyId

-- Unión con Usuarios (Modificador - LEFT JOIN porque puede ser NULL) digo yo que es mejor jajaj
LEFT JOIN [SQM_SECURITY].[Tbl_Users] UM 
    ON SM.stockMovementModifierId = UM.userId;
GO



select * from [SQM_GENERAL].[vw_StockMovements_Detailed]