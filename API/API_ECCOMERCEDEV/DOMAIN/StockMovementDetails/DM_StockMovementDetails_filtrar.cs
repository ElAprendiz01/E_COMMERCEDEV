using System;

namespace DOMAIN.StockMovementDetails
{
    public class DM_StockMovementDetails_filtrar
    {
        public int? DetalleMovimientoId { get; set; }
        public int? CantidadMovida { get; set; }
        public DateTime? FechaFabricacionLote { get; set; }
        public DateTime? FechaExpiracionLote { get; set; }
        public DateTime? FechaRegistroDetalle { get; set; }
        public bool? DetalleActivo { get; set; }
        public int? MovimientoId { get; set; }
        public string? TipoMovimiento { get; set; }
        public string? TipoMovimientoDescripcion { get; set; }
        public string? ReferenciaMovimiento { get; set; }
        public DateTime? FechaMovimiento { get; set; }
        public string? EstadoMovimiento { get; set; }
        public int? VarianteId { get; set; }
        public string? ProductoNombre { get; set; }
        public string? VarianteEspecificacion { get; set; }
        public decimal? VariantePrecioUnitario { get; set; }
        public string? VarianteMoneda { get; set; }
        public string? ProductoDescripcion { get; set; }
        public string? Categoria { get; set; }
        public string? SubCategoria { get; set; }
        public string? Segmento { get; set; }
        public string? Marca { get; set; }
        public string? Proveedor { get; set; }
        public int? PedidoId { get; set; }
        public int? PedidoCantidadSolicitada { get; set; }
        public decimal? PedidoSubtotalFila { get; set; }
        public DateTime? PedidoFechaCreacion { get; set; }
        public string? PedidoEstado { get; set; }
        public int? ClienteId { get; set; }
        public string? ClienteNombreCompleto { get; set; }
        public string? ClienteEmail { get; set; }
        public string? DireccionEnvioZIP { get; set; }
        public string? DireccionEnvioDetalle { get; set; }
        public string? RegistradoPorNombre { get; set; }
        public string? ModificadoPorNombre { get; set; }
        public DateTime? FechaUltimaModificacion { get; set; }
    }
}
