using APLICATION.DTOs.SubCategories;
using APLICATION.Interfaces;
using DOMAIN.SubCategories;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class SubCategoriesServices
    {
        private readonly ISubCategoriesRepository _repository;

        public SubCategoriesServices(ISubCategoriesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<SubCategoriesListarDTOs>> Listar_SubCategories_async()
        {
            var data = await _repository.Listar_SubCategoriesAsync();
            return data.Select(x => new SubCategoriesListarDTOs
            {
                subCategoryId = x.subCategoryId,
                subCategoryName = x.subCategoryName,
                subCategoryDescription = x.subCategoryDescription,
                subCategoryCreatorId = x.subCategoryCreatorId,
                subCategoryStatusId = x.subCategoryStatusId
            });
        }

        public async Task<IEnumerable<SubCategoriesFiltrarDTOs>> Filtrar_SubCategories_async(SubCategoriesFilterDTOs dto)
        {
            var data = await _repository.Filtrar_SubCategoriesAsync(dto.SearchTerm);
            return data.Select(x => new SubCategoriesFiltrarDTOs
            {
                subCategoryId = x.subCategoryId,
                subCategoryName = x.subCategoryName,
                subCategoryDescription = x.subCategoryDescription,
                subCategoryStatusId = x.subCategoryStatusId
            });
        }

        public async Task<OUTPUT> Insertar_SubCategories_async(SubCategoriesinsertarDTOs dto)
        {
            var modelo = new DM_SubCategories_insertar
            {
                subCategoryName = dto.subCategoryName,
                subCategoryDescription = dto.subCategoryDescription,
                subCategoryCreatorId = dto.subCategoryCreatorId,
                subCategoryStatusId = dto.subCategoryStatusId
            };
            return await _repository.Insertar_SubCategoriesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_SubCategories_async(SubCategoriesEditarDTOs dto)
        {
            var modelo = new DM_SubCategories_actualizar
            {
                subCategoryId = dto.subCategoryId,
                subCategoryName = dto.subCategoryName,
                subCategoryDescription = dto.subCategoryDescription,
                subCategoryModificatorId = dto.subCategoryModificatorId,
                subCategoryStatusId = dto.subCategoryStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_SubCategoriesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_SubCategories_async(int? subCategoryId, int? subCategoryModificatorId)
        {
            return await _repository.Eliminar_SubCategoriesAsync(subCategoryId, subCategoryModificatorId);
        }
    }
}
