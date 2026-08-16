using DOMAIN.ProductIdentificators;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IProductIdentificatorsRepository
    {
        Task<OUTPUT> Insertar_ProductIdentificatorsAsync(DM_ProductIdentificators_insertar modelo);
        Task<OUTPUT> Editar_ProductIdentificatorsAsync(DM_ProductIdentificators_actualizar modelo);
        Task<OUTPUT> Eliminar_ProductIdentificatorsAsync(int productIdentificatorId, int productIdentificatorModificatorId);
        Task<IEnumerable<DM_ProductIdentificators_listar>> Listar_ProductIdentificatorsAsync();
        Task<IEnumerable<DM_ProductIdentificators_filtrar>> Filtrar_ProductIdentificatorsAsync(DM_ProductIdentificators_filtrar filtro);
    }
}
