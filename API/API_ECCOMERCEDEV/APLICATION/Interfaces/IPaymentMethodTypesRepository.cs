using DOMAIN.PaymentMethodTypes;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IPaymentMethodTypesRepository
    {
        Task<IEnumerable<DM_PaymentMethodTypes_listar>> Listar_PaymentMethodTypesAsync();
        Task<IEnumerable<DM_PaymentMethodTypes_filtrar>> Filtrar_PaymentMethodTypesAsync(string? searchTerm);
        Task<OUTPUT> Insertar_PaymentMethodTypesAsync(DM_PaymentMethodTypes_insertar modelo);
        Task<OUTPUT> Editar_PaymentMethodTypesAsync(DM_PaymentMethodTypes_actualizar modelo);
        Task<OUTPUT> Eliminar_PaymentMethodTypesAsync(int? paymentMethodTypeId, int? paymentMethodTypeModificatorId);
    }
}
