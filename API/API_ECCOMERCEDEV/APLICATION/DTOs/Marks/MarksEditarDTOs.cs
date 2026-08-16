namespace APLICATION.DTOs.Marks
{
    public class MarksEditarDTOs
    {
        public int? markId { get; set; }
        public string? markName { get; set; }
        public string? markDescription { get; set; }
        public int? markModificatorId { get; set; }
        public bool? markStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
