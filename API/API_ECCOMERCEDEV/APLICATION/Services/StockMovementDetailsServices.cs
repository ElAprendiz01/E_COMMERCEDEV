using APLICATION.DTOs.StockMovementDetails;
using APLICATION.Interfaces;
using DOMAIN.StockMovementDetails;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class StockMovementDetailsServices
    {
        private readonly IStockMovementDetailsRepository _repository;

        public StockMovementDetailsServices(IStockMovementDetailsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_StockMovementDetails_listar>> Listar_StockMovementDetails_async()
        {
            return await _repository.Listar_StockMovementDetailsAsync();
        }

        public async Task<IEnumerable<DM_StockMovementDetails_filtrar>> Filtrar_StockMovementDetails_async(StockMovementDetailsFilterDTOs dto)
        {
            return await _repository.Filtrar_StockMovementDetailsAsync(dto.MovementId, dto.SearchTerm);
        }
    }
}
