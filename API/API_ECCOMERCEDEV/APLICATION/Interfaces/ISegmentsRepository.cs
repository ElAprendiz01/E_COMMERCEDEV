using DOMAIN.Segments;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface ISegmentsRepository
    {
        Task<IEnumerable<DM_Segments_listar>> Listar_SegmentsAsync();
        Task<IEnumerable<DM_Segments_filtrar>> Filtrar_SegmentsAsync(string? searchTerm);
        Task<OUTPUT> Insertar_SegmentsAsync(DM_Segments_insertar modelo);
        Task<OUTPUT> Editar_SegmentsAsync(DM_Segments_actualizar modelo);
        Task<OUTPUT> Eliminar_SegmentsAsync(int? segmentId, int? segmentModificatorId);
    }
}
