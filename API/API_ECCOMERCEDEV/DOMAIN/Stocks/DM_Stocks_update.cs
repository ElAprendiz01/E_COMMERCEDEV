using System;

namespace DOMAIN.Stocks
{
    public class DM_Stocks_update
    {
        public int? StockId { get; set; }
        public int? StockQuantityAdjustment { get; set; }
        public int? StockModificatorId { get; set; }
    }
}
