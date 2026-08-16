using APLICATION.DTOs.StockMovementTypes;
using APLICATION.Interfaces;
using DOMAIN.StockMovementTypes;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class StockMovementTypesServices
    {
        private readonly IStockMovementTypesRepository _repository;

        public StockMovementTypesServices(IStockMovementTypesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_StockMovementTypesListar>> Listar_StockMovementTypes_async()
        {
            return await _repository.Listar_StockMovementTypesAsync();
        }

        public async Task<IEnumerable<DM_StockMovementTypesFiltrar>> Filtrar_StockMovementTypes_async(StockMovementTypesFilterDTOs dto)
        {
            var modelo = new DM_StockMovementTypesFiltrar
            {
                StockMovementTypeId = dto.StockMovementTypeId,
                StockMovementTypeName = dto.StockMovementTypeName,
                StockMovementTypeDescription = dto.StockMovementTypeDescription,
                StockMovementTypeCreatorId = dto.StockMovementTypeCreatorId,
                StockMovementTypeCreationDate = dto.StockMovementTypeCreationDate,
                StockMovementTypeModificatorId = dto.StockMovementTypeModificatorId,
                StockMovementTypeModificationDate = dto.StockMovementTypeModificationDate,
                StockMovementTypeStatusId = dto.StockMovementTypeStatusId
            };
            return await _repository.Filtrar_StockMovementTypesAsync(modelo);
        }

        public async Task<OUTPUT> Insertar_StockMovementTypes_async(StockMovementTypesInsertarDTOs dto)
        {
            var modelo = new DM_StockMovementTypesInsertar
            {
                StockMovementTypeName = dto.StockMovementTypeName,
                StockMovementTypeDescription = dto.StockMovementTypeDescription,
                StockMovementTypeCreatorId = dto.StockMovementTypeCreatorId,
                StockMovementTypeStatusId = dto.StockMovementTypeStatusId
            };
            return await _repository.Insertar_StockMovementTypesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_StockMovementTypes_async(StockMovementTypesEditarDTOs dto)
        {
            var modelo = new DM_StockMovementTypesEditar
            {
                StockMovementTypeId = dto.StockMovementTypeId,
                StockMovementTypeName = dto.StockMovementTypeName,
                StockMovementTypeDescription = dto.StockMovementTypeDescription,
                StockMovementTypeModificatorId = dto.StockMovementTypeModificatorId,
                StockMovementTypeStatusId = dto.StockMovementTypeStatusId
            };
            return await _repository.Editar_StockMovementTypesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_StockMovementTypes_async(int? stockMovementTypeId, int? stockMovementTypeModificatorId)
        {
            return await _repository.Eliminar_StockMovementTypesAsync(stockMovementTypeId, stockMovementTypeModificatorId);
        }
    }
}
