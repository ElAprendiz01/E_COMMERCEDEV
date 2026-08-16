USE [DB_ECOMMERCE]
GO

-- 2. LISTAR
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovements_List]
AS 
BEGIN
    SET NOCOUNT ON;

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
    FROM [SQM_GENERAL].[vw_StockMovements_Detailed] (NOLOCK);

END
GO

exec[SQM_GENERAL].[sp_StockMovements_List]