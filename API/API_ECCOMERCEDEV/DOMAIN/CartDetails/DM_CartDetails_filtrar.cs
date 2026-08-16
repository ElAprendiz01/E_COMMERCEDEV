namespace DOMAIN.CartDetails
{
    public class DM_CartDetails_filtrar
    {
        public int? DetalleCarritoId { get; set; }
        public int? CarritoId { get; set; }
        public int? UsuarioClienteId { get; set; }
        public int? VarianteId { get; set; }
        public int? ProductoId { get; set; }
        public string? ProductoNombre { get; set; }
        public string? ProductoDescripcion { get; set; }
        public string? VarianteEspecificacion { get; set; }
        public string? ProductoImagenUrl { get; set; }
        public decimal? PrecioUnitario { get; set; }
        public int? Cantidad { get; set; }
        public decimal? DescuentoFila { get; set; }
        public decimal? SubTotalFila { get; set; }
        public decimal? ImpuestoFila { get; set; }
        public decimal? TotalFila { get; set; }
        public string? MonedaISO { get; set; }
        public string? MonedaNombre { get; set; }
    }
}
