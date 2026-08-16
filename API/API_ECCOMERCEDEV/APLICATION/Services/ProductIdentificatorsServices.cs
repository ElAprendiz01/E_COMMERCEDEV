using APLICATION.DTOs.ProductIdentificators;
using APLICATION.Interfaces;
using DOMAIN.ProductIdentificators;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class ProductIdentificatorsServices
    {
        private readonly IProductIdentificatorsRepository _repository;

        public ProductIdentificatorsServices(IProductIdentificatorsRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_ProductIdentificators_async(ProductIdentificatorsInsertarDTOs dto)
        {
            var modelo = new DM_ProductIdentificators_insertar
            {
                ProductIdentificatorCategoryId = dto.ProductIdentificatorCategoryId,
                ProductIdentificatorSubCategoryId = dto.ProductIdentificatorSubCategoryId,
                ProductIdentificatorSegmentId = dto.ProductIdentificatorSegmentId,
                ProductIdentificatorCreatorId = dto.ProductIdentificatorCreatorId,
                ProductIdentificatorStatusId = dto.ProductIdentificatorStatusId
            };

            return await _repository.Insertar_ProductIdentificatorsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_ProductIdentificators_async(ProductIdentificatorsActualizarDTOs dto)
        {
            var modelo = new DM_ProductIdentificators_actualizar
            {
                ProductIdentificatorId = dto.ProductIdentificatorId,
                ProductIdentificatorCategoryId = dto.ProductIdentificatorCategoryId,
                ProductIdentificatorSubCategoryId = dto.ProductIdentificatorSubCategoryId,
                ProductIdentificatorSegmentId = dto.ProductIdentificatorSegmentId,
                ProductIdentificatorModificatorId = dto.ProductIdentificatorModificatorId,
                ProductIdentificatorStatusId = dto.ProductIdentificatorStatusId
            };

            return await _repository.Editar_ProductIdentificatorsAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_ProductIdentificators_async(int productIdentificatorId, int productIdentificatorModificatorId)
        {
            return await _repository.Eliminar_ProductIdentificatorsAsync(productIdentificatorId, productIdentificatorModificatorId);
        }

        public async Task<IEnumerable<DM_ProductIdentificators_listar>> Listar_ProductIdentificators()
        {
            return await _repository.Listar_ProductIdentificatorsAsync();
        }

        public async Task<IEnumerable<DM_ProductIdentificators_filtrar>> Filtrar_ProductIdentificators(ProductIdentificatorsFiltrarDTOs dto)
        {
            var modelo = new DM_ProductIdentificators_filtrar
            {
                ProductIdentificatorId = dto.ProductIdentificatorId,
                ProductIdentificatorCategoryId = dto.ProductIdentificatorCategoryId,
                ProductIdentificatorSubCategoryId = dto.ProductIdentificatorSubCategoryId,
                ProductIdentificatorSegmentId = dto.ProductIdentificatorSegmentId,
                ProductIdentificatorCreatorId = dto.ProductIdentificatorCreatorId,
                ProductIdentificatorCreationDate = dto.ProductIdentificatorCreationDate,
                ProductIdentificatorModificatorId = dto.ProductIdentificatorModificatorId,
                ProductIdentificatorModificationDate = dto.ProductIdentificatorModificationDate,
                ProductIdentificatorStatusId = dto.ProductIdentificatorStatusId
            };

            return await _repository.Filtrar_ProductIdentificatorsAsync(modelo);
        }
    }
}
