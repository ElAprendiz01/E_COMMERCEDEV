using System;

namespace DOMAIN.Currencies
{
    public class DM_CurrenciesFiltrar
    {
        public int? MonedaID { get; set; }
        public string? Moneda { get; set; }
        public string? ISO { get; set; }
        public int? CodigoNumerico { get; set; }
        public string? Descripcion { get; set; }
        public int? CreadorID { get; set; }
        public string? CreadorNombre { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public int? ModificadorID { get; set; }
        public string? ModificadorNombre { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public bool? EstadoID { get; set; }
        public string? Estado { get; set; }
    }
}
