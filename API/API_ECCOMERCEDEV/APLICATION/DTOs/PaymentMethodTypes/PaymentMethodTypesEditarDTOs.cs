namespace APLICATION.DTOs.PaymentMethodTypes
{
    public class PaymentMethodTypesEditarDTOs
    {
        public int? paymentMethodTypeId { get; set; }
        public string? paymentMethodTypeName { get; set; }
        public string? paymentMethodTypeDescription { get; set; }
        public int? paymentMethodTypeModificatorId { get; set; }
        public bool? paymentMethodTypeStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
