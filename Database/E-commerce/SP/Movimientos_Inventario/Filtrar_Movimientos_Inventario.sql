USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovements_Filter]
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);
    DECLARE @SearchDate DATETIME = TRY_CAST(@SearchTerm AS DATETIME);

    SELECT 
        MovimientoID,
        Referencia,
        FechaMovimiento,
        FechaRegistro,
        TipoMovimientoID,
        TipoMovimiento,
        DescripcionTipo,
        OrdenPagoID,
        DetalleOrden,
        CreadorID,
        CreadorNombre,
        CreadorUsuario,
        ModificadorID,
        ModificadorNombre,
        FechaModificacion,
        EstadoID,
        Estado
    FROM [SQM_GENERAL].[vw_StockMovements_Detailed] (NOLOCK)
    WHERE 
        @SearchTerm IS NULL
        OR MovimientoID = @SearchId
        OR TipoMovimientoID = @SearchId
        OR OrdenPagoID = @SearchId
        OR EstadoID = @SearchId
        OR Referencia LIKE '%' + @SearchTerm + '%'
        OR (@SearchDate IS NOT NULL AND (
            CONVERT(DATE, FechaMovimiento) = CONVERT(DATE, @SearchDate)
            OR CONVERT(DATE, FechaRegistro) = CONVERT(DATE, @SearchDate)
        ))
    OPTION (RECOMPILE);
END
GO

EXEC [SQM_GENERAL].[sp_StockMovements_Filter];
GO