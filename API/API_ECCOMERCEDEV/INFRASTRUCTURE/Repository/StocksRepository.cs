using APLICATION.Interfaces;
using DOMAIN.Stocks;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class StocksRepository : IStocksRepository
    {
        private readonly DBconexionfactory _connection;

        public StocksRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura

        public async Task<OUTPUT> Insertar_StocksAsync(DM_Stocks_create modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_Stocks_Create", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockProductVariableId", modelo.StockProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockQuantity", modelo.StockQuantity ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockFactoryDate", modelo.StockFactoryDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockExpirationDate", modelo.StockExpirationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockCreatorId", modelo.StockCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockStatusId", modelo.StockStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en SQL Server al insertar el stock.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al insertar el stock.", ex);
            }
        }

        public async Task<OUTPUT> Actualizar_StocksAsync(DM_Stocks_update modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_Stocks_Update", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockId", modelo.StockId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockQuantityAdjustment", modelo.StockQuantityAdjustment ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockModificatorId", modelo.StockModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en SQL Server al actualizar el stock.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al actualizar el stock.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_StocksAsync(int? stockId, int? stockModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_Stocks_Delete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockId", stockId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockModificatorId", stockModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en SQL Server al eliminar el stock.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al eliminar el stock.", ex);
            }
        }

        #endregion

        #region lectura

        public async Task<IEnumerable<DM_Stocks_listar>> Listar_StocksAsync()
        {
            var list = new List<DM_Stocks_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_Stocks_List", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(new DM_Stocks_listar
                            {
                                StockId = dr.IsDBNull(dr.GetOrdinal("stockId")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("stockId")),
                                ProductVariableId = dr.IsDBNull(dr.GetOrdinal("productVariableId")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("productVariableId")),
                                ProductName = dr.IsDBNull(dr.GetOrdinal("productName")) ? null : dr.GetString(dr.GetOrdinal("productName")),
                                VariableValue = dr.IsDBNull(dr.GetOrdinal("variableValue")) ? null : dr.GetString(dr.GetOrdinal("variableValue")),
                                UnitPrice = dr.IsDBNull(dr.GetOrdinal("unitPrice")) ? null : (decimal?)dr.GetDecimal(dr.GetOrdinal("unitPrice")),
                                CurrencyISO = dr.IsDBNull(dr.GetOrdinal("currencyISO")) ? null : dr.GetString(dr.GetOrdinal("currencyISO")),
                                Quantity = dr.IsDBNull(dr.GetOrdinal("quantity")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("quantity")),
                                FactoryDate = dr.IsDBNull(dr.GetOrdinal("factoryDate")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("factoryDate")),
                                ExpirationDate = dr.IsDBNull(dr.GetOrdinal("expirationDate")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("expirationDate")),
                                StatusId = dr.IsDBNull(dr.GetOrdinal("statusId")) ? null : (bool?)dr.GetBoolean(dr.GetOrdinal("statusId"))
                            });
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en SQL Server al listar los stocks.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al consultar el listado de stocks.", ex);
            }
        }

        public async Task<IEnumerable<DM_Stocks_filtrar>> Filtrar_StocksAsync(string? searchTerm, int? productVariableId)
        {
            var list = new List<DM_Stocks_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_Stocks_Filter", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", (object?)searchTerm ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@ProductVariableId", (object?)productVariableId ?? DBNull.Value));

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(new DM_Stocks_filtrar
                            {
                                StockId = dr.IsDBNull(dr.GetOrdinal("stockId")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("stockId")),
                                ProductVariableId = dr.IsDBNull(dr.GetOrdinal("productVariableId")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("productVariableId")),
                                ProductName = dr.IsDBNull(dr.GetOrdinal("productName")) ? null : dr.GetString(dr.GetOrdinal("productName")),
                                VariableValue = dr.IsDBNull(dr.GetOrdinal("variableValue")) ? null : dr.GetString(dr.GetOrdinal("variableValue")),
                                UnitPrice = dr.IsDBNull(dr.GetOrdinal("unitPrice")) ? null : (decimal?)dr.GetDecimal(dr.GetOrdinal("unitPrice")),
                                CurrencyISO = dr.IsDBNull(dr.GetOrdinal("currencyISO")) ? null : dr.GetString(dr.GetOrdinal("currencyISO")),
                                Quantity = dr.IsDBNull(dr.GetOrdinal("quantity")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("quantity")),
                                FactoryDate = dr.IsDBNull(dr.GetOrdinal("factoryDate")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("factoryDate")),
                                ExpirationDate = dr.IsDBNull(dr.GetOrdinal("expirationDate")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("expirationDate")),
                                StatusId = dr.IsDBNull(dr.GetOrdinal("statusId")) ? null : (bool?)dr.GetBoolean(dr.GetOrdinal("statusId"))
                            });
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en SQL Server al filtrar los stocks.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al filtrar los stocks.", ex);
            }
        }

        #endregion
    }
}
