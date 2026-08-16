using APLICATION.Interfaces;
using DOMAIN.Users;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class UsersRepository : IUsersRepository
    {
        private readonly DBconexionfactory _connection;
        private readonly IJwtService _jwtService;

        public UsersRepository(DBconexionfactory connection, IJwtService jwtService)
        {
            _connection = connection;
            _jwtService = jwtService;
        }

        #region escritura_users

        public async Task<OUTPUT> Insertar_UsersAsync(DM_Users_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userFullName", modelo.userFullName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userName", modelo.userName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPasswordPlain", modelo.userPasswordPlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userEmail", modelo.userEmail ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPhoneNumber", modelo.userPhoneNumber ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userCountryId", modelo.userCountryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userGenderId", modelo.userGenderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userBirthDay", modelo.userBirthDay ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userCreatorId", modelo.userCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userStatusId", modelo.userStatusId ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al registrar el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar el usuario.", ex);
            }
        }

        public async Task<OUTPUT> Editar_UsersAsync(DM_Users_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userId", modelo.userId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userFullName", modelo.userFullName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userEmail", modelo.userEmail ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPhoneNumber", modelo.userPhoneNumber ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userModificatorId", modelo.userModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userStatusId", modelo.userStatusId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@ForzarRecuperacion", modelo.ForzarRecuperacion ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al actualizar el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el usuario.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_UsersAsync(int? userId, int? userModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userId", userId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userModificatorId", userModificatorId ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el usuario.", ex);
            }
        }

        public async Task<OUTPUT> CambiarPassword_UsersAsync(DM_Users_cambiar_password modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_ChangePassword]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userId", modelo.userId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userModificatorId", modelo.userModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPasswordPlain", modelo.userPasswordPlain ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al cambiar la contraseña del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al cambiar la contraseña del usuario.", ex);
            }
        }

        #endregion

        #region lectura_users

        public async Task<IEnumerable<DM_Users_listar>> Listar_UsersAsync()
        {
            var list = new List<DM_Users_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_List]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderAListar(dr));
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al consultar el listado completo de usuarios en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Users_filtrar>> Filtrar_UsersAsync(string? searchTerm)
        {
            var list = new List<DM_Users_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", searchTerm ?? (object)DBNull.Value));

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderAFiltrar(dr));
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al filtrar usuarios en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Users_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Users_listar
            {
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                userPasswordDecrypted = dr["userPasswordDecrypted"] != DBNull.Value ? dr["userPasswordDecrypted"].ToString() : null,
                userEmail = dr["userEmail"] != DBNull.Value ? dr["userEmail"].ToString() : null,
                userPhoneNumber = dr["userPhoneNumber"] != DBNull.Value ? dr["userPhoneNumber"].ToString() : null,
                userCountryId = dr["userCountryId"] != DBNull.Value ? (int?)dr["userCountryId"] : null,
                userGenderId = dr["userGenderId"] != DBNull.Value ? (int?)dr["userGenderId"] : null,
                userBirthDay = dr["userBirthDay"] != DBNull.Value ? (DateTime?)dr["userBirthDay"] : null,
                userStatusId = dr["userStatusId"] != DBNull.Value ? (int?)dr["userStatusId"] : null
            };
        }

        private DM_Users_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Users_filtrar
            {
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userPassword = dr["userPassword"] != DBNull.Value ? (byte[])dr["userPassword"] : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                userEmail = dr["userEmail"] != DBNull.Value ? dr["userEmail"].ToString() : null,
                userPhoneNumber = dr["userPhoneNumber"] != DBNull.Value ? dr["userPhoneNumber"].ToString() : null,
                userBirthDay = dr["userBirthDay"] != DBNull.Value ? (DateTime?)dr["userBirthDay"] : null,
                userStatusId = dr["userStatusId"] != DBNull.Value ? (int?)dr["userStatusId"] : null
            };
        }

        #endregion

        #region JWT
        public async Task<OUTPUT> Login_UsersAsync(DM_User_Login credentials)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[sp_Users_Login]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userEmail", credentials.userEmail ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPasswordPlain", credentials.userPasswordPlain ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        if (await dr.ReadAsync())
                        {
                           
                            int userId = dr["userId"] != DBNull.Value ? Convert.ToInt32(dr["userId"]) : 0;
                            string userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString()! : string.Empty;
                            string userEmail = dr["userEmail"] != DBNull.Value ? dr["userEmail"].ToString()! : string.Empty;

                           
                            string token = _jwtService.GenerarToken(userId, userEmail, userFullName);

                           
                            result.Data = new { token, userFullName, userEmail, userId };
                        }
                    }

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al realizar el login.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al realizar el login.", ex);
            }
        }
        #endregion
    }

}

