namespace DOMAIN.PaymentMethodTypes
{
    public class DM_PaymentMethodTypes_listar
    {
        public int? paymentMethodTypeId { get; set; }
        public string? paymentMethodTypeName { get; set; }
        public string? paymentMethodTypeDescription { get; set; }
        public int? paymentMethodTypeCreatorId { get; set; }
        public DateTime? paymentMethodTypeCreationDate { get; set; }
        public int? paymentMethodTypeModificatorId { get; set; }
        public DateTime? paymentMethodTypeModificationDate { get; set; }
        public bool? paymentMethodTypeStatusId { get; set; }
    }
}
