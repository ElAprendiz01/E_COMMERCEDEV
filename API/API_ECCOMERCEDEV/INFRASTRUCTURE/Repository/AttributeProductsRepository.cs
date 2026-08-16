using APLICATION.Interfaces;
using DOMAIN.AttributeProducts;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System.Data;

namespace INFRASTRUCTURE.Repository
{
    public class AttributeProductsRepository : IAttributeProductsRepository
    {
        private readonly DBconexionfactory _connection;

        public AttributeProductsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_attributeproducts

        public async Task<OUTPUT> Insertar_AttributeProductsAsync(DM_AttributeProductsInsertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_AttributeProducts_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@AttributeProductAttributesTypeId", modelo.AttributeProductAttributesTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductName", modelo.AttributeProductName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductDescription", modelo.AttributeProductDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductCreatorId", modelo.AttributeProductCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductStatusId", modelo.AttributeProductStatusId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al crear el atributo de producto: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al crear el atributo de producto: {ex.Message}", ex);
            }
        }

        public async Task<OUTPUT> Editar_AttributeProductsAsync(DM_AttributeProductsEditar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_AttributeProducts_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@AttributeProductId", modelo.AttributeProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductAttributesTypeId", modelo.AttributeProductAttributesTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductName", modelo.AttributeProductName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductDescription", modelo.AttributeProductDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductModificatorId", modelo.AttributeProductModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductStatusId", modelo.AttributeProductStatusId ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.NVarChar, 400) { Direction = ParameterDirection.Output };
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
                throw new Exception($"Error en el motor SQL al actualizar el atributo de producto: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al actualizar el atributo de producto: {ex.Message}", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_AttributeProductsAsync(int? attributeProductId, int? attributeProductModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_AttributeProducts_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@AttributeProductId", attributeProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductModificatorId", attributeProductModificatorId ?? (object)DBNull.Value));

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
                throw new Exception($"Error en el motor SQL al eliminar el atributo de producto: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico de infraestructura al eliminar el atributo de producto: {ex.Message}", ex);
            }
        }

        #endregion

        #region lectura_attributeproducts

        public async Task<IEnumerable<DM_AttributeProductsListar>> Listar_AttributeProductsAsync()
        {
            var list = new List<DM_AttributeProductsListar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_AttributeProducts_List]", con))
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
                throw new Exception($"Error al consultar el listado completo de atributos de productos en la base de datos: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al consultar el listado completo de atributos de productos: {ex.Message}", ex);
            }
        }

        public async Task<IEnumerable<DM_AttributeProductsFiltrar>> Filtrar_AttributeProductsAsync(DM_AttributeProductsFilter filtro)
        {
            var list = new List<DM_AttributeProductsFiltrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_AttributeProducts_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@AttributeProductId", filtro.AttributeProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductAttributesTypeId", filtro.AttributeProductAttributesTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductName", filtro.AttributeProductName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductDescription", filtro.AttributeProductDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductCreatorId", filtro.AttributeProductCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductCreationDate", filtro.AttributeProductCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductModificatorId", filtro.AttributeProductModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductModificationDate", filtro.AttributeProductModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@AttributeProductStatusId", filtro.AttributeProductStatusId ?? (object)DBNull.Value));

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
                throw new Exception($"Error al filtrar atributos de productos en la base de datos: {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error crítico al filtrar atributos de productos: {ex.Message}", ex);
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

        private DM_AttributeProductsListar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_AttributeProductsListar
            {
                AttributeProductId = ObtenerInt(dr, "AttributeProductId"),
                AttributeProductAttributesTypeId = ObtenerInt(dr, "AttributeProductAttributesTypeId"),
                AttributeProductName = ObtenerString(dr, "AttributeProductName"),
                AttributeProductDescription = ObtenerString(dr, "AttributeProductDescription"),
                AttributeProductCreatorId = ObtenerInt(dr, "AttributeProductCreatorId"),
                AttributeProductCreationDate = ObtenerDateTime(dr, "AttributeProductCreationDate"),
                AttributeProductModificatorId = ObtenerInt(dr, "AttributeProductModificatorId"),
                AttributeProductModificationDate = ObtenerDateTime(dr, "AttributeProductModificationDate"),
                AttributeProductStatusId = ObtenerInt(dr, "AttributeProductStatusId")
            };
        }

        private DM_AttributeProductsFiltrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_AttributeProductsFiltrar
            {
                AttributeProductId = ObtenerInt(dr, "AttributeProductId"),
                AttributeProductAttributesTypeId = ObtenerInt(dr, "AttributeProductAttributesTypeId"),
                AttributeProductName = ObtenerString(dr, "AttributeProductName"),
                AttributeProductDescription = ObtenerString(dr, "AttributeProductDescription"),
                AttributeProductCreatorId = ObtenerInt(dr, "AttributeProductCreatorId"),
                AttributeProductCreationDate = ObtenerDateTime(dr, "AttributeProductCreationDate"),
                AttributeProductModificatorId = ObtenerInt(dr, "AttributeProductModificatorId"),
                AttributeProductModificationDate = ObtenerDateTime(dr, "AttributeProductModificationDate"),
                AttributeProductStatusId = ObtenerInt(dr, "AttributeProductStatusId")
            };
        }

        #endregion
    }
}
