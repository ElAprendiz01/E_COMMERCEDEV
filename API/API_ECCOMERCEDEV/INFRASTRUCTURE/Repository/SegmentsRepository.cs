using APLICATION.Interfaces;
using DOMAIN.Segments;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class SegmentsRepository : ISegmentsRepository
    {
        private readonly DBconexionfactory _connection;

        public SegmentsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_segments

        public async Task<OUTPUT> Insertar_SegmentsAsync(DM_Segments_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Segments_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@segmentName", modelo.segmentName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentDescription", modelo.segmentDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentCreatorId", modelo.segmentCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentStatusId", modelo.segmentStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar el segmento.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar el segmento.", ex);
            }
        }

        public async Task<OUTPUT> Editar_SegmentsAsync(DM_Segments_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Segments_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@segmentId", modelo.segmentId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentName", modelo.segmentName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentDescription", modelo.segmentDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentModificatorId", modelo.segmentModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentStatusId", modelo.segmentStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el segmento.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el segmento.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_SegmentsAsync(int? segmentId, int? segmentModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Segments_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@segmentId", segmentId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@segmentModificatorId", segmentModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el segmento.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el segmento.", ex);
            }
        }

        #endregion

        #region lectura_segments

        public async Task<IEnumerable<DM_Segments_listar>> Listar_SegmentsAsync()
        {
            var list = new List<DM_Segments_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Segments_List]", con))
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
                throw new Exception("Error al consultar el listado completo de segmentos en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Segments_filtrar>> Filtrar_SegmentsAsync(string? searchTerm)
        {
            var list = new List<DM_Segments_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Segments_Filter]", con))
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
                throw new Exception("Error al filtrar segmentos en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Segments_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Segments_listar
            {
                segmentId = dr["segmentId"] != DBNull.Value ? (int?)dr["segmentId"] : null,
                segmentName = dr["segmentName"] != DBNull.Value ? dr["segmentName"].ToString() : null,
                segmentDescription = dr["segmentDescription"] != DBNull.Value ? dr["segmentDescription"].ToString() : null,
                segmentCreatorId = dr["segmentCreatorId"] != DBNull.Value ? (int?)dr["segmentCreatorId"] : null,
                segmentStatusId = dr["segmentStatusId"] != DBNull.Value ? (bool?)dr["segmentStatusId"] : null,
                segmentCreationDate = dr["segmentCreationDate"] != DBNull.Value ? (DateTime?)dr["segmentCreationDate"] : null,
                segmentModificationDate = dr["segmentModificationDate"] != DBNull.Value ? (DateTime?)dr["segmentModificationDate"] : null
            };
        }

        private DM_Segments_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Segments_filtrar
            {
                segmentId = dr["segmentId"] != DBNull.Value ? (int?)dr["segmentId"] : null,
                segmentName = dr["segmentName"] != DBNull.Value ? dr["segmentName"].ToString() : null,
                segmentDescription = dr["segmentDescription"] != DBNull.Value ? dr["segmentDescription"].ToString() : null,
                segmentStatusId = dr["segmentStatusId"] != DBNull.Value ? (bool?)dr["segmentStatusId"] : null
            };
        }

        #endregion
    }
}
