using DOMAIN.Marks;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IMarksRepository
    {
        Task<IEnumerable<DM_Marks_listar>> Listar_MarksAsync();
        Task<IEnumerable<DM_Marks_filtrar>> Filtrar_MarksAsync(string? searchTerm);
        Task<OUTPUT> Insertar_MarksAsync(DM_Marks_insertar modelo);
        Task<OUTPUT> Editar_MarksAsync(DM_Marks_actualizar modelo);
        Task<OUTPUT> Eliminar_MarksAsync(int? markId, int? markModificatorId);
    }
}
