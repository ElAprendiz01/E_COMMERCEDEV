using APLICATION.Interfaces;
using DOMAIN.Currencies;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class CurrenciesRepository : ICurrenciesRepository
    {
        private readonly DBconexionfactory _connection;

        public CurrenciesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_currencies

        public async Task<OUTPUT> Insertar_CurrenciesAsync(DM_Currencies_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Currencies_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@currencyName", modelo.currencyName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyISO", modelo.currencyISO ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyCode", modelo.currencyCode ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyDescription", modelo.currencyDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyCreatorId", modelo.currencyCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyStatusId", modelo.currencyStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear la moneda.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear la moneda.", ex);
            }
        }

        public async Task<OUTPUT> Editar_CurrenciesAsync(DM_Currencies_actualizar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Currencies_Update]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@currencyId", modelo.currencyId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyName", modelo.currencyName ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyISO", modelo.currencyISO ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyCode", modelo.currencyCode ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyDescription", modelo.currencyDescription ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyModificatorId", modelo.currencyModificatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyStatusId", modelo.currencyStatusId ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar la moneda.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar la moneda.", ex);
            }
        }

        public async Task<OUTPUT> Eliminar_CurrenciesAsync(int? currencyId, int? currencyModificatorId)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Currencies_Delete]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@currencyId", currencyId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@currencyModificatorId", currencyModificatorId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica la moneda.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al intentar eliminar la moneda.", ex);
            }
        }

        #endregion

        #region lectura_currencies

        public async Task<IEnumerable<DM_Currencies_listar>> Listar_CurrenciesAsync()
        {
            var list = new List<DM_Currencies_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Currencies_List]", con))
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
                throw new Exception("Error al consultar el listado completo de monedas en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Currencies_filtrar>> Filtrar_CurrenciesAsync(string? searchTerm, bool? statusId)
        {
            var list = new List<DM_Currencies_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[sp_Currencies_Filter]", con))
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
                throw new Exception("Error al filtrar monedas en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_Currencies_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_Currencies_listar
            {
                MonedaID = dr["MonedaID"] != DBNull.Value ? (int?)dr["MonedaID"] : null,
                Moneda = dr["Moneda"] != DBNull.Value ? dr["Moneda"].ToString() : null,
                ISO = dr["ISO"] != DBNull.Value ? dr["ISO"].ToString() : null,
                CodigoNumerico = dr["CodigoNumerico"] != DBNull.Value ? (int?)dr["CodigoNumerico"] : null,
                Descripcion = dr["Descripcion"] != DBNull.Value ? dr["Descripcion"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                FechaCreacion = dr["FechaCreacion"] != DBNull.Value ? (DateTime?)dr["FechaCreacion"] : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr["EstadoID"] as bool?,
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        private DM_Currencies_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_Currencies_filtrar
            {
                MonedaID = dr["MonedaID"] != DBNull.Value ? (int?)dr["MonedaID"] : null,
                Moneda = dr["Moneda"] != DBNull.Value ? dr["Moneda"].ToString() : null,
                ISO = dr["ISO"] != DBNull.Value ? dr["ISO"].ToString() : null,
                CodigoNumerico = dr["CodigoNumerico"] != DBNull.Value ? (int?)dr["CodigoNumerico"] : null,
                Descripcion = dr["Descripcion"] != DBNull.Value ? dr["Descripcion"].ToString() : null,
                CreadorID = dr["CreadorID"] != DBNull.Value ? (int?)dr["CreadorID"] : null,
                CreadorNombre = dr["CreadorNombre"] != DBNull.Value ? dr["CreadorNombre"].ToString() : null,
                FechaCreacion = dr["FechaCreacion"] != DBNull.Value ? (DateTime?)dr["FechaCreacion"] : null,
                ModificadorID = dr["ModificadorID"] != DBNull.Value ? (int?)dr["ModificadorID"] : null,
                ModificadorNombre = dr["ModificadorNombre"] != DBNull.Value ? dr["ModificadorNombre"].ToString() : null,
                FechaModificacion = dr["FechaModificacion"] != DBNull.Value ? (DateTime?)dr["FechaModificacion"] : null,
                EstadoID = dr["EstadoID"] as bool?,
                Estado = dr["Estado"] != DBNull.Value ? dr["Estado"].ToString() : null
            };
        }

        #endregion
    }
}
