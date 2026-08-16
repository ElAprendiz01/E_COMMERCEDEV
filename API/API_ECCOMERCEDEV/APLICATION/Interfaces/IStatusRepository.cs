using DOMAIN.Status;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IStatusRepository
    {
        Task<OUTPUT> Insertar_StatusAsync(DM_StatusInsertar modelo);
        Task<OUTPUT> Editar_StatusAsync(DM_StatusEditar modelo);
        Task<OUTPUT> Eliminar_StatusAsync(int? statusId);
        Task<IEnumerable<DM_StatusListar>> Listar_StatusAsync();
        Task<IEnumerable<DM_StatusFiltrar>> Filtrar_StatusAsync(DM_StatusFilter filtro);
    }
}
