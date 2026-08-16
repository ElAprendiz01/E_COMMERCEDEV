using DOMAIN.StockMovementTypes;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IStockMovementTypesRepository
    {
        Task<OUTPUT> Insertar_StockMovementTypesAsync(DM_StockMovementTypesInsertar modelo);
        Task<OUTPUT> Editar_StockMovementTypesAsync(DM_StockMovementTypesEditar modelo);
        Task<OUTPUT> Eliminar_StockMovementTypesAsync(int? stockMovementTypeId, int? stockMovementTypeModificatorId);
        Task<IEnumerable<DM_StockMovementTypesListar>> Listar_StockMovementTypesAsync();
        Task<IEnumerable<DM_StockMovementTypesFiltrar>> Filtrar_StockMovementTypesAsync(DM_StockMovementTypesFiltrar filtro);
    }
}
