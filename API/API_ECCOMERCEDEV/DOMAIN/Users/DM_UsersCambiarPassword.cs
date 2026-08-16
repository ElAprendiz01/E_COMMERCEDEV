namespace DOMAIN.Users
{
    public class DM_UsersCambiarPassword
    {
        public int? userId { get; set; }
        public int? userModificatorId { get; set; }
        public string? userPasswordPlain { get; set; }
    }
}
