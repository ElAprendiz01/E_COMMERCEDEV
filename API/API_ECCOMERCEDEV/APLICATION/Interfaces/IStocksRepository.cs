using DOMAIN.Stocks;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IStocksRepository
    {
        Task<OUTPUT> Insertar_StocksAsync(DM_Stocks_create modelo);
        Task<OUTPUT> Actualizar_StocksAsync(DM_Stocks_update modelo);
        Task<OUTPUT> Eliminar_StocksAsync(int? stockId, int? stockModificatorId);
        Task<IEnumerable<DM_Stocks_listar>> Listar_StocksAsync();
        Task<IEnumerable<DM_Stocks_filtrar>> Filtrar_StocksAsync(string? searchTerm, int? productVariableId);
    }
}
