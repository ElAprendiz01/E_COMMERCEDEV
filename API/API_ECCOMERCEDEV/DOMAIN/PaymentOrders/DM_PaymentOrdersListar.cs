using System;

namespace DOMAIN.PaymentOrders
{
    public class DM_PaymentOrdersListar
    {
        public int? orderId { get; set; }
        public int? userId { get; set; }
        public string? userFullName { get; set; }
        public string? userName { get; set; }
        public int? deliveryAddressId { get; set; }
        public string? deliveryAddressDescription { get; set; }
        public int? paymentMethodId { get; set; }
        public string? paymentMethodCardHolderName { get; set; }
        public decimal? subtotal { get; set; }
        public decimal? discount { get; set; }
        public decimal? shipping { get; set; }
        public decimal? tax { get; set; }
        public decimal? total { get; set; }
        public int? currencyId { get; set; }
        public string? currencyISO { get; set; }
        public DateTime? creationDate { get; set; }
        public int? statusId { get; set; }
        public string? statusName { get; set; }
    }
}
