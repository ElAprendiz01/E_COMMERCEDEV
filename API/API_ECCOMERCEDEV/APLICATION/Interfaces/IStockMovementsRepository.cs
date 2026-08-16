using DOMAIN.StockMovements;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IStockMovementsRepository
    {
        Task<IEnumerable<DM_StockMovements_listar>> Listar_StockMovementsAsync();
        Task<IEnumerable<DM_StockMovements_filtrar>> Filtrar_StockMovementsAsync(string? searchTerm);
        Task<OUTPUT> Insertar_StockMovementsAsync(DM_StockMovements_insertar modelo);
    }
}
