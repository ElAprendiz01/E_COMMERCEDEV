using DOMAIN.PriceHistory;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IPriceHistoryRepository
    {
        Task<OUTPUT> Insertar_PriceHistoryAsync(DM_PriceHistoryInsertar modelo);
        Task<IEnumerable<DM_PriceHistoryListar>> Listar_PriceHistoryAsync();
        Task<IEnumerable<DM_PriceHistoryFiltrar>> Filtrar_PriceHistoryAsync(DM_PriceHistoryFiltrar filtro);
    }
}
