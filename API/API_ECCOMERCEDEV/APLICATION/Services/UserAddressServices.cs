using APLICATION.DTOs.UserAddress;
using APLICATION.Interfaces;
using DOMAIN.UserAddress;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class UserAddressServices
    {
        private readonly IUserAddressRepository _repository;

        public UserAddressServices(IUserAddressRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<UserAddressListarDTOs>> Listar_UserAddress_async()
        {
            var data = await _repository.Listar_UserAddressAsync();
            return data.Select(x => new UserAddressListarDTOs
            {
                userAddressId = x.userAddressId,
                userId = x.userId,
                userFullName = x.userFullName,
                userName = x.userName,
                userEmail = x.userEmail,
                countryId = x.countryId,
                zipCode = x.zipCode,
                addressDescription = x.addressDescription,
                isPrincipal = x.isPrincipal,
                statusId = x.statusId
            });
        }

        public async Task<IEnumerable<UserAddressFiltrarDTOs>> Filtrar_UserAddress_async(UserAddressFilterDTOs dto)
        {
            var data = await _repository.Filtrar_UserAddressAsync(dto.UserId, dto.SearchTerm);
            return data.Select(x => new UserAddressFiltrarDTOs
            {
                userAddressId = x.userAddressId,
                userId = x.userId,
                userFullName = x.userFullName,
                userName = x.userName,
                userEmail = x.userEmail,
                countryId = x.countryId,
                zipCode = x.zipCode,
                addressDescription = x.addressDescription,
                isPrincipal = x.isPrincipal,
                statusId = x.statusId
            });
        }

        public async Task<OUTPUT> Insertar_UserAddress_async(UserAddressinsertarDTOs dto)
        {
            var modelo = new DM_UserAddress_insertar
            {
                userAddressUserId = dto.userAddressUserId,
                userAddressCountryId = dto.userAddressCountryId,
                userAddressZIPCode = dto.userAddressZIPCode,
                userAddressDescription = dto.userAddressDescription,
                userAddressIsPrincipal = dto.userAddressIsPrincipal,
                userAddressCreatorId = dto.userAddressCreatorId,
                userAddressStatusId = dto.userAddressStatusId
            };
            return await _repository.Insertar_UserAddressAsync(modelo);
        }

        public async Task<OUTPUT> Editar_UserAddress_async(UserAddressEditarDTOs dto)
        {
            var modelo = new DM_UserAddress_actualizar
            {
                userAddressId = dto.userAddressId,
                userAddressCountryId = dto.userAddressCountryId,
                userAddressZIPCode = dto.userAddressZIPCode,
                userAddressDescription = dto.userAddressDescription,
                userAddressIsPrincipal = dto.userAddressIsPrincipal,
                userAddressModificatorId = dto.userAddressModificatorId,
                userAddressStatusId = dto.userAddressStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_UserAddressAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_UserAddress_async(int? userAddressId, int? userAddressModificatorId)
        {
            return await _repository.Eliminar_UserAddressAsync(userAddressId, userAddressModificatorId);
        }
    }
}
