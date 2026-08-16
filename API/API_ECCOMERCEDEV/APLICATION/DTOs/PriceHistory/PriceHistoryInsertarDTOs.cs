namespace APLICATION.DTOs.PriceHistory
{
    public class PriceHistoryInsertarDTOs
    {
        public int? PriceHistoryProductVariableId { get; set; }
        public decimal? PriceHistoryOldPrice { get; set; }
        public decimal? PriceHistoryNewPrice { get; set; }
        public int? PriceHistoryModifierId { get; set; }
    }
}
