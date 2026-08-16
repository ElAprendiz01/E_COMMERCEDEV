using APLICATION.Interfaces;
using DOMAIN.MarkByProviders;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class MarkByProvidersRepository : IMarkByProvidersRepository
    {
        private readonly DBconexionfactory _connection;

        public MarkByProvidersRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        public async Task<OUTPUT> Insertar_MarkByProvidersAsync(DM_MarkByProviders_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_MarkByProviders_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markByProviderMarkId", modelo.MarkByProviderMarkId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderProviderId", modelo.MarkByProviderProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderCreatorId", modelo.MarkByProviderCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderStatusId", modelo.MarkByProviderStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar la marca por proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar la marca por proveedor.", ex);
            }
        }

        public async Task<OUTPUT> Editar_MarkByProvidersAsync(DM_MarkByProviders_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_MarkByProviders_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markByProviderId", modelo.MarkByProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderMarkId", modelo.MarkByProviderMarkId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderProviderId", modelo.MarkByProviderProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderModificatorId", modelo.MarkByProviderModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderStatusId", modelo.MarkByProviderStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar la marca por proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la marca por proveedor.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_MarkByProvidersAsync(int markByProviderId, int markByProviderModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_MarkByProviders_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markByProviderId", markByProviderId));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderModificatorId", markByProviderModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar la marca por proveedor.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la marca por proveedor.", ex);
            }
        }

        public async Task<IEnumerable<DM_MarkByProviders_listar>> Listar_MarkByProvidersAsync()
        {
            var list = new List<DM_MarkByProviders_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_MarkByProviders_List]", con))
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
                throw new Exception("Error al consultar el listado completo de marcas por proveedor.", ex);
            }
        }

        public async Task<IEnumerable<DM_MarkByProviders_filtrar>> Filtrar_MarkByProvidersAsync(DM_MarkByProviders_filtrar filtro)
        {
            var list = new List<DM_MarkByProviders_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_MarkByProviders_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markByProviderId", filtro.MarkByProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderMarkId", filtro.MarkByProviderMarkId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderProviderId", filtro.MarkByProviderProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderCreatorId", filtro.MarkByProviderCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderCreationDate", filtro.MarkByProviderCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderModificatorId", filtro.MarkByProviderModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderModificationDate", filtro.MarkByProviderModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markByProviderStatusId", filtro.MarkByProviderStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar las marcas por proveedor.", ex);
            }
        }

        private DM_MarkByProviders_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_MarkByProviders_listar
            {
                MarkByProviderId = dr["markByProviderId"] != DBNull.Value ? (int?)dr["markByProviderId"] : null,
                MarkByProviderMarkId = dr["markByProviderMarkId"] != DBNull.Value ? (int?)dr["markByProviderMarkId"] : null,
                MarkByProviderProviderId = dr["markByProviderProviderId"] != DBNull.Value ? (int?)dr["markByProviderProviderId"] : null,
                MarkByProviderCreatorId = dr["markByProviderCreatorId"] != DBNull.Value ? (int?)dr["markByProviderCreatorId"] : null,
                MarkByProviderStatusId = dr["markByProviderStatusId"] != DBNull.Value ? (bool?)dr["markByProviderStatusId"] : null
            };
        }

        private DM_MarkByProviders_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_MarkByProviders_filtrar
            {
                MarkByProviderId = dr["markByProviderId"] != DBNull.Value ? (int?)dr["markByProviderId"] : null,
                MarkByProviderMarkId = dr["markByProviderMarkId"] != DBNull.Value ? (int?)dr["markByProviderMarkId"] : null,
                MarkByProviderProviderId = dr["markByProviderProviderId"] != DBNull.Value ? (int?)dr["markByProviderProviderId"] : null,
                MarkByProviderCreatorId = dr["markByProviderCreatorId"] != DBNull.Value ? (int?)dr["markByProviderCreatorId"] : null,
                MarkByProviderCreationDate = dr["markByProviderCreationDate"] != DBNull.Value ? (DateTime?)dr["markByProviderCreationDate"] : null,
                MarkByProviderModificatorId = dr["markByProviderModificatorId"] != DBNull.Value ? (int?)dr["markByProviderModificatorId"] : null,
                MarkByProviderModificationDate = dr["markByProviderModificationDate"] != DBNull.Value ? (DateTime?)dr["markByProviderModificationDate"] : null,
                MarkByProviderStatusId = dr["markByProviderStatusId"] != DBNull.Value ? (bool?)dr["markByProviderStatusId"] : null
            };
        }
    }
}
