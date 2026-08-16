namespace APLICATION.DTOs.UserAddress
{
    public class UserAddressinsertarDTOs
    {
        public int? userAddressUserId { get; set; }
        public int? userAddressCountryId { get; set; }
        public int? userAddressZIPCode { get; set; }
        public string? userAddressDescription { get; set; }
        public bool? userAddressIsPrincipal { get; set; }
        public int? userAddressCreatorId { get; set; }
        public bool? userAddressStatusId { get; set; }
    }
}
