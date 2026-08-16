using DOMAIN.ProductImages;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IProductImagesRepository
    {
        Task<OUTPUT> Insertar_ProductImagesAsync(DM_ProductImages_insertar modelo);
        Task<OUTPUT> Editar_ProductImagesAsync(DM_ProductImages_actualizar modelo);
        Task<OUTPUT> Eliminar_ProductImagesAsync(int productImageId, int productImageModificatorId);
        Task<IEnumerable<DM_ProductImages_listar>> Listar_ProductImagesAsync();
        Task<IEnumerable<DM_ProductImages_filtrar>> Filtrar_ProductImagesAsync(DM_ProductImages_filtrar filtro);
    }
}
