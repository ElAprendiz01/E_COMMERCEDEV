using APLICATION.Interfaces;
using DOMAIN.PriceHistory;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class PriceHistoryRepository : IPriceHistoryRepository
    {
        private readonly DBconexionfactory _connection;

        public PriceHistoryRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_pricehistory

        public async Task<OUTPUT> Insertar_PriceHistoryAsync(DM_PriceHistoryInsertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PriceHistory_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@priceHistoryProductVariableId", modelo.PriceHistoryProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryOldPrice", modelo.PriceHistoryOldPrice ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryNewPrice", modelo.PriceHistoryNewPrice ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryModifierId", modelo.PriceHistoryModifierId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al crear el historial de precio: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al crear el historial de precio: {ex.Message}", ex);
            }
        }

        #endregion

        #region lectura_pricehistory

        public async Task<IEnumerable<DM_PriceHistoryListar>> Listar_PriceHistoryAsync()
        {
            var list = new List<DM_PriceHistoryListar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PriceHistory_List]", con))
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
                throw new Exception($"Error al consultar el listado completo del historial de precios: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al consultar el listado completo del historial de precios: {ex.Message}", ex);
            }
        }

        public async Task<IEnumerable<DM_PriceHistoryFiltrar>> Filtrar_PriceHistoryAsync(DM_PriceHistoryFiltrar filtro)
        {
            var list = new List<DM_PriceHistoryFiltrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PriceHistory_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@priceHistoryId", filtro.PriceHistoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryProductVariableId", filtro.PriceHistoryProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryOldPrice", filtro.PriceHistoryOldPrice ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryNewPrice", filtro.PriceHistoryNewPrice ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryModifierId", filtro.PriceHistoryModifierId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@priceHistoryChangeDate", filtro.PriceHistoryChangeDate ?? (object)DBNull.Value));

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
                throw new Exception($"Error al filtrar el historial de precios en la base de datos: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al filtrar el historial de precios: {ex.Message}", ex);
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
                return Convert.ToInt32(dr.GetValue(ordinal));
            }
            catch
            {
                return null;
            }
        }

        private decimal? ObtenerDecimal(SqlDataReader dr, string column)
        {
            try
            {
                int ordinal = dr.GetOrdinal(column);
                if (dr.IsDBNull(ordinal)) return null;
                return Convert.ToDecimal(dr.GetValue(ordinal));
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

        private DM_PriceHistoryListar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_PriceHistoryListar
            {
                PriceHistoryId = ObtenerInt(dr, "priceHistoryId"),
                PriceHistoryProductVariableId = ObtenerInt(dr, "priceHistoryProductVariableId"),
                PriceHistoryOldPrice = ObtenerDecimal(dr, "priceHistoryOldPrice"),
                PriceHistoryNewPrice = ObtenerDecimal(dr, "priceHistoryNewPrice"),
                PriceHistoryChangeDate = ObtenerDateTime(dr, "priceHistoryChangeDate"),
                PriceHistoryModifierId = ObtenerInt(dr, "priceHistoryModifierId")
            };
        }

        private DM_PriceHistoryFiltrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_PriceHistoryFiltrar
            {
                PriceHistoryId = ObtenerInt(dr, "priceHistoryId"),
                PriceHistoryProductVariableId = ObtenerInt(dr, "priceHistoryProductVariableId"),
                PriceHistoryOldPrice = ObtenerDecimal(dr, "priceHistoryOldPrice"),
                PriceHistoryNewPrice = ObtenerDecimal(dr, "priceHistoryNewPrice"),
                PriceHistoryModifierId = ObtenerInt(dr, "priceHistoryModifierId"),
                PriceHistoryChangeDate = ObtenerDateTime(dr, "priceHistoryChangeDate")
            };
        }

        #endregion
    }
}
