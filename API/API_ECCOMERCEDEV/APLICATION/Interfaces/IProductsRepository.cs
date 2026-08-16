using DOMAIN.Products;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IProductsRepository
    {
        Task<(IEnumerable<DM_Products_listar> Data, OUTPUT Output)> Listar_ProductsAsync(int? pageNumber = null);
        Task<(IEnumerable<DM_Products_filtrar> Data, OUTPUT Output)> Filtrar_ProductsAsync(string? searchTerm, int? pageNumber = 1);
        Task<(IEnumerable<DM_Products_filtrar_id> Data, OUTPUT Output)> Filtrar_Products_Por_IdAsync(int? productId);
        Task<OUTPUT> Insertar_ProductsAsync(DM_Products_insertar modelo);
        Task<OUTPUT> Editar_ProductsAsync(DM_Products_actualizar modelo);
        Task<OUTPUT> Eliminar_ProductsAsync(int? productId, int? productModificatorId);
    }
}
