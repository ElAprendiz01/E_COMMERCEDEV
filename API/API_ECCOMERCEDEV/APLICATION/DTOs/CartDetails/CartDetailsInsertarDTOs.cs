namespace APLICATION.DTOs.CartDetails
{
    public class CartDetailsInsertarDTOs
    {
        public int? userId { get; set; }
        public int? productVariableId { get; set; }
        public int? quantity { get; set; }
        public decimal? discount { get; set; }
        public int? creatorId { get; set; }
        public bool? statusId { get; set; }
    }
}
