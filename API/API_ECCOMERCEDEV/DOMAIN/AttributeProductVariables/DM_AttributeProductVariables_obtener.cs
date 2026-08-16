using System;

namespace DOMAIN.AttributeProductVariables
{
    public class DM_AttributeProductVariables_obtener
    {
        public int? IdAtributoVariable { get; set; }
        public string? ValorAtributo { get; set; }
        public bool? RegistroActivo { get; set; }
        public int? IdTipoVariable { get; set; }
        public string? TipoVariable { get; set; }
        public string? DescripcionTipoVariable { get; set; }
        public int? IdVariante { get; set; }
        public string? ValorVariante { get; set; }
        public decimal? PrecioVariante { get; set; }
        public string? CodigoMoneda { get; set; }
        public string? NombreMoneda { get; set; }
        public int? IdProducto { get; set; }
        public string? NombreProducto { get; set; }
        public string? DescripcionProducto { get; set; }
        public string? NombreMarca { get; set; }
        public string? NombreProveedor { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public string? CreadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public int? ModificadoPor { get; set; }
    }
}
