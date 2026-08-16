using System;

namespace DOMAIN.PriceHistory
{
    public class DM_PriceHistoryFiltrar
    {
        public int? PriceHistoryId { get; set; }
        public int? PriceHistoryProductVariableId { get; set; }
        public decimal? PriceHistoryOldPrice { get; set; }
        public decimal? PriceHistoryNewPrice { get; set; }
        public int? PriceHistoryModifierId { get; set; }
        public DateTime? PriceHistoryChangeDate { get; set; }
    }
}
