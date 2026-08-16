namespace APLICATION.DTOs.Categories
{
    public class CategoriesEditarDTOs
    {
        public int? categoryId { get; set; }
        public string? categoryName { get; set; }
        public string? categoryDescription { get; set; }
        public int? categoryModificatorId { get; set; }
        public bool? categoryStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
