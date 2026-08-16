using APLICATION.DTOs.PriceHistory;
using APLICATION.Interfaces;
using DOMAIN.PriceHistory;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class PriceHistoryServices
    {
        private readonly IPriceHistoryRepository _repository;

        public PriceHistoryServices(IPriceHistoryRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_PriceHistoryListar>> Listar_PriceHistory_async()
        {
            return await _repository.Listar_PriceHistoryAsync();
        }

        public async Task<IEnumerable<DM_PriceHistoryFiltrar>> Filtrar_PriceHistory_async(PriceHistoryFilterDTOs dto)
        {
            var modelo = new DM_PriceHistoryFiltrar
            {
                PriceHistoryId = dto.PriceHistoryId,
                PriceHistoryProductVariableId = dto.PriceHistoryProductVariableId,
                PriceHistoryOldPrice = dto.PriceHistoryOldPrice,
                PriceHistoryNewPrice = dto.PriceHistoryNewPrice,
                PriceHistoryModifierId = dto.PriceHistoryModifierId,
                PriceHistoryChangeDate = dto.PriceHistoryChangeDate
            };
            return await _repository.Filtrar_PriceHistoryAsync(modelo);
        }

        public async Task<OUTPUT> Insertar_PriceHistory_async(PriceHistoryInsertarDTOs dto)
        {
            var modelo = new DM_PriceHistoryInsertar
            {
                PriceHistoryProductVariableId = dto.PriceHistoryProductVariableId,
                PriceHistoryOldPrice = dto.PriceHistoryOldPrice,
                PriceHistoryNewPrice = dto.PriceHistoryNewPrice,
                PriceHistoryModifierId = dto.PriceHistoryModifierId
            };
            return await _repository.Insertar_PriceHistoryAsync(modelo);
        }
    }
}
