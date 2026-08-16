using APLICATION.DTOs.StockMovements;
using APLICATION.Interfaces;
using DOMAIN.StockMovements;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class StockMovementsServices
    {
        private readonly IStockMovementsRepository _repository;

        public StockMovementsServices(IStockMovementsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_StockMovements_listar>> Listar_StockMovements_async()
        {
            return await _repository.Listar_StockMovementsAsync();
        }

        public async Task<IEnumerable<DM_StockMovements_filtrar>> Filtrar_StockMovements_async(string? searchTerm)
        {
            return await _repository.Filtrar_StockMovementsAsync(searchTerm);
        }

        public async Task<OUTPUT> Insertar_StockMovements_async(StockMovementsInsertarDTOs dto)
        {
            var modelo = new DM_StockMovements_insertar
            {
                stockMovementType = dto.stockMovementType,
                stockMovementOrderId = dto.stockMovementOrderId,
                stockMovementReference = dto.stockMovementReference,
                stockMovementDate = dto.stockMovementDate,
                stockMovementCreatorId = dto.stockMovementCreatorId,
                stockMovementStatusId = dto.stockMovementStatusId
            };
            return await _repository.Insertar_StockMovementsAsync(modelo);
        }
    }
}
