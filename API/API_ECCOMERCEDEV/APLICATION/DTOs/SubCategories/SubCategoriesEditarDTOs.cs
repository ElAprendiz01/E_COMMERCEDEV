namespace APLICATION.DTOs.SubCategories
{
    public class SubCategoriesEditarDTOs
    {
        public int? subCategoryId { get; set; }
        public string? subCategoryName { get; set; }
        public string? subCategoryDescription { get; set; }
        public int? subCategoryModificatorId { get; set; }
        public bool? subCategoryStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
