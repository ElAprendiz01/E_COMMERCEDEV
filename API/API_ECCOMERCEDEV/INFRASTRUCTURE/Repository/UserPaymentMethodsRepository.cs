using APLICATION.Interfaces;
using DOMAIN.UserPaymentMethods;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class UserPaymentMethodsRepository : IUserPaymentMethodsRepository
    {
        private readonly DBconexionfactory _connection;

        public UserPaymentMethodsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_userpaymentmethods

        public async Task<OUTPUT> Insertar_UserPaymentMethodsAsync(DM_UserPaymentMethods_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserPaymentMethods_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodUserId", modelo.userPaymentMethodUserId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodPaymentMethodTypeId", modelo.userPaymentMethodPaymentMethodTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@CardNumberPlain", modelo.CardNumberPlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationDatePlain", modelo.ExpirationDatePlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@CVVPlain", modelo.CVVPlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCardHolderName", modelo.userPaymentMethodCardHolderName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCreatorId", modelo.userPaymentMethodCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodStatusId", modelo.userPaymentMethodStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar el método de pago del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar el método de pago del usuario.", ex);
            }
        }

        public async Task<OUTPUT> Editar_UserPaymentMethodsAsync(DM_UserPaymentMethods_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserPaymentMethods_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodId", modelo.userPaymentMethodId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodPaymentMethodTypeId", modelo.userPaymentMethodPaymentMethodTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@CardNumberPlain", modelo.CardNumberPlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationDatePlain", modelo.ExpirationDatePlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@CVVPlain", modelo.CVVPlain ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCardHolderName", modelo.userPaymentMethodCardHolderName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificatorId", modelo.userPaymentMethodModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodStatusId", modelo.userPaymentMethodStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el método de pago del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el método de pago del usuario.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_UserPaymentMethodsAsync(int? userPaymentMethodId, int? userPaymentMethodModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserPaymentMethods_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodId", userPaymentMethodId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificatorId", userPaymentMethodModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el método de pago del usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el método de pago del usuario.", ex);
            }
        }

        #endregion

        #region lectura_userpaymentmethods

        public async Task<IEnumerable<DM_UserPaymentMethods_listar>> Listar_UserPaymentMethodsAsync()
        {
            var list = new List<DM_UserPaymentMethods_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserPaymentMethods_List]", con))
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
                throw new Exception("Error al consultar el listado completo de métodos de pago de usuarios en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_UserPaymentMethods_filtrar>> Filtrar_UserPaymentMethodsAsync(string? searchTerm)
        {
            var list = new List<DM_UserPaymentMethods_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_UserPaymentMethods_Filter]", con))
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
                throw new Exception("Error al filtrar métodos de pago de usuarios en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_UserPaymentMethods_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_UserPaymentMethods_listar
            {
                userPaymentMethodId = dr["userPaymentMethodId"] != DBNull.Value ? (int?)dr["userPaymentMethodId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                paymentMethodTypeId = dr["paymentMethodTypeId"] != DBNull.Value ? (int?)dr["paymentMethodTypeId"] : null,
                paymentMethodTypeName = dr["paymentMethodTypeName"] != DBNull.Value ? dr["paymentMethodTypeName"].ToString() : null,
                cardNumberDecrypted = dr["cardNumberDecrypted"] != DBNull.Value ? dr["cardNumberDecrypted"].ToString() : null,
                expirationDateDecrypted = dr["expirationDateDecrypted"] != DBNull.Value ? dr["expirationDateDecrypted"].ToString() : null,
                cvvDecrypted = dr["cvvDecrypted"] != DBNull.Value ? dr["cvvDecrypted"].ToString() : null,
                cardHolderName = dr["cardHolderName"] != DBNull.Value ? dr["cardHolderName"].ToString() : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        private DM_UserPaymentMethods_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_UserPaymentMethods_filtrar
            {
                userPaymentMethodId = dr["userPaymentMethodId"] != DBNull.Value ? (int?)dr["userPaymentMethodId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                paymentMethodTypeId = dr["paymentMethodTypeId"] != DBNull.Value ? (int?)dr["paymentMethodTypeId"] : null,
                paymentMethodTypeName = dr["paymentMethodTypeName"] != DBNull.Value ? dr["paymentMethodTypeName"].ToString() : null,
                cardNumberDecrypted = dr["cardNumberDecrypted"] != DBNull.Value ? dr["cardNumberDecrypted"].ToString() : null,
                expirationDateDecrypted = dr["expirationDateDecrypted"] != DBNull.Value ? dr["expirationDateDecrypted"].ToString() : null,
                cvvDecrypted = dr["cvvDecrypted"] != DBNull.Value ? dr["cvvDecrypted"].ToString() : null,
                cardHolderName = dr["cardHolderName"] != DBNull.Value ? dr["cardHolderName"].ToString() : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        #endregion
    }
}
