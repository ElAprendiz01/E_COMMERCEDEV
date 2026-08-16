namespace DOMAIN.PaymentOrders
{
    public class DM_PaymentOrders_insertar
    {
        public int? orderUserId { get; set; }
        public int? orderDeliveryAddress { get; set; }
        public int? orderPaymentMethodId { get; set; }
        public decimal? orderShipping { get; set; }
        public decimal? orderSubtotal { get; set; }
        public decimal? orderTotal { get; set; }
        public int? orderCreatorId { get; set; }
        public int? orderStatusId { get; set; }
    }
}
