using APLICATION.Interfaces;
using DOMAIN.Marks;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class MarksRepository : IMarksRepository
    {
        private readonly DBconexionfactory _connection;

        public MarksRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_marks

        public async Task<OUTPUT> Insertar_MarksAsync(DM_Marks_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Marks_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markName", modelo.markName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markDescription", modelo.markDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markCreatorId", modelo.markCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markStatusId", modelo.markStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar la marca.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar la marca.", ex);
            }
        }

        public async Task<OUTPUT> Editar_MarksAsync(DM_Marks_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Marks_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markId", modelo.markId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markName", modelo.markName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markDescription", modelo.markDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markModificatorId", modelo.markModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markStatusId", modelo.markStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar la marca.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la marca.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_MarksAsync(int? markId, int? markModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Marks_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@markId", markId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@markModificatorId", markModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica la marca.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la marca.", ex);
            }
        }

        #endregion

        #region lectura_marks

        public async Task<IEnumerable<DM_Marks_listar>> Listar_MarksAsync()
        {
            var list = new List<DM_Marks_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Marks_List]", con))
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
                throw new Exception("Error al consultar el listado completo de marcas en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Marks_filtrar>> Filtrar_MarksAsync(string? searchTerm)
        {
            var list = new List<DM_Marks_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Marks_Filter]", con))
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
                throw new Exception("Error al filtrar marcas en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Marks_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Marks_listar
            {
                MarcaID = dr["MarcaID"] != DBNull.Value ? (int?)dr["MarcaID"] : null,
                Marca = dr["Marca"] != DBNull.Value ? dr["Marca"].ToString() : null,
                Descripcion = dr["Descripcion"] != DBNull.Value ? dr["Descripcion"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                FechaCreacion = dr["FechaCreacion"] != DBNull.Value ? (DateTime?)dr["FechaCreacion"] : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr.IsDBNull(dr.GetOrdinal("EstadoID")) ? null : Convert.ToBoolean(dr["EstadoID"]),
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        private DM_Marks_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Marks_filtrar
            {
                MarcaID = dr["MarcaID"] != DBNull.Value ? (int?)dr["MarcaID"] : null,
                Marca = dr["Marca"] != DBNull.Value ? dr["Marca"].ToString() : null,
                Descripcion = dr["Descripcion"] != DBNull.Value ? dr["Descripcion"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                FechaCreacion = dr["FechaCreacion"] != DBNull.Value ? (DateTime?)dr["FechaCreacion"] : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr.IsDBNull(dr.GetOrdinal("EstadoID")) ? null : Convert.ToBoolean(dr["EstadoID"]),
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        #endregion
    }
}
