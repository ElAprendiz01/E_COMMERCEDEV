using APLICATION.DTOs.Status;
using APLICATION.Interfaces;
using DOMAIN.Status;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class StatusServices
    {
        private readonly IStatusRepository _repository;

        public StatusServices(IStatusRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_StatusListar>> Listar_Status_async()
        {
            return await _repository.Listar_StatusAsync();
        }

        public async Task<IEnumerable<DM_StatusFiltrar>> Filtrar_Status_async(StatusFilterDTOs dto)
        {
            var modelo = new DM_StatusFilter
            {
                statusId = dto.statusId,
                statusName = dto.statusName,
                statusCreatorId = dto.statusCreatorId,
                statusCreationDate = dto.statusCreationDate,
                statusStatusId = dto.statusStatusId
            };
            return await _repository.Filtrar_StatusAsync(modelo);
        }

        public async Task<OUTPUT> Insertar_Status_async(StatusInsertarDTOs dto)
        {
            var modelo = new DM_StatusInsertar
            {
                statusName = dto.statusName,
                statusCreatorId = dto.statusCreatorId,
                statusStatusId = dto.statusStatusId
            };
            return await _repository.Insertar_StatusAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Status_async(StatusEditarDTOs dto)
        {
            var modelo = new DM_StatusEditar
            {
                statusId = dto.statusId,
                statusName = dto.statusName,
                statusStatusId = dto.statusStatusId
            };
            return await _repository.Editar_StatusAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Status_async(int? statusId)
        {
            return await _repository.Eliminar_StatusAsync(statusId);
        }
    }
}
