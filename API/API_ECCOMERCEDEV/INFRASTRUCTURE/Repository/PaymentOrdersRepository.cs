using APLICATION.Interfaces;
using DOMAIN.PaymentOrders;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class PaymentOrdersRepository : IPaymentOrdersRepository
    {
        private readonly DBconexionfactory _connection;

        public PaymentOrdersRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_paymentorders

        public async Task<OUTPUT> Insertar_PaymentOrdersAsync(DM_PaymentOrders_insertar modelo)
        {
            var result = new OUTPUT();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PaymentOrders_Create]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@orderUserId", modelo.orderUserId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderDeliveryAddress", modelo.orderDeliveryAddress ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderPaymentMethodId", modelo.orderPaymentMethodId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderShipping", modelo.orderShipping ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderSubtotal", modelo.orderSubtotal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderTotal", modelo.orderTotal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderCreatorId", modelo.orderCreatorId ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@orderStatusId", modelo.orderStatusId ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear la orden de pago.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear la orden de pago.", ex);
            }
        }

        #endregion

        #region lectura_paymentorders

        public async Task<IEnumerable<DM_PaymentOrders_listar>> Listar_PaymentOrdersAsync()
        {
            var list = new List<DM_PaymentOrders_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PaymentOrders_List]", con))
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
                throw new Exception("Error al consultar el listado completo de ordenes de pago en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_PaymentOrders_filtrar>> Filtrar_PaymentOrdersAsync(int? userId, string? searchTerm, int? statusId)
        {
            var list = new List<DM_PaymentOrders_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PaymentOrders_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@UserId", userId ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar las ordenes de pago en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_PaymentOrders_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_PaymentOrders_listar
            {
                orderId = dr["orderId"] != DBNull.Value ? (int?)dr["orderId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                deliveryAddressId = dr["deliveryAddressId"] != DBNull.Value ? (int?)dr["deliveryAddressId"] : null,
                deliveryAddressDescription = dr["deliveryAddressDescription"] != DBNull.Value ? dr["deliveryAddressDescription"].ToString() : null,
                paymentMethodId = dr["paymentMethodId"] != DBNull.Value ? (int?)dr["paymentMethodId"] : null,
                paymentMethodCardHolderName = dr["paymentMethodCardHolderName"] != DBNull.Value ? dr["paymentMethodCardHolderName"].ToString() : null,
                subtotal = dr["subtotal"] != DBNull.Value ? (decimal?)dr["subtotal"] : null,
                discount = dr["discount"] != DBNull.Value ? (decimal?)dr["discount"] : null,
                shipping = dr["shipping"] != DBNull.Value ? (decimal?)dr["shipping"] : null,
                tax = dr["tax"] != DBNull.Value ? (decimal?)dr["tax"] : null,
                total = dr["total"] != DBNull.Value ? (decimal?)dr["total"] : null,
                currencyId = dr["currencyId"] != DBNull.Value ? (int?)dr["currencyId"] : null,
                currencyISO = dr["currencyISO"] != DBNull.Value ? dr["currencyISO"].ToString() : null,
                creationDate = dr["creationDate"] != DBNull.Value ? (DateTime?)dr["creationDate"] : null,
                statusId = dr["statusId"] != DBNull.Value ? (int?)dr["statusId"] : null,
                statusName = dr["statusName"] != DBNull.Value ? dr["statusName"].ToString() : null
            };
        }

        private DM_PaymentOrders_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_PaymentOrders_filtrar
            {
                orderId = dr["orderId"] != DBNull.Value ? (int?)dr["orderId"] : null,
                userId = dr["userId"] != DBNull.Value ? (int?)dr["userId"] : null,
                userFullName = dr["userFullName"] != DBNull.Value ? dr["userFullName"].ToString() : null,
                userName = dr["userName"] != DBNull.Value ? dr["userName"].ToString() : null,
                deliveryAddressId = dr["deliveryAddressId"] != DBNull.Value ? (int?)dr["deliveryAddressId"] : null,
                deliveryAddressDescription = dr["deliveryAddressDescription"] != DBNull.Value ? dr["deliveryAddressDescription"].ToString() : null,
                paymentMethodId = dr["paymentMethodId"] != DBNull.Value ? (int?)dr["paymentMethodId"] : null,
                paymentMethodCardHolderName = dr["paymentMethodCardHolderName"] != DBNull.Value ? dr["paymentMethodCardHolderName"].ToString() : null,
                subtotal = dr["subtotal"] != DBNull.Value ? (decimal?)dr["subtotal"] : null,
                discount = dr["discount"] != DBNull.Value ? (decimal?)dr["discount"] : null,
                shipping = dr["shipping"] != DBNull.Value ? (decimal?)dr["shipping"] : null,
                tax = dr["tax"] != DBNull.Value ? (decimal?)dr["tax"] : null,
                total = dr["total"] != DBNull.Value ? (decimal?)dr["total"] : null,
                currencyId = dr["currencyId"] != DBNull.Value ? (int?)dr["currencyId"] : null,
                currencyISO = dr["currencyISO"] != DBNull.Value ? dr["currencyISO"].ToString() : null,
                creationDate = dr["creationDate"] != DBNull.Value ? (DateTime?)dr["creationDate"] : null,
                statusId = dr["statusId"] != DBNull.Value ? (int?)dr["statusId"] : null,
                statusName = dr["statusName"] != DBNull.Value ? dr["statusName"].ToString() : null
            };
        }

        #endregion
    }
}
