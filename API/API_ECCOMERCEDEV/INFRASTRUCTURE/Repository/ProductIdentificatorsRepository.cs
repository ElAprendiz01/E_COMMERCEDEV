using APLICATION.Interfaces;
using DOMAIN.ProductIdentificators;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class ProductIdentificatorsRepository : IProductIdentificatorsRepository
    {
        private readonly DBconexionfactory _connection;

        public ProductIdentificatorsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        public async Task<OUTPUT> Insertar_ProductIdentificatorsAsync(DM_ProductIdentificators_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductIdentificators_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCategoryId", modelo.ProductIdentificatorCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSubCategoryId", modelo.ProductIdentificatorSubCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSegmentId", modelo.ProductIdentificatorSegmentId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCreatorId", modelo.ProductIdentificatorCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorStatusId", modelo.ProductIdentificatorStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar el identificador de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar el identificador de producto.", ex);
            }
        }

        public async Task<OUTPUT> Editar_ProductIdentificatorsAsync(DM_ProductIdentificators_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductIdentificators_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorId", modelo.ProductIdentificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCategoryId", modelo.ProductIdentificatorCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSubCategoryId", modelo.ProductIdentificatorSubCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSegmentId", modelo.ProductIdentificatorSegmentId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorModificatorId", modelo.ProductIdentificatorModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorStatusId", modelo.ProductIdentificatorStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar el identificador de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el identificador de producto.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_ProductIdentificatorsAsync(int productIdentificatorId, int productIdentificatorModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductIdentificators_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorId", productIdentificatorId));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorModificatorId", productIdentificatorModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar el identificador de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar el identificador de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductIdentificators_listar>> Listar_ProductIdentificatorsAsync()
        {
            var list = new List<DM_ProductIdentificators_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductIdentificators_List]", con))
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
                throw new Exception("Error al consultar el listado completo de identificadores de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductIdentificators_filtrar>> Filtrar_ProductIdentificatorsAsync(DM_ProductIdentificators_filtrar filtro)
        {
            var list = new List<DM_ProductIdentificators_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_ProductIdentificators_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorId", filtro.ProductIdentificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCategoryId", filtro.ProductIdentificatorCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSubCategoryId", filtro.ProductIdentificatorSubCategoryId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorSegmentId", filtro.ProductIdentificatorSegmentId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCreatorId", filtro.ProductIdentificatorCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorCreationDate", filtro.ProductIdentificatorCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorModificatorId", filtro.ProductIdentificatorModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorModificationDate", filtro.ProductIdentificatorModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productIdentificatorStatusId", filtro.ProductIdentificatorStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar los identificadores de producto.", ex);
            }
        }

        private DM_ProductIdentificators_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_ProductIdentificators_listar
            {
                ProductIdentificatorId = dr["productIdentificatorId"] != DBNull.Value ? (int?)dr["productIdentificatorId"] : null,
                ProductIdentificatorCategoryId = dr["productIdentificatorCategoryId"] != DBNull.Value ? (int?)dr["productIdentificatorCategoryId"] : null,
                ProductIdentificatorSubCategoryId = dr["productIdentificatorSubCategoryId"] != DBNull.Value ? (int?)dr["productIdentificatorSubCategoryId"] : null,
                ProductIdentificatorSegmentId = dr["productIdentificatorSegmentId"] != DBNull.Value ? (int?)dr["productIdentificatorSegmentId"] : null,
                ProductIdentificatorCreatorId = dr["productIdentificatorCreatorId"] != DBNull.Value ? (int?)dr["productIdentificatorCreatorId"] : null,
                ProductIdentificatorStatusId = dr["productIdentificatorStatusId"] != DBNull.Value ? (bool?)dr["productIdentificatorStatusId"] : null
            };
        }

        private DM_ProductIdentificators_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_ProductIdentificators_filtrar
            {
                ProductIdentificatorId = dr["productIdentificatorId"] != DBNull.Value ? (int?)dr["productIdentificatorId"] : null,
                ProductIdentificatorCategoryId = dr["productIdentificatorCategoryId"] != DBNull.Value ? (int?)dr["productIdentificatorCategoryId"] : null,
                ProductIdentificatorSubCategoryId = dr["productIdentificatorSubCategoryId"] != DBNull.Value ? (int?)dr["productIdentificatorSubCategoryId"] : null,
                ProductIdentificatorSegmentId = dr["productIdentificatorSegmentId"] != DBNull.Value ? (int?)dr["productIdentificatorSegmentId"] : null,
                ProductIdentificatorCreatorId = dr["productIdentificatorCreatorId"] != DBNull.Value ? (int?)dr["productIdentificatorCreatorId"] : null,
                ProductIdentificatorCreationDate = dr["productIdentificatorCreationDate"] != DBNull.Value ? (DateTime?)dr["productIdentificatorCreationDate"] : null,
                ProductIdentificatorModificatorId = dr["productIdentificatorModificatorId"] != DBNull.Value ? (int?)dr["productIdentificatorModificatorId"] : null,
                ProductIdentificatorModificationDate = dr["productIdentificatorModificationDate"] != DBNull.Value ? (DateTime?)dr["productIdentificatorModificationDate"] : null,
                ProductIdentificatorStatusId = dr["productIdentificatorStatusId"] != DBNull.Value ? (bool?)dr["productIdentificatorStatusId"] : null
            };
        }
    }
}
