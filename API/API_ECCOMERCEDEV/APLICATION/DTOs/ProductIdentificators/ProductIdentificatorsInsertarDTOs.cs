using System;

namespace APLICATION.DTOs.ProductIdentificators
{
    public class ProductIdentificatorsInsertarDTOs
    {
        public int? ProductIdentificatorCategoryId { get; set; }
        public int? ProductIdentificatorSubCategoryId { get; set; }
        public int? ProductIdentificatorSegmentId { get; set; }
        public int? ProductIdentificatorCreatorId { get; set; }
        public bool? ProductIdentificatorStatusId { get; set; }
    }
}
