using APLICATION.DTOs.Users;
using APLICATION.Interfaces;
using APPLICATION.DTOs.Users;
using DOMAIN.Users;
using DOMAIN.VariablesSalida;

namespace APLICATION.Services
{
    public class UsersServices
    {
        private readonly IUsersRepository _repository;

        public UsersServices(IUsersRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Users_listar>> Listar_Users_async()
        {
            return await _repository.Listar_UsersAsync();
        }

        public async Task<IEnumerable<DM_Users_filtrar>> Filtrar_Users_async(UsersFilterDTOs dto)
        {
            return await _repository.Filtrar_UsersAsync(dto.SearchTerm);
        }

        public async Task<OUTPUT> Insertar_Users_async(UsersinsertarDTOs dto)
        {
            var modelo = new DM_Users_insertar
            {
                userFullName = dto.userFullName,
                userName = dto.userName,
                userPasswordPlain = dto.userPasswordPlain,
                userEmail = dto.userEmail,
                userPhoneNumber = dto.userPhoneNumber,
                userCountryId = dto.userCountryId,
                userGenderId = dto.userGenderId,
                userBirthDay = dto.userBirthDay,
                userCreatorId = dto.userCreatorId,
                userStatusId = dto.userStatusId
            };
            return await _repository.Insertar_UsersAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Users_async(UsersEditarDTOs dto)
        {
            var modelo = new DM_Users_actualizar
            {
                userId = dto.userId,
                userFullName = dto.userFullName,
                userEmail = dto.userEmail,
                userPhoneNumber = dto.userPhoneNumber,
                userModificatorId = dto.userModificatorId,
                userStatusId = dto.userStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_UsersAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Users_async(int? userId, int? userModificatorId)
        {
            return await _repository.Eliminar_UsersAsync(userId, userModificatorId);
        }

        public async Task<OUTPUT> CambiarPassword_Users_async(UsersCambiarPasswordDTOs dto)
        {
            var modelo = new DM_Users_cambiar_password
            {
                userId = dto.userId,
                userModificatorId = dto.userModificatorId,
                userPasswordPlain = dto.userPasswordPlain
            };
            return await _repository.CambiarPassword_UsersAsync(modelo);

        }
        public async Task<OUTPUT> Login_User_async(User_Login credentials)
        {
            // 1. Traducimos (mapeamos) el DTO que viene del Controlador al Modelo que pide el Repositorio
            var modelo = new DM_User_Login
            {
                userEmail = credentials.userEmail,
                userPasswordPlain = credentials.userPasswordPlain
            };

            // 2. Ahora sí, le pasamos el "modelo" correcto al repositorio
            return await _repository.Login_UsersAsync(modelo);
        }

    }
}
