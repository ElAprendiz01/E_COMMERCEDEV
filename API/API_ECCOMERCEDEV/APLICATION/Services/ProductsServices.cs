using APLICATION.DTOs.Products;
using APLICATION.Interfaces;
using DOMAIN.Products;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class ProductsServices
    {
        private readonly IProductsRepository _repository;

        public ProductsServices(IProductsRepository repository)
        {
            _repository = repository;
        }

        public async Task<(IEnumerable<ProductsListarDTOs> Data, OUTPUT Output)> Listar_Products_async(int? pageNumber = null)
        {
            var (data, output) = await _repository.Listar_ProductsAsync(pageNumber);
            var dtos = data.Select(x => new ProductsListarDTOs
            {
                ProductID = x.ProductID,
                ProductName = x.ProductName,
                ProductVariableID = x.ProductVariableID,
                ProductVariableName = x.ProductVariableName,
                ProductVariablePrice = x.ProductVariablePrice,
                CurrencyID = x.CurrencyID,
                CurrencyISO = x.CurrencyISO,
                CategoryID = x.CategoryID,
                CategoryName = x.CategoryName,
                SubcategoryID = x.SubcategoryID,
                SubcategoryName = x.SubcategoryName,
                SegmentID = x.SegmentID,
                SegmentName = x.SegmentName,
                MarkID = x.MarkID,
                MarkName = x.MarkName,
                ProviderID = x.ProviderID,
                ProviderName = x.ProviderName,
                StockID = x.StockID,
                StockAvilable = x.StockAvilable,
                StockFactoryDate = x.StockFactoryDate,
                StockExpirationDate = x.StockExpirationDate,
                ProductImageURL = x.ProductImageURL
            });
            return (dtos, output);
        }

        public async Task<(IEnumerable<ProductsFiltrarDTOs> Data, OUTPUT Output)> Filtrar_Products_async(string? searchTerm, int? pageNumber = 1)
        {
            var (data, output) = await _repository.Filtrar_ProductsAsync(searchTerm, pageNumber);
            var dtos = data.Select(x => new ProductsFiltrarDTOs
            {
                ProductID = x.ProductID,
                ProductName = x.ProductName,
                ProductVariableID = x.ProductVariableID,
                ProductVariableName = x.ProductVariableName,
                ProductVariablePrice = x.ProductVariablePrice,
                CurrencyID = x.CurrencyID,
                CurrencyISO = x.CurrencyISO,
                CategoryID = x.CategoryID,
                CategoryName = x.CategoryName,
                SubcategoryID = x.SubcategoryID,
                SubcategoryName = x.SubcategoryName,
                SegmentID = x.SegmentID,
                SegmentName = x.SegmentName,
                MarkID = x.MarkID,
                MarkName = x.MarkName,
                ProviderID = x.ProviderID,
                ProviderName = x.ProviderName,
                StockID = x.StockID,
                StockAvilable = x.StockAvilable,
                StockFactoryDate = x.StockFactoryDate,
                StockExpirationDate = x.StockExpirationDate,
                ProductImageURL = x.ProductImageURL
            });
            return (dtos, output);
        }

        public async Task<(IEnumerable<ProductsFiltrarIdDTOs> Data, OUTPUT Output)> Filtrar_Products_Por_Id_async(int? productId)
        {
            var (data, output) = await _repository.Filtrar_Products_Por_IdAsync(productId);
            var dtos = data.Select(x => new ProductsFiltrarIdDTOs
            {
                ProductID = x.ProductID,
                ProductName = x.ProductName,
                ProductVariableID = x.ProductVariableID,
                ProductVariableName = x.ProductVariableName,
                ProductVariablePrice = x.ProductVariablePrice,
                CurrencyID = x.CurrencyID,
                CurrencyISO = x.CurrencyISO,
                CategoryID = x.CategoryID,
                CategoryName = x.CategoryName,
                SubcategoryID = x.SubcategoryID,
                SubcategoryName = x.SubcategoryName,
                SegmentID = x.SegmentID,
                SegmentName = x.SegmentName,
                MarkID = x.MarkID,
                MarkName = x.MarkName,
                ProviderID = x.ProviderID,
                ProviderName = x.ProviderName,
                StockID = x.StockID,
                StockAvilable = x.StockAvilable,
                StockFactoryDate = x.StockFactoryDate,
                StockExpirationDate = x.StockExpirationDate,
                ProductImageURL = x.ProductImageURL
            });
            return (dtos, output);
        }

        public async Task<OUTPUT> Insertar_Products_async(ProductsinsertarDTOs dto)
        {
            var modelo = new DM_Products_insertar
            {
                productName = dto.productName,
                productDescription = dto.productDescription,
                productProductIdentificatorId = dto.productProductIdentificatorId,
                productMarkByProviderId = dto.productMarkByProviderId,
                productCreatorId = dto.productCreatorId,
                productStatusId = dto.productStatusId
            };
            return await _repository.Insertar_ProductsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Products_async(ProductsEditarDTOs dto)
        {
            var modelo = new DM_Products_actualizar
            {
                productId = dto.productId,
                productName = dto.productName,
                productDescription = dto.productDescription,
                productProductIdentificatorId = dto.productProductIdentificatorId,
                productMarkByProviderId = dto.productMarkByProviderId,
                productModificatorId = dto.productModificatorId,
                productStatusId = dto.productStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_ProductsAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Products_async(int? productId, int? productModificatorId)
        {
            return await _repository.Eliminar_ProductsAsync(productId, productModificatorId);
        }
    }
}
