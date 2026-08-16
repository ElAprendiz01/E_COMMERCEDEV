using DOMAIN.Categories;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface ICategoriesRepository
    {
        Task<IEnumerable<DM_Categories_listar>> Listar_CategoriesAsync();
        Task<IEnumerable<DM_Categories_filtrar>> Filtrar_CategoriesAsync(string? searchTerm, bool? statusId);
        Task<OUTPUT> Insertar_CategoriesAsync(DM_Categories_insertar modelo);
        Task<OUTPUT> Editar_CategoriesAsync(DM_Categories_actualizar modelo);
        Task<OUTPUT> Eliminar_CategoriesAsync(int categoryId, int categoryModificatorId);
    }
}
