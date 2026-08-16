using System;

namespace APLICATION.DTOs.Stocks
{
    public class StocksUpdateDTOs
    {
        public int? StockId { get; set; }
        public int? StockQuantityAdjustment { get; set; }
        public int? StockModificatorId { get; set; }
    }
}
