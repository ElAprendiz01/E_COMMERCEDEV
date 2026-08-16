using DOMAIN.UserAddress;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IUserAddressRepository
    {
        Task<IEnumerable<DM_UserAddress_listar>> Listar_UserAddressAsync();
        Task<IEnumerable<DM_UserAddress_filtrar>> Filtrar_UserAddressAsync(int? userId, string? searchTerm);
        Task<OUTPUT> Insertar_UserAddressAsync(DM_UserAddress_insertar modelo);
        Task<OUTPUT> Editar_UserAddressAsync(DM_UserAddress_actualizar modelo);
        Task<OUTPUT> Eliminar_UserAddressAsync(int? userAddressId, int? userAddressModificatorId);
    }
}
