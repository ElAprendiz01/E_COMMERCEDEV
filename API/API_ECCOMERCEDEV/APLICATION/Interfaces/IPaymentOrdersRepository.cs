using DOMAIN.PaymentOrders;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IPaymentOrdersRepository
    {
        Task<IEnumerable<DM_PaymentOrders_listar>> Listar_PaymentOrdersAsync();
        Task<IEnumerable<DM_PaymentOrders_filtrar>> Filtrar_PaymentOrdersAsync(int? userId, string? searchTerm, int? statusId);
        Task<OUTPUT> Insertar_PaymentOrdersAsync(DM_PaymentOrders_insertar modelo);
    }
}
