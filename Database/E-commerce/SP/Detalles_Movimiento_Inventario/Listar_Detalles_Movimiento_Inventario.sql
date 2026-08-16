USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovementDetails_List]
AS 
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- 1. Detalle del Movimiento (Kardex Fila)
        DetalleMovimientoId,
        CantidadMovida,
        FechaFabricacionLote,
        FechaExpiracionLote,
        FechaRegistroDetalle,
        DetalleActivo,

        -- 2. Cabecera del Movimiento
        MovimientoId,
        TipoMovimiento,
        TipoMovimientoDescripcion,
        ReferenciaMovimiento,
        FechaMovimiento,
        EstadoMovimiento,

        -- 3. Producto y Variante
        VarianteId,
        ProductoNombre,
        VarianteEspecificacion,
        VariantePrecioUnitario,
        VarianteMoneda,
        ProductoDescripcion,

        -- 4. Clasificación y Marcas
        Categoria,
        SubCategoria,
        Segmento,
        Marca,
        Proveedor,

        -- 5. Pedido Asociado
        PedidoId,
        PedidoCantidadSolicitada,
        PedidoSubtotalFila,
        PedidoFechaCreacion,
        PedidoEstado,

        -- 6. Cliente y Envío
        ClienteId,
        ClienteNombreCompleto,
        ClienteEmail,
        DireccionEnvioZIP,
        DireccionEnvioDetalle,

        -- 7. Auditoría
        RegistradoPorNombre,
        ModificadoPorNombre,
        FechaUltimaModificacion
    FROM [SQM_GENERAL].[v_StockMovementDetails_Complete] WITH (NOLOCK)
    ORDER BY FechaMovimiento DESC, DetalleMovimientoId DESC; -- Ordenado por lo más reciente primero
END
GO


EXEC [SQM_GENERAL].[sp_StockMovementDetails_List]