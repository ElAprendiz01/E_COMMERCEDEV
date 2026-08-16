using APLICATION.DTOs.PaymentOrderDetails;
using APLICATION.Interfaces;
using DOMAIN.PaymentOrderDetails;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class PaymentOrderDetailsServices
    {
        private readonly IPaymentOrderDetailsRepository _repository;

        public PaymentOrderDetailsServices(IPaymentOrderDetailsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<PaymentOrderDetailsListarDTOs>> Listar_PaymentOrderDetails_async()
        {
            var data = await _repository.Listar_PaymentOrderDetailsAsync();
            return data.Select(x => new PaymentOrderDetailsListarDTOs
            {
                orderDetailId = x.orderDetailId,
                orderId = x.orderId,
                productVariableId = x.productVariableId,
                productName = x.productName,
                productDescription = x.productDescription,
                categoryName = x.categoryName,
                subCategoryName = x.subCategoryName,
                segmentName = x.segmentName,
                markName = x.markName,
                providerName = x.providerName,
                variableValue = x.variableValue,
                price = x.price,
                quantity = x.quantity,
                discount = x.discount,
                subtotal = x.subtotal,
                tax = x.tax,
                total = x.total,
                currencyId = x.currencyId,
                currencyISO = x.currencyISO,
                statusId = x.statusId
            });
        }

        public async Task<IEnumerable<PaymentOrderDetailsFiltrarDTOs>> Filtrar_PaymentOrderDetails_async(PaymentOrderDetailsFilterDTOs dto)
        {
            var data = await _repository.Filtrar_PaymentOrderDetailsAsync(dto.OrderId, dto.SearchTerm);
            return data.Select(x => new PaymentOrderDetailsFiltrarDTOs
            {
                orderDetailId = x.orderDetailId,
                orderId = x.orderId,
                productVariableId = x.productVariableId,
                productName = x.productName,
                productDescription = x.productDescription,
                categoryName = x.categoryName,
                subCategoryName = x.subCategoryName,
                segmentName = x.segmentName,
                markName = x.markName,
                providerName = x.providerName,
                variableValue = x.variableValue,
                price = x.price,
                quantity = x.quantity,
                discount = x.discount,
                subtotal = x.subtotal,
                tax = x.tax,
                total = x.total,
                currencyId = x.currencyId,
                currencyISO = x.currencyISO,
                statusId = x.statusId
            });
        }

        
    }
}
