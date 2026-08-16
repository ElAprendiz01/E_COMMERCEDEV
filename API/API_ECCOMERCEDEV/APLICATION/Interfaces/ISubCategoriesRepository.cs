using DOMAIN.SubCategories;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface ISubCategoriesRepository
    {
        Task<IEnumerable<DM_SubCategories_listar>> Listar_SubCategoriesAsync();
        Task<IEnumerable<DM_SubCategories_filtrar>> Filtrar_SubCategoriesAsync(string? searchTerm);
        Task<OUTPUT> Insertar_SubCategoriesAsync(DM_SubCategories_insertar modelo);
        Task<OUTPUT> Editar_SubCategoriesAsync(DM_SubCategories_actualizar modelo);
        Task<OUTPUT> Eliminar_SubCategoriesAsync(int? subCategoryId, int? subCategoryModificatorId);
    }
}
