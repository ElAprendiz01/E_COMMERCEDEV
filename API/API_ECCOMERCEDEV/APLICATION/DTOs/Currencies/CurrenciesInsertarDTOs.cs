namespace APLICATION.DTOs.Currencies
{
    public class CurrenciesInsertarDTOs
    {
        public string? currencyName { get; set; }
        public string? currencyISO { get; set; }
        public int? currencyCode { get; set; }
        public string? currencyDescription { get; set; }
        public int? currencyCreatorId { get; set; }
        public bool? currencyStatusId { get; set; }
    }
}
