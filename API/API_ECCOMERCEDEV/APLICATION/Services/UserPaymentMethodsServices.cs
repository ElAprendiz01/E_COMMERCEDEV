using APLICATION.DTOs.UserPaymentMethods;
using APLICATION.Interfaces;
using DOMAIN.UserPaymentMethods;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class UserPaymentMethodsServices
    {
        private readonly IUserPaymentMethodsRepository _repository;

        public UserPaymentMethodsServices(IUserPaymentMethodsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<UserPaymentMethodsListarDTOs>> Listar_UserPaymentMethods_async()
        {
            var data = await _repository.Listar_UserPaymentMethodsAsync();
            return data.Select(x => new UserPaymentMethodsListarDTOs
            {
                userPaymentMethodId = x.userPaymentMethodId,
                userId = x.userId,
                userFullName = x.userFullName,
                userName = x.userName,
                paymentMethodTypeId = x.paymentMethodTypeId,
                paymentMethodTypeName = x.paymentMethodTypeName,
                cardNumberDecrypted = x.cardNumberDecrypted,
                expirationDateDecrypted = x.expirationDateDecrypted,
                cvvDecrypted = x.cvvDecrypted,
                cardHolderName = x.cardHolderName,
                statusId = x.statusId
            });
        }

        public async Task<IEnumerable<UserPaymentMethodsFiltrarDTOs>> Filtrar_UserPaymentMethods_async(string? searchTerm)
        {
            var data = await _repository.Filtrar_UserPaymentMethodsAsync(searchTerm);
            return data.Select(x => new UserPaymentMethodsFiltrarDTOs
            {
                userPaymentMethodId = x.userPaymentMethodId,
                userId = x.userId,
                userFullName = x.userFullName,
                userName = x.userName,
                paymentMethodTypeId = x.paymentMethodTypeId,
                paymentMethodTypeName = x.paymentMethodTypeName,
                cardNumberDecrypted = x.cardNumberDecrypted,
                expirationDateDecrypted = x.expirationDateDecrypted,
                cvvDecrypted = x.cvvDecrypted,
                cardHolderName = x.cardHolderName,
                statusId = x.statusId
            });
        }

        public async Task<OUTPUT> Insertar_UserPaymentMethods_async(UserPaymentMethodsinsertarDTOs dto)
        {
            var modelo = new DM_UserPaymentMethods_insertar
            {
                userPaymentMethodUserId = dto.userPaymentMethodUserId,
                userPaymentMethodPaymentMethodTypeId = dto.userPaymentMethodPaymentMethodTypeId,
                CardNumberPlain = dto.CardNumberPlain,
                ExpirationDatePlain = dto.ExpirationDatePlain,
                CVVPlain = dto.CVVPlain,
                userPaymentMethodCardHolderName = dto.userPaymentMethodCardHolderName,
                userPaymentMethodCreatorId = dto.userPaymentMethodCreatorId,
                userPaymentMethodStatusId = dto.userPaymentMethodStatusId
            };
            return await _repository.Insertar_UserPaymentMethodsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_UserPaymentMethods_async(UserPaymentMethodsEditarDTOs dto)
        {
            var modelo = new DM_UserPaymentMethods_actualizar
            {
                userPaymentMethodId = dto.userPaymentMethodId,
                userPaymentMethodPaymentMethodTypeId = dto.userPaymentMethodPaymentMethodTypeId,
                CardNumberPlain = dto.CardNumberPlain,
                ExpirationDatePlain = dto.ExpirationDatePlain,
                CVVPlain = dto.CVVPlain,
                userPaymentMethodCardHolderName = dto.userPaymentMethodCardHolderName,
                userPaymentMethodModificatorId = dto.userPaymentMethodModificatorId,
                userPaymentMethodStatusId = dto.userPaymentMethodStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_UserPaymentMethodsAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_UserPaymentMethods_async(int? userPaymentMethodId, int? userPaymentMethodModificatorId)
        {
            return await _repository.Eliminar_UserPaymentMethodsAsync(userPaymentMethodId, userPaymentMethodModificatorId);
        }
    }
}
