using System;

namespace DOMAIN.Marks
{
    public class DM_MarksListar
    {
        public int? MarcaID { get; set; }
        public string? Marca { get; set; }
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
