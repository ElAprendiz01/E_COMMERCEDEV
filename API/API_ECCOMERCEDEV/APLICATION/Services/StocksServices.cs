using APLICATION.DTOs.Stocks;
using APLICATION.Interfaces;
using DOMAIN.Stocks;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class StocksServices
    {
        private readonly IStocksRepository _repository;

        public StocksServices(IStocksRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_Stocks_Async(StocksCreateDTOs dto)
        {
            var modelo = new DM_Stocks_create
            {
                StockProductVariableId = dto.StockProductVariableId,
                StockQuantity = dto.StockQuantity,
                StockFactoryDate = dto.StockFactoryDate,
                StockExpirationDate = dto.StockExpirationDate,
                StockCreatorId = dto.StockCreatorId,
                StockStatusId = dto.StockStatusId
            };
            return await _repository.Insertar_StocksAsync(modelo);
        }

        public async Task<OUTPUT> Actualizar_Stocks_Async(StocksUpdateDTOs dto)
        {
            var modelo = new DM_Stocks_update
            {
                StockId = dto.StockId,
                StockQuantityAdjustment = dto.StockQuantityAdjustment,
                StockModificatorId = dto.StockModificatorId
            };
            return await _repository.Actualizar_StocksAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Stocks_Async(int? stockId, int? stockModificatorId)
        {
            return await _repository.Eliminar_StocksAsync(stockId, stockModificatorId);
        }

        public async Task<IEnumerable<StocksListarDTOs>> Listar_Stocks_Async()
        {
            var data = await _repository.Listar_StocksAsync();
            return data.Select(x => new StocksListarDTOs
            {
                StockId = x.StockId,
                ProductVariableId = x.ProductVariableId,
                ProductName = x.ProductName,
                VariableValue = x.VariableValue,
                UnitPrice = x.UnitPrice,
                CurrencyISO = x.CurrencyISO,
                Quantity = x.Quantity,
                FactoryDate = x.FactoryDate,
                ExpirationDate = x.ExpirationDate,
                StatusId = x.StatusId
            });
        }

        public async Task<IEnumerable<StocksFiltrarDTOs>> Filtrar_Stocks_Async(StocksFilterDTOs filter)
        {
            var data = await _repository.Filtrar_StocksAsync(filter.SearchTerm, filter.ProductVariableId);
            return data.Select(x => new StocksFiltrarDTOs
            {
                StockId = x.StockId,
                ProductVariableId = x.ProductVariableId,
                ProductName = x.ProductName,
                VariableValue = x.VariableValue,
                UnitPrice = x.UnitPrice,
                CurrencyISO = x.CurrencyISO,
                Quantity = x.Quantity,
                FactoryDate = x.FactoryDate,
                ExpirationDate = x.ExpirationDate,
                StatusId = x.StatusId
            });
        }
    }
}
