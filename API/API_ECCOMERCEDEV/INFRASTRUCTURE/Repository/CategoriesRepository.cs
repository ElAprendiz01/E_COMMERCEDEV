using APLICATION.Interfaces;
using DOMAIN.Categories;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class CategoriesRepository : ICategoriesRepository
    {
        private readonly DBconexionfactory _connection;

        public CategoriesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_categories

        public async Task<OUTPUT> Insertar_CategoriesAsync(DM_Categories_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Categories_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@categoryName", modelo.categoryName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryDescription", modelo.categoryDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryCreatorId", modelo.categoryCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryStatusId", modelo.categoryStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar la categoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar la categoría.", ex);
            }
        }

        public async Task<OUTPUT> Editar_CategoriesAsync(DM_Categories_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Categories_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@categoryId", modelo.categoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryName", modelo.categoryName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryDescription", modelo.categoryDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryModificatorId", modelo.categoryModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@categoryStatusId", modelo.categoryStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar la categoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la categoría.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_CategoriesAsync(int categoryId, int categoryModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Categories_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@categoryId", categoryId));
                    cmd.Parameters.Add(new SqlParameter("@categoryModificatorId", categoryModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar la categoría.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la categoría.", ex);
            }
        }

        #endregion

        #region lectura_categories

        public async Task<IEnumerable<DM_Categories_listar>> Listar_CategoriesAsync()
        {
            var list = new List<DM_Categories_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Categories_List]", con))
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
                throw new Exception("Error al consultar el listado completo de categorías.", ex);
            }
        }

        public async Task<IEnumerable<DM_Categories_filtrar>> Filtrar_CategoriesAsync(string? searchTerm, bool? statusId)
        {
            var list = new List<DM_Categories_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Categories_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", searchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@StatusId", statusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar las categorías.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Categories_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Categories_listar
            {
                categoryId = dr["categoryId"] != DBNull.Value ? (int?)dr["categoryId"] : null,
                categoryName = dr["categoryName"] != DBNull.Value ? dr["categoryName"].ToString() : null,
                categoryDescription = dr["categoryDescription"] != DBNull.Value ? dr["categoryDescription"].ToString() : null,
                categoryCreatorId = dr["categoryCreatorId"] != DBNull.Value ? (int?)dr["categoryCreatorId"] : null,
                categoryStatusId = dr["categoryStatusId"] != DBNull.Value ? (bool?)dr["categoryStatusId"] : null
            };
        }

        private DM_Categories_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Categories_filtrar
            {
                categoryId = dr["categoryId"] != DBNull.Value ? (int?)dr["categoryId"] : null,
                categoryName = dr["categoryName"] != DBNull.Value ? dr["categoryName"].ToString() : null,
                categoryDescription = dr["categoryDescription"] != DBNull.Value ? dr["categoryDescription"].ToString() : null,
                categoryStatusId = dr["categoryStatusId"] != DBNull.Value ? (bool?)dr["categoryStatusId"] : null
            };
        }

        #endregion
    }
}
