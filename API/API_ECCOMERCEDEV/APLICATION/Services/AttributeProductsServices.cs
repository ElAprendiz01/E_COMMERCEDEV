using APLICATION.DTOs.AttributeProducts;
using APLICATION.Interfaces;
using DOMAIN.AttributeProducts;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class AttributeProductsServices
    {
        private readonly IAttributeProductsRepository _repository;

        public AttributeProductsServices(IAttributeProductsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_AttributeProductsListar>> Listar_AttributeProducts_async()
        {
            return await _repository.Listar_AttributeProductsAsync();
        }

        public async Task<IEnumerable<DM_AttributeProductsFiltrar>> Filtrar_AttributeProducts_async(AttributeProductsFilterDTOs dto)
        {
            var modelo = new DM_AttributeProductsFilter
            {
                AttributeProductId = dto.AttributeProductId,
                AttributeProductAttributesTypeId = dto.AttributeProductAttributesTypeId,
                AttributeProductName = dto.AttributeProductName,
                AttributeProductDescription = dto.AttributeProductDescription,
                AttributeProductCreatorId = dto.AttributeProductCreatorId,
                AttributeProductCreationDate = dto.AttributeProductCreationDate,
                AttributeProductModificatorId = dto.AttributeProductModificatorId,
                AttributeProductModificationDate = dto.AttributeProductModificationDate,
                AttributeProductStatusId = dto.AttributeProductStatusId
            };
            return await _repository.Filtrar_AttributeProductsAsync(modelo);
        }

        public async Task<OUTPUT> Insertar_AttributeProducts_async(AttributeProductsInsertarDTOs dto)
        {
            var modelo = new DM_AttributeProductsInsertar
            {
                AttributeProductAttributesTypeId = dto.AttributeProductAttributesTypeId,
                AttributeProductName = dto.AttributeProductName,
                AttributeProductDescription = dto.AttributeProductDescription,
                AttributeProductCreatorId = dto.AttributeProductCreatorId,
                AttributeProductStatusId = dto.AttributeProductStatusId
            };
            return await _repository.Insertar_AttributeProductsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_AttributeProducts_async(AttributeProductsEditarDTOs dto)
        {
            var modelo = new DM_AttributeProductsEditar
            {
                AttributeProductId = dto.AttributeProductId,
                AttributeProductAttributesTypeId = dto.AttributeProductAttributesTypeId,
                AttributeProductName = dto.AttributeProductName,
                AttributeProductDescription = dto.AttributeProductDescription,
                AttributeProductModificatorId = dto.AttributeProductModificatorId,
                AttributeProductStatusId = dto.AttributeProductStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_AttributeProductsAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_AttributeProducts_async(int? attributeProductId, int? attributeProductModificatorId)
        {
            return await _repository.Eliminar_AttributeProductsAsync(attributeProductId, attributeProductModificatorId);
        }
    }
}
