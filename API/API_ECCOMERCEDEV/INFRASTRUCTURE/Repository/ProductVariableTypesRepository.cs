using APLICATION.Interfaces;
using DOMAIN.ProductVariableTypes;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class ProductVariableTypesRepository : IProductVariableTypesRepository
    {
        private readonly DBconexionfactory _connection;

        public ProductVariableTypesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        public async Task<OUTPUT> Insertar_ProductVariableTypesAsync(DM_ProductVariableTypes_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductVariableTypes_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeName", modelo.ProductVariableTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeDescription", modelo.ProductVariableTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeCreatorId", modelo.ProductVariableTypeCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeStatusId", modelo.ProductVariableTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar el tipo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar el tipo de variable de producto.", ex);
            }
        }

        public async Task<OUTPUT> Editar_ProductVariableTypesAsync(DM_ProductVariableTypes_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductVariableTypes_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeId", modelo.ProductVariableTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeName", modelo.ProductVariableTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeDescription", modelo.ProductVariableTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificatorId", modelo.ProductVariableTypeModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeStatusId", modelo.ProductVariableTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar el tipo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el tipo de variable de producto.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_ProductVariableTypesAsync(int productVariableTypeId, int productVariableTypeModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductVariableTypes_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeId", productVariableTypeId));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificatorId", productVariableTypeModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar el tipo de variable de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar el tipo de variable de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductVariableTypes_listar>> Listar_ProductVariableTypesAsync()
        {
            var list = new List<DM_ProductVariableTypes_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductVariableTypes_List]", con))
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
                throw new Exception("Error al consultar el listado completo de tipos de variables de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductVariableTypes_filtrar>> Filtrar_ProductVariableTypesAsync(DM_ProductVariableTypes_filtrar filtro)
        {
            var list = new List<DM_ProductVariableTypes_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductVariableTypes_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeId", filtro.ProductVariableTypeId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeName", filtro.ProductVariableTypeName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeDescription", filtro.ProductVariableTypeDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeCreatorId", filtro.ProductVariableTypeCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeCreationDate", filtro.ProductVariableTypeCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificatorId", filtro.ProductVariableTypeModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificationDate", filtro.ProductVariableTypeModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableTypeStatusId", filtro.ProductVariableTypeStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar los tipos de variables de producto.", ex);
            }
        }

        private DM_ProductVariableTypes_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_ProductVariableTypes_listar
            {
                ProductVariableTypeId = dr["productVariableTypeId"] != DBNull.Value ? (int?)dr["productVariableTypeId"] : null,
                ProductVariableTypeName = dr["productVariableTypeName"] != DBNull.Value ? dr["productVariableTypeName"].ToString() : null,
                ProductVariableTypeDescription = dr["productVariableTypeDescription"] != DBNull.Value ? dr["productVariableTypeDescription"].ToString() : null,
                ProductVariableTypeCreatorId = dr["productVariableTypeCreatorId"] != DBNull.Value ? (int?)dr["productVariableTypeCreatorId"] : null,
                ProductVariableTypeStatusId = dr["productVariableTypeStatusId"] != DBNull.Value ? (bool?)dr["productVariableTypeStatusId"] : null
            };
        }

        private DM_ProductVariableTypes_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_ProductVariableTypes_filtrar
            {
                ProductVariableTypeId = dr["productVariableTypeId"] != DBNull.Value ? (int?)dr["productVariableTypeId"] : null,
                ProductVariableTypeName = dr["productVariableTypeName"] != DBNull.Value ? dr["productVariableTypeName"].ToString() : null,
                ProductVariableTypeDescription = dr["productVariableTypeDescription"] != DBNull.Value ? dr["productVariableTypeDescription"].ToString() : null,
                ProductVariableTypeCreatorId = dr["productVariableTypeCreatorId"] != DBNull.Value ? (int?)dr["productVariableTypeCreatorId"] : null,
                ProductVariableTypeCreationDate = dr["productVariableTypeCreationDate"] != DBNull.Value ? (DateTime?)dr["productVariableTypeCreationDate"] : null,
                ProductVariableTypeModificatorId = dr["productVariableTypeModificatorId"] != DBNull.Value ? (int?)dr["productVariableTypeModificatorId"] : null,
                ProductVariableTypeModificationDate = dr["productVariableTypeModificationDate"] != DBNull.Value ? (DateTime?)dr["productVariableTypeModificationDate"] : null,
                ProductVariableTypeStatusId = dr["productVariableTypeStatusId"] != DBNull.Value ? (bool?)dr["productVariableTypeStatusId"] : null
            };
        }
    }
}
