USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_GetClientCart]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;


    -- Retornar el detalle de su carrito activo
    SELECT 
        DetalleCarritoId,
        CarritoId,
        UsuarioClienteId,
        VarianteId,
        ProductoId,
        ProductoNombre,
        ProductoDescripcion,
        VarianteEspecificacion,
        ProductoImagenUrl,
        PrecioUnitario,
        Cantidad,
        DescuentoFila,
        SubTotalFila,
        ImpuestoFila,
        TotalFila,
        MonedaISO,
        MonedaNombre
    FROM [SQM_GENERAL].[v_ClientCartDetails_Complete] WITH (NOLOCK)
    WHERE UsuarioClienteId = @UserId 
      AND DetalleActivo = 1 -- Solo traer lo que está activo actualmente en el carrito
    ORDER BY DetalleCarritoId DESC; -- Los más recientes agregados primero
END
GO

exec  [SQM_GENERAL].[sp_GetClientCart] @UserId=1