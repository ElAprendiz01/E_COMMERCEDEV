namespace DOMAIN.AttributeProducts
{
    public class DM_AttributeProductsEditar
    {
        public int? AttributeProductId { get; set; }
        public int? AttributeProductAttributesTypeId { get; set; }
        public string? AttributeProductName { get; set; }
        public string? AttributeProductDescription { get; set; }
        public int? AttributeProductModificatorId { get; set; }
        public int? AttributeProductStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}