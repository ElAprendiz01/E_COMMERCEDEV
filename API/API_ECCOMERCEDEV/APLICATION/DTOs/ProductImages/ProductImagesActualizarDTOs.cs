using System;

namespace APLICATION.DTOs.ProductImages
{
    public class ProductImagesActualizarDTOs
    {
        public int? ProductImageId { get; set; }
        public int? ProductImageProductId { get; set; }
        public string? ProductImageURL { get; set; }
        public string? ProductImageDescription { get; set; }
        public bool? ProductImageIsPrincipal { get; set; }
        public int? ProductImageModificatorId { get; set; }
        public bool? ProductImageStatusId { get; set; }
    }
}
