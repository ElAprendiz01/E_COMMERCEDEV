using APLICATION.Interfaces;
using DOMAIN.StockMovementDetails;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class StockMovementDetailsRepository : IStockMovementDetailsRepository
    {
        private readonly DBconexionfactory _connection;

        public StockMovementDetailsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region lectura_stockmovementdetails

        public async Task<IEnumerable<DM_StockMovementDetails_listar>> Listar_StockMovementDetailsAsync()
        {
            var list = new List<DM_StockMovementDetails_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_StockMovementDetails_List]", con))
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
                throw new Exception("Error al consultar el listado completo de detalles de movimientos de stock.", ex);
            }
        }

        public async Task<IEnumerable<DM_StockMovementDetails_filtrar>> Filtrar_StockMovementDetailsAsync(int? movementId, string? searchTerm)
        {
            var list = new List<DM_StockMovementDetails_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_StockMovementDetails_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@MovementId", movementId ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar los detalles de movimientos de stock.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_StockMovementDetails_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_StockMovementDetails_listar
            {
                DetalleMovimientoId = dr["DetalleMovimientoId"] != DBNull.Value ? (int?)dr["DetalleMovimientoId"] : null,
                CantidadMovida = dr["CantidadMovida"] != DBNull.Value ? (int?)dr["CantidadMovida"] : null,
                FechaFabricacionLote = dr["FechaFabricacionLote"] != DBNull.Value ? (DateTime?)dr["FechaFabricacionLote"] : null,
                FechaExpiracionLote = dr["FechaExpiracionLote"] != DBNull.Value ? (DateTime?)dr["FechaExpiracionLote"] : null,
                FechaRegistroDetalle = dr["FechaRegistroDetalle"] != DBNull.Value ? (DateTime?)dr["FechaRegistroDetalle"] : null,
                DetalleActivo = dr["DetalleActivo"] != DBNull.Value ? (bool?)dr["DetalleActivo"] : null,
                MovimientoId = dr["MovimientoId"] != DBNull.Value ? (int?)dr["MovimientoId"] : null,
                TipoMovimiento = dr["TipoMovimiento"] != DBNull.Value ? dr["TipoMovimiento"].ToString() : null,
                TipoMovimientoDescripcion = dr["TipoMovimientoDescripcion"] != DBNull.Value ? dr["TipoMovimientoDescripcion"].ToString() : null,
                ReferenciaMovimiento = dr["ReferenciaMovimiento"] != DBNull.Value ? dr["ReferenciaMovimiento"].ToString() : null,
                FechaMovimiento = dr["FechaMovimiento"] != DBNull.Value ? (DateTime?)dr["FechaMovimiento"] : null,
                EstadoMovimiento = dr["EstadoMovimiento"] != DBNull.Value ? dr["EstadoMovimiento"].ToString() : null,
                VarianteId = dr["VarianteId"] != DBNull.Value ? (int?)dr["VarianteId"] : null,
                ProductoNombre = dr["ProductoNombre"] != DBNull.Value ? dr["ProductoNombre"].ToString() : null,
                VarianteEspecificacion = dr["VarianteEspecificacion"] != DBNull.Value ? dr["VarianteEspecificacion"].ToString() : null,
                VariantePrecioUnitario = dr["VariantePrecioUnitario"] != DBNull.Value ? (decimal?)dr["VariantePrecioUnitario"] : null,
                VarianteMoneda = dr["VarianteMoneda"] != DBNull.Value ? dr["VarianteMoneda"].ToString() : null,
                ProductoDescripcion = dr["ProductoDescripcion"] != DBNull.Value ? dr["ProductoDescripcion"].ToString() : null,
                Categoria = dr["Categoria"] != DBNull.Value ? dr["Categoria"].ToString() : null,
                SubCategoria = dr["SubCategoria"] != DBNull.Value ? dr["SubCategoria"].ToString() : null,
                Segmento = dr["Segmento"] != DBNull.Value ? dr["Segmento"].ToString() : null,
                Marca = dr["Marca"] != DBNull.Value ? dr["Marca"].ToString() : null,
                Proveedor = dr["Proveedor"] != DBNull.Value ? dr["Proveedor"].ToString() : null,
                PedidoId = dr["PedidoId"] != DBNull.Value ? (int?)dr["PedidoId"] : null,
                PedidoCantidadSolicitada = dr["PedidoCantidadSolicitada"] != DBNull.Value ? (int?)dr["PedidoCantidadSolicitada"] : null,
                PedidoSubtotalFila = dr["PedidoSubtotalFila"] != DBNull.Value ? (decimal?)dr["PedidoSubtotalFila"] : null,
                PedidoFechaCreacion = dr["PedidoFechaCreacion"] != DBNull.Value ? (DateTime?)dr["PedidoFechaCreacion"] : null,
                PedidoEstado = dr["PedidoEstado"] != DBNull.Value ? dr["PedidoEstado"].ToString() : null,
                ClienteId = dr["ClienteId"] != DBNull.Value ? (int?)dr["ClienteId"] : null,
                ClienteNombreCompleto = dr["ClienteNombreCompleto"] != DBNull.Value ? dr["ClienteNombreCompleto"].ToString() : null,
                ClienteEmail = dr["ClienteEmail"] != DBNull.Value ? dr["ClienteEmail"].ToString() : null,
                DireccionEnvioZIP = dr["DireccionEnvioZIP"] != DBNull.Value ? dr["DireccionEnvioZIP"].ToString() : null,
                DireccionEnvioDetalle = dr["DireccionEnvioDetalle"] != DBNull.Value ? dr["DireccionEnvioDetalle"].ToString() : null,
                RegistradoPorNombre = dr["RegistradoPorNombre"] != DBNull.Value ? dr["RegistradoPorNombre"].ToString() : null,
                ModificadoPorNombre = dr["ModificadoPorNombre"] != DBNull.Value ? dr["ModificadoPorNombre"].ToString() : null,
                FechaUltimaModificacion = dr["FechaUltimaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaUltimaModificacion"] : null
            };
        }

        private DM_StockMovementDetails_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_StockMovementDetails_filtrar
            {
                DetalleMovimientoId = dr["DetalleMovimientoId"] != DBNull.Value ? (int?)dr["DetalleMovimientoId"] : null,
                CantidadMovida = dr["CantidadMovida"] != DBNull.Value ? (int?)dr["CantidadMovida"] : null,
                FechaFabricacionLote = dr["FechaFabricacionLote"] != DBNull.Value ? (DateTime?)dr["FechaFabricacionLote"] : null,
                FechaExpiracionLote = dr["FechaExpiracionLote"] != DBNull.Value ? (DateTime?)dr["FechaExpiracionLote"] : null,
                FechaRegistroDetalle = dr["FechaRegistroDetalle"] != DBNull.Value ? (DateTime?)dr["FechaRegistroDetalle"] : null,
                DetalleActivo = dr["DetalleActivo"] != DBNull.Value ? (bool?)dr["DetalleActivo"] : null,
                MovimientoId = dr["MovimientoId"] != DBNull.Value ? (int?)dr["MovimientoId"] : null,
                TipoMovimiento = dr["TipoMovimiento"] != DBNull.Value ? dr["TipoMovimiento"].ToString() : null,
                TipoMovimientoDescripcion = dr["TipoMovimientoDescripcion"] != DBNull.Value ? dr["TipoMovimientoDescripcion"].ToString() : null,
                ReferenciaMovimiento = dr["ReferenciaMovimiento"] != DBNull.Value ? dr["ReferenciaMovimiento"].ToString() : null,
                FechaMovimiento = dr["FechaMovimiento"] != DBNull.Value ? (DateTime?)dr["FechaMovimiento"] : null,
                EstadoMovimiento = dr["EstadoMovimiento"] != DBNull.Value ? dr["EstadoMovimiento"].ToString() : null,
                VarianteId = dr["VarianteId"] != DBNull.Value ? (int?)dr["VarianteId"] : null,
                ProductoNombre = dr["ProductoNombre"] != DBNull.Value ? dr["ProductoNombre"].ToString() : null,
                VarianteEspecificacion = dr["VarianteEspecificacion"] != DBNull.Value ? dr["VarianteEspecificacion"].ToString() : null,
                VariantePrecioUnitario = dr["VariantePrecioUnitario"] != DBNull.Value ? (decimal?)dr["VariantePrecioUnitario"] : null,
                VarianteMoneda = dr["VarianteMoneda"] != DBNull.Value ? dr["VarianteMoneda"].ToString() : null,
                ProductoDescripcion = dr["ProductoDescripcion"] != DBNull.Value ? dr["ProductoDescripcion"].ToString() : null,
                Categoria = dr["Categoria"] != DBNull.Value ? dr["Categoria"].ToString() : null,
                SubCategoria = dr["SubCategoria"] != DBNull.Value ? dr["SubCategoria"].ToString() : null,
                Segmento = dr["Segmento"] != DBNull.Value ? dr["Segmento"].ToString() : null,
                Marca = dr["Marca"] != DBNull.Value ? dr["Marca"].ToString() : null,
                Proveedor = dr["Proveedor"] != DBNull.Value ? dr["Proveedor"].ToString() : null,
                PedidoId = dr["PedidoId"] != DBNull.Value ? (int?)dr["PedidoId"] : null,
                PedidoCantidadSolicitada = dr["PedidoCantidadSolicitada"] != DBNull.Value ? (int?)dr["PedidoCantidadSolicitada"] : null,
                PedidoSubtotalFila = dr["PedidoSubtotalFila"] != DBNull.Value ? (decimal?)dr["PedidoSubtotalFila"] : null,
                PedidoFechaCreacion = dr["PedidoFechaCreacion"] != DBNull.Value ? (DateTime?)dr["PedidoFechaCreacion"] : null,
                PedidoEstado = dr["PedidoEstado"] != DBNull.Value ? dr["PedidoEstado"].ToString() : null,
                ClienteId = dr["ClienteId"] != DBNull.Value ? (int?)dr["ClienteId"] : null,
                ClienteNombreCompleto = dr["ClienteNombreCompleto"] != DBNull.Value ? dr["ClienteNombreCompleto"].ToString() : null,
                ClienteEmail = dr["ClienteEmail"] != DBNull.Value ? dr["ClienteEmail"].ToString() : null,
                DireccionEnvioZIP = dr["DireccionEnvioZIP"] != DBNull.Value ? dr["DireccionEnvioZIP"].ToString() : null,
                DireccionEnvioDetalle = dr["DireccionEnvioDetalle"] != DBNull.Value ? dr["DireccionEnvioDetalle"].ToString() : null,
                RegistradoPorNombre = dr["RegistradoPorNombre"] != DBNull.Value ? dr["RegistradoPorNombre"].ToString() : null,
                ModificadoPorNombre = dr["ModificadoPorNombre"] != DBNull.Value ? dr["ModificadoPorNombre"].ToString() : null,
                FechaUltimaModificacion = dr["FechaUltimaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaUltimaModificacion"] : null
            };
        }

        #endregion
    }
}
