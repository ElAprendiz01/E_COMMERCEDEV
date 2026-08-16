namespace APLICATION.DTOs.Providers
{
    public class ProvidersEditarDTOs
    {
        public int? providerId { get; set; }
        public string? providerName { get; set; }
        public string? providerDescription { get; set; }
        public int? providerModificatorId { get; set; }
        public bool? providerStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
