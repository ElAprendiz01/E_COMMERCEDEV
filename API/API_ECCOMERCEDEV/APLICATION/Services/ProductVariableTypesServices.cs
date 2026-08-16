using APLICATION.DTOs.ProductVariableTypes;
using APLICATION.Interfaces;
using DOMAIN.ProductVariableTypes;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class ProductVariableTypesServices
    {
        private readonly IProductVariableTypesRepository _repository;

        public ProductVariableTypesServices(IProductVariableTypesRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_ProductVariableTypes_async(ProductVariableTypesInsertarDTOs dto)
        {
            var modelo = new DM_ProductVariableTypes_insertar
            {
                ProductVariableTypeName = dto.ProductVariableTypeName,
                ProductVariableTypeDescription = dto.ProductVariableTypeDescription,
                ProductVariableTypeCreatorId = dto.ProductVariableTypeCreatorId,
                ProductVariableTypeStatusId = dto.ProductVariableTypeStatusId
            };

            return await _repository.Insertar_ProductVariableTypesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_ProductVariableTypes_async(ProductVariableTypesActualizarDTOs dto)
        {
            var modelo = new DM_ProductVariableTypes_actualizar
            {
                ProductVariableTypeId = dto.ProductVariableTypeId,
                ProductVariableTypeName = dto.ProductVariableTypeName,
                ProductVariableTypeDescription = dto.ProductVariableTypeDescription,
                ProductVariableTypeModificatorId = dto.ProductVariableTypeModificatorId,
                ProductVariableTypeStatusId = dto.ProductVariableTypeStatusId
            };

            return await _repository.Editar_ProductVariableTypesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_ProductVariableTypes_async(int productVariableTypeId, int productVariableTypeModificatorId)
        {
            return await _repository.Eliminar_ProductVariableTypesAsync(productVariableTypeId, productVariableTypeModificatorId);
        }

        public async Task<IEnumerable<DM_ProductVariableTypes_listar>> Listar_ProductVariableTypes()
        {
            return await _repository.Listar_ProductVariableTypesAsync();
        }

        public async Task<IEnumerable<DM_ProductVariableTypes_filtrar>> Filtrar_ProductVariableTypes(ProductVariableTypesFiltrarDTOs dto)
        {
            var modelo = new DM_ProductVariableTypes_filtrar
            {
                ProductVariableTypeId = dto.ProductVariableTypeId,
                ProductVariableTypeName = dto.ProductVariableTypeName,
                ProductVariableTypeDescription = dto.ProductVariableTypeDescription,
                ProductVariableTypeCreatorId = dto.ProductVariableTypeCreatorId,
                ProductVariableTypeCreationDate = dto.ProductVariableTypeCreationDate,
                ProductVariableTypeModificatorId = dto.ProductVariableTypeModificatorId,
                ProductVariableTypeModificationDate = dto.ProductVariableTypeModificationDate,
                ProductVariableTypeStatusId = dto.ProductVariableTypeStatusId
            };

            return await _repository.Filtrar_ProductVariableTypesAsync(modelo);
        }
    }
}
