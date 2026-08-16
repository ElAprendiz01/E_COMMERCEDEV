using APLICATION.Interfaces;
using DOMAIN.ProductImages;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class ProductImagesRepository : IProductImagesRepository
    {
        private readonly DBconexionfactory _connection;

        public ProductImagesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        public async Task<OUTPUT> Insertar_ProductImagesAsync(DM_ProductImages_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_ProductImages_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productImageProductId", modelo.ProductImageProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageURL", modelo.ProductImageURL ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageDescription", modelo.ProductImageDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageIsPrincipal", modelo.ProductImageIsPrincipal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageCreatorId", modelo.ProductImageCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageStatusId", modelo.ProductImageStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar la imagen de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar la imagen de producto.", ex);
            }
        }

        public async Task<OUTPUT> Editar_ProductImagesAsync(DM_ProductImages_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_ProductImages_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productImageId", modelo.ProductImageId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageProductId", modelo.ProductImageProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageURL", modelo.ProductImageURL ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageDescription", modelo.ProductImageDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageIsPrincipal", modelo.ProductImageIsPrincipal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageModificatorId", modelo.ProductImageModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageStatusId", modelo.ProductImageStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar la imagen de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la imagen de producto.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_ProductImagesAsync(int productImageId, int productImageModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_ProductImages_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productImageId", productImageId));
                    cmd.Parameters.Add(new SqlParameter("@productImageModificatorId", productImageModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar la imagen de producto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la imagen de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductImages_listar>> Listar_ProductImagesAsync()
        {
            var list = new List<DM_ProductImages_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_ProductImages_List]", con))
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
                throw new Exception("Error al consultar el listado completo de imágenes de producto.", ex);
            }
        }

        public async Task<IEnumerable<DM_ProductImages_filtrar>> Filtrar_ProductImagesAsync(DM_ProductImages_filtrar filtro)
        {
            var list = new List<DM_ProductImages_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_ProductImages_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@productImageId", filtro.ProductImageId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageProductId", filtro.ProductImageProductId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageURL", filtro.ProductImageURL ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageIsPrincipal", filtro.ProductImageIsPrincipal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageCreatorId", filtro.ProductImageCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageCreationDate", filtro.ProductImageCreationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageModificatorId", filtro.ProductImageModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageModificationDate", filtro.ProductImageModificationDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productImageStatusId", filtro.ProductImageStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar las imágenes de producto.", ex);
            }
        }

        private DM_ProductImages_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_ProductImages_listar
            {
                ProductImageId = dr["productImageId"] != DBNull.Value ? (int?)dr["productImageId"] : null,
                ProductImageProductId = dr["productImageProductId"] != DBNull.Value ? (int?)dr["productImageProductId"] : null,
                ProductImageURL = dr["productImageURL"] != DBNull.Value ? dr["productImageURL"].ToString() : null,
                ProductImageDescription = dr["productImageDescription"] != DBNull.Value ? dr["productImageDescription"].ToString() : null,
                ProductImageIsPrincipal = dr["productImageIsPrincipal"] != DBNull.Value ? (bool?)dr["productImageIsPrincipal"] : null,
                ProductImageCreatorId = dr["productImageCreatorId"] != DBNull.Value ? (int?)dr["productImageCreatorId"] : null,
                ProductImageStatusId = dr["productImageStatusId"] != DBNull.Value ? (bool?)dr["productImageStatusId"] : null
            };
        }

        private DM_ProductImages_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_ProductImages_filtrar
            {
                ProductImageId = dr["productImageId"] != DBNull.Value ? (int?)dr["productImageId"] : null,
                ProductImageProductId = dr["productImageProductId"] != DBNull.Value ? (int?)dr["productImageProductId"] : null,
                ProductImageURL = dr["productImageURL"] != DBNull.Value ? dr["productImageURL"].ToString() : null,
                ProductImageDescription = dr["productImageDescription"] != DBNull.Value ? dr["productImageDescription"].ToString() : null,
                ProductImageIsPrincipal = dr["productImageIsPrincipal"] != DBNull.Value ? (bool?)dr["productImageIsPrincipal"] : null,
                ProductImageCreatorId = dr["productImageCreatorId"] != DBNull.Value ? (int?)dr["productImageCreatorId"] : null,
                ProductImageCreationDate = dr["productImageCreationDate"] != DBNull.Value ? (DateTime?)dr["productImageCreationDate"] : null,
                ProductImageModificatorId = dr["productImageModificatorId"] != DBNull.Value ? (int?)dr["productImageModificatorId"] : null,
                ProductImageModificationDate = dr["productImageModificationDate"] != DBNull.Value ? (DateTime?)dr["productImageModificationDate"] : null,
                ProductImageStatusId = dr["productImageStatusId"] != DBNull.Value ? (bool?)dr["productImageStatusId"] : null
            };
        }
    }
}
