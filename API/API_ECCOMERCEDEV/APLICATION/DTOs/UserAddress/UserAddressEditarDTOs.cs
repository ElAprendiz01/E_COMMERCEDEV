namespace APLICATION.DTOs.UserAddress
{
    public class UserAddressEditarDTOs
    {
        public int? userAddressId { get; set; }
        public int? userAddressCountryId { get; set; }
        public int? userAddressZIPCode { get; set; }
        public string? userAddressDescription { get; set; }
        public bool? userAddressIsPrincipal { get; set; }
        public int? userAddressModificatorId { get; set; }
        public bool? userAddressStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
