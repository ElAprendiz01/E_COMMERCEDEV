USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovementDetails_Filter]
    @MovementId INT = NULL,
    @SearchTerm VARCHAR(50) = NULL
AS 
BEGIN
    SET NOCOUNT ON;

   
    DECLARE @SearchDate DATETIME = TRY_CAST(@SearchTerm AS DATETIME);

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

        RegistradoPorNombre,
        ModificadoPorNombre,
        FechaUltimaModificacion
    FROM [SQM_GENERAL].[v_StockMovementDetails_Complete] WITH (NOLOCK)
    WHERE 

        (@MovementId IS NULL OR MovimientoId = @MovementId)
        
      
        AND (
            @SearchTerm IS NULL
            OR ProductoNombre LIKE '%' + @SearchTerm + '%'
            OR Categoria LIKE '%' + @SearchTerm + '%'
            OR Marca LIKE '%' + @SearchTerm + '%'
            OR Proveedor LIKE '%' + @SearchTerm + '%'
            OR ClienteNombreCompleto LIKE '%' + @SearchTerm + '%'
            OR TipoMovimiento LIKE '%' + @SearchTerm + '%'
            OR ReferenciaMovimiento LIKE '%' + @SearchTerm + '%'
            OR PedidoId LIKE '%' + @SearchTerm + '%'
            OR DetalleMovimientoId LIKE '%' + @SearchTerm + '%'
            OR DetalleActivo LIKE '%' + @SearchTerm + '%'
            OR (@SearchDate IS NOT NULL AND (
                -- Filtra ignorando las horas, comparando solo Año-Mes-Día
                CONVERT(DATE, FechaFabricacionLote) = CONVERT(DATE, @SearchDate)
                OR CONVERT(DATE, FechaExpiracionLote) = CONVERT(DATE, @SearchDate)
                OR CONVERT(DATE, FechaRegistroDetalle) = CONVERT(DATE, @SearchDate)
                OR CONVERT(DATE, FechaMovimiento) = CONVERT(DATE, @SearchDate)
            ))
			
        )
        
    OPTION (RECOMPILE);
END
GO



EXEC [SQM_GENERAL].[sp_StockMovementDetails_Filter]



EXEC [SQM_GENERAL].[sp_StockMovementDetails_Filter] @MovementId= 3


SELECT * FROM [SQM_GENERAL].[Tbl_StockMovements] WHERE stockMovementId = 1;