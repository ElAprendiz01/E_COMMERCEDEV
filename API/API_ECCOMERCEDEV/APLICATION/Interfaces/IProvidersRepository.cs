using DOMAIN.Providers;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IProvidersRepository
    {
        Task<IEnumerable<DM_Providers_listar>> Listar_ProvidersAsync();
        Task<IEnumerable<DM_Providers_filtrar>> Filtrar_ProvidersAsync(string? searchTerm, int? providerId);
        Task<OUTPUT> Insertar_ProvidersAsync(DM_Providers_insertar modelo);
        Task<OUTPUT> Editar_ProvidersAsync(DM_Providers_actualizar modelo);
        Task<OUTPUT> Eliminar_ProvidersAsync(int? providerId, int? providerModificatorId);
    }
}
