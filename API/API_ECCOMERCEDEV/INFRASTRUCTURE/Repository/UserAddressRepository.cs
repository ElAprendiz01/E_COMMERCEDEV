using APLICATION.Interfaces;
using DOMAIN.UserAddress;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class UserAddressRepository : IUserAddressRepository
    {
        private readonly DBconexionfactory _connection;

        public UserAddressRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_useraddress

        public async Task<OUTPUT> Insertar_UserAddressAsync(DM_UserAddress_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserAddress_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userAddressUserId", modelo.userAddressUserId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressCountryId", modelo.userAddressCountryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressZIPCode", modelo.userAddressZIPCode ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressDescription", modelo.userAddressDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressIsPrincipal", modelo.userAddressIsPrincipal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressCreatorId", modelo.userAddressCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressStatusId", modelo.userAddressStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar la dirección del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar la dirección del usuario.", ex);
            }
        }

        public async Task<OUTPUT> Editar_UserAddressAsync(DM_UserAddress_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserAddress_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userAddressId", modelo.userAddressId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressCountryId", modelo.userAddressCountryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressZIPCode", modelo.userAddressZIPCode ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressDescription", modelo.userAddressDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressIsPrincipal", modelo.userAddressIsPrincipal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressModificatorId", modelo.userAddressModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressStatusId", modelo.userAddressStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar la dirección del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la dirección del usuario.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_UserAddressAsync(int? userAddressId, int? userAddressModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserAddress_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userAddressId", userAddressId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userAddressModificatorId", userAddressModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica la dirección del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la dirección del usuario.", ex);
            }
        }

        #endregion

        #region lectura_useraddress

        public async Task<IEnumerable<DM_UserAddress_listar>> Listar_UserAddressAsync()
        {
            var list = new List<DM_UserAddress_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserAddress_List]", con))
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
                throw new Exception("Error al consultar el listado completo de direcciones de usuarios en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_UserAddress_filtrar>> Filtrar_UserAddressAsync(int? userId, string? searchTerm)
        {
            var list = new List<DM_UserAddress_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserAddress_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@UserId", userId ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar direcciones de usuarios en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_UserAddress_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_UserAddress_listar
            {
                userAddressId = dr["userAddressId"] != DBNull.Value ? (int?)dr["userAddressId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                userEmail = dr["userEmail"] != DBNull.Value ? dr["userEmail"].ToString() : null,
                countryId = dr["countryId"] != DBNull.Value ? (int?)dr["countryId"] : null,
                zipCode = dr["zipCode"] != DBNull.Value ? (int?)dr["zipCode"] : null,
                addressDescription = dr["addressDescription"] != DBNull.Value ? dr["addressDescription"].ToString() : null,
                isPrincipal = dr["isPrincipal"] != DBNull.Value ? (bool?)dr["isPrincipal"] : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        private DM_UserAddress_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_UserAddress_filtrar
            {
                userAddressId = dr["userAddressId"] != DBNull.Value ? (int?)dr["userAddressId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                userEmail = dr["userEmail"] != DBNull.Value ? dr["userEmail"].ToString() : null,
                countryId = dr["countryId"] != DBNull.Value ? (int?)dr["countryId"] : null,
                zipCode = dr["zipCode"] != DBNull.Value ? (int?)dr["zipCode"] : null,
                addressDescription = dr["addressDescription"] != DBNull.Value ? dr["addressDescription"].ToString() : null,
                isPrincipal = dr["isPrincipal"] != DBNull.Value ? (bool?)dr["isPrincipal"] : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        #endregion
    }
}
