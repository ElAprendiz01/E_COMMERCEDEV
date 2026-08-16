using APLICATION.Interfaces;
using DOMAIN.StockMovements;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class StockMovementsRepository : IStockMovementsRepository
    {
        private readonly DBconexionfactory _connection;

        public StockMovementsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_stockmovements

        public async Task<OUTPUT> Insertar_StockMovementsAsync(DM_StockMovements_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_StockMovements_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@stockMovementType", modelo.stockMovementType ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementOrderId", modelo.stockMovementOrderId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementReference", modelo.stockMovementReference ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementDate", modelo.stockMovementDate ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementCreatorId", modelo.stockMovementCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@stockMovementStatusId", modelo.stockMovementStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear el movimiento de stock.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el movimiento de stock.", ex);
            }
        }

        #endregion

        #region lectura_stockmovements

        public async Task<IEnumerable<DM_StockMovements_listar>> Listar_StockMovementsAsync()
        {
            var list = new List<DM_StockMovements_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_StockMovements_List]", con))
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
                throw new Exception("Error al consultar el listado completo de movimientos de stock en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_StockMovements_filtrar>> Filtrar_StockMovementsAsync(string? searchTerm)
        {
            var list = new List<DM_StockMovements_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_StockMovements_Filter]", con))
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
                throw new Exception("Error al filtrar los movimientos de stock en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_StockMovements_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_StockMovements_listar
            {
                MovimientoID = dr["MovimientoID"] != DBNull.Value ? (int?)dr["MovimientoID"] : null,
                Referencia = dr["Referencia"] != DBNull.Value ? dr["Referencia"].ToString() : null,
                FechaMovimiento = dr["FechaMovimiento"] != DBNull.Value ? (DateTime?)dr["FechaMovimiento"] : null,
                FechaRegistro = dr["FechaRegistro"] != DBNull.Value ? (DateTime?)dr["FechaRegistro"] : null,
                TipoMovimientoID = dr["TipoMovimientoID"] != DBNull.Value ? (int?)dr["TipoMovimientoID"] : null,
                TipoMovimiento = dr["TipoMovimiento"] != DBNull.Value ? dr["TipoMovimiento"].ToString() : null,
                DescripcionTipo = dr["DescripcionTipo"] != DBNull.Value ? dr["DescripcionTipo"].ToString() : null,
                OrdenPagoID = dr["OrdenPagoID"] != DBNull.Value ? (int?)dr["OrdenPagoID"] : null,
                DetalleOrden = dr["DetalleOrden"] != DBNull.Value ? dr["DetalleOrden"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                CreadorUsuario = dr["CreadorUsuario"] != DBNull.Value ? dr["CreadorUsuario"].ToString() : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr["EstadoID"] != DBNull.Value ? (int?)dr["EstadoID"] : null,
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        private DM_StockMovements_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_StockMovements_filtrar
            {
                MovimientoID = dr["MovimientoID"] != DBNull.Value ? (int?)dr["MovimientoID"] : null,
                Referencia = dr["Referencia"] != DBNull.Value ? dr["Referencia"].ToString() : null,
                FechaMovimiento = dr["FechaMovimiento"] != DBNull.Value ? (DateTime?)dr["FechaMovimiento"] : null,
                FechaRegistro = dr["FechaRegistro"] != DBNull.Value ? (DateTime?)dr["FechaRegistro"] : null,
                TipoMovimientoID = dr["TipoMovimientoID"] != DBNull.Value ? (int?)dr["TipoMovimientoID"] : null,
                TipoMovimiento = dr["TipoMovimiento"] != DBNull.Value ? dr["TipoMovimiento"].ToString() : null,
                DescripcionTipo = dr["DescripcionTipo"] != DBNull.Value ? dr["DescripcionTipo"].ToString() : null,
                OrdenPagoID = dr["OrdenPagoID"] != DBNull.Value ? (int?)dr["OrdenPagoID"] : null,
                DetalleOrden = dr["DetalleOrden"] != DBNull.Value ? dr["DetalleOrden"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                CreadorUsuario = dr["CreadorUsuario"] != DBNull.Value ? dr["CreadorUsuario"].ToString() : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr["EstadoID"] != DBNull.Value ? (int?)dr["EstadoID"] : null,
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        #endregion
    }
}
