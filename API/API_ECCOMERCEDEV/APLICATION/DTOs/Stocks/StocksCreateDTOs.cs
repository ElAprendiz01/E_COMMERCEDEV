using System;

namespace APLICATION.DTOs.Stocks
{
    public class StocksCreateDTOs
    {
        public int? StockProductVariableId { get; set; }
        public int? StockQuantity { get; set; }
        public DateTime? StockFactoryDate { get; set; }
        public DateTime? StockExpirationDate { get; set; }
        public int? StockCreatorId { get; set; }
        public bool? StockStatusId { get; set; }
    }
}
