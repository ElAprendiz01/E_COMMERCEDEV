using APLICATION.DTOs.PaymentOrders;
using APLICATION.Interfaces;
using DOMAIN.PaymentOrders;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class PaymentOrdersServices
    {
        private readonly IPaymentOrdersRepository _repository;

        public PaymentOrdersServices(IPaymentOrdersRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_PaymentOrders_listar>> Listar_PaymentOrders_async()
        {
            return await _repository.Listar_PaymentOrdersAsync();
        }

        public async Task<IEnumerable<DM_PaymentOrders_filtrar>> Filtrar_PaymentOrders_async(PaymentOrdersFilterDTOs dto)
        {
            return await _repository.Filtrar_PaymentOrdersAsync(dto.UserId, dto.SearchTerm, dto.StatusId);
        }

        public async Task<OUTPUT> Insertar_PaymentOrders_async(PaymentOrdersInsertarDTOs dto)
        {
            var modelo = new DM_PaymentOrders_insertar
            {
                orderUserId = dto.orderUserId,
                orderDeliveryAddress = dto.orderDeliveryAddress,
                orderPaymentMethodId = dto.orderPaymentMethodId,
                orderShipping = dto.orderShipping,
                orderSubtotal = dto.orderSubtotal,
                orderTotal = dto.orderTotal,
                orderCreatorId = dto.orderCreatorId,
                orderStatusId = dto.orderStatusId
            };
            return await _repository.Insertar_PaymentOrdersAsync(modelo);
        }
    }
}
