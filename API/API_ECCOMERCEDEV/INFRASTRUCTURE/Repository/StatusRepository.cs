using APLICATION.Interfaces;
using DOMAIN.Status;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class StatusRepository : IStatusRepository
    {
        private readonly DBconexionfactory _connection;

        public StatusRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_status

        public async Task<OUTPUT> Insertar_StatusAsync(DM_StatusInsertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Status_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@statusName", modelo.statusName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusCreatorId", modelo.statusCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusStatusId", modelo.statusStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear el estado.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el estado.", ex);
            }
        }

        public async Task<OUTPUT> Editar_StatusAsync(DM_StatusEditar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Status_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@statusId", modelo.statusId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusName", modelo.statusName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusStatusId", modelo.statusStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar el estado.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el estado.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_StatusAsync(int? statusId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Status_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@statusId", statusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar el estado.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el estado.", ex);
            }
        }

        #endregion

        #region lectura_status

        public async Task<IEnumerable<DM_StatusListar>> Listar_StatusAsync()
        {
            var list = new List<DM_StatusListar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Status_List]", con))
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
                throw new Exception("Error al consultar el listado completo de estados en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_StatusFiltrar>> Filtrar_StatusAsync(DM_StatusFilter filtro)
        {
            var list = new List<DM_StatusFiltrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Status_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@statusId", filtro.statusId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusName", filtro.statusName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusCreatorId", filtro.statusCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusCreationDate", filtro.statusCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusStatusId", filtro.statusStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar estados en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_StatusListar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_StatusListar
            {
                statusId = dr["statusId"] != DBNull.Value ? (int?)dr["statusId"] : null,
                statusName = dr["statusName"] != DBNull.Value ? dr["statusName"].ToString() : null,
                statusCreatorId = dr["statusCreatorId"] != DBNull.Value ? (int?)dr["statusCreatorId"] : null,
                statusCreationDate = dr["statusCreationDate"] != DBNull.Value ? (DateTime?)dr["statusCreationDate"] : null,
                statusStatusId = dr["statusStatusId"] != DBNull.Value ? (int?)dr["statusStatusId"] : null
            };
        }

        private DM_StatusFiltrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_StatusFiltrar
            {
                statusId = dr["statusId"] != DBNull.Value ? (int?)dr["statusId"] : null,
                statusName = dr["statusName"] != DBNull.Value ? dr["statusName"].ToString() : null,
                statusCreatorId = dr["statusCreatorId"] != DBNull.Value ? (int?)dr["statusCreatorId"] : null,
                statusCreationDate = dr["statusCreationDate"] != DBNull.Value ? (DateTime?)dr["statusCreationDate"] : null,
                statusStatusId = dr["statusStatusId"] != DBNull.Value ? (int?)dr["statusStatusId"] : null
            };
        }

        #endregion
    }
}
