using APLICATION.Interfaces;
using DOMAIN.Products;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class ProductsRepository : IProductsRepository
    {
        private readonly DBconexionfactory _connection;

        public ProductsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        public async Task<OUTPUT> Insertar_ProductsAsync(DM_Products_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productName", modelo.productName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productDescription", modelo.productDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productProductIdentificatorId", modelo.productProductIdentificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productMarkByProviderId", modelo.productMarkByProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productCreatorId", modelo.productCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productStatusId", modelo.productStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar el producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar el producto.", ex);
            }
        }

        public async Task<OUTPUT> Editar_ProductsAsync(DM_Products_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productId", modelo.productId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productName", modelo.productName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productDescription", modelo.productDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productProductIdentificatorId", modelo.productProductIdentificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productMarkByProviderId", modelo.productMarkByProviderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productModificatorId", modelo.productModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productStatusId", modelo.productStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el producto.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_ProductsAsync(int? productId, int? productModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productId", productId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productModificatorId", productModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el producto.", ex);
            }
        }

        public async Task<(IEnumerable<DM_Products_listar> Data, OUTPUT Output)> Listar_ProductsAsync(int? pageNumber = null)
        {
            var list = new List<DM_Products_listar>();
            var output = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_List]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@i_pageNumber", pageNumber ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pPageNumber = new SqlParameter("@o_pageNumber", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pPageSize = new SqlParameter("@o_pageSize", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pTotalRows = new SqlParameter("@o_totalRows", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pPageNumber);
                    cmd.Parameters.Add(pPageSize);
                    cmd.Parameters.Add(pTotalRows);

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderAListar(dr));
                        }
                    }

                    output.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    output.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    output.PageNumber = pPageNumber.Value != DBNull.Value ? (int?)pPageNumber.Value : null;
                    output.PageSize = pPageSize.Value != DBNull.Value ? (int?)pPageSize.Value : null;
                    output.TotalRows = pTotalRows.Value != DBNull.Value ? (int?)pTotalRows.Value : null;
                }
                return (list, output);
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al consultar el listado completo de productos en la base de datos.", ex);
            }
        }

        public async Task<(IEnumerable<DM_Products_filtrar> Data, OUTPUT Output)> Filtrar_ProductsAsync(string? searchTerm, int? pageNumber = 1)
        {
            var list = new List<DM_Products_filtrar>();
            var output = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", searchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@i_pageNumber", pageNumber ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pPageNumber = new SqlParameter("@o_pageNumber", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pPageSize = new SqlParameter("@o_pageSize", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pTotalRows = new SqlParameter("@o_totalRows", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pPageNumber);
                    cmd.Parameters.Add(pPageSize);
                    cmd.Parameters.Add(pTotalRows);

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderAFiltrar(dr));
                        }
                    }

                    output.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    output.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    output.PageNumber = pPageNumber.Value != DBNull.Value ? (int?)pPageNumber.Value : null;
                    output.PageSize = pPageSize.Value != DBNull.Value ? (int?)pPageSize.Value : null;
                    output.TotalRows = pTotalRows.Value != DBNull.Value ? (int?)pTotalRows.Value : null;
                }
                return (list, output);
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al filtrar productos en la base de datos.", ex);
            }
        }

        public async Task<(IEnumerable<DM_Products_filtrar_id> Data, OUTPUT Output)> Filtrar_Products_Por_IdAsync(int? productId)
        {
            var list = new List<DM_Products_filtrar_id>();
            var output = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Products_Filter_Id]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ProductId", productId ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderAFiltrarId(dr));
                        }
                    }

                    output.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    output.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                }
                return (list, output);
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al consultar el producto por ID en la base de datos.", ex);
            }
        }

        private DM_Products_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Products_listar
            {
                ProductID = dr["ProductID"] != DBNull.Value ? (int?)dr["ProductID"] : null,
                ProductName = dr["ProductName"] != DBNull.Value ? dr["ProductName"].ToString() : null,
                ProductVariableID = dr["ProductVariableID"] != DBNull.Value ? (int?)dr["ProductVariableID"] : null,
                ProductVariableName = dr["ProductVariableName"] != DBNull.Value ? dr["ProductVariableName"].ToString() : null,
                ProductVariablePrice = dr["ProductVariablePrice"] != DBNull.Value ? (decimal?)dr["ProductVariablePrice"] : null,
                CurrencyID = dr["CurrencyID"] != DBNull.Value ? (int?)dr["CurrencyID"] : null,
                CurrencyISO = dr["CurrencyISO"] != DBNull.Value ? dr["CurrencyISO"].ToString() : null,
                CategoryID = dr["CategoryID"] != DBNull.Value ? (int?)dr["CategoryID"] : null,
                CategoryName = dr["CategoryName"] != DBNull.Value ? dr["CategoryName"].ToString() : null,
                SubcategoryID = dr["SubcategoryID"] != DBNull.Value ? (int?)dr["SubcategoryID"] : null,
                SubcategoryName = dr["SubcategoryName"] != DBNull.Value ? dr["SubcategoryName"].ToString() : null,
                SegmentID = dr["SegmentID"] != DBNull.Value ? (int?)dr["SegmentID"] : null,
                SegmentName = dr["SegmentName"] != DBNull.Value ? dr["SegmentName"].ToString() : null,
                MarkID = dr["MarkID"] != DBNull.Value ? (int?)dr["MarkID"] : null,
                MarkName = dr["MarkName"] != DBNull.Value ? dr["MarkName"].ToString() : null,
                ProviderID = dr["ProviderID"] != DBNull.Value ? (int?)dr["ProviderID"] : null,
                ProviderName = dr["ProviderName"] != DBNull.Value ? dr["ProviderName"].ToString() : null,
                StockID = dr["StockID"] != DBNull.Value ? (int?)dr["StockID"] : null,
                StockAvilable = dr["StockAvilable"] != DBNull.Value ? (int?)dr["StockAvilable"] : null,
                StockFactoryDate = dr["StockFactoryDate"] != DBNull.Value ? (DateTime?)dr["StockFactoryDate"] : null,
                StockExpirationDate = dr["StockExpirationDate"] != DBNull.Value ? (DateTime?)dr["StockExpirationDate"] : null,
                ProductImageURL = dr["ProductImageURL"] != DBNull.Value ? dr["ProductImageURL"].ToString() : null
            };
        }

        private DM_Products_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Products_filtrar
            {
                ProductID = dr["ProductID"] != DBNull.Value ? (int?)dr["ProductID"] : null,
                ProductName = dr["ProductName"] != DBNull.Value ? dr["ProductName"].ToString() : null,
                ProductVariableID = dr["ProductVariableID"] != DBNull.Value ? (int?)dr["ProductVariableID"] : null,
                ProductVariableName = dr["ProductVariableName"] != DBNull.Value ? dr["ProductVariableName"].ToString() : null,
                ProductVariablePrice = dr["ProductVariablePrice"] != DBNull.Value ? (decimal?)dr["ProductVariablePrice"] : null,
                CurrencyID = dr["CurrencyID"] != DBNull.Value ? (int?)dr["CurrencyID"] : null,
                CurrencyISO = dr["CurrencyISO"] != DBNull.Value ? dr["CurrencyISO"].ToString() : null,
                CategoryID = dr["CategoryID"] != DBNull.Value ? (int?)dr["CategoryID"] : null,
                CategoryName = dr["CategoryName"] != DBNull.Value ? dr["CategoryName"].ToString() : null,
                SubcategoryID = dr["SubcategoryID"] != DBNull.Value ? (int?)dr["SubcategoryID"] : null,
                SubcategoryName = dr["SubcategoryName"] != DBNull.Value ? dr["SubcategoryName"].ToString() : null,
                SegmentID = dr["SegmentID"] != DBNull.Value ? (int?)dr["SegmentID"] : null,
                SegmentName = dr["SegmentName"] != DBNull.Value ? dr["SegmentName"].ToString() : null,
                MarkID = dr["MarkID"] != DBNull.Value ? (int?)dr["MarkID"] : null,
                MarkName = dr["MarkName"] != DBNull.Value ? dr["MarkName"].ToString() : null,
                ProviderID = dr["ProviderID"] != DBNull.Value ? (int?)dr["ProviderID"] : null,
                ProviderName = dr["ProviderName"] != DBNull.Value ? dr["ProviderName"].ToString() : null,
                StockID = dr["StockID"] != DBNull.Value ? (int?)dr["StockID"] : null,
                StockAvilable = dr["StockAvilable"] != DBNull.Value ? (int?)dr["StockAvilable"] : null,
                StockFactoryDate = dr["StockFactoryDate"] != DBNull.Value ? (DateTime?)dr["StockFactoryDate"] : null,
                StockExpirationDate = dr["StockExpirationDate"] != DBNull.Value ? (DateTime?)dr["StockExpirationDate"] : null,
                ProductImageURL = dr["ProductImageURL"] != DBNull.Value ? dr["ProductImageURL"].ToString() : null
            };
        }

        private DM_Products_filtrar_id MapearDataReaderAFiltrarId(SqlDataReader dr)
        {
            return new DM_Products_filtrar_id
            {
                ProductID = dr["ProductID"] != DBNull.Value ? (int?)dr["ProductID"] : null,
                ProductName = dr["ProductName"] != DBNull.Value ? dr["ProductName"].ToString() : null,
                ProductVariableID = dr["ProductVariableID"] != DBNull.Value ? (int?)dr["ProductVariableID"] : null,
                ProductVariableName = dr["ProductVariableName"] != DBNull.Value ? dr["ProductVariableName"].ToString() : null,
                ProductVariablePrice = dr["ProductVariablePrice"] != DBNull.Value ? (decimal?)dr["ProductVariablePrice"] : null,
                CurrencyID = dr["CurrencyID"] != DBNull.Value ? (int?)dr["CurrencyID"] : null,
                CurrencyISO = dr["CurrencyISO"] != DBNull.Value ? dr["CurrencyISO"].ToString() : null,
                CategoryID = dr["CategoryID"] != DBNull.Value ? (int?)dr["CategoryID"] : null,
                CategoryName = dr["CategoryName"] != DBNull.Value ? dr["CategoryName"].ToString() : null,
                SubcategoryID = dr["SubcategoryID"] != DBNull.Value ? (int?)dr["SubcategoryID"] : null,
                SubcategoryName = dr["SubcategoryName"] != DBNull.Value ? dr["SubcategoryName"].ToString() : null,
                SegmentID = dr["SegmentID"] != DBNull.Value ? (int?)dr["SegmentID"] : null,
                SegmentName = dr["SegmentName"] != DBNull.Value ? dr["SegmentName"].ToString() : null,
                MarkID = dr["MarkID"] != DBNull.Value ? (int?)dr["MarkID"] : null,
                MarkName = dr["MarkName"] != DBNull.Value ? dr["MarkName"].ToString() : null,
                ProviderID = dr["ProviderID"] != DBNull.Value ? (int?)dr["ProviderID"] : null,
                ProviderName = dr["ProviderName"] != DBNull.Value ? dr["ProviderName"].ToString() : null,
                StockID = dr["StockID"] != DBNull.Value ? (int?)dr["StockID"] : null,
                StockAvilable = dr["StockAvilable"] != DBNull.Value ? (int?)dr["StockAvilable"] : null,
                StockFactoryDate = dr["StockFactoryDate"] != DBNull.Value ? (DateTime?)dr["StockFactoryDate"] : null,
                StockExpirationDate = dr["StockExpirationDate"] != DBNull.Value ? (DateTime?)dr["StockExpirationDate"] : null,
                ProductImageURL = dr["ProductImageURL"] != DBNull.Value ? dr["ProductImageURL"].ToString() : null
            };
        }
    }
}
