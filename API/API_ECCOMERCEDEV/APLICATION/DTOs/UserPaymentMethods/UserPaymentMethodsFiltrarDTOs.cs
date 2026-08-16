namespace APLICATION.DTOs.UserPaymentMethods
{
    public class UserPaymentMethodsFiltrarDTOs
    {
        public int? userPaymentMethodId { get; set; }
        public int? userId { get; set; }
        public string? userFullName { get; set; }
        public string? userName { get; set; }
        public int? paymentMethodTypeId { get; set; }
        public string? paymentMethodTypeName { get; set; }
        public string? cardNumberDecrypted { get; set; }
        public string? expirationDateDecrypted { get; set; }
        public string? cvvDecrypted { get; set; }
        public string? cardHolderName { get; set; }
        public bool? statusId { get; set; }
    }
}
