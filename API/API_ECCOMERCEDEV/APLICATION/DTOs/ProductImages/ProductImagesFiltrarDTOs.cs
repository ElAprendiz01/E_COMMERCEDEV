using System;

namespace APLICATION.DTOs.ProductImages
{
    public class ProductImagesFiltrarDTOs
    {
        public int? ProductImageId { get; set; }
        public int? ProductImageProductId { get; set; }
        public string? ProductImageURL { get; set; }
        public bool? ProductImageIsPrincipal { get; set; }
        public int? ProductImageCreatorId { get; set; }
        public DateTime? ProductImageCreationDate { get; set; }
        public int? ProductImageModificatorId { get; set; }
        public DateTime? ProductImageModificationDate { get; set; }
        public bool? ProductImageStatusId { get; set; }
    }
}
