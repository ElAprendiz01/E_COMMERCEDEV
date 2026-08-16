using DOMAIN.ProductVariableTypes;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IProductVariableTypesRepository
    {
        Task<OUTPUT> Insertar_ProductVariableTypesAsync(DM_ProductVariableTypes_insertar modelo);
        Task<OUTPUT> Editar_ProductVariableTypesAsync(DM_ProductVariableTypes_actualizar modelo);
        Task<OUTPUT> Eliminar_ProductVariableTypesAsync(int productVariableTypeId, int productVariableTypeModificatorId);
        Task<IEnumerable<DM_ProductVariableTypes_listar>> Listar_ProductVariableTypesAsync();
        Task<IEnumerable<DM_ProductVariableTypes_filtrar>> Filtrar_ProductVariableTypesAsync(DM_ProductVariableTypes_filtrar filtro);
    }
}
