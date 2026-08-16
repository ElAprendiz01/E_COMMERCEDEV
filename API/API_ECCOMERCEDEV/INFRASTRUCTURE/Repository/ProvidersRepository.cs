using APLICATION.Interfaces;
using DOMAIN.Providers;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class ProvidersRepository : IProvidersRepository
    {
        private readonly DBconexionfactory _connection;

        public ProvidersRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_providers

        public async Task<OUTPUT> Insertar_ProvidersAsync(DM_Providers_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Providers_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@providerName", modelo.providerName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerDescription", modelo.providerDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerCreatorId", modelo.providerCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerStatusId", modelo.providerStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear el proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el proveedor.", ex);
            }
        }

        public async Task<OUTPUT> Editar_ProvidersAsync(DM_Providers_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Providers_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@providerId", modelo.providerId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerName", modelo.providerName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerDescription", modelo.providerDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerModificatorId", modelo.providerModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerStatusId", modelo.providerStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el proveedor.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_ProvidersAsync(int? providerId, int? providerModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Providers_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@providerId", providerId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerModificatorId", providerModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el proveedor.", ex);
            }
        }

        #endregion

        #region lectura_providers

        public async Task<IEnumerable<DM_Providers_listar>> Listar_ProvidersAsync()
        {
            var list = new List<DM_Providers_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Providers_List]", con))
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
                throw new Exception("Error al consultar el listado completo de proveedores en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Providers_filtrar>> Filtrar_ProvidersAsync(string? searchTerm, int? providerId)
        {
            var list = new List<DM_Providers_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Providers_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", searchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@providerId", providerId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar proveedores en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Providers_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Providers_listar
            {
                providerId = dr["providerId"] != DBNull.Value ? (int?)dr["providerId"] : null,
                providerName = dr["providerName"] != DBNull.Value ? dr["providerName"].ToString() : null,
                providerDescription = dr["providerDescription"] != DBNull.Value ? dr["providerDescription"].ToString() : null,
                providerCreatorId = dr["providerCreatorId"] != DBNull.Value ? (int?)dr["providerCreatorId"] : null,
                providerStatusId = dr["providerStatusId"] != DBNull.Value ? (bool?)dr["providerStatusId"] : null
            };
        }

        private DM_Providers_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Providers_filtrar
            {
                providerId = dr["providerId"] != DBNull.Value ? (int?)dr["providerId"] : null,
                providerName = dr["providerName"] != DBNull.Value ? dr["providerName"].ToString() : null,
                providerDescription = dr["providerDescription"] != DBNull.Value ? dr["providerDescription"].ToString() : null,
                providerStatusId = dr["providerStatusId"] != DBNull.Value ? (bool?)dr["providerStatusId"] : null
            };
        }

        #endregion
    }
}
