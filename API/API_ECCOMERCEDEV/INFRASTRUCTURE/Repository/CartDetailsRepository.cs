using APLICATION.Interfaces;
using DOMAIN.CartDetails;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class CartDetailsRepository : ICartDetailsRepository
    {
        private readonly DBconexionfactory _connection;

        public CartDetailsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_cartdetails

        public async Task<OUTPUT> Insertar_CartDetailsAsync(DM_CartDetails_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_CartDetails_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@userId", modelo.userId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@productVariableId", modelo.productVariableId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@quantity", modelo.quantity ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@discount", modelo.discount ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@creatorId", modelo.creatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@statusId", modelo.statusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al insertar el detalle del carrito.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al insertar el detalle del carrito.", ex);
            }
        }

        public async Task<OUTPUT> Editar_CartDetails_CantidadAsync(DM_CartDetails_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_CartDetails_UpdateQuantity]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@cartDetailId", modelo.cartDetailId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@newQuantity", modelo.newQuantity ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@modificatorId", modelo.modificatorId ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al actualizar la cantidad del detalle del carrito.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la cantidad del detalle del carrito.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_CartDetailsAsync(int cartDetailId, int cartDetailModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_CartDetails_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@cartDetailId", cartDetailId));
                    cmd.Parameters.Add(new SqlParameter("@cartDetailModificatorId", cartDetailModificatorId));

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
                throw new Exception("Error en el motor SQL al eliminar el detalle del carrito.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el detalle del carrito.", ex);
            }
        }

        #endregion

        #region lectura_cartdetails

        public async Task<IEnumerable<DM_CartDetails_listar>> Listar_CartDetailsAsync()
        {
            var list = new List<DM_CartDetails_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_CartDetails_List]", con))
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
                throw new Exception("Error al consultar el listado completo de detalles del carrito.", ex);
            }
        }

        public async Task<IEnumerable<DM_CartDetails_filtrar>> Obtener_CarritoClienteAsync(int userId)
        {
            var list = new List<DM_CartDetails_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_Carts_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@UserId", userId));

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
                throw new Exception("Error al consultar el detalle del carrito del cliente.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_CartDetails_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_CartDetails_listar
            {
                cartDetailId = dr["cartDetailId"] != DBNull.Value ? (int?)dr["cartDetailId"] : null,
                cartDetailCartId = dr["cartDetailCartId"] != DBNull.Value ? (int?)dr["cartDetailCartId"] : null,
                cartDetailProductVariableId = dr["cartDetailProductVariableId"] != DBNull.Value ? (int?)dr["cartDetailProductVariableId"] : null,
                cartDetailPrice = dr["cartDetailPrice"] != DBNull.Value ? (decimal?)dr["cartDetailPrice"] : null,
                cartDetailQuantity = dr["cartDetailQuantity"] != DBNull.Value ? (int?)dr["cartDetailQuantity"] : null,
                cartDetailDiscount = dr["cartDetailDiscount"] != DBNull.Value ? (decimal?)dr["cartDetailDiscount"] : null,
                cartDetailSubTotal = dr["cartDetailSubTotal"] != DBNull.Value ? (decimal?)dr["cartDetailSubTotal"] : null,
                cartDetailTAX = dr["cartDetailTAX"] != DBNull.Value ? (decimal?)dr["cartDetailTAX"] : null,
                cartDetailTotal = dr["cartDetailTotal"] != DBNull.Value ? (decimal?)dr["cartDetailTotal"] : null,
                cartDetailCurrencyId = dr["cartDetailCurrencyId"] != DBNull.Value ? (int?)dr["cartDetailCurrencyId"] : null,
                cartDetailCreatorId = dr["cartDetailCreatorId"] != DBNull.Value ? (int?)dr["cartDetailCreatorId"] : null,
                cartDetailCreationDate = dr["cartDetailCreationDate"] != DBNull.Value ? (DateTime?)dr["cartDetailCreationDate"] : null,
                cartDetailModificatorId = dr["cartDetailModificatorId"] != DBNull.Value ? (int?)dr["cartDetailModificatorId"] : null,
                cartDetailModificationDate = dr["cartDetailModificationDate"] != DBNull.Value ? (DateTime?)dr["cartDetailModificationDate"] : null,
                cartDetailStatusId = dr["cartDetailStatusId"] != DBNull.Value ? (bool?)dr["cartDetailStatusId"] : null
            };
        }

        private DM_CartDetails_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_CartDetails_filtrar
            {
                DetalleCarritoId = dr["DetalleCarritoId"] != DBNull.Value ? (int?)dr["DetalleCarritoId"] : null,
                CarritoId = dr["CarritoId"] != DBNull.Value ? (int?)dr["CarritoId"] : null,
                UsuarioClienteId = dr["UsuarioClienteId"] != DBNull.Value ? (int?)dr["UsuarioClienteId"] : null,
                VarianteId = dr["VarianteId"] != DBNull.Value ? (int?)dr["VarianteId"] : null,
                ProductoId = dr["ProductoId"] != DBNull.Value ? (int?)dr["ProductoId"] : null,
                ProductoNombre = dr["ProductoNombre"] != DBNull.Value ? dr["ProductoNombre"].ToString() : null,
                ProductoDescripcion = dr["ProductoDescripcion"] != DBNull.Value ? dr["ProductoDescripcion"].ToString() : null,
                VarianteEspecificacion = dr["VarianteEspecificacion"] != DBNull.Value ? dr["VarianteEspecificacion"].ToString() : null,
                ProductoImagenUrl = dr["ProductoImagenUrl"] != DBNull.Value ? dr["ProductoImagenUrl"].ToString() : null,
                PrecioUnitario = dr["PrecioUnitario"] != DBNull.Value ? (decimal?)dr["PrecioUnitario"] : null,
                Cantidad = dr["Cantidad"] != DBNull.Value ? (int?)dr["Cantidad"] : null,
                DescuentoFila = dr["DescuentoFila"] != DBNull.Value ? (decimal?)dr["DescuentoFila"] : null,
                SubTotalFila = dr["SubTotalFila"] != DBNull.Value ? (decimal?)dr["SubTotalFila"] : null,
                ImpuestoFila = dr["ImpuestoFila"] != DBNull.Value ? (decimal?)dr["ImpuestoFila"] : null,
                TotalFila = dr["TotalFila"] != DBNull.Value ? (decimal?)dr["TotalFila"] : null,
                MonedaISO = dr["MonedaISO"] != DBNull.Value ? dr["MonedaISO"].ToString() : null,
                MonedaNombre = dr["MonedaNombre"] != DBNull.Value ? dr["MonedaNombre"].ToString() : null
            };
        }

        #endregion
    }
}
