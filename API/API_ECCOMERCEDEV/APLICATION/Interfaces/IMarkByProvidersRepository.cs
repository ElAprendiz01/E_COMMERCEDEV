using DOMAIN.MarkByProviders;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IMarkByProvidersRepository
    {
        Task<OUTPUT> Insertar_MarkByProvidersAsync(DM_MarkByProviders_insertar modelo);
        Task<OUTPUT> Editar_MarkByProvidersAsync(DM_MarkByProviders_actualizar modelo);
        Task<OUTPUT> Eliminar_MarkByProvidersAsync(int markByProviderId, int markByProviderModificatorId);
        Task<IEnumerable<DM_MarkByProviders_listar>> Listar_MarkByProvidersAsync();
        Task<IEnumerable<DM_MarkByProviders_filtrar>> Filtrar_MarkByProvidersAsync(DM_MarkByProviders_filtrar filtro);
    }
}
