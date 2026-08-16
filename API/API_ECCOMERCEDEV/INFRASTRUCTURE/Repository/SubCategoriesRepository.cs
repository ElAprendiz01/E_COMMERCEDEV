using APLICATION.Interfaces;
using DOMAIN.SubCategories;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class SubCategoriesRepository : ISubCategoriesRepository
    {
        private readonly DBconexionfactory _connection;

        public SubCategoriesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_subcategories

        public async Task<OUTPUT> Insertar_SubCategoriesAsync(DM_SubCategories_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_SubCategories_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@subCategoryName", modelo.subCategoryName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryDescription", modelo.subCategoryDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryCreatorId", modelo.subCategoryCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryStatusId", modelo.subCategoryStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al registrar la subcategoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al registrar la subcategoría.", ex);
            }
        }

        public async Task<OUTPUT> Editar_SubCategoriesAsync(DM_SubCategories_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_SubCategories_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@subCategoryId", modelo.subCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryName", modelo.subCategoryName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryDescription", modelo.subCategoryDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryModificatorId", modelo.subCategoryModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryStatusId", modelo.subCategoryStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar la subcategoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la subcategoría.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_SubCategoriesAsync(int? subCategoryId, int? subCategoryModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_SubCategories_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@subCategoryId", subCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@subCategoryModificatorId", subCategoryModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica la subcategoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar la subcategoría.", ex);
            }
        }

        #endregion

        #region lectura_subcategories

        public async Task<IEnumerable<DM_SubCategories_listar>> Listar_SubCategoriesAsync()
        {
            var list = new List<DM_SubCategories_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_SubCategories_List]", con))
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
                throw new Exception("Error al consultar el listado completo de subcategorías en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_SubCategories_filtrar>> Filtrar_SubCategoriesAsync(string? searchTerm)
        {
            var list = new List<DM_SubCategories_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_SubCategories_Filter]", con))
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
                throw new Exception("Error al filtrar subcategorías en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_SubCategories_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_SubCategories_listar
            {
                subCategoryId = dr["subCategoryId"] != DBNull.Value ? (int?)dr["subCategoryId"] : null,
                subCategoryName = dr["subCategoryName"] != DBNull.Value ? dr["subCategoryName"].ToString() : null,
                subCategoryDescription = dr["subCategoryDescription"] != DBNull.Value ? dr["subCategoryDescription"].ToString() : null,
                subCategoryCreatorId = dr["subCategoryCreatorId"] != DBNull.Value ? (int?)dr["subCategoryCreatorId"] : null,
                subCategoryStatusId = dr["subCategoryStatusId"] != DBNull.Value ? (bool?)dr["subCategoryStatusId"] : null
            };
        }

        private DM_SubCategories_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_SubCategories_filtrar
            {
                subCategoryId = dr["subCategoryId"] != DBNull.Value ? (int?)dr["subCategoryId"] : null,
                subCategoryName = dr["subCategoryName"] != DBNull.Value ? dr["subCategoryName"].ToString() : null,
                subCategoryDescription = dr["subCategoryDescription"] != DBNull.Value ? dr["subCategoryDescription"].ToString() : null,
                subCategoryStatusId = dr["subCategoryStatusId"] != DBNull.Value ? (bool?)dr["subCategoryStatusId"] : null
            };
        }

        #endregion
    }
}
