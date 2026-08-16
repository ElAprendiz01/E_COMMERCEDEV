namespace DOMAIN.PaymentOrders
{
    public class DM_PaymentOrdersInsertar
    {
        public int? orderUserId { get; set; }
        public int? orderDeliveryAddress { get; set; }
        public int? orderPaymentMethodId { get; set; }
        public int? orderCreatorId { get; set; }
        public int? orderStatusId { get; set; }
    }
}
