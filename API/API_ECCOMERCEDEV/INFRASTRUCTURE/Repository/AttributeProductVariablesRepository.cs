using APLICATION.Interfaces;
using DOMAIN.AttributeProductVariables;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class AttributeProductVariablesRepository : IAttributeProductVariablesRepository
    {
        private readonly DBconexionfactory _connection;

        public AttributeProductVariablesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura

        public async Task<OUTPUT> Insertar_AttributeProductVariablesAsync(DM_AttributeProductVariables_create modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_AttributeProductVariables_Create", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableProductVariableId", modelo.AttributeProductVariableProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableAttributeProductId", modelo.AttributeProductVariableAttributeProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableValue", (object?)modelo.AttributeProductVariableValue ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableCreatorId", modelo.AttributeProductVariableCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableStatusId", modelo.AttributeProductVariableStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en SQL Server al insertar el atributo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al insertar el atributo de variable de producto.", ex);
            }
        }

        public async Task<OUTPUT> Actualizar_AttributeProductVariablesAsync(DM_AttributeProductVariables_update modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_AttributeProductVariables_Update", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableId", modelo.AttributeProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableProductVariableId", modelo.AttributeProductVariableProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableAttributeProductId", modelo.AttributeProductVariableAttributeProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableValue", (object?)modelo.AttributeProductVariableValue ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificatorId", modelo.AttributeProductVariableModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableStatusId", modelo.AttributeProductVariableStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en SQL Server al actualizar el atributo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al actualizar el atributo de variable de producto.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_AttributeProductVariablesAsync(int? attributeProductVariableId, int? attributeProductVariableModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_AttributeProductVariables_Delete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableId", attributeProductVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificatorId", attributeProductVariableModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en SQL Server al eliminar el atributo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al eliminar el atributo de variable de producto.", ex);
            }
        }

        #endregion

        #region lectura

        public async Task<IEnumerable<DM_AttributeProductVariables_obtener>> Obtener_AttributeProductVariablesAsync(int? productVariableId, string? searchTerm)
        {
            var list = new List<DM_AttributeProductVariables_obtener>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("SQM_GENERAL.sp_AttributeProductVariables_GetByProductVariable", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@ProductVariableId", (object?)productVariableId ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", (object?)searchTerm ?? DBNull.Value));

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(new DM_AttributeProductVariables_obtener
                            {
                                IdAtributoVariable = dr.IsDBNull(dr.GetOrdinal("IdAtributoVariable")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("IdAtributoVariable")),
                                ValorAtributo = dr.IsDBNull(dr.GetOrdinal("ValorAtributo")) ? null : dr.GetString(dr.GetOrdinal("ValorAtributo")),
                                RegistroActivo = dr.IsDBNull(dr.GetOrdinal("RegistroActivo")) ? null : (bool?)dr.GetBoolean(dr.GetOrdinal("RegistroActivo")),
                                IdTipoVariable = dr.IsDBNull(dr.GetOrdinal("IdTipoVariable")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("IdTipoVariable")),
                                TipoVariable = dr.IsDBNull(dr.GetOrdinal("TipoVariable")) ? null : dr.GetString(dr.GetOrdinal("TipoVariable")),
                                DescripcionTipoVariable = dr.IsDBNull(dr.GetOrdinal("DescripcionTipoVariable")) ? null : dr.GetString(dr.GetOrdinal("DescripcionTipoVariable")),
                                IdVariante = dr.IsDBNull(dr.GetOrdinal("IdVariante")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("IdVariante")),
                                ValorVariante = dr.IsDBNull(dr.GetOrdinal("ValorVariante")) ? null : dr.GetString(dr.GetOrdinal("ValorVariante")),
                                PrecioVariante = dr.IsDBNull(dr.GetOrdinal("PrecioVariante")) ? null : (decimal?)dr.GetDecimal(dr.GetOrdinal("PrecioVariante")),
                                CodigoMoneda = dr.IsDBNull(dr.GetOrdinal("CodigoMoneda")) ? null : dr.GetString(dr.GetOrdinal("CodigoMoneda")),
                                NombreMoneda = dr.IsDBNull(dr.GetOrdinal("NombreMoneda")) ? null : dr.GetString(dr.GetOrdinal("NombreMoneda")),
                                IdProducto = dr.IsDBNull(dr.GetOrdinal("IdProducto")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("IdProducto")),
                                NombreProducto = dr.IsDBNull(dr.GetOrdinal("NombreProducto")) ? null : dr.GetString(dr.GetOrdinal("NombreProducto")),
                                DescripcionProducto = dr.IsDBNull(dr.GetOrdinal("DescripcionProducto")) ? null : dr.GetString(dr.GetOrdinal("DescripcionProducto")),
                                NombreMarca = dr.IsDBNull(dr.GetOrdinal("NombreMarca")) ? null : dr.GetString(dr.GetOrdinal("NombreMarca")),
                                NombreProveedor = dr.IsDBNull(dr.GetOrdinal("NombreProveedor")) ? null : dr.GetString(dr.GetOrdinal("NombreProveedor")),
                                FechaCreacion = dr.IsDBNull(dr.GetOrdinal("FechaCreacion")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("FechaCreacion")),
                                CreadoPor = dr.IsDBNull(dr.GetOrdinal("CreadoPor")) ? null : dr.GetString(dr.GetOrdinal("CreadoPor")),
                                FechaModificacion = dr.IsDBNull(dr.GetOrdinal("FechaModificacion")) ? null : (DateTime?)dr.GetDateTime(dr.GetOrdinal("FechaModificacion")),
                                ModificadoPor = dr.IsDBNull(dr.GetOrdinal("ModificadoPor")) ? null : (int?)dr.GetInt32(dr.GetOrdinal("ModificadoPor"))
                            });
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en SQL Server al consultar atributos de variables del producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico al obtener atributos de variables del producto.", ex);
            }
        }

        #endregion
    }
}
