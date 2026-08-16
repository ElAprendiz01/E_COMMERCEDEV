namespace DOMAIN.Products
{
    public class DM_Products_actualizar
    {
        public int? productId { get; set; }
        public string? productName { get; set; }
        public string? productDescription { get; set; }
        public int? productProductIdentificatorId { get; set; }
        public int? productMarkByProviderId { get; set; }
        public int? productModificatorId { get; set; }
        public bool? productStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
