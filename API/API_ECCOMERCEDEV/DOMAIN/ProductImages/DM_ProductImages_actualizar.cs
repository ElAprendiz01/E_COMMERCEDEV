using System;

namespace DOMAIN.ProductImages
{
    public class DM_ProductImages_actualizar
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
