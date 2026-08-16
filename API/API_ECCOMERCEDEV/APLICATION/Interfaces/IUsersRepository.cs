using DOMAIN.Users;
using DOMAIN.VariablesSalida;

namespace APLICATION.Interfaces
{
    public interface IUsersRepository
    {
        Task<IEnumerable<DM_Users_listar>> Listar_UsersAsync();
        Task<IEnumerable<DM_Users_filtrar>> Filtrar_UsersAsync(string? searchTerm);
        Task<OUTPUT> Insertar_UsersAsync(DM_Users_insertar modelo);
        Task<OUTPUT> Editar_UsersAsync(DM_Users_actualizar modelo);
        Task<OUTPUT> Eliminar_UsersAsync(int? userId, int? userModificatorId);
        Task<OUTPUT> CambiarPassword_UsersAsync(DM_Users_cambiar_password modelo);

        //Log
        Task<OUTPUT> Login_UsersAsync(DM_User_Login credentials);
       
    }
}