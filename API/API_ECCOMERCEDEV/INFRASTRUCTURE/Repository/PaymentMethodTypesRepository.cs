using APLICATION.Interfaces;
using DOMAIN.PaymentMethodTypes;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class PaymentMethodTypesRepository : IPaymentMethodTypesRepository
    {
        private readonly DBconexionfactory _connection;

        public PaymentMethodTypesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_paymentmethodtypes

        public async Task<OUTPUT> Insertar_PaymentMethodTypesAsync(DM_PaymentMethodTypes_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_PaymentMethodTypes_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeName", modelo.paymentMethodTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeDescription", modelo.paymentMethodTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeCreatorId", modelo.paymentMethodTypeCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeStatusId", modelo.paymentMethodTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar el tipo de método de pago.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar el tipo de método de pago.", ex);
            }
        }

        public async Task<OUTPUT> Editar_PaymentMethodTypesAsync(DM_PaymentMethodTypes_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_PaymentMethodTypes_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeId", modelo.paymentMethodTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeName", modelo.paymentMethodTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeDescription", modelo.paymentMethodTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificatorId", modelo.paymentMethodTypeModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeStatusId", modelo.paymentMethodTypeStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el tipo de método de pago.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el tipo de método de pago.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_PaymentMethodTypesAsync(int? paymentMethodTypeId, int? paymentMethodTypeModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_PaymentMethodTypes_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeId", paymentMethodTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificatorId", paymentMethodTypeModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el tipo de método de pago.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el tipo de método de pago.", ex);
            }
        }

        #endregion

        #region lectura_paymentmethodtypes

        public async Task<IEnumerable<DM_PaymentMethodTypes_listar>> Listar_PaymentMethodTypesAsync()
        {
            var list = new List<DM_PaymentMethodTypes_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_PaymentMethodTypes_List]", con))
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
                throw new Exception("Error al consultar el listado completo de tipos de métodos de pago en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_PaymentMethodTypes_filtrar>> Filtrar_PaymentMethodTypesAsync(string? searchTerm)
        {
            var list = new List<DM_PaymentMethodTypes_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_PaymentMethodTypes_Filter]", con))
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
                throw new Exception("Error al filtrar tipos de métodos de pago en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_PaymentMethodTypes_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_PaymentMethodTypes_listar
            {
                paymentMethodTypeId = dr["paymentMethodTypeId"] != DBNull.Value ? (int?)dr["paymentMethodTypeId"] : null,
                paymentMethodTypeName = dr["paymentMethodTypeName"] != DBNull.Value ? dr["paymentMethodTypeName"].ToString() : null,
                paymentMethodTypeDescription = dr["paymentMethodTypeDescription"] != DBNull.Value ? dr["paymentMethodTypeDescription"].ToString() : null,
                paymentMethodTypeCreatorId = dr["paymentMethodTypeCreatorId"] != DBNull.Value ? (int?)dr["paymentMethodTypeCreatorId"] : null,
                paymentMethodTypeCreationDate = dr["paymentMethodTypeCreationDate"] != DBNull.Value ? (DateTime?)dr["paymentMethodTypeCreationDate"] : null,
                paymentMethodTypeModificatorId = dr["paymentMethodTypeModificatorId"] != DBNull.Value ? (int?)dr["paymentMethodTypeModificatorId"] : null,
                paymentMethodTypeModificationDate = dr["paymentMethodTypeModificationDate"] != DBNull.Value ? (DateTime?)dr["paymentMethodTypeModificationDate"] : null,
                paymentMethodTypeStatusId = dr["paymentMethodTypeStatusId"] != DBNull.Value ? (bool?)dr["paymentMethodTypeStatusId"] : null
            };
        }

        private DM_PaymentMethodTypes_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_PaymentMethodTypes_filtrar
            {
                paymentMethodTypeId = dr["paymentMethodTypeId"] != DBNull.Value ? (int?)dr["paymentMethodTypeId"] : null,
                paymentMethodTypeName = dr["paymentMethodTypeName"] != DBNull.Value ? dr["paymentMethodTypeName"].ToString() : null,
                paymentMethodTypeDescription = dr["paymentMethodTypeDescription"] != DBNull.Value ? dr["paymentMethodTypeDescription"].ToString() : null,
                paymentMethodTypeStatusId = dr["paymentMethodTypeStatusId"] != DBNull.Value ? (bool?)dr["paymentMethodTypeStatusId"] : null
            };
        }

        #endregion
    }
}
