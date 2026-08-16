using APLICATION.Interfaces;
using DOMAIN.PaymentOrderDetails;
using DOMAIN.VariablesSalida;
using INFRASTRUCTURE.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace INFRASTRUCTURE.Repository
{
    public class PaymentOrderDetailsRepository : IPaymentOrderDetailsRepository
    {
        private readonly DBconexionfactory _connection;

        public PaymentOrderDetailsRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

      
        #region lectura_paymentorderdetails

        public async Task<IEnumerable<DM_PaymentOrderDetails_listar>> Listar_PaymentOrderDetailsAsync()
        {
            var list = new List<DM_PaymentOrderDetails_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PaymentOrderDetails_List]", con))
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
                throw new Exception("Error al consultar el listado completo de detalles de orden de pago en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_PaymentOrderDetails_filtrar>> Filtrar_PaymentOrderDetailsAsync(int? orderId, string? searchTerm)
        {
            var list = new List<DM_PaymentOrderDetails_filtrar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[sp_PaymentOrderDetails_Filter]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@OrderId", orderId ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar detalles de orden de pago en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeadores

        private DM_PaymentOrderDetails_listar MapearDataReaderAListar(SqlDataReader dr)
        {
            return new DM_PaymentOrderDetails_listar
            {
                orderDetailId = dr["orderDetailId"] != DBNull.Value ? (int?)dr["orderDetailId"] : null,
                orderId = dr["orderId"] != DBNull.Value ? (int?)dr["orderId"] : null,
                productVariableId = dr["productVariableId"] != DBNull.Value ? (int?)dr["productVariableId"] : null,
                productName = dr["productName"] != DBNull.Value ? dr["productName"].ToString() : null,
                productDescription = dr["productDescription"] != DBNull.Value ? dr["productDescription"].ToString() : null,
                categoryName = dr["categoryName"] != DBNull.Value ? dr["categoryName"].ToString() : null,
                subCategoryName = dr["subCategoryName"] != DBNull.Value ? dr["subCategoryName"].ToString() : null,
                segmentName = dr["segmentName"] != DBNull.Value ? dr["segmentName"].ToString() : null,
                markName = dr["markName"] != DBNull.Value ? dr["markName"].ToString() : null,
                providerName = dr["providerName"] != DBNull.Value ? dr["providerName"].ToString() : null,
                variableValue = dr["variableValue"] != DBNull.Value ? dr["variableValue"].ToString() : null,
                price = dr["price"] != DBNull.Value ? (decimal?)dr["price"] : null,
                quantity = dr["quantity"] != DBNull.Value ? (int?)dr["quantity"] : null,
                discount = dr["discount"] != DBNull.Value ? (decimal?)dr["discount"] : null,
                subtotal = dr["subtotal"] != DBNull.Value ? (decimal?)dr["subtotal"] : null,
                tax = dr["tax"] != DBNull.Value ? (decimal?)dr["tax"] : null,
                total = dr["total"] != DBNull.Value ? (decimal?)dr["total"] : null,
                currencyId = dr["currencyId"] != DBNull.Value ? (int?)dr["currencyId"] : null,
                currencyISO = dr["currencyISO"] != DBNull.Value ? dr["currencyISO"].ToString() : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        private DM_PaymentOrderDetails_filtrar MapearDataReaderAFiltrar(SqlDataReader dr)
        {
            return new DM_PaymentOrderDetails_filtrar
            {
                orderDetailId = dr["orderDetailId"] != DBNull.Value ? (int?)dr["orderDetailId"] : null,
                orderId = dr["orderId"] != DBNull.Value ? (int?)dr["orderId"] : null,
                productVariableId = dr["productVariableId"] != DBNull.Value ? (int?)dr["productVariableId"] : null,
                productName = dr["productName"] != DBNull.Value ? dr["productName"].ToString() : null,
                productDescription = dr["productDescription"] != DBNull.Value ? dr["productDescription"].ToString() : null,
                categoryName = dr["categoryName"] != DBNull.Value ? dr["categoryName"].ToString() : null,
                subCategoryName = dr["subCategoryName"] != DBNull.Value ? dr["subCategoryName"].ToString() : null,
                segmentName = dr["segmentName"] != DBNull.Value ? dr["segmentName"].ToString() : null,
                markName = dr["markName"] != DBNull.Value ? dr["markName"].ToString() : null,
                providerName = dr["providerName"] != DBNull.Value ? dr["providerName"].ToString() : null,
                variableValue = dr["variableValue"] != DBNull.Value ? dr["variableValue"].ToString() : null,
                price = dr["price"] != DBNull.Value ? (decimal?)dr["price"] : null,
                quantity = dr["quantity"] != DBNull.Value ? (int?)dr["quantity"] : null,
                discount = dr["discount"] != DBNull.Value ? (decimal?)dr["discount"] : null,
                subtotal = dr["subtotal"] != DBNull.Value ? (decimal?)dr["subtotal"] : null,
                tax = dr["tax"] != DBNull.Value ? (decimal?)dr["tax"] : null,
                total = dr["total"] != DBNull.Value ? (decimal?)dr["total"] : null,
                currencyId = dr["currencyId"] != DBNull.Value ? (int?)dr["currencyId"] : null,
                currencyISO = dr["currencyISO"] != DBNull.Value ? dr["currencyISO"].ToString() : null,
                statusId = dr["statusId"] != DBNull.Value ? (bool?)dr["statusId"] : null
            };
        }

        #endregion
    }
}
