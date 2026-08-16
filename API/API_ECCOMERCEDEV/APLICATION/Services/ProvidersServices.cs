using APLICATION.DTOs.Providers;
using APLICATION.Interfaces;
using DOMAIN.Providers;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class ProvidersServices
    {
        private readonly IProvidersRepository _repository;

        public ProvidersServices(IProvidersRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Providers_listar>> Listar_Providers_async()
        {
            return await _repository.Listar_ProvidersAsync();
        }

        public async Task<IEnumerable<DM_Providers_filtrar>> Filtrar_Providers_async(ProvidersFilterDTOs dto)
        {
            return await _repository.Filtrar_ProvidersAsync(dto.SearchTerm, dto.providerId);
        }

        public async Task<OUTPUT> Insertar_Providers_async(ProvidersinsertarDTOs dto)
        {
            var modelo = new DM_Providers_insertar
            {
                providerName = dto.providerName,
                providerDescription = dto.providerDescription,
                providerCreatorId = dto.providerCreatorId,
                providerStatusId = dto.providerStatusId
            };
            return await _repository.Insertar_ProvidersAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Providers_async(ProvidersEditarDTOs dto)
        {
            var modelo = new DM_Providers_actualizar
            {
                providerId = dto.providerId,
                providerName = dto.providerName,
                providerDescription = dto.providerDescription,
                providerModificatorId = dto.providerModificatorId,
                providerStatusId = dto.providerStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_ProvidersAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Providers_async(int? providerId, int? providerModificatorId)
        {
            return await _repository.Eliminar_ProvidersAsync(providerId, providerModificatorId);
        }
    }
}
