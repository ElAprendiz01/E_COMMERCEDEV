using System;

namespace APLICATION.DTOs.PriceHistory
{
    public class PriceHistoryFiltrarDTOs
    {
        public int? PriceHistoryId { get; set; }
        public int? PriceHistoryProductVariableId { get; set; }
        public decimal? PriceHistoryOldPrice { get; set; }
        public decimal? PriceHistoryNewPrice { get; set; }
        public DateTime? PriceHistoryChangeDate { get; set; }
        public int? PriceHistoryModifierId { get; set; }
    }
}
