namespace DOMAIN.Users
{
    public class DM_Users_listar
    {
        public int? userId { get; set; }
        public string? userFullName { get; set; }
        public string? userName { get; set; }
        public string? userPasswordDecrypted { get; set; }
        public string? userEmail { get; set; }
        public string? userPhoneNumber { get; set; }
        public int? userCountryId { get; set; }
        public int? userGenderId { get; set; }
        public DateTime? userBirthDay { get; set; }
        public int? userStatusId { get; set; }
    }
}
