using APLICATION.DTOs.Categories;
using APLICATION.Interfaces;
using DOMAIN.Categories;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class CategoriesServices
    {
        private readonly ICategoriesRepository _repository;

        public CategoriesServices(ICategoriesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Categories_listar>> Listar_Categories_async()
        {
            return await _repository.Listar_CategoriesAsync();
        }

        public async Task<IEnumerable<DM_Categories_filtrar>> Filtrar_Categories_async(CategoriesFilterDTOs dto)
        {
            return await _repository.Filtrar_CategoriesAsync(dto.SearchTerm, dto.StatusId);
        }

        public async Task<OUTPUT> Insertar_Categories_async(CategoriesInsertarDTOs dto)
        {
            var modelo = new DM_Categories_insertar
            {
                categoryName = dto.categoryName,
                categoryDescription = dto.categoryDescription,
                categoryCreatorId = dto.categoryCreatorId,
                categoryStatusId = dto.categoryStatusId
            };
            return await _repository.Insertar_CategoriesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Categories_async(CategoriesEditarDTOs dto)
        {
            var modelo = new DM_Categories_actualizar
            {
                categoryId = dto.categoryId,
                categoryName = dto.categoryName,
                categoryDescription = dto.categoryDescription,
                categoryModificatorId = dto.categoryModificatorId,
                categoryStatusId = dto.categoryStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_CategoriesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Categories_async(int categoryId, int categoryModificatorId)
        {
            return await _repository.Eliminar_CategoriesAsync(categoryId, categoryModificatorId);
        }
    }
}
