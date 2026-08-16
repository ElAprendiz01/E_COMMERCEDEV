using APLICATION.DTOs.MarkByProviders;
using APLICATION.Interfaces;
using DOMAIN.MarkByProviders;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class MarkByProvidersServices
    {
        private readonly IMarkByProvidersRepository _repository;

        public MarkByProvidersServices(IMarkByProvidersRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_MarkByProviders_async(MarkByProvidersInsertarDTOs dto)
        {
            var modelo = new DM_MarkByProviders_insertar
            {
                MarkByProviderMarkId = dto.MarkByProviderMarkId,
                MarkByProviderProviderId = dto.MarkByProviderProviderId,
                MarkByProviderCreatorId = dto.MarkByProviderCreatorId,
                MarkByProviderStatusId = dto.MarkByProviderStatusId
            };

            return await _repository.Insertar_MarkByProvidersAsync(modelo);
        }

        public async Task<OUTPUT> Editar_MarkByProviders_async(MarkByProvidersActualizarDTOs dto)
        {
            var modelo = new DM_MarkByProviders_actualizar
            {
                MarkByProviderId = dto.MarkByProviderId,
                MarkByProviderMarkId = dto.MarkByProviderMarkId,
                MarkByProviderProviderId = dto.MarkByProviderProviderId,
                MarkByProviderModificatorId = dto.MarkByProviderModificatorId,
                MarkByProviderStatusId = dto.MarkByProviderStatusId
            };

            return await _repository.Editar_MarkByProvidersAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_MarkByProviders_async(int markByProviderId, int markByProviderModificatorId)
        {
            return await _repository.Eliminar_MarkByProvidersAsync(markByProviderId, markByProviderModificatorId);
        }

        public async Task<IEnumerable<DM_MarkByProviders_listar>> Listar_MarkByProviders()
        {
            return await _repository.Listar_MarkByProvidersAsync();
        }

        public async Task<IEnumerable<DM_MarkByProviders_filtrar>> Filtrar_MarkByProviders(MarkByProvidersFiltrarDTOs dto)
        {
            var modelo = new DM_MarkByProviders_filtrar
            {
                MarkByProviderId = dto.MarkByProviderId,
                MarkByProviderMarkId = dto.MarkByProviderMarkId,
                MarkByProviderProviderId = dto.MarkByProviderProviderId,
                MarkByProviderCreatorId = dto.MarkByProviderCreatorId,
                MarkByProviderCreationDate = dto.MarkByProviderCreationDate,
                MarkByProviderModificatorId = dto.MarkByProviderModificatorId,
                MarkByProviderModificationDate = dto.MarkByProviderModificationDate,
                MarkByProviderStatusId = dto.MarkByProviderStatusId
            };

            return await _repository.Filtrar_MarkByProvidersAsync(modelo);
        }
    }
}
