using DOMAIN.AttributeProducts;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IAttributeProductsRepository
    {
        Task<OUTPUT> Insertar_AttributeProductsAsync(DM_AttributeProductsInsertar modelo);
        Task<OUTPUT> Editar_AttributeProductsAsync(DM_AttributeProductsEditar modelo);
        Task<OUTPUT> Eliminar_AttributeProductsAsync(int? attributeProductId, int? attributeProductModificatorId);
        Task<IEnumerable<DM_AttributeProductsListar>> Listar_AttributeProductsAsync();
        Task<IEnumerable<DM_AttributeProductsFiltrar>> Filtrar_AttributeProductsAsync(DM_AttributeProductsFilter filtro);
    }
}
