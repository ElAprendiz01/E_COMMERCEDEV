namespace DOMAIN.PaymentOrderDetails
{
    public class DM_PaymentOrderDetails_filtrar
    {
        public int? orderDetailId { get; set; }
        public int? orderId { get; set; }
        public int? productVariableId { get; set; }
        public string? productName { get; set; }
        public string? productDescription { get; set; }
        public string? categoryName { get; set; }
        public string? subCategoryName { get; set; }
        public string? segmentName { get; set; }
        public string? markName { get; set; }
        public string? providerName { get; set; }
        public string? variableValue { get; set; }
        public decimal? price { get; set; }
        public int? quantity { get; set; }
        public decimal? discount { get; set; }
        public decimal? subtotal { get; set; }
        public decimal? tax { get; set; }
        public decimal? total { get; set; }
        public int? currencyId { get; set; }
        public string? currencyISO { get; set; }
        public bool? statusId { get; set; }
    }
}
