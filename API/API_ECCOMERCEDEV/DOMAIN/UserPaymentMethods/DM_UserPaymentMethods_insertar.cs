namespace DOMAIN.UserPaymentMethods
{
    public class DM_UserPaymentMethods_insertar
    {
        public int? userPaymentMethodUserId { get; set; }
        public int? userPaymentMethodPaymentMethodTypeId { get; set; }
        public string? CardNumberPlain { get; set; }
        public string? ExpirationDatePlain { get; set; }
        public string? CVVPlain { get; set; }
        public string? userPaymentMethodCardHolderName { get; set; }
        public int? userPaymentMethodCreatorId { get; set; }
        public bool? userPaymentMethodStatusId { get; set; }
    }
}
