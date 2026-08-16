namespace DOMAIN.PaymentMethodTypes
{
    public class DM_PaymentMethodTypes_actualizar
    {
        public int? paymentMethodTypeId { get; set; }
        public string? paymentMethodTypeName { get; set; }
        public string? paymentMethodTypeDescription { get; set; }
        public int? paymentMethodTypeModificatorId { get; set; }
        public bool? paymentMethodTypeStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
