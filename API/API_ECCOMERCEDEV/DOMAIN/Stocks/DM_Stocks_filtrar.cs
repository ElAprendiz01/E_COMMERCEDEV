using System;

namespace DOMAIN.Stocks
{
    public class DM_Stocks_filtrar
    {
        public int? StockId { get; set; }
        public int? ProductVariableId { get; set; }
        public string? ProductName { get; set; }
        public string? VariableValue { get; set; }
        public decimal? UnitPrice { get; set; }
        public string? CurrencyISO { get; set; }
        public int? Quantity { get; set; }
        public DateTime? FactoryDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public bool? StatusId { get; set; }
    }
}
