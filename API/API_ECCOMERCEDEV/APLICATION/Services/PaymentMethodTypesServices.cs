using APLICATION.DTOs.PaymentMethodTypes;
using APLICATION.Interfaces;
using DOMAIN.PaymentMethodTypes;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class PaymentMethodTypesServices
    {
        private readonly IPaymentMethodTypesRepository _repository;

        public PaymentMethodTypesServices(IPaymentMethodTypesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<PaymentMethodTypesListarDTOs>> Listar_PaymentMethodTypes_async()
        {
            var data = await _repository.Listar_PaymentMethodTypesAsync();
            return data.Select(x => new PaymentMethodTypesListarDTOs
            {
                paymentMethodTypeId = x.paymentMethodTypeId,
                paymentMethodTypeName = x.paymentMethodTypeName,
                paymentMethodTypeDescription = x.paymentMethodTypeDescription,
                paymentMethodTypeCreatorId = x.paymentMethodTypeCreatorId,
                paymentMethodTypeCreationDate = x.paymentMethodTypeCreationDate,
                paymentMethodTypeModificatorId = x.paymentMethodTypeModificatorId,
                paymentMethodTypeModificationDate = x.paymentMethodTypeModificationDate,
                paymentMethodTypeStatusId = x.paymentMethodTypeStatusId
            });
        }

        public async Task<IEnumerable<PaymentMethodTypesFiltrarDTOs>> Filtrar_PaymentMethodTypes_async(PaymentMethodTypesFilterDTOs dto)
        {
            var data = await _repository.Filtrar_PaymentMethodTypesAsync(dto.SearchTerm);
            return data.Select(x => new PaymentMethodTypesFiltrarDTOs
            {
                paymentMethodTypeId = x.paymentMethodTypeId,
                paymentMethodTypeName = x.paymentMethodTypeName,
                paymentMethodTypeDescription = x.paymentMethodTypeDescription,
                paymentMethodTypeStatusId = x.paymentMethodTypeStatusId
            });
        }

        public async Task<OUTPUT> Insertar_PaymentMethodTypes_async(PaymentMethodTypesinsertarDTOs dto)
        {
            var modelo = new DM_PaymentMethodTypes_insertar
            {
                paymentMethodTypeName = dto.paymentMethodTypeName,
                paymentMethodTypeDescription = dto.paymentMethodTypeDescription,
                paymentMethodTypeCreatorId = dto.paymentMethodTypeCreatorId,
                paymentMethodTypeStatusId = dto.paymentMethodTypeStatusId
            };
            return await _repository.Insertar_PaymentMethodTypesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_PaymentMethodTypes_async(PaymentMethodTypesEditarDTOs dto)
        {
            var modelo = new DM_PaymentMethodTypes_actualizar
            {
                paymentMethodTypeId = dto.paymentMethodTypeId,
                paymentMethodTypeName = dto.paymentMethodTypeName,
                paymentMethodTypeDescription = dto.paymentMethodTypeDescription,
                paymentMethodTypeModificatorId = dto.paymentMethodTypeModificatorId,
                paymentMethodTypeStatusId = dto.paymentMethodTypeStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_PaymentMethodTypesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_PaymentMethodTypes_async(int? paymentMethodTypeId, int? paymentMethodTypeModificatorId)
        {
            return await _repository.Eliminar_PaymentMethodTypesAsync(paymentMethodTypeId, paymentMethodTypeModificatorId);
        }
    }
}
