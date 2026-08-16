namespace DOMAIN.Users
{
    public class DM_Users_insertar
    {
        public string? userFullName { get; set; }
        public string? userName { get; set; }
        public string? userPasswordPlain { get; set; }
        public string? userEmail { get; set; }
        public string? userPhoneNumber { get; set; }
        public int? userCountryId { get; set; }
        public int? userGenderId { get; set; }
        public DateTime? userBirthDay { get; set; }
        public int? userCreatorId { get; set; }
        public int? userStatusId { get; set; }
    }
}
