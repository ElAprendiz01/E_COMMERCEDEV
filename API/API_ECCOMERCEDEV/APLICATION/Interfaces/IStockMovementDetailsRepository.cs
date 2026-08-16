using DOMAIN.StockMovementDetails;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IStockMovementDetailsRepository
    {
        Task<IEnumerable<DM_StockMovementDetails_listar>> Listar_StockMovementDetailsAsync();
        Task<IEnumerable<DM_StockMovementDetails_filtrar>> Filtrar_StockMovementDetailsAsync(int? movementId, string? searchTerm);
    }
}
