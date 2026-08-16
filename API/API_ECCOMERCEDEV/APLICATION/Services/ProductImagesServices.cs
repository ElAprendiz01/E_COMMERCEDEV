using APLICATION.DTOs.ProductImages;
using APLICATION.Interfaces;
using DOMAIN.ProductImages;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class ProductImagesServices
    {
        private readonly IProductImagesRepository _repository;

        public ProductImagesServices(IProductImagesRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_ProductImages_async(ProductImagesInsertarDTOs dto)
        {
            var modelo = new DM_ProductImages_insertar
            {
                ProductImageProductId = dto.ProductImageProductId,
                ProductImageURL = dto.ProductImageURL,
                ProductImageDescription = dto.ProductImageDescription,
                ProductImageIsPrincipal = dto.ProductImageIsPrincipal,
                ProductImageCreatorId = dto.ProductImageCreatorId,
                ProductImageStatusId = dto.ProductImageStatusId
            };

            return await _repository.Insertar_ProductImagesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_ProductImages_async(ProductImagesActualizarDTOs dto)
        {
            var modelo = new DM_ProductImages_actualizar
            {
                ProductImageId = dto.ProductImageId,
                ProductImageProductId = dto.ProductImageProductId,
                ProductImageURL = dto.ProductImageURL,
                ProductImageDescription = dto.ProductImageDescription,
                ProductImageIsPrincipal = dto.ProductImageIsPrincipal,
                ProductImageModificatorId = dto.ProductImageModificatorId,
                ProductImageStatusId = dto.ProductImageStatusId
            };

            return await _repository.Editar_ProductImagesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_ProductImages_async(int productImageId, int productImageModificatorId)
        {
            return await _repository.Eliminar_ProductImagesAsync(productImageId, productImageModificatorId);
        }

        public async Task<IEnumerable<DM_ProductImages_listar>> Listar_ProductImages()
        {
            return await _repository.Listar_ProductImagesAsync();
        }

        public async Task<IEnumerable<DM_ProductImages_filtrar>> Filtrar_ProductImages(ProductImagesFiltrarDTOs dto)
        {
            var modelo = new DM_ProductImages_filtrar
            {
                ProductImageId = dto.ProductImageId,
                ProductImageProductId = dto.ProductImageProductId,
                ProductImageURL = dto.ProductImageURL,
                ProductImageIsPrincipal = dto.ProductImageIsPrincipal,
                ProductImageCreatorId = dto.ProductImageCreatorId,
                ProductImageCreationDate = dto.ProductImageCreationDate,
                ProductImageModificatorId = dto.ProductImageModificatorId,
                ProductImageModificationDate = dto.ProductImageModificationDate,
                ProductImageStatusId = dto.ProductImageStatusId
            };

            return await _repository.Filtrar_ProductImagesAsync(modelo);
        }
    }
}
