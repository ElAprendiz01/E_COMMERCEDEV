using APLICATION.Interfaces;
using DOMAIN.StockMovementTypes;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class StockMovementTypesRepository : IStockMovementTypesRepository
    {
        private readonly DBconexionfactory _connection;

        public StockMovementTypesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_stockmovementtypes

        public async Task<OUTPUT> Insertar_StockMovementTypesAsync(DM_StockMovementTypesInsertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_StockMovementTypes_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeName", modelo.StockMovementTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeDescription", modelo.StockMovementTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeCreatorId", modelo.StockMovementTypeCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeStatusId", modelo.StockMovementTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al crear el tipo de movimiento de stock: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al crear el tipo de movimiento de stock: {ex.Message}", ex);
            }
        }

        public async Task<OUTPUT> Editar_StockMovementTypesAsync(DM_StockMovementTypesEditar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_StockMovementTypes_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeId", modelo.StockMovementTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeName", modelo.StockMovementTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeDescription", modelo.StockMovementTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificatorId", modelo.StockMovementTypeModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeStatusId", modelo.StockMovementTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al actualizar el tipo de movimiento de stock: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al actualizar el tipo de movimiento de stock: {ex.Message}", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_StockMovementTypesAsync(int? stockMovementTypeId, int? stockMovementTypeModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_StockMovementTypes_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeId", stockMovementTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificatorId", stockMovementTypeModificatorId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al eliminar el tipo de movimiento de stock: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al eliminar el tipo de movimiento de stock: {ex.Message}", ex);
            }
        }

        #endregion

        #region lectura_stockmovementtypes

        public async Task<IEnumerable<DM_StockMovementTypesListar>> Listar_StockMovementTypesAsync()
        {
            var list = new List<DM_StockMovementTypesListar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_StockMovementTypes_List]", con))
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
                throw new Exception($"Error al consultar el listado completo de tipos de movimientos de stock: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al consultar el listado completo de tipos de movimientos de stock: {ex.Message}", ex);
            }
        }

        public async Task<IEnumerable<DM_StockMovementTypesFiltrar>> Filtrar_StockMovementTypesAsync(DM_StockMovementTypesFiltrar filtro)
        {
            var list = new List<DM_StockMovementTypesFiltrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_StockMovementTypes_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeId", filtro.StockMovementTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeName", filtro.StockMovementTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeDescription", filtro.StockMovementTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeCreatorId", filtro.StockMovementTypeCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeCreationDate", filtro.StockMovementTypeCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificatorId", filtro.StockMovementTypeModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificationDate", filtro.StockMovementTypeModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementTypeStatusId", filtro.StockMovementTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception($"Error al filtrar tipos de movimientos de stock en la base de datos: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al filtrar tipos de movimientos de stock: {ex.Message}", ex);
            }
        }

        #endregion

        #region mapeadores

        private int? ObtenerInt(SqlDataReader dr, string column)
        {
            try
            {
                int ordinal = dr.GetOrdinal(column);
                if (dr.IsDBNull(ordinal)) return null;
                object val = dr.GetValue(ordinal);
                if (val is bool b) return b ? 1 : 0;
                return Convert.ToInt32(val);
            }
            catch
            {
                return null;
            }
        }

        private bool? ObtenerBool(SqlDataReader dr, string column)
        {
            try
            {
                int ordinal = dr.GetOrdinal(column);
                if (dr.IsDBNull(ordinal)) return null;
                object val = dr.GetValue(ordinal);
                if (val is bool b) return b;
                return Convert.ToBoolean(val);
            }
            catch
            {
                return null;
            }
        }

        private string? ObtenerString(SqlDataReader dr, string column)
        {
            try
            {
                int ordinal = dr.GetOrdinal(column);
                if (dr.IsDBNull(ordinal)) return null;
                return dr.GetValue(ordinal)?.ToString();
            }
            catch
            {
                return null;
            }
        }

        private DateTime? ObtenerDateTime(SqlDataReader dr, string column)
        {
            try
            {
                int ordinal = dr.GetOrdinal(column);
                if (dr.IsDBNull(ordinal)) return null;
                return Convert.ToDateTime(dr.GetValue(ordinal));
            }
            catch
            {
                return null;
            }
        }

        private DM_StockMovementTypesListar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_StockMovementTypesListar
            {
                StockMovementTypeId = ObtenerInt(dr, "stockMovementTypeId"),
                StockMovementTypeName = ObtenerString(dr, "stockMovementTypeName"),
                StockMovementTypeDescription = ObtenerString(dr, "stockMovementTypeDescription"),
                StockMovementTypeCreatorId = ObtenerInt(dr, "stockMovementTypeCreatorId"),
                StockMovementTypeStatusId = ObtenerBool(dr, "stockMovementTypeStatusId")
            };
        }

        private DM_StockMovementTypesFiltrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_StockMovementTypesFiltrar
            {
                StockMovementTypeId = ObtenerInt(dr, "stockMovementTypeId"),
                StockMovementTypeName = ObtenerString(dr, "stockMovementTypeName"),
                StockMovementTypeDescription = ObtenerString(dr, "stockMovementTypeDescription"),
                StockMovementTypeCreatorId = ObtenerInt(dr, "stockMovementTypeCreatorId"),
                StockMovementTypeCreationDate = ObtenerDateTime(dr, "stockMovementTypeCreationDate"),
                StockMovementTypeModificatorId = ObtenerInt(dr, "stockMovementTypeModificatorId"),
                StockMovementTypeModificationDate = ObtenerDateTime(dr, "stockMovementTypeModificationDate"),
                StockMovementTypeStatusId = ObtenerBool(dr, "stockMovementTypeStatusId")
            };
        }

        #endregion
    }
}
