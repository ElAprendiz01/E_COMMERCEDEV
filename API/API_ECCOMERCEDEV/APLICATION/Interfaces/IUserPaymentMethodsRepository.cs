using DOMAIN.UserPaymentMethods;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IUserPaymentMethodsRepository
    {
        Task<IEnumerable<DM_UserPaymentMethods_listar>> Listar_UserPaymentMethodsAsync();
        Task<IEnumerable<DM_UserPaymentMethods_filtrar>> Filtrar_UserPaymentMethodsAsync(string? searchTerm);
        Task<OUTPUT> Insertar_UserPaymentMethodsAsync(DM_UserPaymentMethods_insertar modelo);
        Task<OUTPUT> Editar_UserPaymentMethodsAsync(DM_UserPaymentMethods_actualizar modelo);
        Task<OUTPUT> Eliminar_UserPaymentMethodsAsync(int? userPaymentMethodId, int? userPaymentMethodModificatorId);
    }
}
