namespace APLICATION.DTOs.UserAddress
{
    public class UserAddressListarDTOs
    {
        public int? userAddressId { get; set; }
        public int? userId { get; set; }
        public string? userFullName { get; set; }
        public string? userName { get; set; }
        public string? userEmail { get; set; }
        public int? countryId { get; set; }
        public int? zipCode { get; set; }
        public string? addressDescription { get; set; }
        public bool? isPrincipal { get; set; }
        public bool? statusId { get; set; }
    }
}
