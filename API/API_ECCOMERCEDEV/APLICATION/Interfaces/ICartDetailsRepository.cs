using DOMAIN.CartDetails;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface ICartDetailsRepository
    {
        Task<IEnumerable<DM_CartDetails_listar>> Listar_CartDetailsAsync();
        Task<OUTPUT> Insertar_CartDetailsAsync(DM_CartDetails_insertar modelo);
        Task<OUTPUT> Editar_CartDetails_CantidadAsync(DM_CartDetails_actualizar modelo);
        Task<OUTPUT> Eliminar_CartDetailsAsync(int cartDetailId, int cartDetailModificatorId);
        Task<IEnumerable<DM_CartDetails_filtrar>> Obtener_CarritoClienteAsync(int userId);
    }
}
