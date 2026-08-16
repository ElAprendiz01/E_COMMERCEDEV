using System;

namespace APLICATION.DTOs.Products
{
    public class ProductsFiltrarDTOs
    {
        public int? ProductID { get; set; }
        public string? ProductName { get; set; }
        public int? ProductVariableID { get; set; }
        public string? ProductVariableName { get; set; }
        public decimal? ProductVariablePrice { get; set; }
        public int? CurrencyID { get; set; }
        public string? CurrencyISO { get; set; }
        public int? CategoryID { get; set; }
        public string? CategoryName { get; set; }
        public int? SubcategoryID { get; set; }
        public string? SubcategoryName { get; set; }
        public int? SegmentID { get; set; }
        public string? SegmentName { get; set; }
        public int? MarkID { get; set; }
        public string? MarkName { get; set; }
        public int? ProviderID { get; set; }
        public string? ProviderName { get; set; }
        public int? StockID { get; set; }
        public int? StockAvilable { get; set; }
        public DateTime? StockFactoryDate { get; set; }
        public DateTime? StockExpirationDate { get; set; }
        public string? ProductImageURL { get; set; }
    }
}
