namespace APLICATION.DTOs.Users
{
    public class UsersEditarDTOs
    {
        public int? userId { get; set; }
        public string? userFullName { get; set; }
        public string? userEmail { get; set; }
        public string? userPhoneNumber { get; set; }
        public int? userModificatorId { get; set; }
        public int? userStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
