using System;

namespace APLICATION.DTOs.StockMovements
{
    public class StockMovementsListarDTOs
    {
        public int? MovimientoID { get; set; }
        public string? Referencia { get; set; }
        public DateTime? FechaMovimiento { get; set; }
        public DateTime? FechaRegistro { get; set; }
        public int? TipoMovimientoID { get; set; }
        public string? TipoMovimiento { get; set; }
        public string? DescripcionTipo { get; set; }
        public int? OrdenPagoID { get; set; }
        public string? DetalleOrden { get; set; }
        public int? CreadorID { get; set; }
        public string? CreadorNombre { get; set; }
        public string? CreadorUsuario { get; set; }
        public int? ModificadorID { get; set; }
        public string? ModificadorNombre { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public int? EstadoID { get; set; }
        public string? Estado { get; set; }
    }
}
